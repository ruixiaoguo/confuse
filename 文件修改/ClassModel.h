//
//  ClassModel.h
//  文件修改
//
//  Created by 孔赵壮 on 2018/9/8.
//  Copyright © 2018年 Weijinjurong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject

@property (nonatomic, copy) NSString * longPath;
@property (nonatomic, copy) NSString * className;
@property (nonatomic, copy) NSString * fileLastPath;

@property (nonatomic, copy) NSString * nPath;
@property (nonatomic, copy) NSString * nClassName;
@property (nonatomic, copy) NSString * nFileLastPath;

/*
 *  #import "DaYuDanKuanResettingPwdVc.h"
 @interface DaYuDanKuanResettingPwdVc : DaYuDanKuanViewController
 @interface DaYuDanKuanResettingPwdVc ()
 @implementation DaYuDanKuanResettingPwdVc
 分类的判断。。。
 */
@property (nonatomic, strong) NSArray * ruleArray;

// 空格DaYuDanKuanViewController空格
@property (nonatomic, copy) NSString * rule1Str;
@property (nonatomic, copy) NSString * nRule1Str;
// 空格DaYuDanKuanViewController换行
@property (nonatomic, copy) NSString * rule2Str;
@property (nonatomic, copy) NSString * nRule2Str;
// 换行DaYuDanKuanViewController空格
@property (nonatomic, copy) NSString * rule3Str;
@property (nonatomic, copy) NSString * nRule3Str;
// 换行DaYuDanKuanViewController空格
@property (nonatomic, copy) NSString * rule4Str;
@property (nonatomic, copy) NSString * nRule4Str;
// 换行DaYuDanKuanViewController换行
@property (nonatomic, copy) NSString * rule5Str;
@property (nonatomic, copy) NSString * nRule5Str;
// [DaYuDanKuanViewController空格
@property (nonatomic, copy) NSString * rule6Str;
@property (nonatomic, copy) NSString * nRule6Str;
// [DaYuDanKuanViewController换行
@property (nonatomic, copy) NSString * rule7Str;
@property (nonatomic, copy) NSString * nRule7Str;
// 空格DaYuDanKuanViewController:
@property (nonatomic, copy) NSString * rule8Str;
@property (nonatomic, copy) NSString * nRule8Str;
// 换行DaYuDanKuanViewController:
@property (nonatomic, copy) NSString * rule9Str;
@property (nonatomic, copy) NSString * nRule9Str;
// 换行DaYuDanKuanViewController(
@property (nonatomic, copy) NSString * rule10Str;
@property (nonatomic, copy) NSString * nRule10Str;
// 空格DaYuDanKuanViewController(
@property (nonatomic, copy) NSString * rule11Str;
@property (nonatomic, copy) NSString * nRule11Str;
// 空格DaYuDanKuanViewController*
@property (nonatomic, copy) NSString * rule12Str;
@property (nonatomic, copy) NSString * nRule12Str;
// 换行DaYuDanKuanViewController*
@property (nonatomic, copy) NSString * rule13Str;
@property (nonatomic, copy) NSString * nRule13Str;
// (DaYuDanKuanViewController*
@property (nonatomic, copy) NSString * rule14Str;
@property (nonatomic, copy) NSString * nRule14Str;
// (DaYuDanKuanViewController空格
@property (nonatomic, copy) NSString * rule15Str;
@property (nonatomic, copy) NSString * nRule15Str;
// 空格DaYuDanKuanViewController<
@property (nonatomic, copy) NSString * rule16Str;
@property (nonatomic, copy) NSString * nRule16Str;
// :DaYuDanKuanViewController<
@property (nonatomic, copy) NSString * rule17Str;
@property (nonatomic, copy) NSString * nRule17Str;

// :DaYuDanKuanViewController
@property (nonatomic, copy) NSString * rule18Str;
@property (nonatomic, copy) NSString * nRule18Str;
// )DaYuDanKuanViewController*
@property (nonatomic, copy) NSString * rule19Str;
@property (nonatomic, copy) NSString * nRule19Str;
// )DaYuDanKuanViewController空格
@property (nonatomic, copy) NSString * rule20Str;
@property (nonatomic, copy) NSString * nRule20Str;

@end
