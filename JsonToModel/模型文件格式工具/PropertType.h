//
//  PropertType.h
//  JsonToModel
//
//  Created by it on 2018/12/17.
//  Copyright © 2018年 it. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PropertType : NSObject

@property(nonatomic, strong) NSMutableArray * intProp;//整型属性集合

@property(nonatomic, strong) NSMutableArray * floatProp;//浮点型属性集合

@property(nonatomic, strong) NSMutableArray * strProp;//字符串型属性集合

@property(nonatomic, strong) NSMutableArray * arrProp;//不可变数组属性集合

@property(nonatomic, strong) NSMutableArray * arrMProp;//可变数组属性集合

@property(nonatomic, strong) NSMutableArray * dicMProp;//可变字典属性集合

@property(nonatomic, strong) NSMutableArray * dataProp;//二进制类属性集合

@property(nonatomic, strong) NSMutableArray * dateProp;//时间类属性集合

@property(nonatomic, strong) NSMutableArray * nullProp;//空类属性集合


@end

NS_ASSUME_NONNULL_END
