Ϊ�˱�֤��������ʹ�ã���������֮ǰ��ϸ�Ķ������˵����

1. �����������wamp���ɻ�����
  1.1 һ��Ҫ��xamppĿ¼����ĳһ���̵ĸ�Ŀ¼������c:\xampp, d:\xampp��
  1.2 ����xamppĿ¼��˫��start.bat�ű���������������������
  1.3 ͨ���������������򼴿������������л����������ʡ�

  ����޷�ͨ�����������������������xampp\serviceĿ¼��˫������install.bat������װ�����������ķ���

2. ע�����

  2.1 ��Ҫ�Ķ�xampp��Ŀ¼��������������л������⡣
  2.2 ����޷�����apache�����˿ں��Ƿ��ͻ�����ȷ�ϲ��Ƕ˿ڳ�ͻ���޷��������뿼�ǰ�װvc���л�����
     32λϵͳ���أ�http://www.microsoft.com/downloads/details.aspx?FamilyID=9B2DA534-3E03-4391-8A4D-074B9F2BC1BF
     64λϵͳ���أ�http://www.microsoft.com/download/en/details.aspx?displaylang=en&id=15336 
  2.3 ����ϵͳĬ�ϵĹ���Ա�ʺ���admin��������123456��
  2.4 ���ݿ�Ĭ�ϵĹ���Ա�ʺ���root������Ϊ123456��
  2.5 ����·����http://localhost/ �����������ʽ�localhost����ip��ַ������˿ںŲ���80������Ҫ���϶˿ںš�
  2.6 ���ݿ��������ʣ�http://localhost/phpmyadmin/��phpmyadminֻ������������������ʡ�

��ϸ�Ľ��ܣ�����ʣ�http://www.zentao.net/.

Please read the flowing notes before you run zentao:

1. How to start zentaowamp:

  1.1 Please make sure to put xmapp under the root of one driver, for example c:\xampp or d:\xampp.
  1.2 Enter the xampp directory and double click the start.bat to start the control panel of zentao.
  1.3 Click the 'Start' button to start zentao.

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
  2.5 The url for zentaowamp is: http://your ip address/, if not 80, add it.
  2.6 To manage database, visit http://localhost/phpmyadmin, which can only be visited from the localhost.

For more infomation, please visit: http://www.zentao.net/.