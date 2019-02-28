//
//  CreatPropert.m
//  JsonToModel
//
//  Created by it on 2018/12/14.
//  Copyright © 2018年 it. All rights reserved.
//

#import "CreatPropert.h"
#import "KVCPropert.h"//kvc模式
#import "JSModelPropert.h"//JsonModel模式

typedef NS_ENUM(NSInteger, AssignmentToolType) {
    AssignmentToolTypeWithKVCModel = 1,//kvc
    AssignmentToolTypeWithJsonModel,//jsonModel
    AssignmentToolTypeWithOtherModel,//其他方式
};

@implementation CreatPropert

#pragma mark - 基础属性声明方法
//存储二进制数据属性
+ (void)myNSData:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM {
    [StrM appendString:@"///注释\n"];
    [StrM appendString:@"@property (nonatomic, strong) NSData *"];
    [StrM appendString:tempStr];
    [StrM appendString:@";\n"];
}
//时间类型属性
+ (void)myNSDate:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM {
    [StrM appendString:@"///注释\n"];
    [StrM appendString:@"@property (nonatomic, strong) NSDate *"];
    [StrM appendString:tempStr];
    [StrM appendString:@";\n"];
}
//字符串类型属性
+ (void)myNSString:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM {
    [StrM appendString:@"///注释\n"];
    [StrM appendString:@"@property (nonatomic, copy) NSString *"];
    [StrM appendString:tempStr];
    [StrM appendString:@";\n"];
}
//空类型属性
+ (void)myNSNull:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM {
    [StrM appendString:@"///注释\n"];
    [StrM appendString:@"@property (nonatomic, strong) NSNull *"];
    [StrM appendString:tempStr];
    [StrM appendString:@";\n"];
}
//整型类型属性
+ (void)myNSNumberInt:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM {
    [StrM appendString:@"///注释\n"];
    [StrM appendString:@"@property (nonatomic, assign) NSInteger "];
    [StrM appendString:tempStr];
    [StrM appendString:@";\n"];
}
//浮点型类型属性
+ (void)myNSNumberFloat:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM {
    [StrM appendString:@"///注释\n"];
    [StrM appendString:@"@property (nonatomic, assign) CGFloat "];
    [StrM appendString:tempStr];
    [StrM appendString:@";\n"];
}
//数组类型属性
+ (void)myNSArray:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM {
    [StrM appendString:@"///注释\n"];
    [StrM appendString:@"@property (nonatomic, strong) NSArray *"];
    [StrM appendString:tempStr];
    [StrM appendString:@";\n"];
}
//字典类型属性
+ (void)myNSDictionary:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM {
    [StrM appendString:@"///注释\n"];
    [StrM appendString:@"@property (nonatomic, strong) NSDictionary *"];
    [StrM appendString:tempStr];
    [StrM appendString:@";\n"];
}

#pragma mark - 构建属性和属性赋值方法的方法
+ (void)creatProperty:(id)obj fileName:(NSString *)fileName WithContext:(NSString *)context savePath:(NSString *)savePath withNSNULL:(BOOL)isNULL withNSDATE:(BOOL)isDATE withNSNUMBER:(BOOL)isNUMBER withGiveData:(NSInteger)category withModelName:(NSString *)modelName {
    
//    if([fileName isEqualToString:modelName] == NO){
//        if(category == 1)
//            fileName = [modelName stringByAppendingString:fileName];
//    }
    if(![fileName isEqualToString:modelName]){
        fileName = [modelName stringByAppendingString:fileName];
    }
    switch (category) {
        case AssignmentToolTypeWithKVCModel:
            [KVCPropert creatProperty:obj fileName:fileName WithContext:context savePath:savePath withNSNULL:isNULL withNSDATE:isDATE withNSNUMBER:isNUMBER withGiveData:category withModelName:modelName];
            break;
        case AssignmentToolTypeWithJsonModel:
            [JSModelPropert creatProperty:obj fileName:fileName WithContext:context savePath:savePath withNSNULL:isNULL withNSDATE:isDATE withNSNUMBER:isNUMBER withGiveData:category withModelName:modelName];
            break;
        default:
            break;
    }

}
#pragma mark - 对象描述方法，方便打印模型对象信息
+ (void)writeDescriptionToNSMutableString:(NSMutableString *)StrM withArrInt:(NSArray *)arrInt withArrFloat:(NSArray *)arrFloat withArrString:(NSArray *)arrString withPMArr:(NSArray *)pMArr withPDic:(NSArray *)pDic withPData:(NSArray *)pData withPDate:(NSArray *)pDate withPNull:(NSArray *)pNull withPArr:(NSArray *)pArr {
    [StrM appendString:@"//重写描述方法，方便打印模型对象信息\n"];
    [StrM appendString:@"- (NSString *)description{\n\t"];
    [StrM appendString:@"return [NSString stringWithFormat:@\""];
    NSMutableArray *arrPropert=[NSMutableArray new];
    NSInteger count = arrInt.count + arrFloat.count + arrString.count + pMArr.count + pDic.count + pData.count + pDate.count + pNull.count + pArr.count;
    if (arrInt.count > 0) {
        for (NSString *tempStr in arrInt) {
            [StrM appendString:tempStr];
            if(count!=1){[StrM appendString:@"=%ld,"];}
            else {[StrM appendString:@"=%ld"];}
            [arrPropert addObject:[@"_" stringByAppendingString:tempStr]];
            count--;
        }
    }
    if (arrFloat.count > 0) {
        for (NSString *tempStr in arrFloat) {
            [StrM appendString:tempStr];
            if(count!=1)[StrM appendString:@"=%f,"];
            else [StrM appendString:@"=%f"];
            [arrPropert addObject:[@"_" stringByAppendingString:tempStr]];
            count--;
        }
    }
    if (arrString.count > 0) {
        for (NSString *tempStr in arrString) {
            [StrM appendString:tempStr];
            if(count!=1)[StrM appendString:@"=%@,"];
            else [StrM appendString:@"=%@"];
            [arrPropert addObject:[@"_" stringByAppendingString:tempStr]];
            count--;
        }
    }
    if (pData.count > 0) {
        for (NSString *tempStr in pData) {
            [StrM appendString:tempStr];
            if(count!=1)[StrM appendString:@"=%@,"];
            else [StrM appendString:@"=%@"];
            [arrPropert addObject:[@"_" stringByAppendingString:tempStr]];
            count--;
        }
    }
    if (pDate.count > 0) {
        for (NSString *tempStr in pDate) {
            [StrM appendString:tempStr];
            if(count!=1)[StrM appendString:@"=%@,"];
            else [StrM appendString:@"=%@"];
            [arrPropert addObject:[@"_" stringByAppendingString:tempStr]];
            count--;
        }
    }
    if (pNull.count > 0) {
        for (NSString *tempStr in pNull) {
            [StrM appendString:tempStr];
            if(count!=1)[StrM appendString:@"=%@,"];
            else [StrM appendString:@"=%@"];
            [arrPropert addObject:[@"_" stringByAppendingString:tempStr]];
            count--;
        }
    }
    if (pMArr.count > 0) {
        for (NSString *tempStr in pMArr) {
            [StrM appendString:@"my"];
            [StrM appendString:PropertyArr(CapitalStr(tempStr))];
            if(count!=1)[StrM appendString:@"=%@,"];
            else [StrM appendString:@"=%@"];
            [arrPropert addObject:[@"_" stringByAppendingString:[@"my"stringByAppendingString:PropertyArr(CapitalStr(tempStr))]]];
            count--;
        }
    }
    if (pArr.count > 0) {
        for (NSString *tempStr in pArr) {
            [StrM appendString:PropertyArr(tempStr)];
            if(count!=1)[StrM appendString:@"=%@,"];
            else [StrM appendString:@"=%@"];
            [arrPropert addObject:[@"_" stringByAppendingString:PropertyArr(tempStr)]];
            count--;
        }
    }
    if (pDic.count > 0) {
        for (NSString *tempStr in pDic) {
            [StrM appendString:@"my"];
            [StrM appendString:[NSString stringWithFormat:@"%@Model",CapitalStr(tempStr)]];
            if(count!=1)[StrM appendString:@"=%@,"];
            else [StrM appendString:@"=%@"];
            [arrPropert addObject:[@"_" stringByAppendingString:[@"my"stringByAppendingString:[NSString stringWithFormat:@"%@Model",CapitalStr(tempStr)]]]];
            count--;
        }
    }
    count = arrPropert.count;
    if (count > 0)
        [StrM appendString:@"\","];
    else [StrM appendString:@"\""];
    for (NSString *tempStr in arrPropert) {
        [StrM appendString:tempStr];
        if (count!=1)
            [StrM appendString:@","];
        count--;
    }
    [StrM appendString:@"];\n"];
    [StrM appendString:@"}\n\n"];
}

#pragma mark - 编写引入的头文件
+ (void)addModelHFileToNSMutableString:(NSMutableString *)StrM withArrNames:(NSArray *)arrNames withDicNames:(NSArray *)dicNames withModelName:(NSString *)modelName {
    
    if (arrNames.count > 0) {
        for (NSString *name in arrNames) {
            [StrM appendString:@"#import \""];
            [StrM appendFormat:@"%@Model.h\"\n",[modelName stringByAppendingString:CapitalStr(name)]];
        }
    }
    if (dicNames.count > 0) {
        for (NSString *name in dicNames) {
            [StrM appendString:@"#import \""];
            [StrM appendFormat:@"%@Model.h\"\n",[modelName stringByAppendingString:CapitalStr(name)]];
        }
    }
    [StrM appendString:@"\n"];
}

@end
