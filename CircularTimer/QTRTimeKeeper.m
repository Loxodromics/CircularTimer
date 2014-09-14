//
//  QTRTimeKeeper.m
//  CircularTimer
//
//  Created by -philipp on 07.09.14.
//  Copyright (c) 2014 Quatur. All rights reserved.
//

#import "QTRTimeKeeper.h"

@interface QTRTimeKeeper()

@property (nonatomic, strong) NSDate* startTime;
@property (nonatomic) bool isRunning;

@end

@implementation QTRTimeKeeper

+ (id)sharedInstance
{
    static QTRTimeKeeper* mySharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        mySharedInstance = [[self alloc] init];
    });
    return mySharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        self.isRunning = NO;
    }
    return self;
}

- (void)run
{
    self.isRunning = YES;
    self.startTime = [NSDate date];
}

- (void)pause
{
    self.isRunning = NO;
    self.deltaT += [self.startTime timeIntervalSinceNow];
}

- (NSTimeInterval)getTimeLeft
{
    if ( self.isRunning )
    {
        return self.deltaT + [self.startTime timeIntervalSinceNow];
    }
    else
    {
        return self.deltaT;
    }
}

@end
