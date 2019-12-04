//
//  KVCPropert.m
//  JsonToModel
//
//  Created by it on 2018/12/14.
//  Copyright © 2018年 it. All rights reserved.
//

#import "KVCPropert.h"
#import "PropertType.h"


@implementation KVCPropert

#pragma mark - 实现自动根据里面的类型自动生成属性 （c方法）
int judge(const char *p) {
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

#pragma mark - KVC辅助函数 - 属性声明
//可变数组类型属性
+ (void)myNSMutableArray:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM {
    [StrM appendString:@"///注释\n"];
    [StrM appendString:@"@property (nonatomic, strong) NSMutableArray *"];
    [StrM appendString:@"my"];
    [StrM appendString:tempStr];
    [StrM appendString:@";\n"];
    
}
//可变字典类型属性
+ (void)myNSMutableDictionary:(NSString *)tempStr ToNSMutableString:(NSMutableString *)StrM withModelName:(NSString *)modelName {
    [StrM appendString:@"///注释\n"];
    [StrM appendString:@"@property (nonatomic, strong) "];
    [StrM appendString:[NSString stringWithFormat:@"%@%@Model *",modelName,tempStr]];
    [StrM appendString:@"my"];
    [StrM appendString:tempStr];
    [StrM appendString:@"Model"];
    [StrM appendString:@";\n"];
}
#pragma mark - KVC辅助函数 - 属性赋值方法实现
//实现懒加载可变对象
+ (void)initNSMutableArrayWithName:(NSString *)name ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"- (NSMutableArray *)my"];
    [StrM appendString:  name];
    [StrM appendString:@"{\n\tif(!_my"];
    [StrM appendString:name];
    [StrM appendString:@"){\n\t\t_my"];
    [StrM appendString:name];
    [StrM appendString:@"=[NSMutableArray new];\n\t}\n\treturn _my"];
    [StrM appendString:name];
    [StrM appendString:@";\n}\n\n"];
}
+ (void)initNSMutableDictionaryWithName:(NSString *)name ToNSMutableString:(NSMutableString *)StrM{
    [StrM appendString:@"- (NSMutableDictionary *)my"];
    [StrM appendString:name];
    [StrM appendString:@"{\n\tif(!_my"];
    [StrM appendString:name];
    [StrM appendString:@"){\n\t\t_my"];
    [StrM appendString:name];
    [StrM appendString:@"=[NSMutableDictionary new];\n\t}\n\treturn _my"];
    [StrM appendString:name];
    [StrM appendString:@";\n}\n\n"];
}
#pragma mark - (void)setValue:(id)value forUndefinedKey:(NSString *)key
+ (void)setValueForUndefinedKeyToNSMutableString:(NSMutableString *)StrM withArrNames:(NSArray *)arrNames withDicNames:(NSArray *)dicNames withArrSpecialName:(NSArray *)arrSpecialName withModelName:(NSString *)modelName{
    [StrM appendString:@"/*设置属性名为key的属性值为value时，如果属性不存在则执行该方法，可自定义实现，默认实现方式为抛出NSUnknownKeyException异常*/\n"];
    [StrM appendString:@"- (void)setValue:(id)value forUndefinedKey:(NSString *)key {\n"];
    
    int count=0;
    if(arrNames.count>0){
        for (NSString *name in arrNames) {
            if(count==0){
                count=1;
                [StrM appendString:@"\tif ([key isEqualToString:@\""];
            }else{
                [StrM appendString:@"\telse if ([key isEqualToString:@\""];
            }
            [StrM appendString:name];
            [StrM appendString:@"\"]) {\n\t\tfor (NSDictionary *dic in value) {\n\t\t\t"];
            [StrM appendString:modelName];[StrM appendString:CapitalStr(name)];
            [StrM appendString:@"Model *model = ["];
            [StrM appendString:modelName];[StrM appendString:CapitalStr(name)];
            [StrM appendString:@"Model new];\n\t\t\t[model setValuesForKeysWithDictionary:dic];\n\t\t\t[self.my"];
            [StrM appendString:PropertyArr(CapitalStr(name))];
            [StrM appendString:@" addObject:model];\n\t\t}\n\t}\n"];
        }
    }
    
    if(arrSpecialName.count > 0){
        for (NSString *name in arrSpecialName) {
            if(count==0){
                count=1;
                [StrM appendString:@"\tif ([key isEqualToString:@\""];
            }else{
                [StrM appendString:@"\telse if ([key isEqualToString:@\""];
            }
            [StrM appendString:name];
            [StrM appendString:@"\"]) {\n\t\t"];
            [StrM appendString:@"self."];
            [StrM appendString:PropertyArr(name)];
            [StrM appendString:@" = [NSArray arrayWithArray:value];\n\t}\n"];
        }
    }
    
    if(dicNames.count > 0){
        for (NSString * name in dicNames) {
            
            if(count == 0){
                count = 1;
                [StrM appendString:@"\tif ([key isEqualToString:@\""];
            }else{
                [StrM appendString:@"\telse if ([key isEqualToString:@\""];
            }
            
            [StrM appendString:name];
            [StrM appendString:@"\"]) {\n\t\t"];
            [StrM appendString:@"self.my"];
            [StrM appendString:CapitalStr(name)];
            [StrM appendString:@"Model"];
            [StrM appendString:@" = ["];
            [StrM appendString:modelName];[StrM appendString:CapitalStr(name)];
            [StrM appendString:@"Model new];\n\t\t"];
            [StrM appendString:@"[self.my"];
            [StrM appendString:CapitalStr(name)];
            [StrM appendString:@"Model setValuesForKeysWithDictionary:value"];
            [StrM appendString:@"];\n\t}\n"];
        }
    }
    
    [StrM appendString:@"}\n\n"];
}
#pragma mark - (void)setValue:(id)value forKey:(NSString *)key
+ (void)setValueForKeyToNSMutableString:(NSMutableString *)StrM withNSNUMBER:(BOOL)NSNUMBER withObjNULL:(BOOL)objNull {
    [StrM appendString:@"//设置属性名为key的属性的值为value\n"];
    [StrM appendString:@"- (void)setValue:(id)value forKey:(NSString *)key {\n"];
    
    if(NSNUMBER == YES){
        [StrM appendString:@"\tif ([value isKindOfClass:[NSNumber class]]) {\n"];
        [StrM appendString:@"\t\t[self setValue:[NSString stringWithFormat:@\"%@\",value] forKey:key];\n\t}"];
    }
    if(objNull == YES){
        [StrM appendString:@"else if ([value isKindOfClass:[NSNull class]] || value == nil) {\n"];
        [StrM appendString:@"\t\t[self setValue:@\"\" forKey:key];\n\t}"];
    }
    [StrM appendString:@"else {\n"];
    [StrM appendString:@"\t\t[super setValue:value forKey:key];\n\t}\n"];
    [StrM appendString:@"}\n\n"];
}
#pragma mark - (id)valueForUndefinedKey:(NSString *)key
+ (void)getValueForUndefinedKeyToNSMutableString:(NSMutableString *)StrM withSelfModelName:(NSString *)selfModelName{
    [StrM appendString:@"/*获取属性名为key的属性值时，如果属性不存在则执行该方法，可自定义实现，默认实现方式为抛出NSUnknownKeyException异常*/\n"];
    [StrM appendString:@"- (id)valueForUndefinedKey:(NSString *)key {\n\t"];
    [StrM appendString:@"NSLog(@\"error: "];
    [StrM appendString:selfModelName];
    [StrM appendString:@"数据模型中:未找到key = %@\",key);\n\t"];
    [StrM appendString:@"return nil;\n"];
    [StrM appendString:@"}\n\n"];
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
                
                if(((NSArray *)obj[objTemp]).count > 0 && [((NSArray *)obj[objTemp])[0] isKindOfClass:[NSDictionary class]]) {//判断里面的数组中是字典
                    
                    [pType.arrMProp addObject:objTemp];//存储修改过的属性名
                    [self myNSMutableArray:PropertyArr(CapitalStr(objTemp)) ToNSMutableString:propertyStr];
                    
                }else {
                    
                    [pType.arrProp addObject:objTemp];//存储修改过的属性名
                    [self myNSArray:PropertyArr(objTemp) ToNSMutableString:propertyStr];
                    
                }
                
                NSString *tempFileName = CapitalStr(objTemp);
                
                [self creatProperty:obj[objTemp] fileName:tempFileName WithContext:tempFileName savePath:savePath withNSNULL:isNULL withNSDATE:isDATE withNSNUMBER:isNUMBER withGiveData:category withModelName:modelName];
                
            }else if ([obj[objTemp] isKindOfClass:[NSDictionary class]]) {//如果字典里面是字典
                
                [pType.dicMProp addObject:objTemp];//存储修改过的属性名
                
                NSString *tempFileName = CapitalStr(objTemp);
                [self myNSMutableDictionary:tempFileName ToNSMutableString:propertyStr withModelName:modelName];
                
                [self creatProperty:obj[objTemp] fileName:tempFileName WithContext:tempFileName savePath:savePath withNSNULL:isNULL withNSDATE:isDATE withNSNUMBER:isNUMBER withGiveData:category withModelName:modelName];
                
            }else if ([obj[objTemp] isKindOfClass:[NSNumber class]]) {//如果字典里面是NSNumber
                
                if(!isNUMBER){//NSNumber不转字符串对象
                    //这里需要对里面的值进行判断
                    NSNumber * num = obj[objTemp];
                    NSString * strNum = [num stringValue];//将NSNumber转换成字符串
                    const char * strP = [strNum UTF8String];
                    switch (judge(strP)) {
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
        
    }else if ([obj isKindOfClass:[NSArray class]]) {//如果obj对象是数组
        
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
    [self createAPropertiesFileAtSavePath:savePath withFileName:fileName withPropertyStr:propertyStr withPType:pType withModelName:modelName withNSNUMBER:isNUMBER withObjNULL:isNULL];
    
}
#pragma mark - 创建模型文件
+ (void)createAPropertiesFileAtSavePath:(NSString *)savePath withFileName:(NSString *)fileName withPropertyStr:(NSString *)propertyStr withPType:(PropertType *)pType withModelName:(NSString *)modelName withNSNUMBER:(BOOL)isNUMBER withObjNULL:(BOOL)objNull {
    
    NSString *path = savePath;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    path = [path stringByAppendingString:fileName];
    
    if (propertyStr.length > 0) {//如果没有就不创建文件夹
        //创建一个.h文件
        NSMutableString *text=[NSMutableString stringWithString:@"#import <Foundation/Foundation.h>\n\n"];
        [self addModelHFileToNSMutableString:text withArrNames:nil withDicNames:pType.dicMProp withModelName:modelName];
        [text appendString:@"@interface "];
        [text appendFormat:@"%@Model",fileName];
        [text appendString:@" : NSObject\n\n"];
        [text appendString:propertyStr];
        [text appendString:@"\n@end\n"];
        [text writeToFile:[path stringByAppendingString:@"Model.h"]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        //还要创建一个.m文件
        [text setString:@"#import \""];
        [text appendFormat:@"%@Model.h\"\n\n",fileName];
        [self addModelHFileToNSMutableString:text withArrNames:pType.arrMProp withDicNames:nil withModelName:modelName];
        [text appendString:@"@implementation "];
        [text appendFormat:@"%@Model\n\n",fileName];
        //在这里还可以添加其他信息
        if(pType.arrMProp.count>0){
            for (NSString *name in pType.arrMProp) {
                [self initNSMutableArrayWithName:PropertyArr(CapitalStr(name)) ToNSMutableString:text];
            }
        }
        
        [self setValueForKeyToNSMutableString:text withNSNUMBER:isNUMBER withObjNULL:objNull];
        
        [self setValueForUndefinedKeyToNSMutableString:text withArrNames:pType.arrMProp withDicNames:pType.dicMProp withArrSpecialName:pType.arrProp withModelName:modelName];
        
        [self getValueForUndefinedKeyToNSMutableString:text withSelfModelName:[fileName stringByAppendingString:@"Model"]];
        //4.添加打印信息
        [self writeDescriptionToNSMutableString:text withArrInt:pType.intProp withArrFloat:pType.floatProp withArrString:pType.strProp withPMArr:pType.arrMProp withPDic:pType.dicMProp withPData:pType.dateProp withPDate:pType.dateProp withPNull:pType.nullProp withPArr:pType.arrProp];
        
        [text appendString:@"\n\n@end\n"];
        [text writeToFile:[path stringByAppendingString:@"Model.m"]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
}








@end
