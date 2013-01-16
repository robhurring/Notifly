//
//  ZCLIHandler.h
//  Notifly
//
//  Created by rob on 1/16/13.
//  Copyright (c) 2013 rob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZCLIEventHandler : NSObject <ZEventHandler>

@property (retain) id<ZEventHandlerDelegate> delegate;
@property (retain) NSDictionary *args;

@end
