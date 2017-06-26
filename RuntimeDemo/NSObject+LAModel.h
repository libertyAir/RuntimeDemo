//
//  NSObject+Model.h
//  RuntimeDemo
//
//  Created by libertyAir on 2017/2/26.
//  Copyright © 2017年 libertyAir. All rights reserved.
//  快速生成Model属性,归解档Model,用字典给Model赋值

#import <Foundation/Foundation.h>

@protocol LAProperty <NSObject>

@optional
/**
 *  数组中需要转换的模型类
 *  @return 字典中的key是数组属性名，value是数组中存放模型的Class（Class类型或者NSString类型）
 */
+ (NSDictionary *)la_objectClassInArray;

/**
 *  将属性名换为其他key去字典中取值
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)la_replacedKeyFromPropertyName;

@end






@interface NSObject (LAModel)<LAProperty>

#pragma mark - Archiver

- (BOOL)la_saveToFile:(NSString *)path;

+ (id)la_readFromFile:(NSString *)path;

+ (BOOL)la_removeFromFile:(NSString *)path;



#pragma mark - CreatePropertyCode

+ (void)la_propertyCodeWithDict:(NSDictionary *)dict recursion:(BOOL)recursion;



#pragma mark - ModelWithDict

+ (instancetype)la_modelWithDict:(NSDictionary *)dict;


@end
