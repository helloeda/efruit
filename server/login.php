<?php
    function userLogin() {
        $userTel = $_POST["usertel"];
        $userPassword = $_POST["password"];
        $con = mysql_connect("127.0.0.1","root","940620");
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
                    $loginStatus = 0;
                    // 将查询结果绑定到数据字典
                    $response = array(
                        'loginStatus' => $loginStatus,
                    );
                        // 将数据字典使用JSON编码
                        echo json_encode($response);
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
