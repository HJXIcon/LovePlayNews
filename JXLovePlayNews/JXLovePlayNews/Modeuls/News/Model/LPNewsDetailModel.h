//
//  LPNewsDetailModel.h
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPNewsCommentModel.h"


@class LPNewsArticleModel,LPNewsDetailImgeInfo,LPNewsFavorInfo;
@interface LPNewsDetailModel : NSObject

@property (nonatomic, strong) LPNewsArticleModel *article;
@property (nonatomic, strong) LPNewsCommentModel *tie;

@end

@interface LPNewsArticleModel : NSObject

@property (nonatomic, strong) NSString *articleUrl; //
@property (nonatomic, strong) NSString *body; // html的body
@property (nonatomic, strong) NSString *digest;
@property (nonatomic, strong) NSString *docid;
@property (nonatomic, strong) NSArray <LPNewsDetailImgeInfo *>*img;
@property (nonatomic, strong) NSString *ptime;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, strong) NSString *shareLink;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray <LPNewsFavorInfo *>*relative_sys;

@end

@interface LPNewsDetailImgeInfo : NSObject
@property (nonatomic, strong) NSString *alt;
@property (nonatomic, strong) NSString *pixel;
@property (nonatomic, strong) NSString *ref;
@property (nonatomic, strong) NSString *src;

@end

@interface LPNewsFavorInfo : NSObject

@property (nonatomic, strong) NSString *docID;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *imgsrc;
@property (nonatomic, strong) NSString *ptime;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *title;

@end
