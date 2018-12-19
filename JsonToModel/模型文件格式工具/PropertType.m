//
//  PropertType.m
//  JsonToModel
//
//  Created by it on 2018/12/17.
//  Copyright © 2018年 it. All rights reserved.
//

#import "PropertType.h"

@implementation PropertType

- (NSMutableArray *)intProp {
    if (!_intProp) {
        _intProp = [NSMutableArray new];
    }
    return _intProp;
}
- (NSMutableArray *)floatProp {
    if (!_floatProp) {
        _floatProp = [NSMutableArray new];
    }
    return _floatProp;
}
- (NSMutableArray *)arrMProp {
    if (!_arrMProp) {
        _arrMProp = [NSMutableArray new];
    }
    return _arrMProp;
}
- (NSMutableArray *)arrProp {
    if (!_arrProp) {
        _arrProp = [NSMutableArray new];
    }
    return _arrProp;
}
- (NSMutableArray *)dicMProp {
    if (!_dicMProp) {
        _dicMProp = [NSMutableArray new];
    }
    return _dicMProp;
}
- (NSMutableArray *)strProp {
    if (!_strProp) {
        _strProp = [NSMutableArray new];
    }
    return _strProp;
}
- (NSMutableArray *)dataProp {
    if (!_dataProp) {
        _dataProp = [NSMutableArray new];
    }
    return _dataProp;
}
- (NSMutableArray *)dateProp {
    if (!_dateProp) {
        _dateProp = [NSMutableArray new];
    }
    return _dateProp;
}
- (NSMutableArray *)nullProp {
    if (!_nullProp) {
        _nullProp = [NSMutableArray new];
    }
    return _nullProp;
}


@end
