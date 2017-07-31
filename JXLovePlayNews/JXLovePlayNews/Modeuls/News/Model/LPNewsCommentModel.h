//
//  LPNewsCommentModel.h
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPNewsCommentItem;
@interface LPNewsCommentModel : NSObject
@property (nonatomic, strong) NSArray *commentIds;
@property (nonatomic, strong) NSDictionary *comments;

@end

@class LPNewsCommentUser;
@interface LPNewsCommentItem : NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *siteName;
@property (nonatomic, strong) LPNewsCommentUser *user;
@property (nonatomic, assign) NSInteger vote;
@end

@interface LPNewsCommentUser : NSObject
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *nickname;

@end
