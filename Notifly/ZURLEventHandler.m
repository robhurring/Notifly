//
//  ZEventController.m
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import "ZURLEventHandler.h"
#import "ZURLEvent.h"

static BOOL initialized = NO;

@implementation ZURLEventHandler
@synthesize delegate;

- (id<ZEventHandler>)initWithDelegate:(id<ZEventHandlerDelegate>)theDelegate
                             userInfo:(NSDictionary *)userInfo
{
    if (self = [self init])
    {
        self.delegate = theDelegate;
    }
    
    return self;
}

- (void)start
{
    if(!initialized)
    {
        [[NSAppleEventManager sharedAppleEventManager]
         setEventHandler:self
         andSelector:@selector(handleURLEvent:withReplyEvent:)
         forEventClass:kInternetEventClass
         andEventID:kAEGetURL];
        
        initialized = YES;
    }
}

- (void)stop
{
    if(initialized)
    {
        [[NSAppleEventManager sharedAppleEventManager]
         removeEventHandlerForEventClass:kInternetEventClass
         andEventID:kAEGetURL];
    }
}

- (void)handleURLEvent:(NSAppleEventDescriptor*)eventDescriptor
        withReplyEvent:(NSAppleEventDescriptor*)replyEvent
{
    ZURLEvent *event = [[ZURLEvent alloc]
                        initWithEventDescriptor:eventDescriptor];
    
    [[NSDistributedNotificationCenter defaultCenter]
     postNotificationName:kNotiflyNotificationName
     object:event.eventName
     userInfo:event.options];
    
    [delegate handleURLEvent:event];
}

@end
