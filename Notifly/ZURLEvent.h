//
//  ZURLEvent.h
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZURLEvent : NSObject

@property (retain) NSString *eventName;
@property (retain) NSDictionary *options;

- (id)initWithEventDescriptor:event;

- (BOOL)isPublishEvent;
- (BOOL)isRemoveEvent;
- (BOOL)isListEvent;

@end
