name             'my-tomcat'
maintainer       'Richard Whitney'
maintainer_email 'x@gmail.com'
license          'All rights reserved'
description      'Wraps chef tomcat lwrp'
version          '0.1.0'

depends 'java'
depends 'git'
depends 'maven'
depends 'tomcat', '~> 2.3.2'
depends 'application', '~> 3.0.0'
depends 'application_java'
depends 'logrotate'