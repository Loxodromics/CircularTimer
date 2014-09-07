//
//  QTRTimeEmitter.h
//  CircularTimer
//
//  Created by -philipp on 07.09.14.
//  Copyright (c) 2014 Quatur. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QTRTimeEmitter : NSObject

@property (nonatomic) NSTimeInterval deltaT;

+ (id)sharedInstance;

- (void)run;
- (void)pause;
- (NSTimeInterval)getTimeLeft;

@end
