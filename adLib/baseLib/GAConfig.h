//
//  CGAConfig.h
//  DemoTest
//
//  Created by  on 13-4-23.
//  Copyright (c) 2013年 __fengsh998__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GAI.h"
#import "GAITracker.h"

@interface GAConfig : NSObject

@property (nonatomic,assign) id<GAITracker> tracker;//保存全局只有一个防止retain
@property (nonatomic,assign) NSTimeInterval dispatchInterval;
@property (nonatomic,assign) BOOL isDebug;
@property (nonatomic,assign) double SampleRate;
@property (nonatomic,assign) BOOL OptOut;
@property (nonatomic,assign) BOOL trackUncaughtExceptions;
@property (nonatomic,assign) BOOL Anonymize;
@property (nonatomic,assign) BOOL UseHttps;

+(GAConfig*)ShareInstrance;
@end