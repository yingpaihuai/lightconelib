//
//  NumberRange.h
//  iComposer
//
//  Created by guangzhuiyuandev on 15/9/17.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef struct _NumberRange{
    double startNum;
    double endNum;
    double length;
}_NumberRange;
@interface NumberRange : NSObject
+ (_NumberRange)valueRangeFrom:(double)startNum to:(double)endNum;
+ (_NumberRange)valueRangeFrom:(double)startNum withLength:(double)length;
+ (_NumberRange)addChangeValue:(double)changeValue toValueRange:(_NumberRange)numRange;
+ (_NumberRange)adjustInsideFrom:(_NumberRange)currentRange to:(_NumberRange)fullRange;
@end
