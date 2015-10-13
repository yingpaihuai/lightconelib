//
//  ViewController.m
//  adLib
//
//  Created by CloudCity on 15/8/3.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "ViewController.h"
#import "ADViewController.h"
#import "PopAdViewController.h"
@interface ViewController ()
@property (nonatomic)ADViewController *adC;
@property (nonatomic)PopAdViewController *popAdc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressAD:(id)sender {
    self.adC = [[ADViewController alloc] initWithNibName:@"ADViewController" bundle:nil];
    //    [self.likeViewController setTitle:@"This is a popup view"];
    [self presentViewController:self.adC animated:YES completion:^{}];
}
- (IBAction)pressPopAd:(id)sender {
    self.popAdc = [[PopAdViewController alloc] initWithNibName:@"PopAdViewController" bundle:nil];
    //    [self.likeViewController setTitle:@"This is a popup view"];
//    [self presentViewController:self.popAdc animated:YES completion:^{}];
    [self.view addSubview:self.popAdc.view];
}

@end
