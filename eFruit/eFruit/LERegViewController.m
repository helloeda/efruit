//
//  LERegController.m
//  eFruit
//
//  Created by Eda on 15/12/25.
//  Copyright © 2015年 Eda. All rights reserved.
//


#import "LERegViewController.h"
#import "MBProgressHUD+MJ.h"
@interface LERegViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTelTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
- (IBAction)regist;

@end
@implementation LERegViewController


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)regist {
    // 1.用户名
    NSString *userTelText = self.userTelTextField.text;
    if (userTelText.length == 0) {
        [MBProgressHUD showError:@"请输入用户名"];
        return;
    }
    
    // 2.密码
    NSString *userPwdText = self.userPwdTextField.text;
    if (userPwdText.length == 0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    // 3.确认密码
    NSString *confirmText = self.confirmTextField.text;
    if (confirmText.length == 0) {
        [MBProgressHUD showError:@"请确认密码"];
        return;
    }
    
    
    if (![confirmText isEqualToString: userPwdText]) {
        [MBProgressHUD showError:@"两次密码不一致，请重新输入！"];
        return;
    }
    
    // 增加蒙板
    [MBProgressHUD showMessage:@"正在注册，请稍后…"];
    [self httpPostWithUserTel:userTelText andUserPwd:userPwdText andConfirm:confirmText];
    
}


-(void) httpPostWithUserTel:(NSString *)tel andUserPwd:(NSString *)pwd andConfirm:(NSString *)conf{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    // 1.设置请求路径
    NSURL *URL=[NSURL URLWithString:@"http://fruit.eda.im/reg.php"];//不需要传递参数
    
    // 2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    // 3.设置请求体
    NSString *param=[NSString stringWithFormat:@"usertel=%@&password=%@&confirm=%@",tel,pwd,conf];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    // 4.设置请求头信息
    [request setValue:@"ios+android" forHTTPHeaderField:@"User-Agent"];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        [MBProgressHUD hideHUD];
        if (connectionError || data == nil)
        { // 一般请求超时就会来到这
            [MBProgressHUD showError:@"网络繁忙，请稍后！"];
            return;
        }
        // 解析服务器返回的JSON数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSNumber *status = dict[@"regStatus"];
        if ([status  isEqual: @1])
        {
            [MBProgressHUD showError:@"信息不完整！请重新输入！"];
        }
        else if ([status isEqual:@2])
        {
            [MBProgressHUD showError:@"该用户已经存在，请登录！"];
            
        }
        else if ([status isEqual:@3])
        {
            [MBProgressHUD showError:@"两次密码不一致，请重新输入！"];
            
        }
        else if ([status isEqual:@0]){
            [MBProgressHUD showSuccess:@"恭喜您，注册成功！"];
        }
        else {
            [MBProgressHUD showSuccess:@"网络繁忙，请稍后！"];
        }
        
    }];
    [dataTask resume];
}



@end
