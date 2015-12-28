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
@interface LECartViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *carts;

@end

@implementation LECartViewController


- (void)refreshData
{
    [self.tableView reloadData];
    
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
    //4. 返回cell
    return cell;
    
    
    
}




#pragma mark - 加载控制器方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.rowHeight = 68;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
