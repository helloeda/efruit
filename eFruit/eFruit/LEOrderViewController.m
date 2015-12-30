//
//  LEOrderViewController.m
//  eFruit
//
//  Created by Eda on 15/12/30.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEOrderViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "LEOrderHeaderView.h"
#import "LESubOrder.h"
#import "LEOrderCell.h"
@interface LEOrderViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *userTel;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (nonatomic, strong) NSMutableArray *arrayOrder;
@end

@implementation LEOrderViewController


- (void)reloadData
{
    [self loadOrder];
    [self.tableView reloadData];
}

#pragma mark - 加载控制器方法
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    self.userTel.text = myDelegate.user.userTel;
    self.userName.text = myDelegate.user.userName;
    [self.imgViewIcon sd_setImageWithURL:[NSURL URLWithString:myDelegate.user.userIcon] placeholderImage:[UIImage imageNamed:@"icon_default"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    [self loadOrder];
    self.tableView.separatorStyle = NO;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.rowHeight = 68;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view 数据源方法
-(void) loadOrder{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    // 1.设置请求路径
    NSURL *URL=[NSURL URLWithString:@"http://127.0.0.1/order.php"];
    
    // 2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    // 3.设置请求体
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
     NSString *param=[NSString stringWithFormat:@"userid=%@",myDelegate.user.userId];
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    // 4.设置请求头信息
    [request setValue:@"ios+android" forHTTPHeaderField:@"User-Agent"];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
        [MBProgressHUD hideHUD];
        if (connectionError || data == nil)
        { // 一般请求超时就会来到这
            [MBProgressHUD showError:@"网络繁忙..."];
            return;
        }
        else {
            id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            self.arrayOrder = dict;
            [self.tableView reloadData];
        }
              
    }];
    [dataTask resume];}
#pragma mark - Table view 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.arrayOrder.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *dictOrder = [NSDictionary dictionary];
    dictOrder = self.arrayOrder[section];
    NSMutableArray *subOrder = [NSMutableArray array];
    subOrder = dictOrder[@"subOrders"];
    return subOrder.count;


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dictOrder = [NSDictionary dictionary];
    dictOrder = self.arrayOrder[indexPath.section];
    NSMutableArray *subOrder = [NSMutableArray array];
    subOrder = dictOrder[@"subOrders"];
    NSDictionary *dictSubOrder = [NSDictionary dictionary];
    dictSubOrder = subOrder[indexPath.row];
    LESubOrder *model = [LESubOrder subOrderWithDict:dictSubOrder];
    
    LEOrderCell *cell = [LEOrderCell orderCellWithTableView:tableView];
    cell.subOrder = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//自定义section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section

{
    
    NSDictionary *dictOrder = [NSDictionary dictionary];
    dictOrder = self.arrayOrder[section];
    LEOrderHeaderView *headerView = [LEOrderHeaderView orderHeaderViewWithId:dictOrder[@"orderId"] andState:dictOrder[@"orderStatus"] andTime:dictOrder[@"boughtTime"]];
    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
