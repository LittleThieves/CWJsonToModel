//
//  JSModelPropert.m
//  JsonToModel
//
//  Created by it on 2018/12/17.
//  Copyright © 2018年 it. All rights reserved.
//

#import "JSModelPropert.h"
#import "PropertType.h"

@implementation JSModelPropert

#pragma mark - 实现自动根据里面的类型自动生成属性 （c方法）
int judgex(const char *p) {
    printf("数字为:%s\n",p);
    const char *s = p;
    int flag=-1;
    //判断里面是否含有小数点
    while (*s!='\0') {
        if(*s=='.')
            flag=2;//2代表浮点数
        else if(!(*s>='0'&&*s<='9')){
            flag=3;//3代表出错
            NSLog(@"plist说的nsnumber里面含有非数字");
        }
        s++;
    }
    if(flag==-1)flag=1;//3代表成功
    return flag;
}

#pragma mark - 辅助函数JSONModel - 属性声明
+ (void)myNSMutableArrayJSONModelToNSMutableString:(NSMutableString *)StrM withArrNames:(NSArray *)arrNames withArrSpecialNames:(NSArray *)arrSpecialNames withModelName:(NSString *)modelName {
    for (NSString *tempStr in arrNames) {
        [StrM appendString:@"///注释\n"];
        [StrM appendString:@"@property (nonatomic, strong) NSMutableArray <"];
        [StrM appendString:modelName];
        [StrM appendString:CapitalStr(tempStr)];
        [StrM appendString:@"Model"];
        [StrM appendString:@"> *my"];
        [StrM appendString:PropertyArr(CapitalStr(tempStr))];
        [StrM appendString:@";\n"];
    }
    for (NSString *tempStr in arrSpecialNames) {
        [StrM appendString:@"///注释\n"];
        [StrM appendString:@"@property (nonatomic, strong) NSArray *"];
        [StrM appendString:PropertyArr(tempStr)];
        [StrM appendString:@";\n"];
    }
}
+ (void)myNSMutableDictionaryJSONModel:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM withModelName:(NSString *)modelName {
    [StrM appendString:@"///注释\n"];
    [StrM appendString:@"@property (nonatomic, strong) NSMutableDictionary <"];
    [StrM appendString:modelName];
    [StrM appendString:tempStr];
    [StrM appendString:@"Model"];
    [StrM appendString:@"> *my"];
    [StrM appendString:tempStr];
    [StrM appendString:@";\n"];
}

#pragma mark - KVC辅助函数 - 属性赋值方法实现声明
//JSONModel辅助函数
+ (void)addProtocolToNSMutableString:(NSMutableString *)StrM withFileName:(NSString *)fileName withModelName:(NSString *)modelName{
    if([modelName isEqualToString:fileName]==NO){
        [StrM appendString:@"@protocol "];
        [StrM appendString:fileName];
        [StrM appendString:@"Model <NSObject>\n\n"];
        [StrM appendString:@"@end\n\n"];
    }
}
//1.keyMapper
+ (void)addKeyMapperToNSMutableString:(NSMutableString *)StrM withNSArrayArr:(NSArray *)NSArrayArr withDicArr:(NSArray *)dicArr {
    [StrM appendString:@"+(JSONKeyMapper *)keyMapper{\n\t"];
    [StrM appendString:@"return [[JSONKeyMapper alloc] initWithDictionary:@{"];
    NSInteger count=NSArrayArr.count+dicArr.count;
    for (NSString *str in NSArrayArr) {
        [StrM appendString:@"@\""];[StrM appendString:str];[StrM appendString:@"\":@\""];
        [StrM appendString:@"my"];[StrM appendString:PropertyArr(CapitalStr(str))];[StrM appendString:@"\""];
        if(count!=1)
            [StrM appendString:@","];
        count--;
    }
    for (NSString *str in dicArr) {
        [StrM appendString:@"@\""];[StrM appendString:str];[StrM appendString:@"\":@\""];
        [StrM appendString:@"my"];[StrM appendString:CapitalStr(str)];[StrM appendString:@"\""];
        if(count!=1)
            [StrM appendString:@","];
        count--;
    }
    [StrM appendString:@"}];\n}\n\n"];
}
//2.propertyIsIgnored
+ (void)addPropertyIsIgnoredToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"+ (BOOL)propertyIsIgnored:(NSString *)propertyName{\n\t"];
    [StrM appendString:@"return YES;\n}\n\n"];
}
//3.propertyIsOptional
+ (void)addPropertyIsOptionalToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"+(BOOL)propertyIsOptional:(NSString *)propertyName{\n\t"];
    [StrM appendString:@"return YES;\n}\n\n"];
}


#pragma mark - 构建属性和属性赋值方法的方法
+ (void)creatProperty:(id)obj fileName:(NSString *)fileName WithContext:(NSString *)context savePath:(NSString *)savePath withNSNULL:(BOOL)isNULL withNSDATE:(BOOL)isDATE withNSNUMBER:(BOOL)isNUMBER withGiveData:(NSInteger)category withModelName:(NSString *)modelName {
    
    NSMutableString * propertyStr = [NSMutableString new];//存储描写属性声明字符串
    
    PropertType * pType = [PropertType new];//帮助存储属性名称
    
    if(![fileName isEqualToString:modelName]){
        
        fileName = [modelName stringByAppendingString:fileName];
        
    }
    
    if ([obj isKindOfClass:[NSDictionary class]]) {//如果obj对象是字典
        
        for (id objTemp in obj) {//开始遍历字典里面的键值对
            
            if ([obj[objTemp] isKindOfClass:[NSString class]]) {//如果字典里面是字符串
                
                [pType.strProp addObject:objTemp];//存储属性名
                [self myNSString:objTemp ToNSMutableString:propertyStr];
                
            }else if([obj[objTemp] isKindOfClass:[NSArray class]]){//如果字典里面是数组
                
                if(((NSArray *)obj[objTemp]).count > 0 && [((NSArray *)obj[objTemp])[0] isKindOfClass:[NSDictionary class]]){//判断里面的数组中是不是字典
                    
                    [pType.arrMProp addObject:objTemp];
                    
                }else{
                    
                    [pType.arrProp addObject:objTemp];
                        
                }
                
                [self myNSMutableArrayJSONModelToNSMutableString:propertyStr withArrNames:[pType.arrMProp copy] withArrSpecialNames:[pType.arrProp copy] withModelName:modelName];
                
                NSString *tempFileName = CapitalStr(objTemp);
                [self creatProperty:obj[objTemp] fileName:tempFileName WithContext:tempFileName savePath:savePath withNSNULL:isNULL withNSDATE:isDATE withNSNUMBER:isNUMBER withGiveData:category withModelName:modelName];
                
            }else if ([obj[objTemp] isKindOfClass:[NSDictionary class]]) {//如果字典里面是字典

                [pType.dicMProp addObject:objTemp];//存储属性名
                
                NSString *tempFileName = CapitalStr(objTemp);//首字母大写
                [self myNSMutableDictionaryJSONModel:tempFileName ToNSMutableString:propertyStr withModelName:modelName];
                
                [self creatProperty:obj[objTemp] fileName:tempFileName WithContext:tempFileName savePath:savePath withNSNULL:isNULL withNSDATE:isDATE withNSNUMBER:isNUMBER withGiveData:category withModelName:modelName];
                
            }else if ([obj[objTemp] isKindOfClass:[NSNumber class]]) {//如果字典里面是NSNumber
                
                if(!isNUMBER){//NSNumber不转字符串对象
                    //这里需要对里面的值进行判断
                    NSNumber * num = obj[objTemp];
                    NSString * strNum = [num stringValue];//将NSNumber转换成字符串
                    const char * strP = [strNum UTF8String];
                    switch (judgex(strP)) {
                        case 1:
                            [pType.intProp addObject:objTemp];
                            [self myNSNumberInt:objTemp ToNSMutableString:propertyStr];
                            break;
                        case 2:
                            [pType.floatProp addObject:objTemp];
                            [self myNSNumberFloat:objTemp ToNSMutableString:propertyStr];
                            break;
                        default:
                            break;
                    }
                    
                }else{//NSNumber转字符串对象
                    [pType.strProp addObject:objTemp];
                    [self myNSString:objTemp ToNSMutableString:propertyStr];
                }
                
            }else if ([obj[objTemp] isKindOfClass:[NSDate class]]) {//如果字典里面是NSDate
                
                if(!isDATE){//NSDate不转字符串对象
                    [pType.dateProp addObject:objTemp];
                    [self myNSDate:objTemp ToNSMutableString:propertyStr];
                }
                else{//NSDate转字符串对象
                    [pType.strProp addObject:objTemp];
                    [self myNSString:objTemp ToNSMutableString:propertyStr];
                }
                
            }else if ([obj[objTemp] isKindOfClass:[NSNull class]]) {//如果字典里面是NSNull
                
                if(!isNULL){//NSNull不转字符串对象
                    //这里需要注意,假如文本里面是空,可能会被当做成NSNull
                    [pType.nullProp addObject:objTemp];
                    [self myNSNull:objTemp ToNSMutableString:propertyStr];
                }else{//NSNull转字符串对象
                    [pType.strProp addObject:objTemp];
                    [self myNSString:objTemp ToNSMutableString:propertyStr];
                }
                
            }else if([obj[objTemp] isKindOfClass:[NSData class]]){//如果字典里面是NSData
                [pType.dataProp addObject:objTemp];
                [self myNSData:objTemp ToNSMutableString:propertyStr];
                
            }
            
        }
        
    }//如果obj对象是字典
    else if ([obj isKindOfClass:[NSArray class]]) {//如果obj对象是数组
        
        NSString *tempFileName = context;
        for (id objTemp in obj) {
            if ([objTemp isKindOfClass:[NSDictionary class]]) {
                [self creatProperty:objTemp fileName:tempFileName WithContext:objTemp savePath:savePath withNSNULL:isNULL withNSDATE:isDATE withNSNUMBER:isNUMBER withGiveData:category withModelName:modelName];
                break;
            }
            else if ([objTemp isKindOfClass:[NSArray class]]) {
                [self creatProperty:obj[objTemp] fileName:tempFileName WithContext:objTemp savePath:savePath withNSNULL:isNULL withNSDATE:isDATE withNSNUMBER:isNUMBER withGiveData:category withModelName:modelName];
                break;
            }
        }
        
    }
    //调用创建模型文件方法
    [self createAPropertiesFileAtSavePath:savePath withFileName:fileName withPropertyStr:propertyStr withPType:pType withModelName:modelName withNSNUMBER:isNUMBER];
}
#pragma mark - 创建模型文件
+ (void)createAPropertiesFileAtSavePath:(NSString *)savePath withFileName:(NSString *)fileName withPropertyStr:(NSString *)propertyStr withPType:(PropertType *)pType withModelName:(NSString *)modelName withNSNUMBER:(BOOL)isNUMBER {
    
    NSString *path = savePath;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    path = [path stringByAppendingString:fileName];
    
    if (propertyStr.length > 0) {//如果没有就不创建文件夹
        NSMutableString *text=[NSMutableString stringWithString:@"#import \"JSONModel.h\"\n\n"];
        
        //在这里写入要导入的模型
        [self addModelHFileToNSMutableString:text withArrNames:pType.arrMProp withDicNames:pType.dicMProp withModelName:modelName];
        //在这里还需要写协议
        [self addProtocolToNSMutableString:text withFileName:fileName withModelName:modelName];
        
        [text appendString:@"@interface "];
        [text appendFormat:@"%@Model",fileName];
        [text appendString:@" : JSONModel\n\n"];
        [text appendString:propertyStr];
        [text appendString:@"\n@end\n"];
        [text writeToFile:[path stringByAppendingString:@"Model.h"]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        //还要创建一个.m文件
        [text setString:@"#import \""];
        [text appendFormat:@"%@Model.h\"\n",fileName];
        [text appendString:@"@implementation "];
        [text appendFormat:@"%@Model\n\n",fileName];
        //在这里还可以添加其他信息
        //1.keyMapper
        [self addKeyMapperToNSMutableString:text withNSArrayArr:pType.arrMProp withDicArr:pType.dicMProp];
        //2.propertyIsOptional
        [self addPropertyIsOptionalToNSMutableString:text];
        //3.添加打印信息
        [self writeDescriptionToNSMutableString:text withArrInt:pType.intProp withArrFloat:pType.floatProp withArrString:pType.strProp withPMArr:pType.arrMProp withPDic:pType.dicMProp withPData:pType.dateProp withPDate:pType.dateProp withPNull:pType.nullProp withPArr:pType.arrProp];
        
        [text appendString:@"\n\n@end\n"];
        [text writeToFile:[path stringByAppendingString:@"Model.m"]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }

}

#pragma mark - 对象描述方法，方便打印模型对象信息
+ (void)writeDescriptionToNSMutableString:(NSMutableString *)StrM withArrInt:(NSArray *)arrInt withArrFloat:(NSArray *)arrFloat withArrString:(NSArray *)arrString withPMArr:(NSArray *)pMArr withPDic:(NSArray *)pDic withPData:(NSArray *)pData withPDate:(NSArray *)pDate withPNull:(NSArray *)pNull withPArr:(NSArray *)pArr {
    [StrM appendString:@"//重写描述方法，方便打印模型对象信息\n"];
    [StrM appendString:@"- (NSString *)description{\n\t"];
    [StrM appendString:@"return [NSString stringWithFormat:@\""];
    NSMutableArray *arrPropert=[NSMutableArray new];
    NSInteger count = arrInt.count + arrFloat.count + arrString.count + pArr.count + pDic.count + pData.count + pDate.count + pNull.count;
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
    if ( pDate.count > 0) {
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
            [StrM appendString:CapitalStr(tempStr)];
            if(count!=1)[StrM appendString:@"=%@,"];
            else [StrM appendString:@"=%@"];
            [arrPropert addObject:[@"_" stringByAppendingString:[@"my"stringByAppendingString:CapitalStr(tempStr)]]];
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

@end
