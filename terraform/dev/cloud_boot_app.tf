resource "aws_security_group" "sg_cloud_boot_app" {
  name = "cloud-boot-app-incoming-port"
  ingress {
    from_port = "${var.cloud_boot_server_port}"
    to_port = "${var.cloud_boot_server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "sg_elb" {
  name = "cloud-boot-app-elb"
  ingress {
    from_port = "${var.cloud_boot_elb_port}"
    to_port = "${var.cloud_boot_elb_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "lc_cloud_boot_app" {
  image_id = "${var.cloud_boot_server_image_id}"
  instance_type = "${var.cloud_boot_server_instance_type}"
  key_name = "${var.cloud_key_name}"
  security_groups = ["${aws_security_group.sg_cloud_boot_app.id, "${aws_security_group.sg_default.id}"}"]
  user_data = <<-EOF
                  #!/bin/bash
                  echo "Hello, Kaytrina. I love you!" > index.html
                  nohup busybox httpd -f -p ${var.cloud_boot_server_port} &
                  EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "elb_cloud_boot_app" {
  name = "CloudBootApp"

  # The same availability zone as our instances
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_security_group.sg_elb.id}"]

  listener {
    instance_port     = "${var.cloud_boot_server_port}"
    instance_protocol = "http"
    lb_port           = "${var.cloud_boot_elb_port}"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:${var.cloud_boot_server_port}/"
    interval            = 30
  }
}

resource "aws_autoscaling_group" "asg_cloud_boot_app" {
  launch_configuration = "${aws_launch_configuration.lc_cloud_boot_app.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  name = "asg_cloud_boot_app"
  force_delete = true
  min_size = "${var.cloud_boot_server_asg_min}"
  max_size = "${var.cloud_boot_server_asg_max}"
  desired_capacity = "${var.cloud_boot_server_asg_desired}"
  load_balancers = ["${aws_elb.elb_cloud_boot_app.name}"]
  health_check_type = "ELB"
  tag {
    key = "Name"
    value = "cloud-boot-app-server"
    propagate_at_launch = true
  }
}

output "elb_dns_name" {
  value = "${aws_elb.elb_cloud_boot_app.dns_name}"
}