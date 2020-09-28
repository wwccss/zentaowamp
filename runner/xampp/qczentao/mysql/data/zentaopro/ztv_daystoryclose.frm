TYPE=VIEW
query=select count(0) AS `storyclose`,left(`zentaopro`.`zt_action`.`date`,10) AS `day` from `zentaopro`.`zt_action` where ((`zentaopro`.`zt_action`.`objectType` = \'story\') and (`zentaopro`.`zt_action`.`action` = \'closed\')) group by left(`zentaopro`.`zt_action`.`date`,10)
md5=87e61b96d53708f67b19b9f2fe117dca
updatable=0
algorithm=0
definer_user=zentao
definer_host=localhost
suid=2
with_check_option=0
timestamp=2017-04-28 03:31:18
create-version=2
source=select count(*) AS `storyclose`,left(zentaopro.`zt_action`.`date`,10) AS `day` from zentaopro.`zt_action` where ((zentaopro.`zt_action`.`objectType` = \'story\') and (zentaopro.`zt_action`.`action` = \'closed\')) group by left(zentaopro.`zt_action`.`date`,10)
client_cs_name=utf8
connection_cl_name=utf8_general_ci
view_body_utf8=select count(0) AS `storyclose`,left(`zentaopro`.`zt_action`.`date`,10) AS `day` from `zentaopro`.`zt_action` where ((`zentaopro`.`zt_action`.`objectType` = \'story\') and (`zentaopro`.`zt_action`.`action` = \'closed\')) group by left(`zentaopro`.`zt_action`.`date`,10)
mariadb-version=100121
