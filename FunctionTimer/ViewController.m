//
//  ViewController.m
//  FunctionTimer
//
//  Created by mmt on 20/4/14.
//  Copyright (c) 2014 Michael WU. All rights reserved.
//

#import "ViewController.h"
#import "MRTimer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [MRTimer observeSelector:@selector(displayImage) timeIntervalBlock:^(NSTimeInterval interval) {
        NSLog(@"Selector %@ excuted %f seconds", NSStringFromSelector(@selector(displayImage)), interval);
    }];
    
    [self displayImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayImage
{
    [MRTimer observeBegin:MR_SELECTOR];
    
    [MRTimer setFlag];
    UIImage *image = [UIImage imageNamed:@"IMG_1001.JPG"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = self.view.bounds;
    [self.view addSubview:imageView];
    NSTimeInterval interval = [MRTimer timeIntervalFromLastFlag];
    NSLog(@"Time interval from begin: %f", interval);
    
    [MRTimer observeEnd:MR_SELECTOR];
}

@end
