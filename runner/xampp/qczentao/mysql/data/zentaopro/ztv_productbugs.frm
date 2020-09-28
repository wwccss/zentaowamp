TYPE=VIEW
query=select `zentaopro`.`zt_bug`.`product` AS `product`,count(0) AS `bugs`,sum(if((`zentaopro`.`zt_bug`.`resolution` = \'\'),0,1)) AS `resolutions`,sum(if((`zentaopro`.`zt_bug`.`severity` <= 2),1,0)) AS `seriousBugs` from `zentaopro`.`zt_bug` where (`zentaopro`.`zt_bug`.`deleted` = \'0\') group by `zentaopro`.`zt_bug`.`product`
md5=9008fe5ed5d48105dce0d30a2a1f41b1
updatable=0
algorithm=0
definer_user=zentao
definer_host=localhost
suid=2
with_check_option=0
timestamp=2017-04-28 03:31:18
create-version=2
source=select zentaopro.`zt_bug`.`product` AS `product`,count(0) AS `bugs`,sum(if((zentaopro.`zt_bug`.`resolution` = \'\'),0,1)) AS `resolutions`,sum(if((zentaopro.`zt_bug`.`severity` <= 2),1,0)) AS `seriousBugs` from zentaopro.`zt_bug` where (zentaopro.`zt_bug`.`deleted` = \'0\') group by zentaopro.`zt_bug`.`product`
client_cs_name=utf8
connection_cl_name=utf8_general_ci
view_body_utf8=select `zentaopro`.`zt_bug`.`product` AS `product`,count(0) AS `bugs`,sum(if((`zentaopro`.`zt_bug`.`resolution` = \'\'),0,1)) AS `resolutions`,sum(if((`zentaopro`.`zt_bug`.`severity` <= 2),1,0)) AS `seriousBugs` from `zentaopro`.`zt_bug` where (`zentaopro`.`zt_bug`.`deleted` = \'0\') group by `zentaopro`.`zt_bug`.`product`
mariadb-version=100121
