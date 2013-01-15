//
//  ZEventController.m
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import "ZEventController.h"
#import "ZURLEvent.h"

@implementation ZEventController
@synthesize delegate;

static ZEventController *sharedInstance;

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
    
    [delegate handleURLEvent:event];
}

@end
