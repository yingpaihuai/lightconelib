//
//  UIColor+ColorSet.h
//  iComposer
//
//  Created by guangzhuiyuandev on 15/9/15.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorSet)
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
@end
