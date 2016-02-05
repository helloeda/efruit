<?php
	function subOrder() {
		
		$jsonStr = $_POST["jsonStr"];
		//echo $jsonStr;
		$obj = json_decode($jsonStr,true);
		//var_dump(json_decode($jsonStr)); 
		

		include "config.php";
		mysql_select_db("efruit");	//选择数据库
		mysql_query("set names 'UTF-8'");	//设定字符集
		$subStatus = 0;
		$response = array(); 
		foreach($obj as $x=>$x_value) {
			$Status = 1;
  			$userId = $x_value['userid'] ;
			$fruitId = $x_value['fruitid'] ;
			$fruitPrice = $x_value['price'] ;
 			$fruitQuantity = $x_value['quantity'] ;

			$result = mysql_query("SELECT max(sub_order_id) FROM sub_order");
			while($row = mysql_fetch_array($result))
  			{
  				$id = $row['max(sub_order_id)']+1;
 			}
			$sql_insert = "INSERT INTO sub_order 
			VALUES ('$id', '$userId', '$fruitId', '$fruitPrice', '$fruitQuantity')";
			$res_insert = mysql_query($sql_insert);
			if($res_insert)
			{
			}
			else
			{
				$Status = 0;
			}
			array_push($response, $id);
		}
		if($Status == 1)
			$subStatus = 1;
		if($subStatus == 1)
			echo json_encode($response, JSON_UNESCAPED_UNICODE);

}

	header('Content-Type:application/json;charset=utf-8');
	subOrder();
?>