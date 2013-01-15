//
//  ZAppDelegate.h
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZEventController.h"
#import "ZNotificationController.h"

@interface ZAppDelegate : NSObject <NSApplicationDelegate, ZEventControllerDelegate>

@property (assign) IBOutlet NSMenu *mainMenu;

@property (retain) NSStatusItem *statusItem;
@property (retain) ZEventController *eventController;
@property (retain) ZNotificationController *notificationController;

@end
