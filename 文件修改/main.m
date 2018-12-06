//
//  main.m
//  文件修改
//
//  Created by 孔赵壮 on 2018/9/6.
//  Copyright © 2018年 Weijinjurong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Manager.h"
#import "ClassRenameManager.h"
#import "HeaderConfuseManager.h"


// 命令行修改工程目录下所有 png 资源 hash 值
// 使用 ImageMagick 进行图片压缩，所以需要安装 ImageMagick，安装方法 brew install imagemagick
// find . -iname "*.png" -exec echo {} \; -exec convert {} {} \;
// or
// find . -iname "*.png" -exec echo {} \; -exec convert {} -quality 95 {} \;

int main(int argc, const char * argv[]) {
    @autoreleasepool {


        /**
         不要同时进行两个操作。
         执行步骤：1、先改类名，然后解决报错
         2、再进行混淆
         */
        
        NSString * path = @"/Users/guoruixiao/Desktop/aaa/LYFrameWork/LYFrameWork/Helper";
        NSInteger step = 1;

        switch (step) {
            case 1:
            {
                ClassRenameManager * classManager = [[ClassRenameManager alloc]init];
                /**
                 path : 工程路径
                 ignoreArray:忽略的类名
                 newClassSub:新的类名前缀
                 replaceClassSub:需要改的类名前缀
                 */
                [classManager startRenameClassInPath:path ignoreArray:@[@"AppDelegate"] newClassSub:@"QD" replaceClassSub:@[@"HXH"]];//@"MX",@"CT"

            }
                break;
            case 2:
            {
                //methods.plist 的路径，使用前请换成自己的路径。
                NSString * methodPlistPath = @"/Users/guoruixiao/Desktop/代码混淆插件/confuse/文件修改/methods.plist";
                Manager * manager = [[Manager alloc]init];
                NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:methodPlistPath];

                NSArray * ignoreArr = @[
                                        @"main.m",
                                        ];
                [manager startConfusePath:path methodDic:dic minMethodNumberPerFile:4 maxMethodNumberPerFile:8 spaceMaxNumber:3 lineMaxNumber:4 ignoreClassArr:ignoreArr];
            }
                break;
            case 3:
            {
                HeaderConfuseManager * headerManager = [[HeaderConfuseManager alloc]init];
                [headerManager startConfuseHeaderIndexPath:path spaceMaxNumber:4 lineMaxNumber:4 ignoreClassArr:@[@"KeychainItemWrapper"]] ;

            }
                break;
            default:
                break;
        }



    }
    return 0;
}

