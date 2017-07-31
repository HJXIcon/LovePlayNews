//
//  LPNewsCommentModel.m
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "LPNewsCommentModel.h"


@implementation LPNewsCommentModel


@end

@implementation LPNewsCommentItem

// 告诉MJExtension当前模型数组中字典需要转换成哪个模型
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"user":[LPNewsCommentUser class]};
}
@end


@implementation LPNewsCommentUser

@end

