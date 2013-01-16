//
//  ZAppDelegate.m
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import "ZAppDelegate.h"
#import "ZURLEvent.h"
#import "ZCLIEventHandler.h"
#import "ZURLEventHandler.h"

@interface ZAppDelegate ()
@property (assign) BOOL cliMode;
@property (retain) NSDictionary *args;

- (void)printUsage;
- (void)parseArgs;
- (void)attachMenu;
- (void)detachMenu;
@end

@implementation ZAppDelegate
@synthesize mainMenu, statusItem, eventHandler, cliMode;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.notificationHandler = [[ZNotificationHandler alloc]
                                   initWithDelegate:self];

    [self parseArgs];
    cliMode = (self.args.count > 0);
    
    if(!self.cliMode)
    {
        self.eventHandler = [[ZURLEventHandler alloc] initWithDelegate:self userInfo:nil];
        [self attachMenu];
    }else{
        self.eventHandler = [[ZCLIEventHandler alloc] initWithDelegate:self userInfo:self.args];
    }
    
    [eventHandler start];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [eventHandler stop];
    
    if(!self.cliMode)
    {
        [self detachMenu];
    }
}

#pragma mark Cocoa

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

#pragma mark CLI

- (void)printUsage
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
    
    exit(1);
}

- (void)parseArgs
{
    NSArray *valueArgs = @[
        @"event",
        @"title",
        @"subtitle",
        @"message",
        @"channel"
    ];
    
    NSUserDefaults *args = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    for(NSString *key in valueArgs)
    {
        NSString *value = [args objectForKey:key];
        
        if(value)
        {
            [dict setObject:value forKey:key];
        }
    }
    
    self.args = [NSDictionary dictionaryWithDictionary:dict];
}

// TODO: this is ghetto, fix it
- (void)didDeliverNotification:(NSUserNotification *)notification
{
    if(cliMode) exit(0);    
}

- (void)didHandleUrlEvent:(ZURLEvent *)event
{
    if(cliMode) exit(0);
}

- (void)handleURLEvent:(ZURLEvent *)event
{
    if([event isPublishEvent])
    {
        [self.notificationHandler publishNotificationFromURLEvent:event];
    }else if ([event isRemoveEvent]){
        [self.notificationHandler removeNotificationsFromURLEvent:event];
    }else if([event isListEvent]){
        [self.notificationHandler listNotificationsFromURLEvent:event];
    }else{
        NSString *reason = [NSString stringWithFormat:@"Unknown event name: %@", event.eventName];
        [self handleFailedURLEvent:reason];
    }
}

- (void)handleFailedURLEvent:(NSString *)reason
{
    if(cliMode)
    {
        [self printUsage];
    }else{
        NSLog(@"Unknown event name: %@", reason);
    }
}

@end
