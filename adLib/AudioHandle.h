//
//  AudioHandle.h
//  iComposer
//
//  Created by guangzhuiyuandev on 15/9/7.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Constant.h"
@interface AudioHandle : NSObject
///从durationValue(timescale*duration一般是44100*秒数)开始,截取长度为length的音频
+ (NSString *)cutMusic:(NSString *)recordFileName fromDurationValue:(long)durationValue withDurationLength:(long)durationLength withIndex:(int)index;
/**
 *@param secondsArray 包括起始的0和最终的长度!!!
 */
+ (NSArray *)cutMusic:(NSString *)recordFileName startSecondsArray:(double[])secondsArray withArrayLength:(int)arrayLength;
///合并多个音频,要求多段音频路径完整,且按合并顺序存放在数组中.合并完后会删除传入的待合并音频文件
/**
 * @brief 音频合并
 *
 * @param inputFilesPaths 顺序存储的文件绝对路径
 * @param outputFilePath 输出文件的绝对路径
 * @param channelNum 声道数
 * @param willDelete 选择是否删除inputFilesPaths文件
 */
+ (BOOL)mergeAudioFiles:(NSArray *)inputFilesPaths outputFilePath:(NSString *)outputFileFullPath withChannelNum:(NSInteger)channelNum willDeleteInputFilesPaths:(BOOL)willDelete;

/**
 * @brief 音频混轨函数
 * 重叠多个音频,最后生成长度是最短音频长度.故要求第一个音频是主音频,其它的音频长度应大于主音频
 * @param inputFilesPaths 顺序存储的文件绝对路径
 * @param outputFilePath 输出文件的绝对路径
 * @param willDelete 选择是否删除inputFilesPaths文件
 */
+ (BOOL)mixAudio:(NSArray *)inputFilesPaths outputFilePath:(NSString *)outputFilePath willDeleteInputFilesPaths:(BOOL)willDelete;
@end
