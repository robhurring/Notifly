//
//  ZEventController.h
//  Notifly
//
//  Created by rob on 1/15/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZURLEvent;

@protocol ZEventControllerDelegate <NSObject>
- (void)handleURLEvent:(ZURLEvent *)event;
@end

@interface ZEventHandler : NSObject

@property (retain) id<ZEventControllerDelegate> delegate;

+ (id)initialize;

@end
