//
//  HeaderConfuseManager.m
//  文件修改
//
//  Created by 孔赵壮 on 2018/9/10.
//  Copyright © 2018年 Weijinjurong. All rights reserved.
//

#import "HeaderConfuseManager.h"

@interface HeaderConfuseManager ()

//路径。
@property (nonatomic, copy) NSString * path;
//是否是开始拼接了
@property (nonatomic, assign) BOOL isStartAppend;
//协议是否开始了
@property (nonatomic, assign) BOOL isStartProtocol;

@property (nonatomic, assign) BOOL isStartInterface;
//是否是注释。
@property (nonatomic, assign) BOOL isZhuShi;




@property (nonatomic, strong) NSMutableArray * headerArray;
@property (nonatomic, strong) NSMutableArray * protocolArray;
@property (nonatomic, strong) NSMutableArray * interfaceArray;

@property (nonatomic, assign) NSInteger spaceMaxNumber;
@property (nonatomic, assign) NSInteger lineMaxNumber;

@property (nonatomic, strong) NSMutableString * betweenHeaderProtocolString;
@property (nonatomic, strong) NSMutableString * betweenHeaderInterfaceString;

@property (nonatomic, assign) BOOL isBetweenHeaderProtocol;


@property (nonatomic, assign) BOOL isComplete;
@property (nonatomic, copy) NSString * completeString;

@property (nonatomic, strong) NSArray * ignoreArr;

@end



@implementation HeaderConfuseManager

- (void)startConfuseHeaderIndexPath:(NSString *)path spaceMaxNumber:(NSInteger)spaceMaxNumber lineMaxNumber:(NSInteger)lineMaxNumber ignoreClassArr:(NSArray *)ignoreArr {

    self.spaceMaxNumber = spaceMaxNumber;
    self.lineMaxNumber = lineMaxNumber;
    self.ignoreArr = ignoreArr;
    [self getAllFile:path];
}

- (void)getAllFile:(NSString *)path {

    NSLog(@"开始....");
    NSFileManager * fileManager = [NSFileManager defaultManager];
    BOOL isExit = NO;
    BOOL isDirectory = NO;
    isExit = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
    //如果存在的话
    if (isExit) {
        //如果是文件夹的话
        if (isDirectory) {
            NSArray * subArr = [fileManager contentsOfDirectoryAtPath:path error:nil];
            for (NSString * subPath in subArr) {
                NSString * filePath = [path stringByAppendingPathComponent:subPath];
                [self getAllFile:filePath];
            }
        }else{
            if ([path.pathExtension isEqualToString:@"h"]) {
                BOOL isIgnore = NO;
                for (NSString * className in self.ignoreArr) {
                    if ([className isEqualToString:path.lastPathComponent.stringByDeletingPathExtension]) {
                        isIgnore = YES;
                        break;
                    }
                }
                if (!isIgnore) {
                    [self startConfuseFileInPath:path];
                }
            }
        }
    }
    NSLog(@"结束");
}


- (void)startConfuseFileInPath:(NSString *)path {

    self.interfaceArray = [NSMutableArray array];
    self.protocolArray = [NSMutableArray array];
    self.headerArray = [NSMutableArray array];
    self.isStartAppend = NO;
    self.isStartProtocol = NO;
    self.isStartInterface = NO;
    self.betweenHeaderProtocolString = [NSMutableString string];
    self.betweenHeaderInterfaceString = [NSMutableString string];
    self.isBetweenHeaderProtocol = NO;
    self.isComplete = NO;
    self.completeString = @"";

    NSString * content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //如果有interface再进行性处理。
    if ([content containsString:@"@interface"]) {
        typeof(self)weakSelf = self;
        [content enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
            [weakSelf confuseFileInString:line];
        }];

        //拼接
        NSMutableString * finalString = [NSMutableString string];
        //头文件
        if (self.headerArray.count > 0) {
            NSInteger headLength = self.headerArray.count;
            for (int i = 0; i < headLength; i++) {
                NSInteger number = arc4random()%(self.lineMaxNumber+1);
                NSInteger index = arc4random()%self.headerArray.count;
                for (int j = 0; j < number; j++) {
                    [finalString appendString:@"\n"];
                }
                [finalString appendFormat:@"%@\n",self.headerArray[index]];
                [self.headerArray removeObjectAtIndex:index];
            }
        }
        [finalString appendString:self.betweenHeaderProtocolString];
        //协议
        if (self.protocolArray.count > 0) {
            [finalString appendFormat:@"%@\n",self.protocolArray.firstObject];
            [self.protocolArray removeObjectAtIndex:0];
            NSInteger protocolLength = self.protocolArray.count - 1;
            for (int i = 0; i < protocolLength; i++) {
                NSInteger number = arc4random()%(self.lineMaxNumber + 1);
                NSInteger index = arc4random()%(self.protocolArray.count-1) ;
                for (int j = 0; j < number; j++) {
                    [finalString appendString:@"\n"];
                }
                [finalString appendFormat:@"%@\n",self.protocolArray[index]];
                [self.protocolArray removeObjectAtIndex:index];
            }
            [finalString appendFormat:@"%@\n",self.protocolArray.lastObject];
        }
        [finalString appendString:self.betweenHeaderInterfaceString];
        //interface
        if (self.interfaceArray.count > 0) {
            [finalString appendFormat:@"%@\n",self.interfaceArray.firstObject];
            [self.interfaceArray removeObjectAtIndex:0];
            NSInteger interLength = self.interfaceArray.count - 1;
            for (int i = 0; i < interLength; i++) {
                NSInteger number = arc4random()%(self.lineMaxNumber + 1);
                NSInteger index = arc4random()%(self.interfaceArray.count-1);
                for (int j = 0; j < number; j++) {
                    [finalString appendString:@"\n"];
                }
                [finalString appendFormat:@"%@\n",self.interfaceArray[index]];
                [self.interfaceArray removeObjectAtIndex:index];
            }
            [finalString appendFormat:@"%@\n",self.interfaceArray.lastObject];
        }
        //重新写入
        [finalString writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
}

- (void)confuseFileInString:(NSString *)string {

    //先将头尾的空格换行去掉。
    string = [self deleteSpaceInString:string];
//    NSLog(@"-----%@",string);
    //把头部的数据删除掉
    if (self.isStartAppend) {
        NSString * newStr = [NSString stringWithString:string];
        string = [self codeString:string shouldDeal:YES];
        if (string == nil) {
            if (self.isStartInterface) {
                self.completeString = [NSString stringWithFormat:@"%@\n%@",self.completeString,newStr];
            }
        }else{
           
            //截取头文件,并将头文件装起来。
            if ([string hasPrefix:@"#import"] || [string hasPrefix:@"#include"]) {
                [self getHeaderFilesInString:string];
            }
            //处理协议
            else if ([string hasPrefix:@"@protocol"]){
                self.isStartProtocol = YES;
                [self getProtocolInString:string];
            }
            else if (self.isStartProtocol){
                //这里没有考虑@end前面还有代码的情况
                if ([string hasPrefix:@"@end"]) {
                    self.isStartProtocol = NO;
                    self.isBetweenHeaderProtocol = YES;
                }
                [self getProtocolInString:string];
            }
            //处理interface
            else if ([string hasPrefix:@"@interface"]){
                self.isStartInterface = YES;
                [self getInter:string];
            }
            else if (self.isStartInterface){
                //这里没有考虑@end前面还有代码的情况
                if ([string hasPrefix:@"@end"]) {
                    self.isStartInterface = NO;
                    [self getInter:string];
                }else{
                    [self getInterfaceInString:string];
                }
            }else{
                if (self.isBetweenHeaderProtocol) {
                    [self.betweenHeaderInterfaceString appendFormat:@"%@\n",string];
                }else{
                    [self.betweenHeaderProtocolString appendFormat:@"%@\n",string];
                }
            }
        }
    }else{
        //如果是系统的注释直接越过
        if (![string hasPrefix:@"//"]) {
            self.isStartAppend = YES;
            //开始了
            [self confuseFileInString:string];
        }
    }
//    NSLog(@"=======%@",string);
}

/**
 *处理头文件
 */
- (void)getHeaderFilesInString:(NSString *)string {

    NSInteger number = arc4random()%(self.spaceMaxNumber+1);
    for (int i = 0; i < number; i++) {
        string = [NSString stringWithFormat:@" %@",string];
    }
    [self.headerArray addObject:string];
}

/**
 *处理协议
 */
- (void)getProtocolInString:(NSString *)string {

    NSInteger number = arc4random()%(self.spaceMaxNumber+1);
    for (int i = 0; i < number; i++) {
        string = [NSString stringWithFormat:@" %@",string];
    }
    [self.protocolArray addObject:string];
}

/**
 *处理属性和方法。
 */
- (void)getInterfaceInString:(NSString *)string {

    NSInteger number = arc4random()%(self.spaceMaxNumber+1);
    for (int i = 0; i < number; i++) {
        string = [NSString stringWithFormat:@" %@",string];
    }
    //这里应该处理一下方法和属性有换行的问题。。。
    if ([string hasSuffix:@";"]) {
        self.completeString = [NSString stringWithFormat:@"%@\n%@",self.completeString,string];
        self.isComplete = YES;
    }else{
        self.completeString = [NSString stringWithFormat:@"%@\n%@",self.completeString,string];
        self.isComplete = NO;
    }

    if (self.isComplete) {
        [self.interfaceArray addObject:self.completeString];
        self.completeString = @"";
    }
}

- (void)getInter:(NSString *)string {

    NSInteger number = arc4random()%(self.spaceMaxNumber+1);
    for (int i = 0; i < number; i++) {
        string = [NSString stringWithFormat:@" %@",string];
    }
    [self.interfaceArray addObject:string];
}

/**
 *删除头尾的空格
 */
- (NSString * )deleteSpaceInString:(NSString *)string {

    NSCharacterSet * set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [string stringByTrimmingCharactersInSet:set];
}

//如果是nil的说明这一行不是代码，是注释。。
- (NSString *)codeString:(NSString *)str shouldDeal:(BOOL)shouDealwith{

    if (self.isZhuShi) {
        if ([str containsString:@"*/"]) {
            self.isZhuShi = NO;
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
                self.isZhuShi = YES;
                return nil;
            }
        }else if ([str containsString:@"/*"]){
            if ([str containsString:@"*/"]) {

            }else{
                if (shouDealwith) {
                    self.isZhuShi = YES;
                }
            }
            return str;
        }
    }
    return str;
}




@end
