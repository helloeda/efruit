//
//  homeViewController.m
//  eFruit
//
//  Created by Eda on 15/12/1.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "homeViewController.h"
#import "LEGoods.h"
#import "LEGoodsCell.h"
#import "LEFooterView.h"
#import "LEHeaderView.h"
@interface homeViewController ()<UITableViewDataSource,LEFooterViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *goods;

@end

@implementation homeViewController


#pragma mark - 懒加载数据

- (NSMutableArray *)goods
{
    if(_goods == nil)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fruit.plist" ofType:nil];
        NSArray *arrayDict = [NSArray arrayWithContentsOfFile:path];
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
    return self.goods.count;
    
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
    LEGoods *model = [[LEGoods alloc] init];
    model.title = @"朱家尖大西瓜";
    model.price = @"6.0";
    model.buyCount = @"1000";
    model.icon = @"watermelon.jpg";
    [self.goods addObject:model];
    [self.tableView reloadData];
    
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:self.goods.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:currentIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
