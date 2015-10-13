//
//  CGAConfig.m
//  DemoTest
//
//  Created by  on 13-4-23.
//  Copyright (c) 2013年 __fengsh998__. All rights reserved.
//
//          Google Analytics config
//
//

#import "GAConfig.h"


static GAConfig * gacfg = nil;


@implementation GAConfig

/*
 -(id)init
 {
 [NSException raise:@"singlton not call init."
 format:@"Abort, retry, fail?"];
 return nil;
 }
 */

-(void)InitDefaulteValue
{
    //add google analytics
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    //设置每隔多少时间向ＧＡ发送一次数据
    [GAI sharedInstance].dispatchInterval = 20;
    //设置打开ＳＤＫ的调试信息开关
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-40231989-1"];
    //[self.tracker setSampleRate:50.0];//设置采样的速度
    
    //设置是否停止向ＧＡ发送数据
    //[[GAI sharedInstance] setOptOut:YES];
    //设置捕获tracker产生的异常，当为ＦＡＬＳＥ时不捕捉
    if ([GAI sharedInstance].trackUncaughtExceptions) {
        [[GAI sharedInstance]setTrackUncaughtExceptions:YES];
    }
    
    //黑认为false，设置是否Ni名访问GA
    //[self.tracker setAnonymize:YES];
    //设置是否使用https访问GA default = YES
    //[self.tracker setUseHttps:YES];
    //手动跟踪某个view
}

+(id) allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (!gacfg)
        {
            gacfg = [super allocWithZone:zone];
            return gacfg;
        }
    }
    return nil;
}


+(GAConfig*)ShareInstrance
{
    @synchronized(self)
    {
        if (!gacfg)
        {
            gacfg = [[self alloc] init];
            [gacfg InitDefaulteValue];
        }
    }
    
    return gacfg;
}

-(void)setDispatchInterval:(NSTimeInterval)dispatchInterval
{
    [GAI sharedInstance].dispatchInterval = dispatchInterval;
}

-(NSTimeInterval)setDispatchInterval
{
    return [GAI sharedInstance].dispatchInterval;
}

-(void)setOptOut:(BOOL)OptOut
{
    [[GAI sharedInstance] setOptOut:OptOut];
}

-(BOOL)getOptOut
{
    return [GAI sharedInstance].optOut;
}

-(void)setTrackUncaughtExceptions:(BOOL)trackUncaughtExceptions
{
    [[GAI sharedInstance] setTrackUncaughtExceptions:trackUncaughtExceptions];
}

-(BOOL)getTrackUncaughtExceptions
{
    return [GAI sharedInstance].trackUncaughtExceptions;
}


@end