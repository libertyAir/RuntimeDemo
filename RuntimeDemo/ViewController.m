//
//  ViewController.m
//  RuntimeDemo
//
//  Created by libertyAir on 2017/2/26.
//  Copyright © 2017年 libertyAir. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+LAModel.h"
#import "LAModel.h"

@interface ViewController ()
@property(nonatomic,strong)NSDictionary *dict;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [NSObject la_propertyCodeWithDict:self.dict recursion:YES];
    LAModel *model = [LAModel la_modelWithDict:self.dict];
    [model la_saveToFile:nil];
    LAModel *getModel = [NSObject la_readFromFile:nil];
}


- (NSDictionary *)dict{
    if (!_dict) {
        _dict = @{
                       @"id"                : @"1",
                       @"text"              : @"Agree!Nice weather!",
                       @"user"              : @{
                                                   @"id"   : @"213",
                                                   @"name" : @"Jack",
                                                   @"icon" : @"lufy.png"
                                                   },
                       @"retweetedStatus"   : @{
                               @"text" : @"Nice weather!",
                               @"user" : @{
                                               @"name" : @"Rose",
                                               @"icon" : @"nami.png"
                                           }
                               },
                       @"array"             : @[
                               @{
                                   @"name" : @"Rose",
                                   @"icon" : @"nami.png"
                                   },
                               @{
                                   @"name" : @"Rose",
                                   @"icon" : @"nami.png"
                                   }
                               ],
                       @"dict"              : @{
                               @"user":@{
                                       @"name" : @"Rose",
                                       @"icon" : @"nami.png"
                                       }
                               
                               },
                       @"isVip"             : @(YES)
                       };

    }
    return _dict;
}

@end
