//
//  NumberRange.m
//  iComposer
//
//  Created by guangzhuiyuandev on 15/9/17.
//  Copyright (c) 2015年 lightcone. All rights reserved.
//

#import "NumberRange.h"

@implementation NumberRange
+ (_NumberRange)valueRangeFrom:(double)startNum to:(double)endNum{
    _NumberRange numRange;
    numRange.startNum = startNum;
    numRange.endNum = endNum;
    numRange.length = endNum - startNum;
    return numRange;
}
+ (_NumberRange)valueRangeFrom:(double)startNum withLength:(double)length{
    _NumberRange numRange;
    numRange.startNum = startNum;
    numRange.length = length;
    numRange.endNum = startNum + length;
    return numRange;
}
+ (_NumberRange)valueRangeEnd:(double)endNum withLength:(double)length{
    _NumberRange numRange;
    numRange.endNum = endNum;
    numRange.length = length;
    numRange.startNum = endNum - length;
    return numRange;
}

+ (_NumberRange)addChangeValue:(double)changeValue toValueRange:(_NumberRange)numRange{
    _NumberRange newNumRange;
    newNumRange = numRange;
    newNumRange.startNum += changeValue;
    newNumRange.endNum += changeValue;
    return newNumRange;
}

+ (_NumberRange)adjustInsideFrom:(_NumberRange)currentRange to:(_NumberRange)fullRange{
    _NumberRange newcurrentRange;
    newcurrentRange = currentRange;
    if (newcurrentRange.length >= fullRange.length) {
        return fullRange;
    }else if (newcurrentRange.startNum < fullRange.startNum) {
        return [self valueRangeFrom:fullRange.startNum withLength:newcurrentRange.length];
    }else if (newcurrentRange.endNum > fullRange.endNum) {
        return [self valueRangeEnd:fullRange.endNum withLength:newcurrentRange.length];
    }else{
        return newcurrentRange;
    }
}
@end
