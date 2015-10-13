//
//  UIImage+UIImageHandle.h
//  iComposer
//
//  Created by guangzhuiyuandev on 15/9/2.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageHandle)
///将图片存到tmp的指定为dir的目录下,名称为imageName
+(void)saveImage:(UIImage *)image withName:(NSString *)imageName withDir:(NSString *)dir;

///将图片存到tmp的固定的cache目录下,名称为imageName
+(void)saveCacheImage:(UIImage *)image withName:(NSString *)imageName;

/**
 * 真实修改图片大小,而非显示上的缩放
 */
+ (UIImage *)zoomToSize:(CGSize)size withImage:(UIImage *)image;

/**
 *真实旋转图片,而非显示上的旋转.这里angle用角度为单位,取值0-360
 */
+ (UIImage *)rotateAngle:(float)angle withImage:(UIImage *)image;
@end
