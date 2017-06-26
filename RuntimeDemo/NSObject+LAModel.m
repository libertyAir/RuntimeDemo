//
//  NSObject+Model.m
//  RuntimeDemo
//
//  Created by libertyAir on 2017/2/26.
//  Copyright © 2017年 libertyAir. All rights reserved.
//

#import "NSObject+LAModel.h"
#import <objc/message.h>

static NSString * const fileName = @"LAModel.dat";

@implementation NSObject (LAModel)

#pragma mark - Archiver
//解档
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [self init]) {
        //属性的个数
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i ++) {
            //取出对应的Ivar
            Ivar ivar = ivars[i];
            //取出名称
            const char *name = ivar_getName(ivar);
            //char * 转 OC 字符串
            NSString *key = [NSString stringWithUTF8String:name];
            //解档  利用KVC赋值
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    //用runtime赋值需要知道3个东西，属性的个数(用于控制循环)，属性的key，属性的值
    //属性的个数
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    //遍历
    for (int i = 0; i < count; i++) {
        //取出对应的Ivar
        Ivar ivar = ivars[i];
        //取出名称
        const char *name = ivar_getName(ivar);
        //char * 转 OC 字符串  归档
        NSString *key = [NSString stringWithUTF8String:name];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

- (BOOL)la_saveToFile:(NSString *)path{
    NSString *filePath = path;
    if (!filePath) {
        //default path
        filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:fileName];
    }
    
    return [NSKeyedArchiver archiveRootObject:self toFile:filePath];
}

+ (id)la_readFromFile:(NSString *)path{
    NSString *filePath = path;
    if (!filePath) {
        //default path
        filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:fileName];
    }
    
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (BOOL)la_removeFromFile:(NSString *)path{
    NSString *filePath = path;
    if(!path){
        filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:fileName];
    }
    
    NSFileManager *manager = [[NSFileManager alloc]init];
    return [manager removeItemAtPath:filePath error:nil];
}



#pragma mark - CreatePropertyCode
+ (void)la_propertyCodeWithDict:(NSDictionary *)dict recursion:(BOOL)recursion
{
    NSMutableString * printString = [NSMutableString new];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *str;
        
//        NSLog(@"key: %@ \t\t %@",key,[obj class]);
        
        if ([obj isKindOfClass:[NSString class]]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;",key];
        }
        
        if ([obj isKindOfClass:[NSArray class]]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
        }
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
            if (recursion) {
                [NSObject la_propertyCodeWithDict:obj recursion:YES];
            }
        }
        if ([obj isKindOfClass:[NSNumber class]]) {
            NSNumber *number = (NSNumber *)obj;
            if (strcmp(number.objCType, @encode(int)) == 0) {
                str = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
            }
            if (strcmp(number.objCType, @encode(Boolean)) == 0) {
                str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
            }
            if (strcmp(number.objCType, @encode(float)) == 0) {
                str = [NSString stringWithFormat:@"@property (nonatomic, assign) CGFloat %@;",key];
            }
            if (strcmp(number.objCType, @encode(double)) == 0) {
                str = [NSString stringWithFormat:@"@property (nonatomic, assign) double %@;",key];
            }
            NSLog(@"%s",number.objCType);
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        }
        [printString appendFormat:@"\n%@\n",str];
    }];
    NSLog(@"\n\n--------------------begin--------------------\n%@\n---------------------end---------------------\n\n\n",printString);
}


#pragma mark - ModelWithDict
+ (instancetype)la_modelWithDict:(NSDictionary *)dict{
    
    //1.创建实例对象
    id instance = [[self alloc] init];
    //2.取出所有成员属性
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(self, &count);
    //3.遍历所有成员属性,并依次赋值
    for (int i = 0; i < count;  i++) {
        
        //取出成员属性名字 类型
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
        //去下划线
        NSString *key = [ivarName substringFromIndex:1];
        id value = dict[key];
        //当value为空时,判断是否有replacedKeyFromPropertyName
        if (!value) {
            if ([self respondsToSelector:@selector(la_replacedKeyFromPropertyName)]) {
                NSString *newKey = [self la_replacedKeyFromPropertyName][key];
                value = dict[newKey];
            }
        }
        //字典嵌套字典
        if([value isKindOfClass:[NSDictionary class]]){
            
            //并且成员属性类型不是字典
            NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivars[i])];
            if (![ivarType containsString:@"Dictionary"]) {
                ivarType = [ivarType substringFromIndex:2];      //把@"@"User"" 变成User
                ivarType = [ivarType substringToIndex:ivarType.length-1];
                
                Class modelClass = NSClassFromString(ivarType);
                if (modelClass)
                    value = [modelClass la_modelWithDict:value];
            }
        }
        //字典嵌套数组
        if ([value isKindOfClass:[NSArray class]]) {
            if ([self respondsToSelector:@selector(la_objectClassInArray)])
            {
                NSMutableArray *models = [NSMutableArray array];
                
                NSString *type = [self la_objectClassInArray][key];
                Class classModel = NSClassFromString(type);
                for (NSDictionary *dict in value)
                {
                    id model = [classModel la_modelWithDict:dict];
                    [models addObject:model];
                }
                value = models;
            }
        }
        //赋值
        if (value) {
            [instance setValue:value forKey:key];
        }
    }
    
    return instance;
}


@end
