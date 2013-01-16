//
//  ZAppDelegate.h
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZNotificationHandler.h"

@interface ZAppDelegate : NSObject <NSApplicationDelegate, ZEventHandlerDelegate, ZNotificationHandlerDelegate>

@property (assign) IBOutlet NSMenu *mainMenu;
@property (retain) NSStatusItem *statusItem;
@property (retain) id<ZEventHandler> eventHandler;
@property (retain) ZNotificationHandler *notificationHandler;

@end
