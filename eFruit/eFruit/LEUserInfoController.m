//
//  LEUserInfoController.m
//  eFruit
//
//  Created by Eda on 15/12/26.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEUserInfoController.h"
#import "LEUser.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
@interface LEUserInfoController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserSex;
@property (weak, nonatomic) IBOutlet UILabel *lblUserBirth;
@property (weak, nonatomic) IBOutlet UILabel *lblUserTel;
@property (strong, nonatomic) LEUser *user;
@end

@implementation LEUserInfoController



#pragma mark - 懒加载数据

- (LEUser *)user
{
    if(_user == nil)
    {
        AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
        _user =  myDelegate.user;
    }
    return _user;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lblUserName.text = self.user.userName;
    self.lblUserSex.text = self.user.userSex;
    self.lblUserBirth.text = self.user.userBirth;
    self.lblUserTel.text = self.user.userTel;
    [self.imgViewIcon sd_setImageWithURL:[NSURL URLWithString:self.user.userIcon] placeholderImage:[UIImage imageNamed:@"icon_default"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        // receivedSize 已经接受到的大小
        // expectedSize 期望的大小，总大小
        //        float progress = (float)receivedSize/expectedSize;
        //        NSLog(@"下载进度 %f", progress);
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //        NSLog(@"%@", [NSThread currentThread]);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
