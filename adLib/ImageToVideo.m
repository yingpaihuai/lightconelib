//
//  ImageToVideo.m
//  iComposer
//
//  Created by guangzhuiyuandev on 15/8/26.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "ImageToVideo.h"

@implementation ImageToVideo

- (UIImage *)createVideoImage:(UIImage *)image withCoverImage:(UIImage *)coverImage withMusicParameter:(MusicParameter *)musicParameter{
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, 400, 480)];
    
    UILabel *musicNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 25)];
    musicNameLabel.text = musicParameter.musicName;
    musicNameLabel.textAlignment = NSTextAlignmentCenter;
    musicNameLabel.font = [UIFont systemFontOfSize:11];
    musicNameLabel.textColor = [UIColor colorWithHex:0x666666];
    [musicNameLabel drawTextInRect:CGRectMake(0, 12, 400, 25)];
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 400, 25)];
    authorLabel.text = [[NSString alloc] initWithFormat:@"-%@-",musicParameter.author];
    authorLabel.textAlignment = NSTextAlignmentCenter;
    authorLabel.font = [UIFont systemFontOfSize:11];
    authorLabel.textColor = [UIColor colorWithHex:0x666666];
    [authorLabel drawTextInRect:CGRectMake(0, 12+25, 400, 25)];
    
    [coverImage drawInRect:CGRectMake(121, 176, 150, 150)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

///一次性完成视频图片的生成
-(instancetype)initWithCoverImage:(UIImage *)coverImage withAngle:(float)angle withCenterText:(NSString *)centerText withWaterMarkImage:(UIImage *)waterMarkImage{
    UIImage *newCoverImage = [self addText:centerText toImage:coverImage withAngle:angle];
    self.videoImage = [self compoundCoverImage:newCoverImage withWaterMarkImage:waterMarkImage];
    return self;
}

///图片加上文字并旋转,可用于视频生成时图片的旋转,图片本身是圆形(或者正方形),angle为顺时针角度
- (UIImage *)addText:(NSString *)centerText toImage:(UIImage *)coverImage withAngle:(float)angle{
    float diameter = coverImage.size.height;
    UIGraphicsBeginImageContext(coverImage.size);
    
    [coverImage drawInRect:CGRectMake(0, 0, diameter , diameter)];
    
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,diameter , 150)];
    textLabel.text = centerText;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:30];
    textLabel.textColor = [UIColor whiteColor];
    [textLabel drawTextInRect:CGRectMake(0, (diameter - 150)/2, diameter, 150)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    resultingImage = [UIImage rotateAngle:angle withImage:resultingImage];
    return resultingImage;
}

///生成水印图片,详细大小参数待修改,也可作为参数传入
+(UIImage *)genWaterMark:(UIImage *)logoImage withAppName:(NSString *)appName{
    if (logoImage == nil ) {
    }
    if (appName == nil) {
        appName = @"iComposer";
    }
    
    float height = logoImage.size.height;
    float width = logoImage.size.width + 150;
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [logoImage drawInRect:CGRectMake(0, 0, logoImage.size.width, logoImage.size.height)];
    UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,150 , logoImage.size.height)];
    textLabel.text = appName;
    textLabel.font = [UIFont systemFontOfSize:25];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.textColor = [UIColor whiteColor];
    [textLabel drawTextInRect:CGRectMake(logoImage.size.width, 0, 150, logoImage.size.height)];
    
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

///合成原图和水印
-(UIImage *)compoundCoverImage:(UIImage *)coverImage withWaterMarkImage:(UIImage *)waterMarkImage{
    CGSize size = CGSizeMake(coverImage.size.width, coverImage.size.height + waterMarkImage.size.height);
    UIGraphicsBeginImageContext(size);
    
    [coverImage drawInRect:CGRectMake(0, 0, coverImage.size.width, coverImage.size.height)];
    [waterMarkImage drawInRect:CGRectMake(0, coverImage.size.height, waterMarkImage.size.width, waterMarkImage.size.height)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.videoImage = resultImage;
    return resultImage;
}

@end
