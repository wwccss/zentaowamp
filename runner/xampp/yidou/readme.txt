为了保证您的正常使用，请在运行之前仔细阅读下面的说明：

1. 如何启动然之：
  双击启动然之.exe运行控制面板。在然之集成运行环境控制面板上点击启动按钮即可启动。

  如果无法通过控制面板启动然之，进入xampp\service目录，双击运行install.bat，来安装并启动然之的服务。

2. 注意事项：

  2.1 不要改动xampp的目录名，否则程序运行会有问题。
  2.2 如果无法启动apache，检查端口号是否冲突。如果确认不是端口冲突且无法启动，请考虑安装vc运行环境：
     32位系统下载：http://www.microsoft.com/downloads/details.aspx?FamilyID=9B2DA534-3E03-4391-8A4D-074B9F2BC1BF
     64位系统下载：http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=15336 
  2.3 然之系统默认的管理员帐号是admin，密码是123456。
  2.4 数据库默认的密码是root，密码为空。
  2.5 然之的访问路径：http://localhost/ 其他机器访问将localhost换成ip地址。如果端口号不是80，还需要加上端口号。
  2.6 数据库管理请访问：http://localhost/phpmyadmin/。phpmyadmin只能在然之机器上面访问。

详细的介绍，请访问：http://www.ranzhi.org

Please read the flowing notes before you run ranzhi:

1. How to start ranzhi:

   Double Click 启动然之.exe to run control application。Click the start button to start services.

  If you can't start ranzhi by the control panel, cd xampp\service, double click the install.bat to install and start services
  for ranzhi manually.

2. Notice:

  2.1 Don't change the directory name of xampp.
  2.2 If ranzhi can't start, please check whether the ports of 80 and 3306 conflict with other webserver and database server.
      If you make sure no conflicts for apache and mysql, please consider to install the vc runtime.
      32bit: http://www.microsoft.com/downloads/details.aspx?FamilyID=9B2DA534-3E03-4391-8A4D-074B9F2BC1BF
      64bit: http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=15336 
  2.3 The default administrator for ranzhi is admin, password is 123456.
  2.4 The default administrator for database is root, password is empty.
  2.5 The url for ranzhi is: http://your ip address/, if not 80, add it.
  2.6 To manage database, visit http://localhost/phpmyadmin, which can only be visited from the localhost.

For more infomation, please visit: http://www.ranzhi.org/.
