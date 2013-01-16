//
//  ZAppDelegate.h
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZEventHandler.h"
#import "ZNotificationHandler.h"

@interface ZAppDelegate : NSObject <NSApplicationDelegate, ZEventControllerDelegate>

@property (assign) IBOutlet NSMenu *mainMenu;

@property (retain) NSStatusItem *statusItem;
@property (retain) ZEventHandler *eventController;
@property (retain) ZNotificationHandler *notificationController;

@end
