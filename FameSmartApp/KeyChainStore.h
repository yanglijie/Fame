//
//  KeyChainStore.h
//  FameSmartIos
//
//  Created by famesmart on 16/11/18.
//  Copyright © 2016年 famesmart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
