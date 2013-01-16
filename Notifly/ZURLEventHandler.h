//
//  ZEventController.h
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZURLEvent;

@interface ZURLEventHandler : NSObject <ZEventHandler>

@property (retain) id<ZEventHandlerDelegate> delegate;

@end
