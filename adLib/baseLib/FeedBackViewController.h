//
//  FeedBackViewController.h
//  RPS
//
//  Created by CloudCity on 15/5/18.
//  Copyright (c) 2015年 CloudCity. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h> 
#import "GAI.h"
@interface FeedBackViewController : GAITrackedViewController <MFMailComposeViewControllerDelegate,UITextViewDelegate>
{
    MFMailComposeViewController *mailComposer;
}
/**
 *  初始化传入appName
 */
@property NSString *appName;
/**
 *  初始化传入email  默认是gzyappservice@gmail.com
 */
@property NSString *emailAddress;
@end