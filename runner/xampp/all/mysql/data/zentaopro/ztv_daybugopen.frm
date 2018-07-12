TYPE=VIEW
query=select count(0) AS `bugopen`,left(`zentaopro`.`zt_action`.`date`,10) AS `day` from `zentaopro`.`zt_action` where ((`zentaopro`.`zt_action`.`objectType` = \'bug\') and (`zentaopro`.`zt_action`.`action` = \'opened\')) group by left(`zentaopro`.`zt_action`.`date`,10)
md5=fdf26b045ca99c7d7130db17bc8e23de
updatable=0
algorithm=0
definer_user=zentao
definer_host=localhost
suid=2
with_check_option=0
timestamp=2017-04-28 03:31:18
create-version=2
source=select count(*) AS `bugopen`,left(zentaopro.`zt_action`.`date`,10) AS `day` from zentaopro.`zt_action` where ((zentaopro.`zt_action`.`objectType` = \'bug\') and (zentaopro.`zt_action`.`action` = \'opened\')) group by left(zentaopro.`zt_action`.`date`,10)
client_cs_name=utf8
connection_cl_name=utf8_general_ci
view_body_utf8=select count(0) AS `bugopen`,left(`zentaopro`.`zt_action`.`date`,10) AS `day` from `zentaopro`.`zt_action` where ((`zentaopro`.`zt_action`.`objectType` = \'bug\') and (`zentaopro`.`zt_action`.`action` = \'opened\')) group by left(`zentaopro`.`zt_action`.`date`,10)
mariadb-version=100121
