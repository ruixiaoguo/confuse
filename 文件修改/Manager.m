
//
//  Manager.m
//  文件修改
//
//  Created by 孔赵壮 on 2018/9/6.
//  Copyright © 2018年 Weijinjurong. All rights reserved.
//

#import "Manager.h"

@interface Manager ()

    ///头部内容
@property (nonatomic, strong) NSMutableString * headString ;
///中间的内容
@property (nonatomic, strong)  NSMutableArray * middleArray ;
@property (nonatomic, strong)    __block NSMutableString * middleTempString ;

@property (nonatomic, assign)     __block BOOL isCodeStart;
//一个代码块里面的方法{ }的数量

@property (nonatomic, assign)      __block int  leftNumber;

@property (nonatomic, assign)     __block BOOL isHasStartZhushi ;

//最后代码的开始

@property (nonatomic, assign)     __block BOOL isEndStart ;

//中间代码的开始

@property (nonatomic, assign)     __block BOOL isMiddleStart;

//记录文本的开头的结束,为了删除开头的注释。

@property (nonatomic, assign)     __block BOOL fileStart ;


@property (nonatomic, assign)     __block int rightNumber;
///尾部的内容

@property (nonatomic, strong)     NSMutableString * endString ;

//@property (nonatomic, strong) NSMutableSet * set = [NSMutableSet set];

@property (nonatomic, strong) NSDictionary * methodDic;
@property (nonatomic, assign) NSInteger lineMaxNumber;

@property (nonatomic, assign) NSInteger spaceMaxNumber;

@property (nonatomic, assign) NSInteger minMethodNumberPerFile;

@property (nonatomic, assign) NSInteger maxMethodNumberPerFile;



@property (nonatomic, strong) NSMutableArray * headImportArr;
@property (nonatomic, strong) NSMutableArray * protoryArr;
///是否是interface开始了
@property (nonatomic, assign) BOOL isInterfaceStart;
@property (nonatomic, copy) NSString * interFString;
@property (nonatomic, copy) NSString * implementStr;

//{这种属性}
@property (nonatomic, assign) BOOL isOtherProperyStart;
@property (nonatomic, strong) NSMutableString * otherPropertyString;

//delegate
@property (nonatomic, assign) BOOL isDelegateStart;
@property (nonatomic, strong) NSMutableString * deletaString;


//是否是implement开始了
@property (nonatomic, assign) BOOL isImplementStart;
///忽略的文件
@property (nonatomic, strong) NSArray * ignoreArray;
@property (nonatomic, strong) NSMutableString * otherParamString;

@end

@implementation Manager

- (void)startConfusePath:(NSString *)path methodDic:(NSDictionary *)dic minMethodNumberPerFile:(NSInteger)minMethodNumber maxMethodNumberPerFile:(NSInteger)maxMethodNumber spaceMaxNumber:(NSInteger)spaceMaxNumber lineMaxNumber:(NSInteger)lineMaxNumber ignoreClassArr:(NSArray *)arr {

    self.methodDic = dic;

    self.ignoreArray = arr;
    ///如果数量超了，默认为整个数组的方法都要出现一遍
    self.minMethodNumberPerFile = minMethodNumber;
    self.maxMethodNumberPerFile = maxMethodNumber;
    
    self.lineMaxNumber = lineMaxNumber;
    self.spaceMaxNumber = spaceMaxNumber;

    [self filePathInDirectory:path];
}

- (void)filePathInDirectory:(NSString *)directory {

    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isDirec1;
    [fileManager fileExistsAtPath:directory isDirectory:&isDirec1];
    if (!isDirec1) {

        if (![directory hasSuffix:@".m"]) {
            return;
        }
        BOOL isIgnore = NO;
        for (NSString * ignoreStr in self.ignoreArray) {
            if ([directory hasSuffix:ignoreStr]) {
                isIgnore = YES;
                break;
            }
        }
        if (!isIgnore) {
            [self startDealWith:directory];
        }
        return;
    }
    NSArray * arr = [fileManager contentsOfDirectoryAtPath:directory error:nil];
    for (int i = 0; i < arr.count; i++) {
        BOOL isDirec = NO;
        BOOL isExit = [fileManager fileExistsAtPath:[directory stringByAppendingPathComponent:arr[i]] isDirectory:&isDirec];
        if (isExit && isDirec) {
            [self filePathInDirectory:[directory stringByAppendingPathComponent:arr[i]]];
        }else{
            NSString * fileStr = [directory stringByAppendingPathComponent:arr[i]];
            if (![fileStr hasSuffix:@".m"]) {
                continue;
            }
            BOOL isIgnore = NO;
            for (NSString * ignoreStr in self.ignoreArray) {
                if ([fileStr hasSuffix: ignoreStr]) {
                    isIgnore = YES;
                    break;
                }
            }
            if (!isIgnore) {
                [self startDealWith:fileStr];
            }
        }
    }
}

- (void)startDealWith:(NSString *)fileStr {

    NSString * content = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:fileStr] encoding:NSUTF8StringEncoding error:nil];
    ////先把文件分为 头  中间   尾
    ///然后将中间的代码 块  装到数组中   然后对每个数组进行加空行空格  然后随机安排位置  然后将三块组合，
    ///写进文件。。。
    ///初始化一下数据
    [self setupdata];
    __weak typeof(self)weakSelf = self;
    NSArray * tempArr = [content componentsSeparatedByString:@"@implementation"];
    if (tempArr.count > 2 || tempArr.count <= 1) {
        return;
    }
    [content enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        [weakSelf dealWithString:line];
    }];

    //这里也可以调整一下头文件，属性的位置。
    NSMutableString * finalStr = [NSMutableString string];
    ///先拼接头文件
    NSInteger impLength = self.headImportArr.count;
    for (int i = 0; i < impLength; i++) {
        int index = arc4random()%self.headImportArr.count;
        [finalStr appendFormat:@"%@\n",self.headImportArr[index]];
        [self.headImportArr removeObjectAtIndex:index];
    }
    ///在拼接头文件和类之间的属性
    [finalStr appendFormat:@"%@\n",self.otherParamString];
    ///inter
    [finalStr appendFormat:@"%@\n",self.interFString];
    ///拼接delegate
    NSArray * deleArr = [self.deletaString componentsSeparatedByString:@","];

    if (self.deletaString.length != 0 && deleArr.count > 1) {
        NSMutableArray * delegateMArr = [NSMutableArray array];
        for (int i = 0; i < deleArr.count; i++) {
            if (i > 0 && i < deleArr.count - 1) {
                [delegateMArr addObject:deleArr[i]];
            }
        }
        [finalStr appendFormat:@"%@,\n",deleArr.firstObject];
        NSInteger deleLengt = delegateMArr.count ;
        for (int i = 0; i < deleLengt; i++) {
            int index = arc4random()%delegateMArr.count;
            int lineR = arc4random()%self.lineMaxNumber;
            for (int j = 0; j < lineR; j++) {
                [finalStr appendString:@"\n"];
            }
            [finalStr appendFormat:@"%@,\n",delegateMArr[index]];
            [delegateMArr removeObjectAtIndex:index];
        }

        [finalStr appendFormat:@"%@\n",deleArr.lastObject];
    }else if (deleArr.count == 1 && self.deletaString.length > 0){
        [finalStr appendFormat:@"%@\n",self.deletaString];
    }

    ///在拼接属性
    NSInteger proLength = self.protoryArr.count;
    for (int i = 0; i < proLength; i++) {
        int index = arc4random()%self.protoryArr.count;
        [finalStr appendFormat:@"%@\n",self.protoryArr[index]];
        [self.protoryArr removeObjectAtIndex:index];
    }
    ///拼接{}属性
    [finalStr appendFormat:@"%@\n",self.otherPropertyString];
    ///最后拼接的
    [finalStr appendFormat:@"%@\n",self.headString];

    ///先取出重复的方法。
    NSMutableArray * tempMethodArr = [NSMutableArray array];
    for (NSString * key in self.methodDic) {
        if (![content containsString:key]) {
            [tempMethodArr addObject:self.methodDic[key]];
        }
    }
    NSMutableArray * finalRandomArr = [NSMutableArray array];

    if (self.minMethodNumberPerFile < self.maxMethodNumberPerFile) {
        NSInteger number = arc4random()%(self.maxMethodNumberPerFile - self.minMethodNumberPerFile + 1 ) + self.minMethodNumberPerFile ;

        ///再随机取出若干个方法
        if (number < tempMethodArr.count ) {
            for (int i = 0; i < number; i++) {
                [finalRandomArr addObject:tempMethodArr[i]];
            }
        }else{
            finalRandomArr = tempMethodArr;
        }
        ////把方法加进来
        [self.middleArray addObjectsFromArray:finalRandomArr];
    }

    NSInteger length = self.middleArray.count;
    ///随机调整代码快的位置
    for (int i = 0; i < length; i++) {
        int index = arc4random()%self.middleArray.count;
        [finalStr appendFormat:@"%@\n",self.middleArray[index] ];
        [self.middleArray removeObjectAtIndex:index];

    }
    [finalStr appendFormat:@"%@\n",self.endString ];
    //        NSLog(@"%@",finalStr);
    [finalStr writeToFile:fileStr atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)dealWithString:(NSString *)line {

//                NSLog(@"*%@*",line);
    line =  getNoSpaceString(line);
//                NSLog(@"*%@*",line);
    if (line.length == 0) {
        return;
    }else{
        ///如果是正文了
        if (self.fileStart) {
            //中间
            if (self.isMiddleStart) {
                [self dealWithCode:line];
                //最后面的开始
            }else if (self.isEndStart){
                [self dealWithEnd:line];
                //头部
            }else{
                [self dealWithStart:line];
            }
        }else{
            ///判断是不是注释
            if ([line hasPrefix:@"//"]) {
            }else{
                self.fileStart = YES;
                [self dealWithStart:line];
//                [self.headString appendFormat:@"%@\n",line];
            }
        }
    }

}

///处理中间的代码
- (void)dealWithCode:(NSString *)line {

    //先判断注释
    if ([self codeString:line shouldDeal:NO] == nil) {

    //后进行代码的判断
    }else{
        //判断代码段是否开始了还没有结束
        if (self.isCodeStart) {
        }else{
            //重置字符
            self.middleTempString = [NSMutableString string];
            //代码的开始
            if ([line hasPrefix:@"-"] || [line hasPrefix:@"+"]) {
#warning 这里应该判断是否在一行内就结束了
                self.isCodeStart = YES;
            }
        }

        ///计算{}的数量，
        if ([line containsString:@"{"] || [line containsString:@"}"]) {
            NSString * codeStr = [self codeString:line shouldDeal:YES];
            ///如果有代码的话
            if (codeStr != nil) {
                //计算{的数量
                //计算}的苏亮
                int lef = (int)[[line componentsSeparatedByString:@"{"] count];
                int rig = (int)[[line componentsSeparatedByString:@"}"] count];
//                NSLog(@"%d",rig);
                self.leftNumber += lef - 1;
                self.rightNumber += rig - 1;
            }
        }
        //判断{}数量是否相等了，相等的花代表一个代码块要结束了，为0的花代表没有进入代码块
        if (self.leftNumber == 0) {

        }else{
            if (self.leftNumber == self.rightNumber) {
                self.isCodeStart = NO;
                self.leftNumber = 0;
                self.rightNumber = 0;
                [self.middleArray addObject:self.middleTempString];
//                NSLog(@"%@\n",self.middleTempString);
            }
        }
    }

    ///判断是不是一个类的结束了，再判断文件里面还有没有其他的类。
    if ([line containsString:@"@end"]) {
        self.isEndStart = YES;
        [self.endString appendString:line];
    }else{
        [self pendCodeWithRandomSpaceLine:line];
    }
}

//并在代码块中添加空行什么的
- (void)pendCodeWithRandomSpaceLine:(NSString *)str {

    if (self.spaceMaxNumber == 0) {
        self.spaceMaxNumber = 10;
    }
    if (self.lineMaxNumber == 0) {
        self.lineMaxNumber = 10;
    }
    int spaceR = arc4random()%self.spaceMaxNumber;
    int lineR = arc4random()%self.lineMaxNumber;
    for (int i = 0; i < spaceR; i++) {
        [self.middleTempString appendString:@" "];
    }
    [self.middleTempString appendFormat:@"%@\n",str];
    for (int i = 0; i < lineR; i++) {
        [self.middleTempString appendString:@"\n"];
    }
}

///拼接@implementation 字符
- (void)apendImportString:(NSString *)line {

    self.isMiddleStart = YES;
    self.isImplementStart = NO;
    [self.headString appendFormat:@"%@\n",line];
}

///处理开头的代码
- (void)dealWithStart:(NSString *)line {


#warning 这里可能会 因为一行里面有太多不同规范的东西造成问题。。。。
    if ([line hasPrefix:@"@implementation"]) {
        [self apendImportString:line];
    }else if (self.isImplementStart){
        //拼接@end 和@implement之间的代码。
        [self.headString appendFormat:@"%@\n",line ];
    }else if ([line hasPrefix:@"@interface"]) {
        self.isInterfaceStart = YES;
        if ([line containsString:@"<"]) {
            NSRange start = [line rangeOfString:@"<"];
            if ([line containsString:@">"]) {
                NSRange end = [line rangeOfString:@">"];
                self.deletaString = [NSMutableString stringWithString: [line substringWithRange:NSMakeRange(start.location, end.location + end.length - start.location)]];
                NSLog(@"%@",self.deletaString);
            }else{
                self.isDelegateStart = YES;
                [self.deletaString appendFormat:@"%@\n", [line substringWithRange:NSMakeRange(start.location, line.length - start.location)]];
            }
            self.interFString = [line substringToIndex:start.location];
        }else{
            self.interFString = line;
        }
    }else if(self.isInterfaceStart) {
        NSString * codeStr = [self codeString:line shouldDeal:YES];
        if ([codeStr hasPrefix:@"@end"]) {
            self.isInterfaceStart = NO;
            self.isImplementStart = YES;
            [self.headString appendFormat:@"%@\n",codeStr];
        }else{
            if (codeStr.length > 0) {
                if (self.protoryArr == nil) {
                    self.protoryArr = [NSMutableArray array];
                }
                ///如果是{}的属性开始了
                if (self.isOtherProperyStart) {
                    if ([codeStr containsString:@"}"]) {
                        self.isOtherProperyStart = NO;
                    }else{
                    }
                    [self.otherPropertyString appendFormat:@"%@\n",codeStr];
                    ///如果是delegate的属性开始了。
                }else if (self.isDelegateStart){
                    if ([codeStr containsString:@">"]) {
                        NSRange end = [codeStr rangeOfString:@">"];
                        [self.deletaString appendFormat:@"%@\n", [codeStr substringWithRange:NSMakeRange(0, end.location + 1)]];
                        NSLog(@"%@",self.deletaString);
                        self.isDelegateStart = NO;
                    }else{
                        [self.deletaString appendFormat:@"%@\n",codeStr];
                    }
                }else{
                    //拼接属性
                    if ([codeStr hasPrefix:@"@property"]) {
                        int spaceR = arc4random()%self.spaceMaxNumber;
                        int lineR = arc4random()%self.lineMaxNumber;
                        NSMutableString * string = [NSMutableString string];
                        for (int i = 0; i < spaceR; i++) {
                            [string appendString:@" "];
                        }
                        [string appendFormat:@"%@\n",codeStr];
                        for (int i = 0; i < lineR; i++) {
                            [string appendString:@"\n"];
                        }
                        [self.protoryArr addObject:string];
                    }else  if ([codeStr containsString:@"{"]) {
                        self.isOtherProperyStart = YES;
                        [self.otherPropertyString appendFormat:@"%@\n",codeStr];
                    }else if ([codeStr containsString:@"<"]){
                        if ([codeStr containsString:@">"]) {
                            NSRange start = [codeStr rangeOfString:@"<"];
                            NSRange end = [codeStr rangeOfString:@">"];
                            self.deletaString = [NSMutableString stringWithString: [codeStr substringWithRange:NSMakeRange(start.location, end.location + end.length - start.location)]];
                            NSLog(@"%@",self.deletaString);
                        }else{
                            self.isDelegateStart = YES;
                            NSRange start = [codeStr rangeOfString:@"<"];
                            [self.deletaString appendFormat:@"%@\n", [codeStr substringWithRange:NSMakeRange(start.location, codeStr.length - start.location)]];
                            NSLog(@"%@",self.deletaString);
                        }
                    }
                }
            }
        }
    }else  if ([line hasPrefix:@"#import"] || [line hasPrefix:@"#include"]) {
        if (self.headImportArr == nil) {
            self.headImportArr = [NSMutableArray array];
        }
        int spaceR = arc4random()%self.spaceMaxNumber;
        int lineR = arc4random()%self.lineMaxNumber;
        NSMutableString * string = [NSMutableString string];
        for (int i = 0; i < spaceR; i++) {
            [string appendString:@" "];
        }
        [string appendFormat:@"%@\n",line];
        for (int i = 0; i < lineR; i++) {
            [string appendString:@"\n"];
        }
        [self.headImportArr addObject:string];
    }else{
        [self.otherParamString appendFormat:@"%@\n",line];
    }
}

///处理尾部的代码
- (void)dealWithEnd:(NSString *)line {

    ///判断是不是注释
    if ([line hasPrefix:@"//"]) {

    }else{
        self.fileStart = YES;
//        [self.headString appendFormat:@"%@\n",line];
        [self dealWithStart:line];
    }
}

//如果是nil的说明这一行不是代码，是注释。。
- (NSString *)codeString:(NSString *)str shouldDeal:(BOOL)shouDealwith{

    if (self.isHasStartZhushi) {
        if ([str containsString:@"*/"]) {
            self.isHasStartZhushi = NO;
            if ([str hasSuffix:@"*/"]) {
                return nil;
            }else{
                //返回注释后面的文字
                return [str substringFromIndex:[str rangeOfString:@"*/"].location + 2];
            }
        }else{
            return nil;
        }
    }else{
        if ([str hasPrefix:@"//"]) {
            return nil;
        }else if ([str hasPrefix:@"/*"]){
            if ([str containsString:@"*/"]) {
                //返回注释后面的文字
                return [str substringFromIndex:[str rangeOfString:@"*/"].location + 2];
            }else{
                self.isHasStartZhushi = YES;
                return nil;
            }
        }else if ([str containsString:@"/*"]){
            if ([str containsString:@"*/"]) {

            }else{
                if (shouDealwith) {
                    self.isHasStartZhushi = YES;
                }
            }
            return str;
        }
    }
    return str;
}

//获取去掉头部空格的字符串
NSString * getNoSpaceString(NSString * str){

    if (str.length == 0 ) {
        return str;
    }
    if (str == nil) {
        return @"";
    }
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return str;
}

- (void)setupdata {

    self.headString = [NSMutableString string];
    self.middleArray = [NSMutableArray array];
    self.middleTempString = [NSMutableString string];
    self.isCodeStart = NO;
    self.leftNumber = 0;
    self.rightNumber = 0;
    self.fileStart = NO;
    self.isMiddleStart = NO;
    self.isEndStart = NO;
    self.endString = [NSMutableString string];
    self.isHasStartZhushi = NO;
    self.headString = [NSMutableString string];
    self.headImportArr = nil;
    self.deletaString = [NSMutableString string];
    self.isDelegateStart = NO;
    self.protoryArr = nil;
    self.otherParamString = [NSMutableString string];
    ///是否是interface开始了
    self.isInterfaceStart = NO;
    self.interFString = [NSMutableString string];
    self.isOtherProperyStart = NO;
    self.otherPropertyString = [NSMutableString string];;
}

@end
