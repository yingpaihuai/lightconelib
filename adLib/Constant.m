//
//  Constant.m
//  iComposer
//
//  Created by guangzhuiyuandev on 15/8/17.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "Constant.h"

@implementation Constant
+(NSString*)timeStringForTimeInterval:(NSTimeInterval)timeInterval
{
    NSInteger time = (NSInteger)timeInterval;
    NSInteger seconds = time % 60;
    NSInteger minutes = time/60;
    return  [NSString stringWithFormat:@"%02ld:%02ld",minutes, seconds];
}

+(NSString*)numberForPercent:(NSInteger)number{
    if (number >=0) {
        return [NSString stringWithFormat:@"+%ld%%",number];
    }else{
        return [NSString stringWithFormat:@"%ld%%",number];
    }
}


+(NSString *) getDocumentDir{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doc = paths[0];
    return doc;
}

+(NSString *)stringFromDate:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(NSString *)getTimeStampStr:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+(BOOL)createDir:(NSString *)dirFullPath{
    BOOL isDir = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:dirFullPath isDirectory:&isDir] == NO) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dirFullPath withIntermediateDirectories:YES attributes:nil error:nil];
        return YES;
    }
    return NO;
}

+(NSString *)getPathFromFileName:(NSString *)fileName withFileType:(NSString *)fileType withDir:(NSString *)dir{
    if (fileType == nil){
        fileType = @"";
    }
    if (dir == nil) {
        return [NSTemporaryDirectory() stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"%@%@",fileName,fileType]];
    }else{
        return [[NSTemporaryDirectory() stringByAppendingPathComponent:dir] stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"%@%@",fileName,fileType]];
    }
    
}


+(BOOL) deleteFile:(NSString *)fullFilePath{
    if (fullFilePath == nil || [fullFilePath length] == 0) {
        return NO;
    }
    if([[NSFileManager defaultManager] fileExistsAtPath:fullFilePath]){
        [[NSFileManager defaultManager] removeItemAtPath:fullFilePath error:nil];
        return YES;
    }
    return NO;
}

@end
