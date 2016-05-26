//
//  IFlySpeechUtility.h
//  MSCDemo
//
//  Created by admin on 14-5-7.
//  Copyright (c) 2014 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IFlySpeechError.h"


@class IFlySpeechUtility;

@interface IFlySpeechUtility : NSObject
{
    
}
+ (IFlySpeechUtility*) createUtility:(NSString *) params;


+(BOOL) destroy;



+(IFlySpeechUtility *) getUtility;



@end
