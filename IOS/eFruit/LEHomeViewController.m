//
//  homeViewController.m
//  eFruit
//
//  Created by Eda on 15/12/1.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEHomeViewController.h"
#import "LEGoods.h"
#import "LEGoodsCell.h"
#import "LEFooterView.h"
#import "LEHeaderView.h"
#import "LEHomeDetailViewController.h"
@interface LEHomeViewController () <UITableViewDataSource,LEFooterViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *goods;
@end

@implementation LEHomeViewController

int cellCount =10;

#pragma mark - 懒加载数据

- (NSMutableArray *)goods
{
    if(_goods == nil)
    {
        // 1.获得沙盒根路径
        NSString *home = NSHomeDirectory();
        // 2.document路径
        NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
                NSLog(@"%@",docPath);
        // 3.文件路径
        NSString *filepath = [docPath stringByAppendingPathComponent:@"fruit.plist"];
        NSArray *arrayDict = [NSArray arrayWithContentsOfFile:filepath];
        NSMutableArray *arrayModel = [NSMutableArray array];
        for (NSDictionary *dict in arrayDict) {
            LEGoods *model = [LEGoods goodsWithDict:dict];
            [arrayModel addObject:model];
        }
        _goods = arrayModel;
    }
    return _goods;
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellCount;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1. 获取数据模型
    LEGoods *model = self.goods[indexPath.row];
    
    //2. 通过xib方式创建单元格
    LEGoodsCell *cell = [LEGoodsCell goodsCellWithTableView:tableView];
    //3. 把模型数据设置给单元格
    cell.goods = model;
    //4. 返回cell
    return cell;
    
}

#pragma mark - LEFooterView的代理方法
- (void)footerViewUpdateData:(LEFooterView *)footerView
{
    if (cellCount != self.goods.count) {
        cellCount++;
        [self.tableView reloadData];
        NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:cellCount-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

#pragma mark - 加载控制器方法
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = FALSE;
    self.tableView.rowHeight = 68;
    LEFooterView *footerView = [LEFooterView footerView];
    self.tableView.tableFooterView = footerView;
    footerView.delegate = self;
    
    LEHeaderView *headerView =[LEHeaderView headerView];
    self.tableView.tableHeaderView = headerView;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LEGoods *fruitM = _goods[indexPath.row];
    UIStoryboard *story=[UIStoryboard  storyboardWithName:@"Main" bundle:nil];
    LEHomeDetailViewController *homeDetailVC = [story instantiateViewControllerWithIdentifier:@"homeDetail"];
    homeDetailVC.good = fruitM;
    [self.navigationController pushViewController:homeDetailVC animated:YES];
    
}




//#pragma mark - 隐藏状态栏
//- (BOOL) prefersStatusBarHidden
//{
//    return YES;
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
