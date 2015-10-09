//
//  ZNotificationController.m
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//


#import "ZNotificationHandler.h"
#import "ZURLEvent.h"

@implementation ZNotificationHandler
@synthesize delegate, notificationCenter;

- (id)initWithDelegate:(id)theDelegate
{
    if (self = [self init])
    {
        self.delegate = theDelegate;
    }
    
    return self;
}

- (id)init
{
    if(self = [super init])
    {
        notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
        notificationCenter.delegate = self;
    }
    
    return self;
}

#pragma mark Event Hooks

- (void)publishNotificationFromURLEvent:(ZURLEvent *)event
{
    NSMutableDictionary *options = [NSMutableDictionary
                                    dictionaryWithDictionary:event.options];
    
    NSString *title = [options objectForKey:@"title"];
    [options removeObjectForKey:@"title"];
    
    NSString *subtitle = [options objectForKey:@"subtitle"];
    [options removeObjectForKey:@"subtitle"];
    
    NSString *message = [options objectForKey:@"message"];
    [options removeObjectForKey:@"message"];
    
    [self publishNotificationWithTitle:title
                              subtitle:subtitle
                               message:message
                               options:options];
}

- (void)removeNotificationsFromURLEvent:(ZURLEvent *)event
{
    NSString *channel = [event.options objectForKey:@"channel"];

    if([channel isEqualToString:@""])
    {
        [self removeAllNotifications];
    }else{
        for(NSUserNotification *notification in notificationCenter.deliveredNotifications)
        {
            NSDictionary *userInfo = notification.userInfo;
            if([[userInfo objectForKey:@"channel"] isEqualToString:channel])
            {
                [self removeNotification:notification];
            }
        }        
    }
    
    [delegate didHandleUrlEvent:event];
}

- (void)listNotificationsFromURLEvent:(ZURLEvent *)event
{
    NSString *channel = [event.options objectForKey:@"channel"];
    
    if([channel isEqualToString:@""])
    {
        [self listNotifications:notificationCenter.deliveredNotifications];
    }else{
        NSMutableArray *notifications = [NSMutableArray array];
        
        for(NSUserNotification *notification in notificationCenter.deliveredNotifications)
        {
            NSDictionary *userInfo = notification.userInfo;
            if([[userInfo objectForKey:@"channel"] isEqualToString:channel])
            {
                [notifications addObject:notification];
            }
        }
        
        [self listNotifications:[NSArray arrayWithArray:notifications]];
    }

    [delegate didHandleUrlEvent:event];
}

#pragma mark Hooks

- (void)publishNotificationWithTitle:(NSString *)title
                             subtitle:(NSString *)subtitle 
                             message:(NSString *)message
                             options:(NSDictionary *)options
{
    NSUserNotification *notification = [NSUserNotification new];
    
    notification.title = title;
    notification.subtitle = subtitle;
    notification.informativeText = message;
    notification.userInfo = options;
    
    [notificationCenter scheduleNotification:notification];
}

- (void)removeNotification:(NSUserNotification *)notification
{
    [notificationCenter removeDeliveredNotification:notification];
}

- (void)removeAllNotifications
{
    [notificationCenter removeAllDeliveredNotifications];
}

- (void)listNotifications:(NSArray *)notifications
{
    NSMutableArray *lines = [NSMutableArray array];
    
    for(NSUserNotification *notification in notifications)
    {
        NSMutableDictionary *meta = [NSMutableDictionary
                                     dictionaryWithDictionary:notification.userInfo];
        
        NSString *title = notification.title;
        NSString *subtitle = notification.subtitle;
        NSString *message = notification.informativeText;
        NSString *channel = [meta objectForKey:@"channel"];
        [meta removeObjectForKey:@"channel"];
        
        NSString *delivered = [notification.deliveryDate description];

        if(!message)    message = @"";
        if(!title)      title = @"";
        if(!subtitle)   subtitle = @"";
        if(!channel)    channel = @"";
        if(!delivered)  delivered = @"";
        
        NSDictionary *data = @{
            @"title"    : title,
            @"subtitle" : subtitle,
            @"message"  : message,
            @"channel"  : channel,
            @"delivered": delivered,
            @"meta"     : meta
        };
        
        [lines addObject:data];
    }
  
  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:lines
                                                     options:NSJSONWritingPrettyPrinted
                                                       error:&error];
  if (! jsonData) {
    NSLog(@"Got an error: %@", error);
  } else {
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    printf("%s", [jsonString UTF8String]);
  }
}

#pragma mark NSUserNotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center
        didDeliverNotification:(NSUserNotification *)notification
{
    [delegate didDeliverNotification:notification];
}

- (void)userNotificationCenter:(NSUserNotificationCenter *)center
       didActivateNotification:(NSUserNotification *)notification
{
    [self removeNotification: notification];
    
    // perform action
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center
     shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

#pragma mark Notification Actions

@end
