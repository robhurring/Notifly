//
//  ZEventController.m
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import "ZEventHandler.h"
#import "ZURLEvent.h"

@implementation ZEventHandler
@synthesize delegate;

static ZEventHandler *sharedInstance;

+ (id)initialize
{
    static BOOL initialized = NO;
    if (initialized == NO)
    {
        sharedInstance = [[self alloc] init];

        [[NSAppleEventManager sharedAppleEventManager]
         setEventHandler:sharedInstance
         andSelector:@selector(handleURLEvent:withReplyEvent:)
         forEventClass:kInternetEventClass
         andEventID:kAEGetURL];
        
        initialized = YES;
    }

    return sharedInstance;
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
