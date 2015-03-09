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
@property (nonatomic, strong) NSTimer* timer;
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
    if ( self = [super init] )
    {
        _isRunning = NO;
        [self assignDeltaT];
    }
    return self;
}

- (void)run
{
    self.isRunning = YES;
    self.startTime = [NSDate date];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.deltaT target:self selector:@selector(timerFired) userInfo:nil repeats:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QTRTimeKeeperTimerStarted" object:self userInfo:@{@"time": @(self.deltaT)}];
    
    [[NSUserDefaults standardUserDefaults] setObject:@(self.deltaT) forKey:@"QTRTimeKeeperDeltaT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)pause
{
    if ( self.isRunning )
    {
        self.isRunning = NO;
        self.deltaT += [self.startTime timeIntervalSinceNow];
        [self.timer invalidate];
        self.timer = nil;
    }
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
    [self pause];
    [self assignDeltaT];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QTRTimeKeeperTimerFired" object:self];
}


- (void)assignDeltaT
{
    NSNumber* storedDeltaT = [[NSUserDefaults standardUserDefaults] objectForKey:@"QTRTimeKeeperDeltaT"];
    if ( storedDeltaT == nil )
    {
        [self setDeltaT:(15 * 60)]; // 15min
    }
    else
    {
        [self setDeltaT:[storedDeltaT floatValue]];
    }
}

@end
