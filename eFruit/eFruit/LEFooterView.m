//
//  LEFooterView.m
//  Tuan
//
//  Created by Eda on 15/10/26.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LEFooterView.h"

@interface LEFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *btnLoadMore;
@property (weak, nonatomic) IBOutlet UIView *waitingView;
- (IBAction)btnLoadMoreClick;


@end



@implementation LEFooterView


+(instancetype)footerView
{
    LEFooterView *footerView = [[[NSBundle mainBundle] loadNibNamed:@"LEFooterView" owner:nil options:nil]lastObject];
    return footerView;

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)btnLoadMoreClick {
    self.btnLoadMore.hidden = YES;
    self.waitingView.hidden = NO;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(footerViewUpdateData:)]) {
        [self.delegate footerViewUpdateData:self];
        }
        // 4. 显示"加载更多"按钮
        self.btnLoadMore.hidden = NO;
        // 5. 隐藏"等待指示器"所在的那个UIView
        self.waitingView.hidden = YES;
    });

    

}
@end
