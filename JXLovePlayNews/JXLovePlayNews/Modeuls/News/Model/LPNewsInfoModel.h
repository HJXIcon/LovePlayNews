//
//  LPNewsInfoModel.h
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPNewsInfoModel : NSObject

@property (nonatomic, strong) NSString *digest;
@property (nonatomic, strong) NSString *docid;
@property (nonatomic, strong) NSArray *imgextra;
@property (nonatomic, strong) NSArray *imgsrc;
@property (nonatomic, strong) NSString *ltitle;
@property (nonatomic, strong) NSString *postid;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, strong) NSString *ptime;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, assign) NSInteger showType;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *topicId;

@end
