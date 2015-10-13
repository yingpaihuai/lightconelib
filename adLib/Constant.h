//
//  Constant.h
//  iComposer
//
//  Created by guangzhuiyuandev on 15/8/17.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *STR_RECORD_BACK = @"Your piece hasn’t been saved, do you want to quit?";
static NSString *STR_PLAYER_FIRST_MUSIC = @"It’s already the first piece.";
static NSString *STR_PLAYER_LAST_MUSIC = @"It’s already the last piece.";
static NSString *STR_ARRANGE_SAVE_ALERT = @"Save your master piece";
static NSString *STR_ARRANGE_PIECE_NAME = @"Piece Name";
static NSString *STR_ARRANGE_COMPOSER = @"Composer";
static NSString *STR_ARRANGE_REPEAT_MUSIC= @"The name has existed.Do you want to override it?";
static NSString *STR_ARRANGE_BACK = @"Your haven't saved your piece,do you want to delete?";

static NSString *STR_CONFIG_MUSIC_PLIST = @"musicPlist";
static NSString *STR_CONFIG_CUSTOM_COVER_PLIST = @"customCoverPlist";
static NSString *STR_CONFIG_DEFAULT_COVER_PLIST = @"defaultCoverPlist";
static NSString *STR_CONFIG_INFLEXION_PLIST = @"inflexionPlist";
static NSString *STR_CONFIG_VARIATION_PLIST = @"variationPlist";

static NSString *STR_NOTIFY_MERGE_VIDEO_DONE =@"VideoMergeDone";
static NSString *STR_NOTIFY_PLAYER_MUSIC_CHANGE = @"PlayerMusicChange";

static NSInteger INT_MAX_TIME_LENGTH = 90;//单位:秒

static NSInteger INT_MAX_BPM_VALUE = 10;
static NSInteger INT_STEP_SIZE = 1;

static NSString *STR_NOTIFY_DONE_ANALYZE = @"analyzedone";

@interface Constant : NSObject
///将秒数转化为类似01:30的分钟:秒钟的形式
+(NSString*)timeStringForTimeInterval:(NSTimeInterval)timeInterval;
///将一个数添加为百分比,如30 -> +30%,注意不是把 0.3 -> +30%哦
+(NSString*)numberForPercent:(NSInteger)number;

+(NSString *) getDocumentDir;
///获得形如YYYY-MM-dd HH:mm:ss的字符串
+(NSString *)stringFromDate:(NSDate *)date;
///获得形如YYYY-MM-dd-HH-mm-ss的字符串
+(NSString *)getTimeStampStr:(NSDate *)date;
///dir取record/music/coverImage/clip/cache/nil其一,或者是复合文件夹前后不含/,如"clip/2015-01-01-12-00-00";fileType为后缀(要含点号),若fileName中含后缀则fileType为空
+(NSString *)getPathFromFileName:(NSString *)fileName withFileType:(NSString *)fileType  withDir:(NSString *)dir;
///删除文件,fullFilePath取完整的文件路径及名称,若成功删除返回YES,不存在/无法删除否则NO
+(BOOL) deleteFile:(NSString *)fullFilePath;
///创建文件夹,路径为绝对路径,已存在返回NO,
+(BOOL)createDir:(NSString *)dirFullPath;
@end
