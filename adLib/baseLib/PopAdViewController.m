//
//  PopAdViewController.m
//  LifeComic
//
//  Created by CloudCity on 15/7/7.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "PopAdViewController.h"
#import "LoadConfig.h"
@interface PopAdViewController ()
@property (strong,nonatomic) NSDictionary *configDic;
@property (strong,nonatomic) NSMutableArray *appIdArr;
@property (strong,nonatomic) NSMutableArray *imageArr;
@property (strong,nonatomic) NSMutableDictionary *timeDic;
@property (strong,nonatomic) NSMutableDictionary *idToNameDic;
@property NSString *appId;
@property NSString *imageName;
@property BOOL isLoaded;
@end

@implementation PopAdViewController

- (IBAction)onPressClose:(id)sender {
    [self.view removeFromSuperview];
}

- (void)viewWillDisappear:(BOOL)animated{
    NSString *plistPath = NSTemporaryDirectory();
    NSString *filePath =[plistPath stringByAppendingPathComponent:@"AD"];
    NSString *timeFile = [filePath stringByAppendingPathComponent:@"popadtime.plist"];
    [self.timeDic writeToFile:timeFile atomically:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    self.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    [super viewDidLoad];
    self.appIdArr = [[NSMutableArray alloc]init];
    self.imageArr = [[NSMutableArray alloc]init];   //用来存目录名字的数组
    self.timeDic = [[NSMutableDictionary alloc]init];
    NSString *plistPath = NSTemporaryDirectory();
    NSString *filePath =[plistPath stringByAppendingPathComponent:@"AD"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *timeFile = [filePath stringByAppendingPathComponent:@"popadtime.plist"];
    if([fileManager fileExistsAtPath:timeFile]){
        self.timeDic = [[NSMutableDictionary alloc]initWithContentsOfFile:timeFile];
    }
    self.idToNameDic = [[NSMutableDictionary alloc]init];
    self.isLoaded = [[ADManager getInstance] isLoadedImageWithOrder:YES withCompareFileName:popADname];
    NSLog(@"是否下载完了！！！！！%d",self.isLoaded);
    self.appIdArr = [[NSMutableArray alloc]initWithArray:[ADManager getInstance].appIdArr];
    self.imageArr = [[NSMutableArray alloc]initWithArray:[ADManager getInstance].imageArr];
    self.appId = [self.appIdArr firstObject];
    self.imageName = [self.imageArr firstObject];
    if(self.isLoaded){
        NSString *filePath =[[[ADManager getInstance] getDocumentsPath] stringByAppendingPathComponent:@"AD"];
         NSString *filename =[filePath stringByAppendingPathComponent:self.imageName];
        self.popImage.image = [[UIImage alloc] initWithContentsOfFile:filename];
    }else{
        self.popImage.image = [UIImage imageNamed:self.imageName];
    }
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInImage:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.popImage addGestureRecognizer:tapRecognizer];
    if([self.timeDic objectForKey:self.appId]){
        int time = [[self.timeDic objectForKey:self.appId] intValue];
        NSString *value = [[NSString alloc]initWithFormat:@"%d",(time+1)];
        [self.timeDic setObject:value forKey:self.appId];
    }else{
        [self.timeDic setObject:@"1" forKey:self.appId];
    }
    [[LoadConfig getInstance]loadConfig];
    // Do any additional setup after loading the view from its nib.
}

-(void)tapInImage:(UITapGestureRecognizer *)tap{
    if(![self isConnected]){
        return;
    }
    NSLog(@"跳转appstroe %@",self.appId);
    [self openAppStore];
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

- (void)openAppStore{
    if([self.appId rangeOfString:@"http://"].location != NSNotFound || [self.appId rangeOfString:@"https://"].location != NSNotFound){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.appId]];
        return;
    }
    NSString *str = [NSString stringWithFormat:@"http://itunes.apple.com/us/app/id%@",self.appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
