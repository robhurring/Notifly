//
//  ZProtocols.h
//  Notifly
//
//  Created by rob on 1/16/13.
//  Copyright (c) 2013 rob. All rights reserved.
//
@class ZURLEvent;

@protocol ZEventHandlerDelegate <NSObject>
- (void)handleURLEvent:(ZURLEvent *)event;
- (void)handleFailedURLEvent:(NSString *)reason;
@end

@protocol ZEventHandler <NSObject>
- (id<ZEventHandler>)initWithDelegate:(id<ZEventHandlerDelegate>)theDelegate
                             userInfo:(NSDictionary *)userInfo;

- (void)start;
@end

