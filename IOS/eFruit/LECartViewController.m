//
//  LECartViewController.m
//  eFruit
//
//  Created by Eda on 15/12/28.
//  Copyright © 2015年 Eda. All rights reserved.
//
#import "AppDelegate.h"
#import "LECartViewController.h"
#import "LEGoods.h"
#import "LEGoodsCell.h"
#import "LEHomeDetailViewController.h"
#import "LECart.h"
#import "LECartCell.h"
#import "LECartFooterView.h"
#import "MBProgressHUD+MJ.h"
@interface LECartViewController () <UITableViewDataSource,UITableViewDelegate,LECartFooterViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textRemarks;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *carts;
- (IBAction)segChangeDelivery;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segDelivery;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIButton *lblAddress;

@end

@implementation LECartViewController


#pragma - mark 代理方法refreshData实现

- (void)refreshData
{
    [self.tableView reloadData];

    if ([self.tableView numberOfRowsInSection:0] == 0) {
        self.tableView.tableFooterView.hidden = YES;
    }
    else {
        self.tableView.tableFooterView.hidden = NO;
    }
    
    
}
#pragma - mark 选择配送方式方法
- (IBAction)segChangeDelivery {
    //此处配送选择功能未实现
    if(self.segDelivery.selectedSegmentIndex == 0)
    {
        self.lblTitle.text = @"提货地址：";
        self.lblAddress.titleLabel.text = @"浙工大提货点";
    }
    else
    {
        self.lblTitle.text = @"配送地址：";
        self.lblAddress.titleLabel.text = @"东14幢414室";
    }
}

#pragma - mark 代理方法cartFooterViewSubmit实现
- (void)cartFooterViewSubmit:(LECartFooterView *)footerView{
    if(self.textRemarks.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入备注！"];
    }
    else{
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        NSMutableArray *paraArray = [NSMutableArray array];
        for (LECart *cart in self.carts) {
            NSString *quantity = [NSString stringWithFormat:@"%d",cart.num];
            NSDictionary *paraDict = @{@"userid": myDelegate.user.userId,@"fruitid": cart.good.fruitId,
                                       @"price": cart.good.fruitPrice,@"quantity": quantity};
            [paraArray addObject:paraDict];
        }
        
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:paraArray options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr =[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];


        //子订单请求
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];

        // 1.设置请求路径
        NSURL *URL=[NSURL URLWithString:@"http://fruit.eda.im/submit_order.php"];//不需要传递参数
        // 2.创建请求对象
        NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
        request.timeoutInterval=5.0;//设置请求超时为5秒
        request.HTTPMethod=@"POST";//设置请求方法
        // 3.设置请求体

        NSString *param=[NSString stringWithFormat:@"jsonStr=%@",jsonStr];
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
            else
            {
                NSString *subOrderId =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                
                // 1.设置请求路径
                NSURL *URL=[NSURL URLWithString:@"http://fruit.eda.im/submit_total.php"];//不需要传递参数
                // 2.创建请求对象
                NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];
                request.timeoutInterval=5.0;//设置请求超时为5秒
                request.HTTPMethod=@"POST";//设置请求方法
                // 3.设置请求体
                NSString *param=[NSString stringWithFormat:@"shopid=%@&userid=%@&remarks=%@&method=%ld&address=%@&suborderid=%@",myDelegate.user.shopId,myDelegate.user.userId,self.textRemarks.text,(long)self.segDelivery.selectedSegmentIndex,self.lblAddress.titleLabel.text,subOrderId];
                request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
                // 4.设置请求头信息
                [request setValue:@"ios+android" forHTTPHeaderField:@"User-Agent"];
                
                NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    NSNumber *status = dict[@"totalStatus"];
                    if ([status  isEqual: @0])
                    {
                        [MBProgressHUD showSuccess:@"订单提交成功！"];
                        [myDelegate.carts removeAllObjects];
                        [self.tableView reloadData];
                         self.tableView.tableFooterView.hidden = YES;
                        
                    }
                    else if ([status isEqual:@1])
                    {
                        [MBProgressHUD showError:@"订单提交失败！"];
                        
                    }

                
                }];
                [dataTask resume];

            }
            
        }];
        [dataTask resume];

    }
}





#pragma mark - 懒加载数据

- (NSMutableArray *)carts
{
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableArray *arrayModel = [NSMutableArray arrayWithArray: myDelegate.carts];
    _carts = arrayModel;
    return _carts;

}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // NSLog(@"%d",self.carts.count);
    return self.carts.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1. 获取数据模型
    LECart *model = self.carts[indexPath.row];
    //2. 通过xib方式创建单元格
    LECartCell *cell = [LECartCell cartCellWithTableView:tableView];
    //3. 把模型数据设置给单元格
    cell.cart = model;
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    //4. 返回cell
    return cell;
    
    
    
}

//滑动删除功能

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:YES animated:YES];
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    [myDelegate.carts removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    if ([self.tableView numberOfRowsInSection:0] == 0) {
        self.tableView.tableFooterView.hidden = YES;
    }
    else {
        self.tableView.tableFooterView.hidden = NO;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView setEditing:NO animated:YES];
}

#pragma mark - 加载控制器方法
- (void)viewDidLoad {
    [super viewDidLoad];
    LECartFooterView *cartFooterView = [LECartFooterView cartFooterView];
    self.tableView.tableFooterView = cartFooterView;
    cartFooterView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.rowHeight = 68;
    if ([self.tableView numberOfRowsInSection:0] == 0) {
        self.tableView.tableFooterView.hidden = YES;
    }
    else {
        self.tableView.tableFooterView.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.tableView setEditing:NO animated:YES];
}



//#pragma mark - UITableViewDelegate
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    LEGoods *fruitM = _goods[indexPath.row];
//    UIStoryboard *story=[UIStoryboard  storyboardWithName:@"Main" bundle:nil];
//    LEHomeDetailViewController *homeDetailVC = [story instantiateViewControllerWithIdentifier:@"homeDetail"];
//    homeDetailVC.good = fruitM;
//    [self.navigationController pushViewController:homeDetailVC animated:YES];
//    
//}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
