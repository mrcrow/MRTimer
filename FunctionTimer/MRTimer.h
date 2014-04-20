//
//  MRTimer.h
//  UiImageResizeTest
//
//  Created by mmt on 18/4/14.
//  Copyright (c) 2014 Michael WU. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MR_SELECTOR _cmd

typedef void(^ MRTimerIntervalReturnBlock)(NSTimeInterval);

extern NSTimeInterval const MRTimeIntervalInvalid;

@interface MRTimer : NSObject

+ (void)setFlag;
+ (NSTimeInterval)timeIntervalFromLastFlag;

+ (void)observeSelector:(SEL)selector timeIntervalBlock:(MRTimerIntervalReturnBlock)block;
+ (void)observeBegin:(SEL)selector;
+ (void)observeEnd:(SEL)selector;

@end
