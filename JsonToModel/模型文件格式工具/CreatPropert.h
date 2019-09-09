//
//  CreatPropert.h
//  JsonToModel
//
//  Created by it on 2018/12/14.
//  Copyright © 2018年 it. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CapitalStr(Str) [Str capitalizedString]//首字母大写
#define PropertyArr(Str) [NSString stringWithFormat:@"%@Arr",Str]//数组属性
#define PropertyDic(Str) [NSString stringWithFormat:@"%@Dic",Str]//字典属性



NS_ASSUME_NONNULL_BEGIN

@interface CreatPropert : NSObject

#pragma mark - 创建模型文件方法
+ (void)creatProperty:(id)obj//数据对象
             fileName:(NSString *)fileName//模型类名称
          WithContext:(NSString *)context//模型name 默认是空字符串""
             savePath:(NSString *)savePath//保存创建模型文件的路径
           withNSNULL:(BOOL)isNULL//判断是不是NSNULL对象转NSString
           withNSDATE:(BOOL)isDATE//判断是不是NSDate对象转NSString
         withNSNUMBER:(BOOL)isNUMBER//判断是不是NSNumber对象转NSString
         withGiveData:(NSInteger)category//采用什么赋值方式（kvc，jsmodel，其他
        withModelName:(NSString *)modelName;//用户输入数据模型名称
#pragma mark - 基础属性声明方法
//整型类型属性
+ (void)myNSNumberInt:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM;
//浮点型类型属性
+ (void)myNSNumberFloat:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM;
//字符串类型属性
+ (void)myNSString:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM;
//存储二进制数据属性
+ (void)myNSData:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM;
//时间类型属性
+ (void)myNSDate:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM;
//空类型属性
+ (void)myNSNull:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM;
//数组类型属性
+ (void)myNSArray:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM;
//字典类型属性
+ (void)myNSDictionary:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM;


#pragma mark - 对象描述方法，方便打印模型对象信息
+ (void)writeDescriptionToNSMutableString:(NSMutableString *)StrM//
                               withArrInt:(NSArray *)arrInt//模型对象里面整型属性集合
                             withArrFloat:(NSArray *)arrFloat//模型对象里面浮点型属性集合
                            withArrString:(NSArray *)arrString//模型对象里面字符串属性集合
                                 withPMArr:(NSArray *)pMArr//模型对象里面集合
                                 withPDic:(NSArray *)pDic//模型对象字典属性集合
                                 withPData:(NSArray *)pDicData//模型对象二进制属性集合
                                 withPDate:(NSArray *)pDate//模型对象时间属性集合
                                 withPNull:(NSArray *)pNull//模型对象空属性集合
                                 withPArr:(NSArray *)pArr;//模型对象里面集合

#pragma mark - 编写引入的头文件
+ (void)addModelHFileToNSMutableString:(NSMutableString *)StrM
                          withArrNames:(nullable NSArray *)arrNames
                          withDicNames:(nullable NSArray *)dicNames
                         withModelName:(NSString *)modelName;


@end

NS_ASSUME_NONNULL_END
