//
//  LPNewsBaseCellNode.h
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "LPNewsInfoModel.h"

@interface LPNewsBaseCellNode : ASCellNode

@property (nonatomic, strong, readonly) LPNewsInfoModel *newsInfo;

- (instancetype)initWithNewsInfo:(LPNewsInfoModel *)newsInfo;


@end
