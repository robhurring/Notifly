//
//  ZNotificationController.m
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//


#import "ZNotificationController.h"
#import "ZURLEvent.h"
#import "JSONKit.h"

@interface ZNotificationController()
- (NSString *)JSONFormatNotification:(NSUserNotification *)notification;
@end

@implementation ZNotificationController
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
    NSString *title = [event.options objectForKey:@"title"];
    NSString *subtitle = [event.options objectForKey:@"subtitle"];
    NSString *message = [event.options objectForKey:@"message"];
    
    [self publishNotificationWithTitle:title
                              subtitle:subtitle
                               message:message
                               options:event.options];
}

- (void)removeNotificationsFromURLEvent:(ZURLEvent *)event
{
    NSString *group = [event.options objectForKey:@"group"];

    if([group isEqualToString:@""])
    {
        [self removeAllNotifications];
    }else{
        for(NSUserNotification *notification in notificationCenter.deliveredNotifications)
        {
            NSDictionary *userInfo = notification.userInfo;
            if([[userInfo objectForKey:@"group"] isEqualToString:group])
            {
                [self removeNotification:notification];
            }
        }        
    }
}

- (void)listNotificationsFromURLEvent:(ZURLEvent *)event
{
    NSString *group = [event.options objectForKey:@"group"];
    
    if([group isEqualToString:@""])
    {
        [self listNotifications:notificationCenter.deliveredNotifications];
    }else{
        NSMutableArray *notifications = [NSMutableArray array];
        
        for(NSUserNotification *notification in notificationCenter.deliveredNotifications)
        {
            NSDictionary *userInfo = notification.userInfo;
            if([[userInfo objectForKey:@"group"] isEqualToString:group])
            {
                [notifications addObject:notification];
            }
        }
        
        [self listNotifications:[NSArray arrayWithArray:notifications]];
    }
}

#pragma mark Hooks

- (void)publishNotificationWithTitle:(NSString *)title
                             subtitle:(NSString *)subtitle 
                             message:(NSString *)message
                             options:(NSDictionary *)options
{
    NSUserNotification *notification = [NSUserNotification new];
    
    notification.title = (title ? title : @"");
    notification.subtitle = (subtitle ? subtitle : @"");
    notification.informativeText = (message ? message : @"");
    notification.userInfo = (options ? options : [NSDictionary dictionary]);
    
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
        // TODO: fix nils here
        NSDictionary *data = @{
            @"title"    : notification.title,
            @"subtitle" : notification.subtitle,
            @"message"  : notification.informativeText,
            @"group"    : [notification.userInfo objectForKey:@"group"],
            @"delivered": [notification.deliveryDate description],
            @"data"     : notification.userInfo
        };
        
        [lines addObject:data];
    }
    
    printf("%s", [[lines JSONString] UTF8String]);
}

#pragma mark NSUserNotificationCenterDelegate

- (void)userNotificationCenter:(NSUserNotificationCenter *)center
        didDeliverNotification:(NSUserNotification *)notification
{
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
