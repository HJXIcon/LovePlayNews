//
//  NSString+LPImageURL.m
//  JXLovePlayNews
//
//  Created by mac on 17/7/26.
//  Copyright © 2017年 JXIcon. All rights reserved.
//

#import "NSString+LPImageURL.h"

@implementation NSString (LPImageURL)


- (NSString *)appropriateImageURLSting
{
    return [NSString stringWithFormat:@"%@?w=750&h=20000&quality=75",self];
}

- (NSURL *)appropriateImageURL
{
    return [NSURL URLWithString:[self appropriateImageURLSting]];
}

@end
