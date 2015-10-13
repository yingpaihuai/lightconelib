//
//  LoadConfig.m
//  LifeComic
//
//  Created by CloudCity on 15/6/24.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "LoadConfig.h"
@interface LoadConfig()
@property NSInteger needLoad;
@property NSURL *loadUrl;
@property (nonatomic)  BOOL isLoaded;
@end
@implementation LoadConfig

+ (LoadConfig *)getInstance
{
    static LoadConfig *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(BOOL)getAdisLoaded{
    return self.isLoaded;
}

-(void)initConfigUrl:(NSString *)url{
    self.loadUrl = [[NSURL alloc]initWithString:url];
}

-(void)loadConfig{
    [self loadConfigWithUrl:[self.loadUrl absoluteString]];
}

-(void)loadConfigWithUrl:(NSString *)url{
    self.isLoaded = NO;
    self.loadUrl = [[NSURL alloc]initWithString:url];
    self.reciveConfig = [[NSMutableData alloc]init];
    //加上日期防止没更新
    NSString *urlStr = [NSString stringWithFormat:@"%@%f",url,[NSDate timeIntervalSinceReferenceDate]];
    NSURL *netUrl = [[NSURL alloc]initWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:netUrl];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    [request setHTTPMethod:@"GET"];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    if (conn)
    {
        [conn start];//开始连接网络
    }
}

//接收到服务器回应的时候调用此方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
//    NSLog(@"%@",[res allHeaderFields]);
    
}
//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.reciveConfig appendData:data];
}
//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //    self.reciveDic = [NSDictionary dictionaryWithXMLData:self.reciveConfig];
    self.reciveDic = [NSJSONSerialization JSONObjectWithData:self.reciveConfig options:NSJSONReadingMutableLeaves error:nil];
    [self saveToLocal];
}

- (void)saveToLocal{
    //获取应用沙盒的的DOCUMENT 的路径；
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString* plistPath = [paths objectAtIndex:0];
    NSString* plistPath = NSTemporaryDirectory();
    NSString *filePath =[plistPath stringByAppendingPathComponent:@"AD"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSLog(@"%@",filePath);
    if(![fileManager fileExistsAtPath:filePath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSLog(@"first run");
        NSString *directryPath = [plistPath stringByAppendingPathComponent:@"AD"];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *adTimesPath = [filePath stringByAppendingPathComponent:@"adtime.plist"];
    if(![fileManager fileExistsAtPath:adTimesPath]){
        [fileManager createFileAtPath:adTimesPath contents:nil attributes:nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"1011029854",@"0",@"1011108519", nil];
        [dic writeToFile:adTimesPath atomically:YES];
    }
    
    NSString *popAdList = [filePath stringByAppendingPathComponent:@"popadtime.plist"];
    if(![fileManager fileExistsAtPath:popAdList]){
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
        NSDictionary *popDic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"LifeComicShowAdKey", nil];
        [popDic writeToFile:popAdList atomically:YES];
    }
    NSString *filename =[filePath stringByAppendingPathComponent:@"CacheADConfig.plist"];
    //写入文件
    NSArray *adArr = [self.reciveDic objectForKey:@"ads"];
    NSArray *showArr = [self.reciveDic objectForKey:@"so"];
    self.needLoad = 0;
    for(NSInteger j = 0;j < [showArr count];j++){
        NSNumber *index = [showArr objectAtIndex:j];
        for(NSInteger i = 0;i < [adArr count];i++){
            NSDictionary *contDic = [adArr objectAtIndex:i];
            NSString *url = [contDic objectForKey:@"du"];
            NSString *imageName = [contDic objectForKey:@"fn"];
            NSString *adId = [contDic objectForKey:@"id"];
            if([adId intValue] != [index intValue]){
                continue;
            }
            NSString *realName = [[imageName componentsSeparatedByString:@"."] firstObject];
            //url不能为空，有网络，没有下载过，且在显示列表里面
            if(url != nil && ![url  isEqual: @""] && [self isConnected] && ![self hasLoad:[NSString stringWithFormat:@"%@.png",realName]] && [showArr containsObject:adId]){
                self.needLoad++;
                UIImageFromURL( [NSURL URLWithString:url], ^( UIImage * image )
                               {
                                   [self saveImage:image withFileName:realName ofType:@"png" inDirectory:[plistPath stringByAppendingPathComponent:@"AD"]];
                                   NSLog(@"%@",image);
                               }, ^(void){
                                   NSLog(@"error!");
                               });
            }
            break;
        }
        if(self.needLoad > 0){
            break;
        }
    }
    if(self.needLoad == 0){
        [self.reciveDic writeToFile:filename atomically:YES];
    }
}

-(BOOL) hasLoad:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString* plistPath = [paths objectAtIndex:0];
    NSString* plistPath = NSTemporaryDirectory();
    NSString *filePath =[plistPath stringByAppendingPathComponent:@"AD"];
    NSString *realPath  =[filePath stringByAppendingPathComponent:[[NSString alloc]initWithFormat:@"%@",fileName]];
    return [fileManager fileExistsAtPath:realPath];
}

void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL];
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}

-(BOOL) isConnected
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
    
}

-(UIImage *) getImageFromURL:(NSString *)fileURL {
    NSLog(@"执行图片下载函数");
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    self.needLoad--;
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
    if(self.needLoad == 0){
        [self.reciveDic writeToFile:[directoryPath stringByAppendingPathComponent:@"CacheADConfig.plist"] atomically:YES];
    }
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection
 didFailWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
}
@end
