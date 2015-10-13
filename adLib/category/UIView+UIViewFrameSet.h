//
//  UIView+UIViewFrameSet.h
//  iComposer
//
//  Created by guangzhuiyuandev on 15/9/1.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (UIViewFrameSet)
- (void)setFrameX:(CGFloat)x;
- (void)setFrameY:(CGFloat)y;
- (void)setFrameWidth:(CGFloat)width;
- (void)setFrameHeight:(CGFloat)height;

- (void)getFrameInfo:(NSString *)viewName;
@end
