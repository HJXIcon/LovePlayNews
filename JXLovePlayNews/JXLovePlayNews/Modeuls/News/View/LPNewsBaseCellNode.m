//
//  LPNewsBaseCellNode.m
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "LPNewsBaseCellNode.h"

@interface LPNewsBaseCellNode ()

@property (nonatomic, strong) LPNewsInfoModel *newsInfo;

@end

@implementation LPNewsBaseCellNode

- (instancetype)initWithNewsInfo:(LPNewsInfoModel *)newsInfo
{
    if (self = [super init]) {
        _newsInfo = newsInfo;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
