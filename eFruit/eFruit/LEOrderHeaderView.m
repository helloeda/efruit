//
//  LESectionHeaderView.m
//  eFruit
//
//  Created by Eda on 15/12/30.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEOrderHeaderView.h"
@interface LEOrderHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *lblOrderId;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderstate;
@property (weak, nonatomic) IBOutlet UILabel *lblBoughtTime;
@end
@implementation LEOrderHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


+(instancetype)orderHeaderViewWithId:(NSString *)orderId andState:(NSString *)orderState andTime:(NSString *)boughtTime
{
    LEOrderHeaderView *orderHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"LEOrderHeaderView" owner:nil options:nil]lastObject];
    if ([orderState isEqualToString:@"0"] ) {
        orderHeaderView.lblOrderstate.text = @"待支付";
    }
    else if ([orderState isEqualToString:@"1"] ) {
        orderHeaderView.lblOrderstate.text = @"已支付";
    }
    else
    {
        orderHeaderView.lblOrderstate.text = @"已完成";
    }
    orderHeaderView.lblOrderId.text = orderId;
    orderHeaderView.lblBoughtTime.text = boughtTime;
    
    
    return orderHeaderView;
}


@end
