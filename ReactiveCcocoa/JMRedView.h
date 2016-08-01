//
//  JMRedView.h
//  ReactiveCocoa
//
//  Created by 张家铭 on 16/7/29.
//  Copyright © 2016年 张家铭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHeader.h"

@interface JMRedView : UIView

@property (strong, nonatomic) RACSubject *btnClickSignal;

@end
