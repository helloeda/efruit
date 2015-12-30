//
//  LECartFooterView.h
//  eFruit
//
//  Created by Eda on 15/12/28.
//  Copyright © 2015年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LECartFooterView;
@protocol LECartFooterViewDelegate <NSObject,UIScrollViewDelegate>
@required
- (void)cartFooterViewSubmit:(LECartFooterView *)footerView;
@end
@interface LECartFooterView : UIView
@property (nonatomic, weak) id<LECartFooterViewDelegate> delegate;
+(instancetype)cartFooterView;
@end




