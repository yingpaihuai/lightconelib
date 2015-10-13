//
//  CutImageRadius.m
//  iComposer
//
//  Created by guangzhuiyuandev on 15/8/20.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "CutImageRadius.h"

@implementation CutImageRadius

- (void)initWithImage:(UIImage *)image{
    self.image = image;
}

///图片切角,变圆滑,当为正方形且radius为1/4/长时得到圆形
- (UIImage*)cutImageWithRadius
{
    
    if (self.image.size.height != self.image.size.width){
        [self changeToSquare:self.image];
    }
    
    float radius = self.image.size.height/4;

    UIGraphicsBeginImageContext(self.image.size);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    float x1 = 0.;
    float y1 = 0.;
    float x2 = x1+self.image.size.width;
    float y2 = y1;
    float x3 = x2;
    float y3 = y1+self.image.size.height;
    float x4 = x1;
    float y4 = y3;
    radius = radius*2;
    
    CGContextMoveToPoint(gc, x1, y1+radius);
    CGContextAddArcToPoint(gc, x1, y1, x1+radius, y1, radius);
    CGContextAddArcToPoint(gc, x2, y2, x2, y2+radius, radius);
    CGContextAddArcToPoint(gc, x3, y3, x3-radius, y3, radius);
    CGContextAddArcToPoint(gc, x4, y4, x4, y4-radius, radius);
    
    
    CGContextClosePath(gc);
    CGContextClip(gc);
    
    CGContextTranslateCTM(gc, 0, self.image.size.height);
    CGContextScaleCTM(gc, 1, -1);
    CGContextDrawImage(gc, CGRectMake(0, 0, self.image.size.width, self.image.size.height), self.image.CGImage);
    
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return self.image;
}

///从矩形获得正方形(方便切割圆形)
- (UIImage *)changeToSquare:(UIImage *)image{
    //获取小正方形,用长宽小的做直径
    double diameter = image.size.height < image.size.width ? image.size.height : image.size.width;
    /*如果是获取大正方形,用斜边做直径
    double diameter = sqrt(pow(image.size.height, 2.0) + pow(image.size.width, 2.0));
     如果是获取大正方形,用长宽大的做直径
     double diameter = image.size.height > image.size.width ? image.size.height : image.size.width;//用此法暂时会出现正方形透明化的问题
     */
    UIGraphicsBeginImageContext(CGSizeMake(diameter, diameter));
    
    float x = (diameter - image.size.width)/2.0;
    float y = (diameter - image.size.height)/2.0;
    
    [image drawInRect:CGRectMake(x, y, image.size.width, image.size.height)];
    
    self.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return self.image;
}

@end
