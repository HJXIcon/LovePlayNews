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

+ (void)requestNewsListWithTopId:(NSString *)topId pageIndex:(NSInteger)pageIndex completion:(void(^)(NSArray <LPNewsInfoModel *>*modelArray))completion;

+ (void)requestNewsDetailWithNewsId:(NSString *)newsId completion:(void(^)(LPNewsDetailModel *))completion;

@end
