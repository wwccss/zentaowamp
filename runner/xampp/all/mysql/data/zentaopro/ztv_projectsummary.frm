TYPE=VIEW
query=select `zentaopro`.`zt_task`.`project` AS `project`,sum(`zentaopro`.`zt_task`.`estimate`) AS `estimate`,sum(`zentaopro`.`zt_task`.`consumed`) AS `consumed`,sum(`zentaopro`.`zt_task`.`left`) AS `left`,count(0) AS `number`,sum(if(((`zentaopro`.`zt_task`.`status` = \'wait\') or (`zentaopro`.`zt_task`.`status` = \'doing\')),1,0)) AS `undone`,sum((`zentaopro`.`zt_task`.`consumed` + `zentaopro`.`zt_task`.`left`)) AS `totalReal` from `zentaopro`.`zt_task` where (`zentaopro`.`zt_task`.`deleted` = \'0\') group by `zentaopro`.`zt_task`.`project`
md5=aa02807656820c00cc06d86e02af87dd
updatable=0
algorithm=0
definer_user=zentao
definer_host=localhost
suid=2
with_check_option=0
timestamp=2017-04-28 03:31:17
create-version=2
source=select zentaopro.`zt_task`.`project` AS `project`,sum(zentaopro.`zt_task`.`estimate`) AS `estimate`,sum(zentaopro.`zt_task`.`consumed`) AS `consumed`,sum(zentaopro.`zt_task`.`left`) AS `left`,count(0) AS `number`,sum(if(((zentaopro.`zt_task`.`status` = \'wait\') or (zentaopro.`zt_task`.`status` = \'doing\')),1,0)) AS `undone`,sum((zentaopro.`zt_task`.`consumed` + zentaopro.`zt_task`.`left`)) AS `totalReal` from zentaopro.`zt_task` where (zentaopro.`zt_task`.`deleted` = \'0\') group by zentaopro.`zt_task`.`project`
client_cs_name=utf8
connection_cl_name=utf8_general_ci
view_body_utf8=select `zentaopro`.`zt_task`.`project` AS `project`,sum(`zentaopro`.`zt_task`.`estimate`) AS `estimate`,sum(`zentaopro`.`zt_task`.`consumed`) AS `consumed`,sum(`zentaopro`.`zt_task`.`left`) AS `left`,count(0) AS `number`,sum(if(((`zentaopro`.`zt_task`.`status` = \'wait\') or (`zentaopro`.`zt_task`.`status` = \'doing\')),1,0)) AS `undone`,sum((`zentaopro`.`zt_task`.`consumed` + `zentaopro`.`zt_task`.`left`)) AS `totalReal` from `zentaopro`.`zt_task` where (`zentaopro`.`zt_task`.`deleted` = \'0\') group by `zentaopro`.`zt_task`.`project`
mariadb-version=100121
