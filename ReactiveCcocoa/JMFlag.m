//
//  JMFlag.m
//  ReactiveCocoa
//
//  Created by 张家铭 on 16/7/29.
//  Copyright © 2016年 张家铭. All rights reserved.
//

#import "JMFlag.h"

@implementation JMFlag

+ (instancetype)flagWithDict:(NSDictionary *)dict {
    JMFlag *flag = [[self alloc] init];
    [flag setValuesForKeysWithDictionary:dict];
    return flag;
}
@end
