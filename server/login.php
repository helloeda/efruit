<?php
    $lifetime=3000;
    session_set_cookie_params($lifetime);
    session_start();
    function userLogin() {
        $userTel = $_POST["usertel"];
        $userPassword = $_POST["password"];
        include "config.php";
	    if(!$con)
 	    {
	        $loginStatus = 3;
            $response = array(
                'loginStatus' => $loginStatus,
            );
            // 将数据字典使用JSON编码
            die (json_encode($response));
 	      }
        mysql_select_db("efruit");	//选择数据库
        mysql_query("set names utf8;");
        $result = mysql_query("select * from user");
        while($row = mysql_fetch_array($result))
        {   
 	        if($userTel==$row['user_tel'])
            {   
     	        $sign = true;
                if($userPassword==$row['user_password'])
                {    /*存取session*/
                    $_SESSION['usertel']=$row['user_tel'];   
                    $_SESSION['password']=$row['user_password'];

                    $userId = $row['user_id'];
                    $userName = $row['user_name'];
                    $userSex = $row['user_sex'];
                    $userBirth = $row['user_birthdate'];
                    $shopId = $row['shop_id'];
                    $userIcon = $row['user_icon_address'];
                    $loginStatus = 0;
                    // 将查询结果绑定到数据字典
                    $response = array(
                        'loginStatus' => $loginStatus,
                        'userId' => $userId,
                        'userName' => $userName,
                        'userSex' => $userSex,
                        'userBirth' => $userBirth,
                        'userTel' => $userTel,
                        'userPassword' => $userPassword,
                        'shopId' => $shopId,
                        'userIcon' => $userIcon
                        
                    );
                        // 将数据字典使用JSON编码
                        echo json_encode($response, JSON_UNESCAPED_UNICODE);

                }
                else{
                    $loginStatus = 2;
                    $response = array(
                        'loginStatus' => $loginStatus,
                    );
                    // 将数据字典使用JSON编码
                    echo json_encode($response);
                }
                     
            }
        }
        if($sign == false)
        {
            $loginStatus = 1;
            $response = array(
                'loginStatus' => $loginStatus,
            );
            // 将数据字典使用JSON编码
            echo json_encode($response);
        }
    }

    header('Content-Type:application/json;charset=utf-8');
    userLogin();

?>
