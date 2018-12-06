//
//  HeaderConfuseManager.h
//  文件修改
//
//  Created by 孔赵壮 on 2018/9/10.
//  Copyright © 2018年 Weijinjurong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeaderConfuseManager : NSObject

- (void)startConfuseHeaderIndexPath:(NSString *)path spaceMaxNumber:(NSInteger)spaceMaxNumber lineMaxNumber:(NSInteger)lineMaxNumber ignoreClassArr:(NSArray *)ignoreArr;

@end
