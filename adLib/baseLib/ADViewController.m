//
//  ADViewController.m
//  RPS
//
//  Created by CloudCity on 15/5/26.
//  Copyright (c) 2015年 CloudCity. All rights reserved.
//

#import "ADViewController.h"
#import "ShowAdViewController.h"
#import "ADManager.h"
#import "LoadConfig.h"
@interface ADViewController ()
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) NSDictionary *configDic;
@property (strong,nonatomic) NSMutableArray *appIdArr;
@property (strong,nonatomic) NSMutableArray *imageArr;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong,nonatomic) NSMutableDictionary *timeDic;
@property (strong,nonatomic) NSMutableDictionary *idToNameDic;

@property BOOL isLoaded;
@end

@implementation ADViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appIdArr = [[NSMutableArray alloc]init];
    self.imageArr = [[NSMutableArray alloc]init];   //用来存目录名字的数组
    self.timeDic = [[NSMutableDictionary alloc]init];
    self.idToNameDic = [[NSMutableDictionary alloc]init];
    self.isLoaded = [[ADManager getInstance] isLoadedImageWithOrder:NO withCompareFileName:pageADname];
//    [[ADManager getInstance] getAdDataWithAppIdArr:self.appIdArr withImageArr:self.imageArr];
    self.appIdArr = [[NSMutableArray alloc]initWithArray:[ADManager getInstance].appIdArr];
    self.imageArr = [[NSMutableArray alloc]initWithArray:[ADManager getInstance].imageArr];
//    self.isLoaded = [self isLoadedImage];
    NSLog(@"是否下载完了！！！！！%d",self.isLoaded);
    self.pageViewController = [[UIPageViewController alloc]init];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    ShowAdViewController *startingVC = [self viewControllerAtIndex:0];
    [self.pageViewController setViewControllers:@[startingVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    self.pageControl.numberOfPages = [self.appIdArr count];
    [self.view bringSubviewToFront:self.pageControl];
    [self.view bringSubviewToFront:self.closeBtn];
    [[LoadConfig getInstance]loadConfig];
    
}

- (IBAction)pressClose:(id)sender {
    if(self.navigationController){
//        [self.navigationController setNavigationBarHidden:NO];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    ShowAdViewController *currentViewController = pageViewController.viewControllers[0];
    [self.pageControl setCurrentPage:currentViewController.pageIndex];
}

- (void)viewWillDisappear:(BOOL)animated{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *plistPath = [paths objectAtIndex:0];
    NSString* plistPath = NSTemporaryDirectory();
    NSString *filePath =[plistPath stringByAppendingPathComponent:@"AD"];
    NSString *timeFile = [filePath stringByAppendingPathComponent:@"adtime.plist"];
    [self.timeDic writeToFile:timeFile atomically:YES];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((ShowAdViewController *)viewController).pageIndex;
    
    if ((index == 0) || index == NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = ((ShowAdViewController *)viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.appIdArr count]) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (ShowAdViewController *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.appIdArr count] == 0) || (index >= [self.appIdArr count])) {
        return nil;
    }
    ShowAdViewController *pageContentViewController = [[ShowAdViewController alloc] initWithNibName:@"ShowAdViewController" bundle:nil];
    pageContentViewController.pageIndex = index;
    pageContentViewController.appId = [self.appIdArr objectAtIndex:index];
    pageContentViewController.isLoaded = self.isLoaded;
    
    pageContentViewController.imagePath = [self.imageArr objectAtIndex:index];
    NSString *appId = [self.appIdArr objectAtIndex:index];
    if([self.timeDic objectForKey:appId]){
        int time = [[self.timeDic objectForKey:appId] intValue];
        NSString *value = [[NSString alloc]initWithFormat:@"%d",(time+1)];
        [self.timeDic setObject:value forKey:appId];
    }else{
        [self.timeDic setObject:@"1" forKey:appId];
    }
    NSString *showAdID = [[NSString alloc]initWithFormat:@"ad_%@",appId];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UI" action:@"showAd" label:showAdID value:nil] build]];
    return pageContentViewController;
}

@end
