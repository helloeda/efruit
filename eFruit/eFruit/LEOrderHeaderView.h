//
//  LESectionHeaderView.h
//  eFruit
//
//  Created by Eda on 15/12/30.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LEOrderHeaderView : UIView
+(instancetype)orderHeaderViewWithId:(NSString *)orderId andState:(NSString *)orderState andTime:(NSString *)boughtTime;
@end
