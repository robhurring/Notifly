//
//  ZURLEvent.m
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import "ZURLEvent.h"
#import "ZURLUtils.h"

static NSString *const kPublishEvent   = @"publish";
static NSString *const kRemoveEvent    = @"remove";
static NSString *const kListEvent      = @"list";

@implementation ZURLEvent
@synthesize eventName, options;

- (id)initWithEventDescriptor:(NSAppleEventDescriptor *)event
{
    if(self = [super init])
    {
        NSString *description = [[event paramDescriptorForKeyword:keyDirectObject] stringValue];
        NSURL *url = [NSURL URLWithString:description];

        NSDictionary *queryDict = [ZURLUtils parseURLQuery:url.query];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:queryDict];
        [dict setValue:[NSString stringWithString:url.path] forKey:@"channel"];
        
        self.eventName = url.host;
        self.options = [NSDictionary dictionaryWithDictionary:dict];
        
        NSLog(@"Event: %@", self.eventName);
        NSLog(@"Options: %@", self.options);
    }
    
    return self;
}

- (BOOL)isPublishEvent
{
    return [eventName isEqualToString:kPublishEvent];
}

- (BOOL)isRemoveEvent
{
    return [eventName isEqualToString:kRemoveEvent];
}

- (BOOL)isListEvent
{
    return [eventName isEqualToString:kListEvent];
}

@end