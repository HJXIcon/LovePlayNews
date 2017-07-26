//
//  LPNewsViewModel.m
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "LPNewsViewModel.h"

@implementation LPNewsViewModel

+ (void)requestNewsListWithTopId:(NSString *)topId pageIndex:(NSInteger)pageIndex completion:(void(^)(NSArray <LPNewsInfoModel *>*modelArray))completion{
    
    int pageCount = 20;
    
    NSString *URLString;
    
    if (topId.length > 0) {
        URLString = [NSString stringWithFormat:@"%@/%@/%ld/%d",NewsListURL,topId,(long)pageIndex*pageCount,pageCount];
    }else {
        URLString = [NSString stringWithFormat:@"%@%ld/%d",NewsListURL,(long)pageIndex*pageCount,pageCount];
    }
    
    
    URLString = [NSString stringWithFormat:@"%@%@",BaseURL,URLString];
    
    
    [PPNetworkHelper GET:URLString parameters:nil success:^(id responseObject) {
        
        NSArray *modelArra = @[];
        
        if ([responseObject[@"code"] intValue] == 0) {
            
            modelArra = [LPNewsInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"info"]];
            
            completion(modelArra);
            
            
        }else{
            completion(nil);
            
        }
        
        
    } failure:^(NSError *error) {
        
        
        completion(nil);
    }];
    
    
}


+ (void)requestNewsDetailWithNewsId:(NSString *)newsId
{
    NSString *URLString = [NSString stringWithFormat:@"%@/%@",NewsDetailURL,newsId];
     NSDictionary *parameters = @{@"tieVersion":@"v2",@"platform":@"ios",@"width":@(kScreenWidth*2),@"height":@(kScreenHeight*2),@"decimal":@"75"};
    
    
}


@end
