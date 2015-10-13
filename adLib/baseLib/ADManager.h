//
//  ADManager.h
//  LifeComic
//
//  Created by CloudCity on 15/7/7.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
static NSString *pageADname = @"adtime.plist";
static NSString *popADname = @"popadtime.plist";
static NSString *popShowKey = @"PopShowTimeKey";
@interface ADManager : NSObject
+ (ADManager *)getInstance;
-(NSString *)getDocumentsPath;
-(BOOL)isLoadedImageWithOrder:(BOOL)isOrder withCompareFileName:(NSString *)fileName;
//默认广告队列 配置在DefaultADConfig中  更具应用具体情况去更改
@property (strong,nonatomic) NSMutableArray *appIdArr;
@property (strong,nonatomic) NSMutableArray *imageArr;

@property (strong,nonatomic) NSMutableDictionary *timeDic; //ad time dic
/**
 *  弹出滑动广告
 *
 *  @param parentVC rootvc
 */
-(void)showAdController:(UIViewController *)parentVC;

/**
 *  在rootvc中的viewwillappear中调用，次数加1 并检查是否可以弹出
 *
 *  @param checkTime 每出现多少次rootvc后弹出popad
 *  @param key       自定义应用key，用来保存次数信息
 *  @param parentVC  rootvc
 */
-(void)checkAndShowPopAd:(NSUInteger)checkTime withCheckKey:(NSString *)key  withVc:(UIViewController *)parentVC;
@end
