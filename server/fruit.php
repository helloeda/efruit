<?php
    function userLogin() {
        $userTel = $_POST["usertel"];
        $userPassword = $_POST["password"];
        include "config.php";
	    if(!$con)
 	    {
	        $fruitStatus = 0;
            $response = array(
                'fruitStatus' => $Status,
            );
            // 将数据字典使用JSON编码
            die (json_encode($response));
 	      }
        mysql_select_db("efruit");	//选择数据库
        mysql_query("set names utf8;");
        $result = mysql_query("select * from fruit");
        $json = array();
        while($row = mysql_fetch_array($result))
        {   
            $fruitId = $row['fruit_id'];
            $fruitName = $row['fruit_name'];
            $fruitImage = $row['fruit_image'];
            $fruitIntro = $row['fruit_intro'];
            $fruitPrice = $row['fruit_price'];
            $fruitSales = $row['fruit_sales_volume'];
            $fruitBuyable = $row['fruit_is_buyable'];
            $response = array(
                'fruitId' => $fruitId,      
                'fruitName' =>  $fruitName,
                'fruitImage' => $fruitImage,
                'fruitIntro' => $fruitIntro,
                'fruitPrice' => $fruitPrice,
                'fruitSales' => $fruitSales ,
                'fruitBuyable' => $fruitBuyable
            );
            array_push($json, $response);
           
        } // 将数据字典使用JSON编码
            echo json_encode($json, JSON_UNESCAPED_UNICODE);
    }

    header('Content-Type:application/json;charset=utf-8');
    userLogin();

?>