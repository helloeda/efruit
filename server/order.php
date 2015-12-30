<?php

	  function showOrder() {
        $userId = $_POST["userid"];
        $con = mysql_connect("127.0.0.1","root","940620");
        mysql_select_db("efruit");	//选择数据库
        mysql_query("set names utf8;");
        $orders = array();
        $result = mysql_query("select * from total_order");
        while($row = mysql_fetch_array($result))
        {   
 	        if($userId == $row['user_id'])
 	        {
 	        	$orderId = $row['order_id'];
 	        	$boughtTime = $row['bought_time'];
 	        	$remarks = $row['order_remarks'];
 	        	$orderStatus = $row['order_state'];
 	        	$subOrderId = $row['sub_order_id'];
 	        	$obj = json_decode($subOrderId,true);
 	        	$subOrders = array();
 	        	foreach($obj as $x=>$x_value) {
 	        		$newResult = mysql_query("select * from view_order");
 	        	 	while($row = mysql_fetch_array($newResult))
        			{   
 	        			if($x_value == $row['sub_order_id'])
 	        			{
 	        				$subOrder = array(
				        	    'fruitName' =>  $row['fruit_name'],
				                'fruitImage' => $row['fruit_image'],
				                'fruitPrice' => $row['sub_order_price'],
				                'fruitQuantity' => $row['sub_order_quantity'] 
				            );
 	        			array_push($subOrders,$subOrder);
 	        			}
 	        		}	
 	        	}
    			$order = array(
    			    'orderId' => $orderId,
	        	    'boughtTime' =>  $boughtTime,
	                'remarks' => $remarks,
	                'orderStatus' => $orderStatus,
	                'subOrders' => $subOrders
	            );
				array_push($orders, $order);
				
 	        }

		}

		echo json_encode($orders, JSON_UNESCAPED_UNICODE);;





	}

 	header('Content-Type:application/json;charset=utf-8');
	showOrder();
?>