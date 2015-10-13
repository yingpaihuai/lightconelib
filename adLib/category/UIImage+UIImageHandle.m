//
//  UIImage+UIImageHandle.m
//  iComposer
//
//  Created by guangzhuiyuandev on 15/9/2.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "UIImage+UIImageHandle.h"

@implementation UIImage (UIImageHandle)


+(void)saveImage:(UIImage *)image withName:(NSString *)imageName withDir:(NSString *)dir{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *dirPath = [NSTemporaryDirectory() stringByAppendingPathComponent:dir];
    BOOL isDir = YES;
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fullPath = [dirPath stringByAppendingPathComponent:imageName];
    [[NSFileManager defaultManager] createFileAtPath:fullPath contents:imageData attributes:nil];
}


+(void)saveCacheImage:(UIImage *)image withName:(NSString *)imageName{
    NSData *imageData = UIImagePNGRepresentation(image);
    NSString *dirPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"cache"];
    BOOL isDir = YES;
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *fullPath = [dirPath stringByAppendingPathComponent:imageName];
    [[NSFileManager defaultManager] createFileAtPath:fullPath contents:imageData attributes:nil];
}



+ (UIImage *)zoomToSize:(CGSize)size withImage:(UIImage *)image{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.width)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}


+ (UIImage *)rotateAngle:(float)angle withImage:(UIImage *)image{
    angle += 180;
    CGSize size = image.size;
    UIGraphicsBeginImageContext(size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat centerX = image.size.width/2.0f;
    CGFloat centerY = image.size.height/2.0f;
    CGContextTranslateCTM(ctx, centerX, centerY);
    CGContextScaleCTM(ctx, -1.0, 1.0);
    CGContextRotateCTM(ctx, -angle * M_PI / 180.0f);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(-centerX,-centerY,size.width, size.height), image.CGImage);
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

@end
