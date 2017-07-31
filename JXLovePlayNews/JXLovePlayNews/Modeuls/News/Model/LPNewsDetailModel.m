//
//  LPNewsDetailModel.m
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "LPNewsDetailModel.h"
#import "LPNewsCommentModel.h"

@implementation LPNewsDetailModel


// 告诉MJExtension当前模型数组中字典需要转换成哪个模型
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"article":[LPNewsArticleModel class],
             @"tie":[LPNewsCommentModel class]
             };
}


@end

@implementation LPNewsArticleModel

// 告诉MJExtension当前模型数组中字典需要转换成哪个模型
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"img":[LPNewsDetailImgeInfo class],
             @"relative_sys":[LPNewsFavorInfo class]
             };
}


@end

@implementation LPNewsDetailImgeInfo


@end

@implementation LPNewsFavorInfo

@end
