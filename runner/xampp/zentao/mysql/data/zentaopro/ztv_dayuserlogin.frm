TYPE=VIEW
query=select count(0) AS `userlogin`,left(`zentaopro`.`zt_action`.`date`,10) AS `day` from `zentaopro`.`zt_action` where ((`zentaopro`.`zt_action`.`objectType` = \'user\') and (`zentaopro`.`zt_action`.`action` = \'login\')) group by left(`zentaopro`.`zt_action`.`date`,10)
md5=0cf6389d4d92625e3343d330a069e8c5
updatable=0
algorithm=0
definer_user=zentao
definer_host=localhost
suid=2
with_check_option=0
timestamp=2017-04-28 03:31:18
create-version=2
source=select count(*) AS `userlogin`,left(zentaopro.`zt_action`.`date`,10) AS `day` from zentaopro.`zt_action` where ((zentaopro.`zt_action`.`objectType` = \'user\') and (zentaopro.`zt_action`.`action` = \'login\')) group by left(zentaopro.`zt_action`.`date`,10)
client_cs_name=utf8
connection_cl_name=utf8_general_ci
view_body_utf8=select count(0) AS `userlogin`,left(`zentaopro`.`zt_action`.`date`,10) AS `day` from `zentaopro`.`zt_action` where ((`zentaopro`.`zt_action`.`objectType` = \'user\') and (`zentaopro`.`zt_action`.`action` = \'login\')) group by left(`zentaopro`.`zt_action`.`date`,10)
mariadb-version=100121
