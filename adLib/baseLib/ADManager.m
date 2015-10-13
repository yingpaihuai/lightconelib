//
//  ADManager.m
//  LifeComic
//
//  Created by CloudCity on 15/7/7.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "ADManager.h"
#import "PopAdViewController.h"
#import "ADViewController.h"
@interface ADManager()
@property (strong,nonatomic) NSDictionary *configDic;
@property (strong,nonatomic) NSMutableDictionary *idToNameDic;
@property (strong,nonatomic) NSMutableArray *defaultAppIdArr;
@property (strong,nonatomic) NSMutableArray *defaultImageArr;
@property (strong,nonatomic) PopAdViewController *popAdController;
@property BOOL isLoaded;
@end

@implementation ADManager
+ (ADManager *)getInstance
{
    static ADManager *Instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Instance = [[self alloc] init];
    });
    return Instance;
}

-(void)orderADArrWithName:(NSString *)name{
    NSString *plistPath = [self getDocumentsPath];
    NSString *filePath =[plistPath stringByAppendingPathComponent:@"AD"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *timeFile = [filePath stringByAppendingPathComponent:name];
    if([fileManager fileExistsAtPath:timeFile]){
        self.timeDic = [[NSMutableDictionary alloc]initWithContentsOfFile:timeFile];
    }
    //根据看的次数多少排序
    for(int i= 0;i < [self.imageArr count];i++){
        [self.idToNameDic setObject:[self.imageArr objectAtIndex:i] forKey:[self.appIdArr objectAtIndex:i]];
    }
    [self.appIdArr sortUsingComparator:^NSComparisonResult(id string1,id string2) {
        //这里的代码可以参照上面compare:默认的排序方法，也可以把自定义的方法写在这里，给对象排序
        NSInteger time1 = 0;
        if([self.timeDic objectForKey:string1]){
            time1 = [[self.timeDic objectForKey:string1] intValue];
        }
        NSInteger time2 = 0;
        if([self.timeDic objectForKey:string2]){
            time2 = [[self.timeDic objectForKey:string2] intValue];
        }
        if (time1 > time2) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (time1 < time2){
            return (NSComparisonResult)NSOrderedAscending;
        }else{
            return (NSComparisonResult)NSOrderedSame;
        }
    }];
    for(int i= 0;i < [self.imageArr count];i++){
        NSString * newName = [self.idToNameDic objectForKey:[self.appIdArr objectAtIndex:i]];
        [self.imageArr setObject:newName atIndexedSubscript:i];
    }
}

-(void)initNeedData{
    self.appIdArr = [[NSMutableArray alloc]init];
    self.imageArr = [[NSMutableArray alloc]init];   //用来存目录名字的数组
    self.timeDic = [[NSMutableDictionary alloc]init];
    self.idToNameDic = [[NSMutableDictionary alloc]init];
}

//判断是否下载完广告，然后在appIdArr和imageArr中返回广告数组 在timeDic 返回adtime的次数字典
-(BOOL)isLoadedImageWithOrder:(BOOL)isOrder withCompareFileName:(NSString *)fileName{
    [self initNeedData];
    NSString *plistPath = [self getDocumentsPath];
    NSString *filePath =[plistPath stringByAppendingPathComponent:@"AD"];
    NSString *filename =[filePath stringByAppendingPathComponent:@"CacheADConfig.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isFisrtLoaded = NO;
    BOOL isLoaded = NO;
    if(![fileManager fileExistsAtPath:filename]){
        isLoaded = NO;
    }else{
        self.configDic = [[NSDictionary alloc]initWithContentsOfFile:filename];
        NSArray *adArr = [self.configDic objectForKey:@"ads"];
        NSArray *showArr = [self.configDic objectForKey:@"so"];
        for(NSInteger i = 0;i < [showArr count];i++){
            for(NSInteger j = 0;j < [adArr count];j++){
                if([[[adArr objectAtIndex:j] objectForKey:@"id"]intValue] == [[showArr objectAtIndex:i] intValue]){
                    [self.appIdArr addObject:[[adArr objectAtIndex:j] objectForKey:@"cu"]];
                    NSString *imageName = [[adArr objectAtIndex:j] objectForKey:@"fn"];
                    NSString *realName = [[imageName componentsSeparatedByString:@"."] firstObject];
                    [self.imageArr addObject:[[NSString alloc] initWithFormat:@"%@.png",realName]];
                }
            }
        }
        isLoaded = YES;
        NSMutableArray *tempIdArr = [[NSMutableArray alloc]init];
        NSMutableArray *tempImageArr = [[NSMutableArray alloc]init];
        for(NSInteger k = 0;k < [self.imageArr count];k++){
            NSString *obStr = [self.imageArr objectAtIndex:k];
            NSString *realPath  =[filePath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"%@",obStr]];
            if([fileManager fileExistsAtPath:realPath]){
                if(k == 0){
                    isFisrtLoaded = YES;
                }
                [tempIdArr addObject:[self.appIdArr objectAtIndex:k]];
                [tempImageArr addObject:obStr];
//                isLoaded = NO;
            }
        }
        self.imageArr = tempImageArr;
        self.appIdArr = tempIdArr;
    }
//    if(!isLoaded){
//        [self setDefaultArr];
//    }
    if([self.imageArr count] == 0 || isFisrtLoaded == NO){
        [self setDefaultArr];
        isLoaded = NO;
    }
    if(isOrder){
        [self orderADArrWithName:fileName];
    }
    return isLoaded;
}

//会先尝试＋1次数 写，写成功后判断是否达到次数
-(BOOL)checkNeedShowPopWithTime:(NSInteger)timeInterval{
    BOOL needShow = NO;
    NSString* plistPath = NSTemporaryDirectory();
    NSString *filePath =[plistPath stringByAppendingPathComponent:@"AD"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    int time = 0;
    if([fileManager fileExistsAtPath:filePath]){
        NSString *adPath = [filePath stringByAppendingPathComponent:@"popadtime.plist"];
        NSMutableDictionary *popAdTimesDic = [[NSMutableDictionary alloc]initWithContentsOfFile:adPath];
        if([popAdTimesDic objectForKey:popShowKey]){
            time = [[popAdTimesDic objectForKey:popShowKey] intValue];
            NSString *value = [[NSString alloc]initWithFormat:@"%d",(time+1)];
            [popAdTimesDic setObject:value forKey:popShowKey];
        }else{
            [popAdTimesDic setObject:@"1" forKey:popShowKey];
        }
        BOOL succ = [popAdTimesDic writeToFile:adPath atomically:YES];
        if(succ){
            if((time + 1)%timeInterval == 0){
                return YES;
            }
        }
    }
    return needShow;
}

-(BOOL)checkIfTheAppHasLoad:(NSUInteger)appId{
    //这个需要在info.plist中定义URL Types ,具体格式还没定下来
    NSString *checkStr = [NSString stringWithFormat:@"lightcore%d",appId];
    return [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:checkStr]];
}

-(void)setDefaultAppIdArr:(NSMutableArray *)defaultAppIdArr setDefaultImageArr:(NSMutableArray *)defaultImageArr{
    self.defaultAppIdArr = [[NSMutableArray alloc]initWithArray:defaultAppIdArr];
    self.defaultImageArr = [[NSMutableArray alloc]initWithArray:defaultImageArr];
}

-(void)setDefaultArr{
    NSString *defaultPath = [[NSBundle mainBundle]pathForResource:@"DefaultADConfig" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:defaultPath];
    self.appIdArr = [dic[@"AppIdArr"] mutableCopy];
    self.imageArr = [dic[@"ImageArr"] mutableCopy];
}

-(NSString *)getDocumentsPath{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
////    NSLog(@"文件路径－－%@",[paths objectAtIndex:0]);
//    return [paths objectAtIndex:0];
    return NSTemporaryDirectory();
}

-(void)showAdController:(UIViewController *)parentVC{
    ADViewController *adScrollViewVC = [[ADViewController alloc]init];
    if(parentVC.navigationController){
        [parentVC.navigationController pushViewController:adScrollViewVC animated:YES];
    }else{
        [parentVC presentViewController:adScrollViewVC animated:NO completion:nil];
    }
    
}

-(void)checkAndShowPopAd:(NSUInteger)checkTime withCheckKey:(NSString *)key withVc:(UIViewController *)parentVC{
    NSString* plistPath = NSTemporaryDirectory();
    NSString *filePath =[plistPath stringByAppendingPathComponent:@"AD"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    int time = 0;
    if([fileManager fileExistsAtPath:filePath]){
        NSString *adPath = [filePath stringByAppendingPathComponent:@"popadtime.plist"];
        NSMutableDictionary *popAdTimesDic = [[NSMutableDictionary alloc]initWithContentsOfFile:adPath];
        if([popAdTimesDic objectForKey:key]){
            time = [[popAdTimesDic objectForKey:key] intValue];
            NSString *value = [[NSString alloc]initWithFormat:@"%d",(time+1)];
            [popAdTimesDic setObject:value forKey:key];
        }else{
            [popAdTimesDic setObject:@"1" forKey:key];
        }
        BOOL succ = [popAdTimesDic writeToFile:adPath atomically:YES];
        if(succ){
            if((time + 1)%checkTime == 0){
                self.popAdController = [[PopAdViewController alloc] initWithNibName:@"PopAdViewController" bundle:nil];
                [parentVC.view addSubview:self.popAdController.view];
            }
        }
    }
}
@end
