name             'my-mysql'
maintainer       'Richard Whitney'
maintainer_email 'x@gmail.com'
license          'All rights reserved'
description      'Wraps chef tomcat lwrp'
version          '0.1.0'

depends 'mysql', '~> 8.0'
depends 'yum-mysql-community'