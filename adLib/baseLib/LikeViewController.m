//
//  PopUpViewController.m
//  NMPopUpView
//
//  Created by Nikos Maounis on 9/12/13.
//  Copyright (c) 2013 Nikos Maounis. All rights reserved.
//

#import "LikeViewController.h"

@interface LikeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *disLikeBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation LikeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    self.view.frame = CGRectMake(0, 0, width, height);
    self.view.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:.6];
//    self.popUpView.layer.cornerRadius = 5;
    self.popUpView.layer.shadowOpacity = 0.8;
    self.popUpView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.disLikeBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    self.disLikeBtn.layer.borderWidth = 0.5;
    NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"fivestars" ofType:@"gif"]];
    self.webView.userInteractionEnabled = NO;//用户不交互
    self.webView.scalesPageToFit = YES;
    [self.webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (IBAction)gotoApp:(id)sender {
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UI" action:@"touch" label:@"5stars" value:nil] build]];
    NSString *str = [NSString stringWithFormat:
                     @"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8",self.appId];//appId
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (IBAction)disLike:(id)sender {
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:@"UI" action:@"touch" label:@"dislike" value:nil] build]];
    [self removeAnimate];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dislikeApp" object:self];
}

- (IBAction)closePopup:(id)sender {
    [self removeAnimate];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)aView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [aView addSubview:self.view];
            [self showAnimate];
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
