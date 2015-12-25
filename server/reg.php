<?php
	function userReg() {
		$userTel = $_POST["usertel"];
		$userPassword = $_POST["password"];
		$pswConfirm = $_POST["confirm"];
		if($userTel == "" || $userPassword == "" || $pswConfirm == "")
		{
			  $regStatus = 1;
              $response = array(
    	          'regStatus' => $regStatus,
              );
              // 将数据字典使用JSON编码
              echo json_encode($response);
		}
		else
		{
			if($userPassword == $pswConfirm)
			{
				mysql_connect("127.0.0.1","root","940620");	//连接数据库
				mysql_select_db("efruit");	//选择数据库
				mysql_query("set names 'UTF-8'");	//设定字符集
				//$sql = "select user_tel from 'user' where 'user_tel' = $_POST[usertel]";	//SQL语句
				$sql = "select user_tel from user where user_tel ='$_POST[usertel]'";	//SQL语句
				$result = mysql_query($sql);	//执行SQL语句

				$num = mysql_num_rows($result);	//统计执行结果影响的行数
				if($num)	//如果已经存在该用户
				{
					$regStatus = 2;
                    $response = array(
    	            	'regStatus' => $regStatus,
              		);
              		// 将数据字典使用JSON编码
              		echo json_encode($response);
				}
				else	//不存在当前注册用户名称
				{

					$result = mysql_query("SELECT max(user_id) FROM user");

					while($row = mysql_fetch_array($result))
  					{
  						$id = $row['max(user_id)']+1;
 					}
					$sql_insert = "INSERT INTO user 
						 VALUES ('$id', NULL, NULL, NULL, '$_POST[password]','$_POST[usertel]', NULL, NULL)";
					$res_insert = mysql_query($sql_insert);
					if($res_insert)
					{
						$regStatus = 0;
              			$response = array(
    	          			'regStatus' => $regStatus,
              			);
              			// 将数据字典使用JSON编码
              			echo json_encode($response);
					}
					else
					{
						$regStatus = 4;
              			$response = array(
    	          			'regStatus' => $regStatus,
              			);
              			// 将数据字典使用JSON编码
              			echo json_encode($response);
					}
				}
			}
			else
			{
				$regStatus = 3;
              	$response = array(
    	        	'regStatus' => $regStatus,
              	);
              	// 将数据字典使用JSON编码
              	echo json_encode($response);
			}
		}
	}

	header('Content-Type:application/json;charset=utf-8');
	userReg();
?>