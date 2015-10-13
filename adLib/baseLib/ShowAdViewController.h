//
//  ShowAdViewController.h
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
@interface ShowAdViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property NSUInteger pageIndex;
@property NSString *appId;
@property BOOL isLoaded;
@property NSString *imagePath;
@end
