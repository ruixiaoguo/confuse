//
//  ClassRenameManager.m
//  文件修改
//
//  Created by 孔赵壮 on 2018/9/7.
//  Copyright © 2018年 Weijinjurong. All rights reserved.
//

#import "ClassRenameManager.h"
#import "ClassModel.h"

@interface ClassRenameManager ()

@property (nonatomic, strong) NSMutableArray * pathArray;
@property (nonatomic, strong) NSArray * ignoreArray;
@property (nonatomic, copy) NSArray * replaceSubStrArr;
@property (nonatomic, copy) NSString * nSubStr;
@property (nonatomic, strong) NSMutableString * finalString;
@property (nonatomic, strong) NSMutableArray * alreadyRenameArray;
@property (nonatomic, copy) NSString * projString;
@property (nonatomic, copy) NSString * projPath;

@end


//  /Users/kongzhaozhuang/Desktop/aaaa/aaaa
@implementation ClassRenameManager

/**
*没取出一个文件，记录类名，然后遍历每一个文件包含的这个类的名字添加上前缀（改前缀），
但是为了减少遍历次数，.h和.m当遍历了其中一个的时候，另一个避免再次遍历。


先读取出所有的路径，存储起来，不再多次读取，加快速度。
*/
- (void)startRenameClassInPath:(NSString *)str ignoreArray:(NSArray *)classArray newClassSub:(NSString *)subStr replaceClassSub:(NSArray *)replaceStrArr {

    NSLog(@"开始改类名");
    self.ignoreArray = classArray;
    self.nSubStr = subStr;
    self.replaceSubStrArr = replaceStrArr;
    self.alreadyRenameArray = [NSMutableArray array];
    self.projPath = [NSString stringWithFormat:@"%@.xcodeproj/project.pbxproj",str];
    self.projString = [NSString stringWithContentsOfFile:self.projPath encoding:NSUTF8StringEncoding error:nil];
    ///  第一步读取路径
    NSFileManager * manager = [NSFileManager defaultManager];
    BOOL isExit = NO;
    BOOL isDirectory = NO;
    isExit = [manager fileExistsAtPath:str isDirectory:&isDirectory];
    //如果是文件夹
    if (isDirectory) {
        [self readFileOfDirectory:str];
    //如果是文件
    }else{
        return;
    }

    //取出所有的文件开始处理
    for (ClassModel * model in self.pathArray) {
        ///去掉忽略的文件
        BOOL isIgnore = NO;
        for (NSString * str in self.ignoreArray) {
            NSLog(@"%@",model.className);
            if ([str isEqualToString:model.className]) {
                isIgnore = YES;
                break;
            }
        }
        //忽略的类名,默认忽略代理。忽略不需要改类名的类。
        if (isIgnore || [model.className isEqualToString:model.nClassName] || [model.fileLastPath isEqualToString:@"main.m"] || [model.className isEqualToString:@"AppDelegate"]) {
        }else{
            [self startDealWithModel:model];
        }
    }
    [self.projString writeToFile:self.projPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"完成");
}


/**
 *读取文件的处理，进行遍历
 */
- (void)readFileOfDirectory:(NSString *)directory {

    NSError * err = nil;
    NSFileManager * manager = [NSFileManager defaultManager];
    NSArray * arr = [manager contentsOfDirectoryAtPath:directory error:&err];
    if (err) {
        NSLog(@"读取文件失败：\n%@",err);
        return;
    }else{
        for (int i = 0; i < arr.count; i++) {
            NSString * path = arr[i];
            BOOL isExit = NO;
            BOOL isDirectory = NO;
            isExit = [manager fileExistsAtPath:[directory stringByAppendingPathComponent:path] isDirectory:&isDirectory];
            if (isExit) {
                if (isDirectory) {
                    //继续遍历文件夹的内容
                    [self readFileOfDirectory:[directory stringByAppendingPathComponent:path]];
                }else{
                    //开始处理文件，取出文件路径并存储起来。
                    NSString * longPath = [directory stringByAppendingPathComponent:path];
                    [self dealWithFileInPath:longPath];
                }
            }

        }
    }
}

/**
 *开始处理每个.h 或 .m 文件的内容。这个方法直走一次,把后面所有需要的规则字符都拼接好
 */

- (void)dealWithFileInPath:(NSString * )path {

    ///只处理.m  .h  .xib
    if ([path.pathExtension isEqualToString:@"h"] || [path.pathExtension isEqualToString:@"m"] || [path.pathExtension isEqualToString:@"xib"]) {
        ClassModel * model = [[ClassModel alloc]init];
        model.longPath = path;
        model.className =  path.lastPathComponent.stringByDeletingPathExtension;
        model.fileLastPath = path.lastPathComponent;
        if (self.replaceSubStrArr.count != 0) {
            BOOL isContain = NO;
            NSArray * arr = @[@"A",@"B",@"C",@"D"];
            int i = 0;
            for (NSString * replaceStr in self.replaceSubStrArr) {
                //如果是以他开头的替换，并break.
                if ([path.lastPathComponent hasPrefix:replaceStr]) {
                    model.nPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:[path.lastPathComponent stringByReplacingOccurrencesOfString:replaceStr withString:[NSString stringWithFormat:@"%@%@",self.nSubStr,arr[i%arr.count]]]];
                    isContain = YES;
                    break;
                }
                i++;
            }
            if (!isContain) {
                model.nPath = model.longPath;
            }
        }else{
            model.nPath = [[path stringByDeletingLastPathComponent] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",self.nSubStr,path.lastPathComponent]];
        }


        model.nFileLastPath = model.nPath.lastPathComponent;
        model.nClassName = model.nPath.lastPathComponent.stringByDeletingPathExtension;

        [self.pathArray addObject:model];
    }
}


/**
 *开始处理每一个类名
 */
- (void)startDealWithModel:(ClassModel *)model {

    NSLog(@"完成%d/%d",[self.pathArray indexOfObject:model],self.pathArray.count);

    ///如果已经处理过了同一个类名，就不用再处理了。
    if ([self.alreadyRenameArray containsObject:model.className]) {
        return;
    }

    BOOL shoudRename = NO;
    if (![model.className isEqualToString:model.nClassName]) {
        shoudRename = YES;
    }
    //先重命名自己的文件名，先后更改自己里面的类名
    [self replaceClassNameInWithModel:model contentModel:model shouldRename:shoudRename];
    //会加两个吗？
    [self.alreadyRenameArray addObject:model.className];
    //然后处理其他文件
    for (ClassModel * classModel in self.pathArray) {
        if (model != classModel) {
            if ([classModel.className isEqualToString:model.className]) {
                BOOL shouldRn = NO;
                if (![model.className isEqualToString:model.nClassName]) {
                    shouldRn = YES;
                }
                [self replaceClassNameInWithModel:model contentModel:classModel shouldRename:shouldRn];
            }else{
                [self replaceClassNameInWithModel:model contentModel:classModel shouldRename:NO];
            }
        }
    }
}

/**
 *替换字符串中的所有类名
 */
- (void)replaceClassNameInWithModel:(ClassModel *)model contentModel:(ClassModel *)contentModel shouldRename:(BOOL)shouldRename{

   NSString * content = [NSString stringWithContentsOfFile:contentModel.longPath encoding:NSUTF8StringEncoding error:nil];
    self.finalString = [NSMutableString string];

    __weak typeof(self)weakSelf = self;
    [content enumerateLinesUsingBlock:^(NSString * _Nonnull line, BOOL * _Nonnull stop) {
        [weakSelf replaceRuleInString:line withModel:model];
    }];
    //替换后重新保存并命名文件。
    if (shouldRename) {
        [self.finalString writeToFile:contentModel.nPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        if (![self.projString containsString:contentModel.nFileLastPath]) {
            self.projString = [self.projString stringByReplacingOccurrencesOfString:contentModel.fileLastPath withString:contentModel.nFileLastPath];
        }
        //删除文件
        NSFileManager * fileManager = [NSFileManager defaultManager];
        NSError * err = nil;
        BOOL isSUccess = [fileManager removeItemAtPath:contentModel.longPath error:&err];
        contentModel.longPath = contentModel.nPath;

//        NSLog(@"%d",isSUccess);
//        NSLog(@"%@",err.description);
        if (!isSUccess ) {
            NSLog(@"%@",model.longPath);
        }
    }else{
        [self.finalString writeToFile:contentModel.longPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }

}

/**
 *判断类名的
 */
/*
 *  #import "DaYuDanKuanResettingPwdVc.h"
 @interface DaYuDanKuanResettingPwdVc : DaYuDanKuanViewController
 @interface DaYuDanKuanResettingPwdVc ()
 @implementation DaYuDanKuanResettingPwdVc
 分类的判断。。。
 */

- (void)replaceRuleInString:(NSString *)string withModel:(ClassModel *)model {

    if ([string hasPrefix:@"//"]) {

    }else if(![string containsString:model.className]){
        
    }else{
        if ([string isEqualToString:model.className]) {
            string = model.nClassName;
        }else{
            ///根据规则替换
            for (NSDictionary * dic in model.ruleArray) {
                if ([string containsString:dic[@"key1"]]) {
                    if ([string containsString:dic[@"key1"]]) {
                        string = [string stringByReplacingOccurrencesOfString:dic[@"key1"] withString:dic[@"key2"]];
                    }
                }
            }
            

            if ([string hasPrefix:model.rule3Str]) {
                string = [string stringByReplacingOccurrencesOfString:model.rule3Str withString:model.nRule3Str];
            }
            if ([string hasPrefix:model.rule4Str]) {
                string = [string stringByReplacingOccurrencesOfString:model.rule4Str withString:model.nRule4Str];
            }
            if ([string hasSuffix:model.rule2Str]) {
                string = [string stringByReplacingOccurrencesOfString:model.rule2Str withString:model.nRule2Str];
            }
            if ([string hasPrefix:model.rule9Str]) {
                string = [string stringByReplacingOccurrencesOfString:model.rule9Str withString:model.nRule9Str];
            }
            if ([string hasPrefix:model.rule10Str]) {
                string = [string stringByReplacingOccurrencesOfString:model.rule10Str withString:model.nRule10Str];
            }
            if ([string hasPrefix:model.rule13Str]) {
                string = [string stringByReplacingOccurrencesOfString:model.rule13Str withString:model.nRule13Str];
            }
            if ([string hasSuffix:model.rule18Str]) {
                string = [string stringByReplacingOccurrencesOfString:model.rule18Str withString:model.nRule18Str];
            }
        }
    }
    [self.finalString appendFormat:@"%@\n", string];
}

#pragma mark- lazy
- (NSMutableArray *)pathArray {

    if (_pathArray == nil) {
        _pathArray = [NSMutableArray array];
    }
    return _pathArray;
}

- (NSMutableArray *)alreadyRenameArray {

    if (_alreadyRenameArray == nil) {
        _alreadyRenameArray = [NSMutableArray  array];
    }
    return _alreadyRenameArray;
}

@end
