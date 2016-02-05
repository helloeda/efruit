<?php
	function totalOrder() {
		date_default_timezone_set("PRC");
		$shopId = $_POST["shopid"];		
		$userId = $_POST["userid"];
		$orderRemarks = $_POST["remarks"];
		$deliveryMethod = $_POST["method"];
		$orderAddress = $_POST["address"];
		$subOrderId = $_POST["suborderid"];
		if($subOrderId == "" || $shopId == "" || $userId == "" || $orderRemarks == "" 
			||$deliveryMethod == "" || $orderAddress == "")
		{
			$totalStatus = 1;
            $response = array(
    	        'totalStatus' => $totalStatus,
            );
            // 将数据字典使用JSON编码
            echo json_encode($response);
		}
		else
		{
			include "config.php";
			mysql_select_db("efruit");	//选择数据库
			mysql_query("set names 'UTF-8'");	//设定字符集
			$result = mysql_query("SELECT max(order_id) FROM total_order");
			while($row = mysql_fetch_array($result))
  			{
  				$id = $row['max(order_id)']+1;
 			}

 			$boughtTime = date('Y-m-d H:i:s',time());

 			mysql_query("SET NAMES 'UTF8'"); 
			$sql_insert = "INSERT INTO total_order 
			VALUES ($id,$shopId,$userId, '$boughtTime', '$orderRemarks', '$deliveryMethod' , '$orderAddress', '0', '$subOrderId')";
			$res_insert = mysql_query($sql_insert);
			if($res_insert)
			{
	     		$totalStatus = 0;
              	$response = array(
    	        	'totalStatus' => $totalStatus,
              	);
              	// 将数据字典使用JSON编码
              	echo json_encode($response);
			}
			else
			{
  				$totalStatus = 2;
              	$response = array(
    	        	'totalStatus' => $totalStatus,
              	);
              	// 将数据字典使用JSON编码
             	echo json_encode($response);
			}
			
		}
	}



	header('Content-Type:application/json;charset=utf-8');
	totalOrder();
?>