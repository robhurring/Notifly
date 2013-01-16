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
        [delegate handleFailedURLEvent:errorMessage];
    }else{
        [delegate handleURLEvent:event];
    }
}

- (ZURLEvent *)buildEventFromArgs:(NSString **)errorMessage
{
    ZURLEvent *event = [[ZURLEvent alloc] init];
    
    event.eventName = [args objectForKey: @"event"];

    if([event isPublishEvent])
    {
        NSString *title     = [self.args objectForKey:@"title"];
        NSString *subtitle  = [self.args objectForKey:@"subtitle"];
        NSString *message   = [self.args objectForKey:@"message"];
        NSString *channel   = [self.args objectForKey:@"channel"];
        
        if(!subtitle)   subtitle = @"";
        if(!channel)    channel = @"";
        
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
            @"title": title,
            @"subtitle": subtitle,
            @"message": message,
            @"group": channel
        };
    }
    
    return event;
}

@end
