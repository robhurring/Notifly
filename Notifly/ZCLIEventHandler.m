//
//  ZCLIHandler.m
//  Notifly
//
//  Created by rob on 1/16/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import "ZCLIEventHandler.h"
#import "ZURLEvent.h"

@interface ZCLIEventHandler ()
- (ZURLEvent *)buildEventFromArgs:(NSString **)errorMessage;
@end

@implementation ZCLIEventHandler
@synthesize delegate, args;

- (id<ZEventHandler>)initWithDelegate:(id<ZEventHandlerDelegate>)theDelegate
                             userInfo:(NSDictionary *)userInfo
{
    if(self = [self init])
    {
        self.delegate = theDelegate;
        self.args = userInfo;
    }
    
    return self;
}

- (void)start
{
    NSString *errorMessage;
    ZURLEvent *event = [self buildEventFromArgs:&errorMessage];
    
    if(!event)
    {
        NSLog(@"Error: %@", errorMessage);
        [delegate handleFailedURLEvent:errorMessage];
    }else{
        [delegate handleURLEvent:event];
    }
}

- (void)stop
{
}

- (ZURLEvent *)buildEventFromArgs:(NSString **)errorMessage
{
    ZURLEvent *event = [[ZURLEvent alloc] init];
    
    event.eventName = [args objectForKey: @"event"];

    NSString *channel   = [self.args objectForKey:@"channel"];
    if(!channel)    channel = @"";

    if([event isPublishEvent])
    {
        NSString *title     = [self.args objectForKey:@"title"];
        NSString *subtitle  = [self.args objectForKey:@"subtitle"];
        NSString *message   = [self.args objectForKey:@"message"];
        
        if(!subtitle)   subtitle = @"";
        
        if(!title)
        {
            *errorMessage = @"Missing title!";
            return nil;
        }
        
        if(!message)
        {
            *errorMessage = @"Missing message!";
            return nil;
        }
        
        event.options = @{
            @"title"    : title,
            @"subtitle" : subtitle,
            @"message"  : message,
            @"channel"  : channel
        };
    }else if([event isListEvent] || [event isRemoveEvent]){
        event.options = @{@"channel" : channel};
    }else{
        *errorMessage = @"Unknown event name";
        return nil;
    }
    
    return event;
}

@end
