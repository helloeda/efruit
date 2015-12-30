<?php
	header('Content-Type:application/json;charset=utf-8');
	showOrder();
	  function showOrder() {
        $userId = $_POST["user_id"];
        $con = mysql_connect("127.0.0.1","root","940620");
        mysql_select_db("efruit");	//选择数据库
        mysql_query("set names utf8;");
        $result = mysql_query("select * from total_order");
          while($row = mysql_fetch_array($result))
        {   
 	        if($userTel==$row['user_tel'])
?>