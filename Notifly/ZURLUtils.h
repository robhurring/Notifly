//
//  ZURLUtils.h
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZURLUtils : NSObject

+ (NSDictionary *)parseURLQuery:(NSString *)queryString;

@end
