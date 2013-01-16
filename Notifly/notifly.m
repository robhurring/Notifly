//
//  notifly.m
//  notifly
//
//  Created by rob on 1/16/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#import "ZConstants.h"
#endif

#import <Foundation/Foundation.h>
#import "ZURLEvent.h"
#import "ZNotificationHandler.h"

ZURLEvent *buildEventFromArgs(NSString **errorMessage)
{
    NSUserDefaults *args = [NSUserDefaults standardUserDefaults];    
    NSString *eventName = [args stringForKey:@"event"];
    
    if(!eventName)
    {
        *errorMessage = @"Missing event name";
        return nil;
    }
    
    ZURLEvent *event = [[ZURLEvent alloc] init];
    event.eventName = eventName;
    
    if([event isPublishEvent])
    {
        NSString *title     = [args stringForKey:@"title"];
        NSString *subtitle  = [args stringForKey:@"subtitle"];
        NSString *message   = [args stringForKey:@"message"];
        NSString *channel   = [args stringForKey:@"channel"];
        
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
        
    }else if([event isListEvent]){
        
    }else if([event isRemoveEvent]){
        
    }else{
        *errorMessage = @"Invalid event. Event must be one of: publish, list or remove";
        return nil;
    }
    
    return event;
}

void printHelpBanner()
{
    printf("notifly\n\n" \
        "Usage: notifly -event [publish|list|remove] [event-options]\n\n" \
       
        "Publish Events - publish user notification to the notification center\n" \
           "\t-title VALUE\tTitle of the notification\n" \
           "\t-subtitle VALUE\tSubtitle of the notification (optional)\n" \
           "\t-message VALUE\tNotification message body\n" \
           "\t-channel VALUE\tChannel for notification grouping (optional)\n"\
       
        "\nList Events - output JSON list of all notifications to stdout\n" \
           "\t-channel VALUE\tList only notifications in this channel (optional)\n" \
           "\t\t\tIf left blank all notifications will be listed.\n" \
       
        "\nRemove Events - remove notifications from the notification center\n" \
           "\t-channel VALUE\tRemove only notifications in this channel (optional)\n" \
           "\t\t\tIf left blank all notifications will be removed.\n" \
           "\n"
    );
}

int main(int argc, const char * argv[])
{
    @autoreleasepool
    {
        if (argc >= 2 && (!strcmp(argv[1], "--help") || !strcmp(argv[1], "-h")))
        {
            printHelpBanner();
            return 0;
        }
        
        if (argc >= 2 && (!strcmp(argv[1], "--version") || !strcmp(argv[1], "-v")))
        {
            printf("0.0");
            return 0;
        }
        
        NSString *errorMessage;
        ZURLEvent *event = buildEventFromArgs(&errorMessage);
        
        if(!event)
        {
            printHelpBanner();
            return 0;
        }
        
        ZNotificationHandler *handler = [[ZNotificationHandler alloc] init];
        
        if([event isPublishEvent])
        {
            [handler publishNotificationFromURLEvent:event];
        }else{
            printf("Unknown event name: %s", [event.eventName UTF8String]);
            return 1;
        }
    }
    
    CFRunLoopRun();    
    return 0;
}

