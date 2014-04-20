//
//  MRTimer.m
//  UiImageResizeTest
//
//  Created by mmt on 18/4/14.
//  Copyright (c) 2014 Michael WU. All rights reserved.
//

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
