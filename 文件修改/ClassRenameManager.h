//
//  ClassRenameManager.h
//  文件修改
//
//  Created by 孔赵壮 on 2018/9/7.
//  Copyright © 2018年 Weijinjurong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassRenameManager : NSObject

- (void)startRenameClassInPath:(NSString *)str ignoreArray:(NSArray *)classArray newClassSub:(NSString *)subStr replaceClassSub:(NSArray *)replaceStrArr;

@end
