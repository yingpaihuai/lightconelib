//
//  CommonViewController.m
//  baseLib
//
//  Created by CloudCity on 15/7/8.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "CommonViewController.h"

@interface CommonViewController ()

@end

@implementation CommonViewController

-(id)init
{
    self = [super init];
    if (self) {
        
        //add code here.
        self.tracker = [GAConfig ShareInstrance].tracker;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //add code here.
        self.tracker = [GAConfig ShareInstrance].tracker;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


@end
