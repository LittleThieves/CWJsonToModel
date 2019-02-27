//
//  ModelDataSourceViewController.m
//  JsonToModel
//
//  Created by it on 2019/2/27.
//  Copyright © 2019年 it. All rights reserved.
//

#import "ModelDataSourceViewController.h"
#import "CreatPropert.h"

@interface ModelDataSourceViewController ()
///数据源
@property (unsafe_unretained) IBOutlet NSTextView *dataSourceTextV;

///存储模型文件的路径
@property (weak) IBOutlet NSTextField *savePathTF;
///模型头
@property (weak) IBOutlet NSTextField *modelNameTF;
///采用kvc模式生成模型文件
@property (weak) IBOutlet NSButton *KVCBtn;
///采用jsmodel模式生成模型文件
@property (weak) IBOutlet NSButton *JSModelBtn;
///采用其他模式生成模型文件
@property (weak) IBOutlet NSButton *otherBtn;
///空对象转字符串
@property (weak) IBOutlet NSButton *nullToStrBtn;
///number对象转字符串
@property (weak) IBOutlet NSButton *numToStrBtn;
///时间对象转字符串
@property (weak) IBOutlet NSButton *dateToStrBtn;
///生成模型文件结果
@property (weak) IBOutlet NSButton *resultsBnt;

//存储后台返回的数据对象
@property (nonatomic, strong)NSDictionary *dict;
@property (nonatomic, strong)NSArray *arr;

@property (nonatomic,copy)NSString *filePath;//文件路径


@end

@implementation ModelDataSourceViewController

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"数据源转模型界面";
    //加载一些初始化数据
    NSString *HomePath=NSHomeDirectory();
    self.savePathTF.stringValue=[HomePath stringByAppendingString:@"/Desktop/MyModel/"];
    self.arr=[NSArray new];
    self.dict=[NSDictionary new];
}

#pragma mark - 采用KVC模式
- (IBAction)clickKVCBtn:(NSButton *)sender {
    if(self.KVCBtn.state == 1){
        self.JSModelBtn.state = 0;
        //        self.otherBtn.state = 0;
    }else if(self.JSModelBtn.state == 0){
        self.JSModelBtn.state=1;
    }
}
#pragma mark - 采用JSModel模式
- (IBAction)clickJSModelBtn:(NSButton *)sender {
    if(self.JSModelBtn.state == 1){
        self.KVCBtn.state = 0;
        //        self.otherBtn.state = 0;
    }else if(self.KVCBtn.state == 0){
        self.KVCBtn.state=1;
    }
}
#pragma mark - 采用其他模式
- (IBAction)clickOtherBtn:(NSButton *)sender {
    
}
#pragma mark - 采用哪种工具生成模型文件(kvc,jsmodel,其他)
- (NSInteger)returnNSInteger {
    if(self.KVCBtn.state==1)
        return 1;
    else if(self.JSModelBtn.state==1){
        return 2;
    }
    else if(self.otherBtn.state==1){
        return 3;
    }
    return 1;//默认返回0
}
#pragma mark - Null转str
- (IBAction)clickNullBtn:(NSButton *)sender {
}
#pragma mark - Number转str
- (IBAction)clickNumBtn:(NSButton *)sender {
}
#pragma mark - Date转str
- (IBAction)clickDateBtn:(NSButton *)sender {
}
#pragma mark - 创建模型文件
- (IBAction)beginCreatModelFileBtn:(NSButton *)sender {
    [self auto_creat];
    self.filePath = [self.savePathTF.stringValue stringByAppendingString:[self.modelNameTF.stringValue stringByAppendingString:@".plist"]];
}
#pragma mark - 检查用户必填项是否填写
- (void)auto_creat{
    
    if(self.dataSourceTextV.string.length==0){
        [self.resultsBnt setTitle:@"数据源不能为空"];
        return;
    }
    if(self.modelNameTF.stringValue.length==0){
        [self.resultsBnt setTitle:@"请输入数据模型名"];
        return;
    }
    //判断保存路径是否存在
    if(self.savePathTF.stringValue.length>0){
        //判断用户是否直接保存到了桌面
        if([self.savePathTF.stringValue isEqualToString:[NSHomeDirectory() stringByAppendingString:@"/Desktop/"]]||[self.savePathTF.stringValue isEqualToString:[NSHomeDirectory() stringByAppendingString:@"/Desktop"]]){
            [self.resultsBnt setTitle:@"请不要文件直接存在桌面上"];
            return;
        }
        if([self.savePathTF.stringValue hasSuffix:@"/"]==NO){
            NSString *tmp=self.savePathTF.stringValue;
            self.savePathTF.stringValue=[tmp stringByAppendingString:@"/"];
        }
        [self requstDataWithUrlPath];//请求数据
    }else {
        [self.resultsBnt setTitle:@"保存路径不能为空"];
    }
}
#pragma mark - 移除数据
- (void)removeData {
    self.arr=[NSArray new];
    self.dict=[NSDictionary new];
}
#pragma mark - 创建模型文件成功，打开模型文件
- (IBAction)openModelFileBtn:(NSButton *)sender {
    if([self.resultsBnt.title isEqualToString:@"生成成功,打开文件夹"]){
        system([[@"open " stringByAppendingString:self.savePathTF.stringValue] UTF8String]);
    }
}
#pragma mark - 检查违规字符
- (BOOL)exsistStr:(NSString *)str InURL:(NSString *)url {
    if([url rangeOfString:str].location!=NSNotFound)
        return YES;
    else return NO;
}

#pragma mark - 将数据源字符串转成字典或者数组对象
- (id)jsonToObject:(NSString *)json{
    //string转data
    NSData * jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    //json解析
    id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return obj;
}

#pragma mark - 发起请求
- (void)requstDataWithUrlPath {
    [self removeData];//清空上一次请求的数据
    
    NSLog(@"self.dataSourceTextV.string === %@",self.dataSourceTextV.string);
    
    id responseObject = [self jsonToObject:self.dataSourceTextV.string];
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        self.dict = responseObject;
        if (self.dict == nil) {
            [self.resultsBnt setTitle:@"请求的网路数据有误"];
            return ;
        }
    }else if ([responseObject isKindOfClass:[NSArray class]]) {
        self.arr = responseObject;
        if (self.arr == nil) {
            [self.resultsBnt setTitle:@"请求的网路数据有误"];
            return ;
        }
    }
    
    [self requstSuccees];
    
}

#pragma mark - 后端返回的数据成功
- (void)requstSuccees {
    if (_dict != nil) {
        //删除原先的文件夹
        [self deleteOldDirectory];
        //分析数据结构创建模型文件
        [CreatPropert creatProperty:self.dict fileName:self.modelNameTF.stringValue WithContext:@"" savePath:self.savePathTF.stringValue withNSNULL:self.nullToStrBtn.state withNSDATE:self.dateToStrBtn.state withNSNUMBER:self.numToStrBtn.state withGiveData:[self returnNSInteger] withModelName:self.modelNameTF.stringValue];
        [self.resultsBnt setTitle:@"生成成功,打开文件夹"];
        [self JsonToPlistWithFilePath:self.filePath withDataJsonStr:self.dataSourceTextV.string];
    }else if (_arr != nil) {
        //删除原先的文件夹
        [self deleteOldDirectory];
        //分析数据结构创建模型文件
        [CreatPropert creatProperty:self.arr fileName:self.modelNameTF.stringValue WithContext:@"" savePath:self.savePathTF.stringValue withNSNULL:self.nullToStrBtn.state withNSDATE:self.dateToStrBtn.state withNSNUMBER:self.numToStrBtn.state withGiveData:[self returnNSInteger] withModelName:self.modelNameTF.stringValue];
        [self.resultsBnt setTitle:@"生成成功,打开文件夹"];
        [self JsonToPlistWithFilePath:self.filePath withDataJsonStr:self.dataSourceTextV.string];
    }else [self.resultsBnt setTitle:@"生成失败"];
}

#pragma mark - 删除原先的文件夹
- (void)deleteOldDirectory {
    //删除原先的文件夹
    BOOL yes=YES;
    if([[NSFileManager defaultManager]fileExistsAtPath:self.savePathTF.stringValue isDirectory:&yes]){
        [[NSFileManager defaultManager]removeItemAtPath:self.savePathTF.stringValue error:nil];
    }
}

#pragma mark - 打开生成的模型文件夹
- (void)JsonToPlistWithFilePath:(NSString *)FilepPath withDataJsonStr:(NSString *)dataJsonStr{
    
    NSFileManager *fm=[NSFileManager defaultManager];
    [fm createFileAtPath:FilepPath contents:nil attributes:nil];
    if([fm fileExistsAtPath:FilepPath] && dataJsonStr.length>0){
        
        id obj = [self jsonToObject:self.dataSourceTextV.string];

        if([obj isKindOfClass:[NSMutableArray class]]){
            NSMutableArray *arr=(NSMutableArray *)obj;
            [arr writeToFile:FilepPath atomically:YES];
        }else if([obj isKindOfClass:[NSMutableDictionary class]]){
            NSMutableDictionary *dicM=(NSMutableDictionary *)obj;
            [dicM writeToFile:FilepPath atomically:YES];
        }
        system([[@"open " stringByAppendingString:FilepPath] UTF8String]);
    }
    
}

@end
