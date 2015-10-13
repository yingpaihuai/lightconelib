//
//  ImageToVideo.h
//  iComposer
//
//  Created by guangzhuiyuandev on 15/8/26.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CutImageRadius.h"
#import "UIImage+UIImageHandle.h"
#import "MusicParameter.h"
#import "UIColor+ColorSet.h"

@interface ImageToVideo : NSObject
@property (strong, nonatomic) UIImage *videoImage;

- (UIImage *)createVideoImage:(UIImage *)image withCoverImage:(UIImage *)coverImage withMusicParameter:(MusicParameter *)musicParameter;
@end
