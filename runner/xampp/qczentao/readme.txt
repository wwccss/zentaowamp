为了保证您的正常使用，请在运行之前仔细阅读下面的说明：

1. 如何启动禅道：
  双击启动禅道.exe运行控制面板。在禅道集成运行环境控制面板上点击启动按钮即可启动禅道。

  如果无法通过控制面板启动禅道，进入xampp\service目录，双击运行install.bat，来安装并启动禅道的服务。

2. 注意事项：

  2.1 不要改动xampp的目录名，否则程序运行会有问题。
  2.2 如果无法启动apache，检查端口号是否冲突。如果确认不是端口冲突且无法启动，请考虑安装vc运行环境：
     32位系统下载：http://www.microsoft.com/downloads/details.aspx?FamilyID=9B2DA534-3E03-4391-8A4D-074B9F2BC1BF
     64位系统下载：http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=15336 
  2.3 禅道系统默认的管理员帐号是admin，密码是123456。
  2.4 数据库默认的管理员帐号是root，密码为123456。
  2.5 禅道的访问路径：http://localhost/zentao/ 其他机器访问将localhost换成ip地址。如果端口号不是80，还需要加上端口号。
  2.6 数据库管理请访问：http://localhost/phpmyadmin/。phpmyadmin只能在禅道机器上面访问。

详细的介绍，请访问：http://www.zentao.net/help-read-79597.html

Please read the flowing notes before you run zentao:

1. How to start zentao:

  Double Click 启动禅道.exe to run control application。Click the start button to start services.

  If you can't start zentao by the control panel, cd xampp\service, double click the install.bat to install and start services
  for zentao manually.

2. Notice:

  2.1 Don't change the directory name of xampp.
  2.2 If zentao can't start, please check whether the ports of 80 and 3306 conflict with other webserver and database server.
      If you make sure no conflicts for apache and mysql, please consider to install the vc runtime.
      32bit: http://www.microsoft.com/downloads/details.aspx?FamilyID=9B2DA534-3E03-4391-8A4D-074B9F2BC1BF
      64bit: http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=15336 
  2.3 The default administrator for zentao is admin, password is 123456.
  2.4 The default administrator for database is root, password is empty.
  2.5 The url for zentao is: http://your ip address/zentao/, if not 80, add it.
  2.6 To manage database, visit http://localhost/phpmyadmin, which can only be visited from the localhost.

For more infomation, please visit: http://www.zentao.net/help-read-79597.html.
