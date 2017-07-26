//
//  LPNewsListController.h
//  JXLovePlayNews
//
//  Created by mac on 17/7/25.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface LPNewsListController : ASViewController

@property (nonatomic, strong) NSString *newsTopId;
@property (nonatomic, assign) NSInteger sourceType;

@property (nonatomic, assign) BOOL extendedTabBarInset; // 扩展到底部tabbar

@end
