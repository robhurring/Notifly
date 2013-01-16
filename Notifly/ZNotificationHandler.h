//
//  ZNotificationController.h
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZURLEvent;

@protocol ZNotificationHandlerDelegate <NSObject>
- (void)didDeliverNotification:(NSUserNotification *)notification;
@end

@interface ZNotificationHandler : NSObject <NSUserNotificationCenterDelegate>

@property (retain) id<ZNotificationHandlerDelegate> delegate;
@property (retain) NSUserNotificationCenter *notificationCenter;

- (id)initWithDelegate:(id<ZNotificationHandlerDelegate>)theDelegate;

#pragma mark Event Hooks

- (void)publishNotificationFromURLEvent:(ZURLEvent *)event;
- (void)removeNotificationsFromURLEvent:(ZURLEvent *)event;
- (void)listNotificationsFromURLEvent:(ZURLEvent *)event;

#pragma mark Hooks

- (void)publishNotificationWithTitle:(NSString *)title
                            subtitle:(NSString *)subtitle
                             message:(NSString *)message
                             options:(NSDictionary *)options;

- (void)removeNotification:(NSUserNotification *)notification;
- (void)removeAllNotifications;
- (void)listNotifications:(NSArray *)notifications;

@end
