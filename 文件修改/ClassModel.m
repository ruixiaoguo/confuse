//
//  ClassModel.m
//  文件修改
//
//  Created by 孔赵壮 on 2018/9/8.
//  Copyright © 2018年 Weijinjurong. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel

- (NSArray *)ruleArray {

    return @[
             @{
                 @"key1":[NSString stringWithFormat:@"\"%@.h\"",self.className],
                 @"key2":[NSString stringWithFormat:@"\"%@.h\"",self.nClassName]
                 },
             @{
                 @"key1":[NSString stringWithFormat:@"\"%@.m\"",self.className],
                 @"key2":[NSString stringWithFormat:@"\"%@.m\"",self.nClassName]
                 },
             @{
                 @"key1":[NSString stringWithFormat:@"<%@.h>",self.className],
                 @"key2":[NSString stringWithFormat:@"<%@.h>",self.nClassName]
                 },
             @{
                 @"key1":[NSString stringWithFormat:@"<%@.m>",self.className],
                 @"key2":[NSString stringWithFormat:@"<%@.m>",self.nClassName]
                 },
             @{
                 @"key1":self.rule1Str,
                 @"key2":self.nRule1Str
                 },
//             @{
//                 @"key1":self.rule2Str,
//                 @"key2":self.nRule2Str
//                 },
//             @{
//                 @"key1":self.rule3Str,
//                 @"key2":self.nRule3Str
//                 },
//             @{
//                 @"key1":self.rule4Str,
//                 @"key2":self.nRule4Str
//                 },
             @{
                 @"key1":self.rule5Str,
                 @"key2":self.nRule5Str
                 },
             @{
                 @"key1":self.rule6Str,
                 @"key2":self.nRule6Str
                 },
//             @{
//                 @"key1":self.rule7Str,
//                 @"key2":self.nRule7Str
//                 },
             @{
                 @"key1":self.rule8Str,
                 @"key2":self.nRule8Str
                 },
//             @{
//                 @"key1":self.rule9Str,
//                 @"key2":self.nRule9Str
//                 },
//             @{
//                 @"key1":self.rule10Str,
//                 @"key2":self.nRule10Str
//                 },
             @{
                 @"key1":self.rule11Str,
                 @"key2":self.nRule11Str
                 },
             @{
                 @"key1":self.rule12Str,
                 @"key2":self.nRule12Str
                 },
//             @{
//                 @"key1":self.rule13Str,
//                 @"key2":self.nRule13Str
//                 },
             @{
                 @"key1":self.rule14Str,
                 @"key2":self.nRule14Str
                 },
             @{
                 @"key1":self.rule15Str,
                 @"key2":self.nRule15Str
                 },
             @{
                 @"key1":self.rule16Str,
                 @"key2":self.nRule16Str
                 },
             @{
                 @"key1":self.rule17Str,
                 @"key2":self.nRule17Str
                 },
             @{
                 @"key1":self.rule19Str,
                 @"key2":self.nRule19Str
                 },
             @{
                 @"key1":self.rule20Str,
                 @"key2":self.nRule20Str
                 }
             ];
}
// 空格DaYuDanKuanViewController空格
- (NSString *)rule1Str {

    if (_rule1Str == nil) {
        _rule1Str = [NSString stringWithFormat:@" %@ ",self.className];
    }
    return _rule1Str;
}

- (NSString *)nRule1Str {

    if (_nRule1Str == nil) {
        return [NSString stringWithFormat:@" %@ ",self.nClassName];
    }
    return _nRule1Str;
}
// 空格DaYuDanKuanViewController换行
- (NSString *)rule2Str {

    if (_rule2Str == nil) {
        return [NSString stringWithFormat:@" %@",self.className];
    }
    return _rule2Str;
}

- (NSString *)nRule2Str {

    if (_nRule2Str == nil) {
        return [NSString stringWithFormat:@" %@",self.nClassName];
    }
    return _nRule2Str;
}

// 换行DaYuDanKuanViewController空格
- (NSString *)rule3Str {

    if (_rule3Str == nil) {
        return [NSString stringWithFormat:@"%@ ",self.className];
    }
    return _rule3Str;
}

- (NSString *)nRule3Str {

    if (_nRule3Str == nil) {
        return [NSString stringWithFormat:@"%@ ",self.nClassName];
    }
    return _nRule3Str;
}

// 换行DaYuDanKuanViewController空格
- (NSString *)rule4Str {

    if (_rule4Str == nil) {
        return [NSString stringWithFormat:@"%@ ",self.className];
    }
    return _rule4Str;
}

- (NSString *)nRule4Str {

    if (_nRule4Str == nil) {
        return [NSString stringWithFormat:@"%@ ",self.nClassName];
    }
    return _nRule4Str;
}

// 换行DaYuDanKuanViewController换行
- (NSString *)rule5Str {

    if (_rule5Str == nil) {
        return [NSString stringWithFormat:@"%@;",self.className];
    }
    return _rule5Str;
}

- (NSString *)nRule5Str {

    if (_nRule5Str == nil) {
        return [NSString stringWithFormat:@"%@;",self.nClassName];
    }
    return _nRule5Str;
}

// [DaYuDanKuanViewController空格
- (NSString *)rule6Str {

    if (_rule6Str == nil) {
        return [NSString stringWithFormat:@"[%@ ",self.className];
    }
    return _rule6Str;
}

- (NSString *)nRule6Str {

    if (_nRule6Str == nil) {
        return [NSString stringWithFormat:@"[%@ ",self.nClassName];
    }
    return _nRule6Str;
}

// [DaYuDanKuanViewController换行
- (NSString *)rule7Str {

    if (_rule7Str == nil) {
        return [NSString stringWithFormat:@"[%@",self.className];
    }
    return _rule7Str;
}

- (NSString *)nRule7Str {

    if (_nRule7Str == nil) {
        return [NSString stringWithFormat:@"[%@",self.nClassName];
    }
    return _nRule7Str;
}

// 空格DaYuDanKuanViewController:
- (NSString *)rule8Str {

    if (_rule8Str == nil) {
        return [NSString stringWithFormat:@" %@:",self.className];
    }
    return _rule8Str;
}

- (NSString *)nRule8Str {

    if (_nRule8Str == nil) {
        return [NSString stringWithFormat:@" %@:",self.nClassName];
    }
    return _nRule8Str;
}

// 换行DaYuDanKuanViewController:
- (NSString *)rule9Str {

    if (_rule9Str == nil) {
        return [NSString stringWithFormat:@"%@:",self.className];
    }
    return _rule9Str;
}

- (NSString *)nRule9Str {

    if (_nRule9Str == nil) {
        return [NSString stringWithFormat:@"%@:",self.nClassName];
    }
    return _nRule9Str;
}

// 换行DaYuDanKuanViewController(
- (NSString *)rule10Str {

    if (_rule10Str == nil) {
        return [NSString stringWithFormat:@"%@(",self.className];
    }
    return _rule10Str;
}

- (NSString *)nRule10Str {

    if (_nRule10Str == nil) {
        return [NSString stringWithFormat:@"%@(",self.nClassName];
    }
    return _nRule10Str;
}

// 空格DaYuDanKuanViewController(
- (NSString *)rule11Str {

    if (_rule11Str == nil) {
        return [NSString stringWithFormat:@" %@(",self.className];
    }
    return _rule11Str;
}

- (NSString *)nRule11Str {

    if (_nRule11Str == nil) {
        return [NSString stringWithFormat:@" %@(",self.nClassName];
    }
    return _nRule11Str;
}

// 空格DaYuDanKuanViewController*
- (NSString *)rule12Str {

    if (_rule12Str == nil) {
        return [NSString stringWithFormat:@" %@*",self.className];
    }
    return _rule12Str;
}

- (NSString *)nRule12Str {

    if (_nRule12Str == nil) {
        return [NSString stringWithFormat:@" %@*",self.nClassName];
    }
    return _nRule12Str;
}

 //换行DaYuDanKuanViewController*
- (NSString *)rule13Str {

    if (_rule13Str == nil) {
        return [NSString stringWithFormat:@"%@*",self.className];
    }
    return _rule13Str;
}

- (NSString *)nRule13Str {

    if (_nRule13Str == nil) {
        return [NSString stringWithFormat:@"%@*",self.nClassName];
    }
    return _nRule13Str;
}

// (DaYuDanKuanViewController*
- (NSString *)rule14Str {

    if (_rule14Str == nil) {
        return [NSString stringWithFormat:@"(%@*",self.className];
    }
    return _rule14Str;
}

- (NSString *)nRule14Str {

    if (_nRule14Str == nil) {
        return [NSString stringWithFormat:@"(%@*",self.nClassName];
    }
    return _nRule14Str;
}
// (DaYuDanKuanViewController空格

- (NSString *)rule15Str {

    if (_rule15Str == nil) {
        return [NSString stringWithFormat:@"(%@ ",self.className];
    }
    return _rule15Str;
}

- (NSString *)nRule15Str {

    if (_nRule15Str == nil) {
        return [NSString stringWithFormat:@"(%@ ",self.nClassName];
    }
    return _nRule15Str;
}

// 空格DaYuDanKuanViewController<
- (NSString *)rule16Str {
    
    if (_rule16Str == nil) {
        return [NSString stringWithFormat:@" %@<",self.className];
    }
    return _rule16Str;
}

- (NSString *)nRule16Str {
    
    if (_nRule16Str == nil) {
        return [NSString stringWithFormat:@" %@<",self.nClassName];
    }
    return _nRule16Str;
}

// :DaYuDanKuanViewController<
- (NSString *)rule17Str {
    
    if (_rule17Str == nil) {
        return [NSString stringWithFormat:@":%@<",self.className];
    }
    return _rule17Str;
}

- (NSString *)nRule17Str {
    
    if (_nRule17Str == nil) {
        return [NSString stringWithFormat:@":%@<",self.nClassName];
    }
    return _nRule17Str;
}
// :DaYuDanKuanViewController
- (NSString *)rule18Str {
    
    if (_rule18Str == nil) {
        return [NSString stringWithFormat:@":%@",self.className];
    }
    return _rule18Str;
}

- (NSString *)nRule18Str {
    
    if (_nRule18Str == nil) {
        return [NSString stringWithFormat:@":%@",self.nClassName];
    }
    return _nRule18Str;
}
// )DaYuDanKuanViewController*
- (NSString *)rule19Str {
    
    if (_rule19Str == nil) {
        return [NSString stringWithFormat:@")%@*",self.className];
    }
    return _rule19Str;
}

- (NSString *)nRule19Str {
    
    if (_nRule19Str == nil) {
        return [NSString stringWithFormat:@")%@*",self.nClassName];
    }
    return _nRule19Str;
}

// )DaYuDanKuanViewController空格
- (NSString *)rule20Str {
    
    if (_rule20Str == nil) {
        return [NSString stringWithFormat:@")%@ ",self.className];
    }
    return _rule20Str;
}

- (NSString *)nRule20Str {
    
    if (_nRule20Str == nil) {
        return [NSString stringWithFormat:@")%@ ",self.nClassName];
    }
    return _nRule20Str;
}
@end
