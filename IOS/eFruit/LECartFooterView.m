//
//  LECartFooterView.m
//  eFruit
//
//  Created by Eda on 15/12/28.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import "LECartFooterView.h"
@interface LECartFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *btnSubmit;
@property (weak, nonatomic) IBOutlet UIView *waitingView;
- (IBAction)btnSubmitClick;

@end

@implementation LECartFooterView


+(instancetype)cartFooterView
{
    LECartFooterView *cartFooterView = [[[NSBundle mainBundle] loadNibNamed:@"LECartFooterView" owner:nil options:nil]lastObject];
    return cartFooterView;
}

- (IBAction)btnSubmitClick {
    self.btnSubmit.hidden = YES;
    self.waitingView.hidden = NO;

    if ([self.delegate respondsToSelector:@selector(cartFooterViewSubmit:)]) {
        [self.delegate cartFooterViewSubmit:self];
    }
    // 4. 显示"加载更多"按钮
    self.btnSubmit.hidden = NO;
    // 5. 隐藏"等待指示器"所在的那个UIView
    self.waitingView.hidden = YES;
  

    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
