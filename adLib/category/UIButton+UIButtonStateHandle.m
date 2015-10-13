//
//  UIButton+UIButtonStateHandle.m
//  iComposer
//
//  Created by guangzhuiyuandev on 15/9/18.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "UIButton+UIButtonStateHandle.h"

@implementation UIButton (UIButtonStateHandle)

- (void)setPressDownImageName:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    [self setImage:image forState:UIControlStateHighlighted];
}

- (void)setPressDownImage:(UIImage *)image{
    [self setImage:image forState:UIControlStateHighlighted];
}
@end
