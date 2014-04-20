//
//  MRTimer.m
//
//  Copyright (c) 2014 Michael WU. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MRTimer.h"

NSTimeInterval const MRTimeIntervalInvalid = -1;

static NSString *const kMRSelectorKey       = @"com.michaelwu.selector";
static NSString *const kMRReturnBlockKey    = @"com.michaelwu.block";
static NSString *const kMRBeginDateKey      = @"com.michaelwu.beginDate";
static NSString *const kMREndDateKey        = @"com.michaelwu.endDate";

@interface MRTimer ()
@property (nonatomic, strong)   NSDate              *lastFlagDate;
@property (nonatomic, strong)   NSMutableDictionary *observeDictionary;
@end

@implementation MRTimer

+ (instancetype)sharedTimer
{
    static MRTimer *timer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timer = [[MRTimer alloc] init];
    });
    
    return timer;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.observeDictionary = @{}.mutableCopy;
    }
    return self;
}

+ (void)setFlag
{
    MRTimer *timer = [MRTimer sharedTimer];
    timer.lastFlagDate = [NSDate date];
}

+ (NSTimeInterval)timeIntervalFromLastFlag
{
    NSDate *lastDate = [MRTimer sharedTimer].lastFlagDate;
    if (!lastDate)
    {
        return MRTimeIntervalInvalid;
    }
    
    NSDate *now = [NSDate date];
    return [now timeIntervalSinceDate:lastDate];
}

+ (void)observeBegin:(SEL)selector
{
    MRTimer *timer = [MRTimer sharedTimer];
    NSString *selectorIndicator = NSStringFromSelector(selector);
    
    NSMutableDictionary *observeInfo = timer.observeDictionary[selectorIndicator];
    if (!observeInfo)
    {
        return;
    }
    
    [observeInfo setValue:[NSDate date] forKey:kMRBeginDateKey];
}

+ (void)observeEnd:(SEL)selector
{
    MRTimer *timer = [MRTimer sharedTimer];
    NSString *selectorIndicator = NSStringFromSelector(selector);
    NSMutableDictionary *observeInfo = timer.observeDictionary[selectorIndicator];
    if (!observeInfo)
    {
        return;
    }
    
    NSDate *now = [NSDate date];
    MRTimerIntervalReturnBlock block = observeInfo[kMRReturnBlockKey];
    NSDate *beginDate = timer.observeDictionary[selectorIndicator][kMRBeginDateKey];
    block([now timeIntervalSinceDate:beginDate]);
}

+ (void)observeSelector:(SEL)selector timeIntervalBlock:(MRTimerIntervalReturnBlock)block
{
    NSParameterAssert(block);
    MRTimer *timer = [MRTimer sharedTimer];
    NSString *selectorIndicator = NSStringFromSelector(selector);
    NSMutableDictionary *observeInfo = @{kMREndDateKey : [NSDate date],
                                         kMRReturnBlockKey : [block copy]}.mutableCopy;
    [timer.observeDictionary setObject:observeInfo forKey:selectorIndicator];
}

@end
