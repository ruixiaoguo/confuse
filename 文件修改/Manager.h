//
//  Manager.h
//  文件修改
//
//  Created by 孔赵壮 on 2018/9/6.
//  Copyright © 2018年 Weijinjurong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Manager : NSObject

- (void)startConfusePath:(NSString *)path methodDic:(NSDictionary *)dic minMethodNumberPerFile:(NSInteger)minMethodNumber maxMethodNumberPerFile:(NSInteger)maxMethodNumber spaceMaxNumber:(NSInteger)spaceMaxNumber lineMaxNumber:(NSInteger)lineMaxNumber ignoreClassArr:(NSArray *)arr;

@end
