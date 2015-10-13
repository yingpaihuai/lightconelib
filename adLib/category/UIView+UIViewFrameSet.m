//
//  UIView+UIViewFrameSet.m
//  iComposer
//
//  Created by guangzhuiyuandev on 15/9/1.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "UIView+UIViewFrameSet.h"

@implementation UIView (UIViewFrameSet)
- (void)setFrameX:(CGFloat)x{
    self.frame = CGRectMake(x, self.frame.origin.y, self.frame.size.width,self.frame.size.height);
}
- (void)setFrameY:(CGFloat)y{
    self.frame = CGRectMake(self.frame.origin.x, y, self.frame.size.width,self.frame.size.height);
}
- (void)setFrameWidth:(CGFloat)width{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width,self.frame.size.height);
}
- (void)setFrameHeight:(CGFloat)height{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,height);
}

- (void)getFrameInfo:(NSString *)viewName{
    if (viewName == nil) {
        viewName = @"";
    }
    NSLog(@"%@坐标X=%f,Y=%f,大小width=%f,height=%f",viewName,self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
}
@end
