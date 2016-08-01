//
//  JMFlag.h
//  ReactiveCocoa
//
//  Created by 张家铭 on 16/7/29.
//  Copyright © 2016年 张家铭. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMFlag : NSObject

@property (copy, nonatomic) NSString *name;

@property (copy, nonatomic) NSString *icon;

+ (instancetype)flagWithDict:(NSDictionary *)dict;
@end
