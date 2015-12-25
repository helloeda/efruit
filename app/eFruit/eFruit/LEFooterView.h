//
//  LEFooterView.h
//  Tuan
//
//  Created by Eda on 15/10/26.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LEFooterView;
@protocol LEFooterViewDelegate <NSObject,UIScrollViewDelegate>
@required
- (void)footerViewUpdateData:(LEFooterView *)footerView;
@end

@interface LEFooterView : UIView

+ (instancetype)footerView;
@property (nonatomic, weak) id<LEFooterViewDelegate> delegate;

@end
