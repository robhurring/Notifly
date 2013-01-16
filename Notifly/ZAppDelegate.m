//
//  ZAppDelegate.m
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import "ZAppDelegate.h"
#import "ZURLEvent.h"

@interface ZAppDelegate()
- (void)attachMenu;
- (void)detachMenu;
@end

@implementation ZAppDelegate
@synthesize mainMenu, statusItem, eventController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self attachMenu];
    self.notificationController = [[ZNotificationHandler alloc]
                                   initWithDelegate:self];
    self.eventController = [ZEventHandler initialize];
    self.eventController.delegate = self;  
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self detachMenu];
}

- (void)attachMenu
{
    NSString *iconPath = [[NSBundle mainBundle]
                          pathForImageResource:@"Icon_On.png"];
    
    NSImage *menuImage = [[NSImage alloc] initWithContentsOfFile:iconPath];
    
    statusItem = [[NSStatusBar systemStatusBar]
                  statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:mainMenu];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:menuImage];
    
    [statusItem setTarget:self];    
}

- (void)detachMenu
{
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
}

- (void)handleURLEvent:(ZURLEvent *)event
{
    if([event isPublishEvent])
    {
        [self.notificationController publishNotificationFromURLEvent:event];
    }else if ([event isRemoveEvent]){
        [self.notificationController removeNotificationsFromURLEvent:event];
    }else if([event isListEvent]){
        [self.notificationController listNotificationsFromURLEvent:event];
    }else{
        NSLog(@"Unknown event name: %@", event.eventName);
    }
}

@end
