//
//  ADViewController.h
//  RPS
//
//  Created by CloudCity on 15/5/26.
//  Copyright (c) 2015年 CloudCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
#import "GAIFields.h"
#import "GAITracker.h"
#import "GAIDictionaryBuilder.h"
#
@interface ADViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property NSUInteger pageIndex;
@end
