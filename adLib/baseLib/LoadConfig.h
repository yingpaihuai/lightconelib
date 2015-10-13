//
//  LoadConfig.h
//  LifeComic
//
//  Created by CloudCity on 15/6/24.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
@interface LoadConfig : NSObject
-(void)loadConfigWithUrl:(NSString *)url;
//有初始化过URL后可调用这个
-(void)loadConfig;
+ (LoadConfig *)getInstance;
@property NSMutableData *reciveConfig;
@property NSDictionary *reciveDic;
@end
