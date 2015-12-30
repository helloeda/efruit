//
//  LELoginViewController.m
//  eFruit
//
//  Created by Eda on 15/12/25.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LELoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "LEHomeViewController.h"
#import "AppDelegate.h"
@interface LELoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTelTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPwdTextField;
- (IBAction)login;

@end

@implementation LELoginViewController

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login {
    // 1.用户名
    NSString *userTelText = self.userTelTextField.text;
    if (userTelText.length == 0) {
        [MBProgressHUD showError:@"请输入用户名"];
        return;
    }
    // 2.密码
    NSString *passwordText = self.userPwdTextField.text;
    if (passwordText.length == 0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    // 增加蒙板
    [MBProgressHUD showMessage:@"正在拼命登录中...."];
    [self httpPostWithUserTel:userTelText andUserPwd:passwordText];
    
    
}

-(void) httpPostWithUserTel:(NSString *)tel andUserPwd:(NSString *)pwd{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    // 1.设置请求路径
    NSURL *URL=[NSURL URLWithString:@"http://fruit.eda.im/login.php"];//不需要传递参数
    
    // 2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    // 3.设置请求体
    NSString *param=[NSString stringWithFormat:@"usertel=%@&password=%@",tel,pwd];
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
        NSNumber *status = dict[@"loginStatus"];
        if ([status  isEqual: @1])
        {
            [MBProgressHUD showError:@"该用户尚未注册，请注册！"];
        }
        else if ([status isEqual:@2])
        {
            [MBProgressHUD showError:@"密码错误，请重试！"];
            
        }
        else if ([status isEqual:@0]){
            
            [MBProgressHUD showSuccess:@"登录成功！"];
            //把用户信息存到全局变量中
            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
            myDelegate.user = [LEUser userWithDict:dict];
            
            //更新水果信息
            NSURL *fruitUrl = [NSURL URLWithString:@"http://fruit.eda.im/fruit.php"];
            // session发起任务
            [[[NSURLSession sharedSession] dataTaskWithURL:fruitUrl completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                // 反序列化
                id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
                NSString *home = NSHomeDirectory();
                NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
                NSString *filepath = [docPath stringByAppendingPathComponent:@"fruit.plist"];
                [dict writeToFile:filepath atomically:YES];
            }] resume];
            
            //切换界面
            UIStoryboard *story=[UIStoryboard  storyboardWithName:@"Main" bundle:nil];
            UIViewController *dtView=[story  instantiateViewControllerWithIdentifier:@"tabbar"];
            [self presentViewController:dtView animated:NO completion:nil];
        }
        else
        {
            [MBProgressHUD showError:@"服务器繁忙，请稍后！"];
        }
        
    }];
    [dataTask resume];
}

@end
