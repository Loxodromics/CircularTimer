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
@property (nonatomic, strong) NSTimer* timer;

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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.deltaT target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
}

- (void)pause
{
    self.isRunning = NO;
    self.deltaT += [self.startTime timeIntervalSinceNow];
    [self.timer invalidate];
    self.timer = nil;
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

- (void)timerFired
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QTRTimeKeeperTimerFired" object:self];
}

@end
