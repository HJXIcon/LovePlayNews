//
//  NSString+LPImageURL.h
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LPImageURL)

/// 返回适当的图片RUL
- (NSURL *)appropriateImageURL;

- (NSString *)appropriateImageURLSting;

@end
