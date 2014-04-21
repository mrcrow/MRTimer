MRTimer
=======

MRTimer is used to measure the time interval between lines of codes.

You can simply get the time interval withinin the function like: 

    [MRTimer setFlag];
    
    [self doSomething];
    
    NSTimeInterval interval = [MRTimer timeIntervalFromLastFlag];
    
Or jump out of the function and use the observe style:

    - (void)viewDidLoad 
    {
        [super viewDidLoad];
        [MRTimer observeSelector:@selector(doSomething) timeIntervalBlock:^(NSTimeInterval interval) {
            NSLog(@"Time interval for selector: (%@, %f), NSStringFromSelector(doSomething), interval);
        }];
    }
    
    - (void)doSomething
    {
        [MRTimer observeBegin:MR_SELECTOR];
        
        ...
        
        [MRTimer observeEnd:MR_SELECTOR];
    }

Lisence
=======

MRTimer is available under the MIT license.
