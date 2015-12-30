<?php
	function totalOrder() {
			$subOrderID = $_POST["suborderid"]
			$shopId = $_POST["shopid"];		
			$userId = $_POST["userid"];
			$orderRemarks = $_POST["remarks"];
			$deliveryMethod = $_POST["method"];
			$orderAddress = $_POST["address"];
			$orderState = $_POST["state"];	
		}
	





	header('Content-Type:application/json;charset=utf-8');
	totalOrder();
?>