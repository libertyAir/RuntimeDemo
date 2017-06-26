//
//  Model.h
//  RuntimeDemo
//
//  Created by libertyAir on 2017/6/26.
//  Copyright © 2017年 libertyAir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;

+ (NSDictionary *)la_replacedKeyFromPropertyName;
@end



@interface RetweetedStatus : NSObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) User *user;

@end


@interface LAModel : NSObject

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL isVip;
@property (nonatomic, strong) NSArray<User *>*array;
@property (nonatomic, strong) RetweetedStatus *retweetedStatus;
@property (nonatomic, strong) User *user;

+ (NSDictionary *)la_replacedKeyFromPropertyName;
+ (NSDictionary *)la_objectClassInArray;

@end





