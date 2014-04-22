//
//  ViewController.m
//  FunctionTimer
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
