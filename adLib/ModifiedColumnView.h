//
//  ModifiedColumnView.h
//  iComposer
//
//  Created by guangzhuiyuandev on 15/9/1.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import <UIKit/UIKit.h>
///用于显示一栏标签,加减按钮和调节值.如编曲页面的音高和速度调节栏
@interface ModifiedColumnView : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UIButton *reduceButton;
@property (nonatomic) UIButton *addButton;

@end
