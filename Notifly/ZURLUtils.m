//
//  ZURLUtils.m
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import "ZURLUtils.h"

@implementation ZURLUtils

+ (NSDictionary *)parseURLQuery:(NSString *)queryString
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *components = [queryString componentsSeparatedByString:@"&"];

    for(NSString *kvp in components)
    {
        NSArray *pair = [kvp componentsSeparatedByString:@"="];
        NSString *key = [pair objectAtIndex:0];
        NSString *value = [[pair objectAtIndex:1]
                           stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        [dict setObject:value forKey:key];
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
