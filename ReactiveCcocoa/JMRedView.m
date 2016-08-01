//
//  JMRedView.m
//  ReactiveCocoa
//
//  Created by 张家铭 on 16/7/29.
//  Copyright © 2016年 张家铭. All rights reserved.
//

#import "JMRedView.h"


@implementation JMRedView

- (RACSubject *)btnClickSignal {
    if (!_btnClickSignal) {
        _btnClickSignal = [RACSubject subject];
    }
    return _btnClickSignal;
}

- (IBAction)btnClick:(id)sender {
    // 1.
    //[self.btnClickSignal sendNext:@"按钮没点击了"];
}

@end
