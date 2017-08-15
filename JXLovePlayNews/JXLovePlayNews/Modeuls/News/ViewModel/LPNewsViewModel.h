//
//  LPNewsViewModel.h
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPNewsInfoModel.h"
#import "LPNewsDetailModel.h"


@interface LPNewsViewModel : NSObject

/**
 请求新闻列表数据

 @param topId id
 @param pageIndex 页数
 */
+ (void)requestNewsListWithTopId:(NSString *)topId pageIndex:(NSInteger)pageIndex completion:(void(^)(NSArray <LPNewsInfoModel *>*modelArray))completion;

/**
 请求新闻详情

 @param newsId id
 */
+ (void)requestNewsDetailWithNewsId:(NSString *)newsId completion:(void(^)(LPNewsDetailModel *))completion;



+ (void)requestHotCommentWithNewsId:(NSString *)newsId completion:(void(^)(LPNewsCommentModel *))completion;

+ (void)requestNewCommentWithNewsId:(NSString *)newsId pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;


@end
