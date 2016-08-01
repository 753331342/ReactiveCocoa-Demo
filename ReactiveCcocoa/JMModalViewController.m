//
//  JMModalViewController.m
//  ReactiveCocoa
//
//  Created by 张家铭 on 16/7/30.
//  Copyright © 2016年 张家铭. All rights reserved.
//

#import "JMModalViewController.h"
#import "GlobalHeader.h"

@interface JMModalViewController ()

@property (strong, nonatomic) RACSignal *signal;

@end

@implementation JMModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        NSLog(@"%@", self);
        [subscriber sendNext:@"你好"];
        return nil;
    }];
    
    _signal = signal;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
   NSLog(@"%s", __func__);
}
@end
