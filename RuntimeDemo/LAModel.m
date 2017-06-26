//
//  Model.m
//  RuntimeDemo
//
//  Created by libertyAir on 2017/6/26.
//  Copyright © 2017年 libertyAir. All rights reserved.
//

#import "LAModel.h"

@implementation User
+ (NSDictionary *)la_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end

@implementation RetweetedStatus

@end


@implementation LAModel
+ (NSDictionary *)la_objectClassInArray{
    return @{
             @"array" : @"User"
             };
}
+ (NSDictionary *)la_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end
