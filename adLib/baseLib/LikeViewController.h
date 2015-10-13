//
//  LikeViewController.h
//  RPS
//
//  Created by CloudCity on 15/5/19.
//  Copyright (c) 2015年 CloudCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
@interface LikeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *popUpView;
/**
 *  弹出likeview
 *
 *  @param aView 容器view
 */
- (void)showInView:(UIView *)aView;
/**
 *  初始化时 需要传入跳转的appid
 */
@property (nonatomic) NSUInteger appId;
@end
