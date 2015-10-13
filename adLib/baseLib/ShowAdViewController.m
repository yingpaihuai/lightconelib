//
//  ShowAdViewController.m
//  RPS
//
//  Created by CloudCity on 15/5/26.
//  Copyright (c) 2015年 CloudCity. All rights reserved.
//

#import "ShowAdViewController.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
@interface ShowAdViewController ()

@end

@implementation ShowAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        if(self.isLoaded){
            NSString* plistPath = NSTemporaryDirectory();
            NSString *filePath =[plistPath stringByAppendingPathComponent:@"AD"];
            NSString *filename =[filePath stringByAppendingPathComponent:self.imagePath];
           self.imageView.image = [[UIImage alloc] initWithContentsOfFile:filename];
        }else{
          self.imageView.image = [UIImage imageNamed:self.imagePath];
        }
    UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInImage:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.imageView addGestureRecognizer:tapRecognizer];
    // Do any additional setup after loading the view.
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
