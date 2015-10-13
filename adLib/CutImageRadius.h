//
//  CutImageRadius.h
//  iComposer
//
//  Created by guangzhuiyuandev on 15/8/20.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CutImageRadius : NSObject
@property (strong, nonatomic)UIImage *image;
- (void)initWithImage:(UIImage *)image;
- (UIImage*)cutImageWithRadius;
- (UIImage *)addImage:(UIImage *)coverImage toImage:(UIImage *)customImage;
@end
