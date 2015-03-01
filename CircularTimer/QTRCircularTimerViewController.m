//
//  QTRCircularTimerViewController.m
//  CircularTimer
//
//  Created by -philipp on 07.09.14.
//  Copyright (c) 2014 Quatur. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "QTRCircularTimerViewController.h"
#import "QTRTimeKeeper.h"

@interface QTRCircularTimerViewController ()

@property (strong, nonatomic) NSTimer* updateTimer;

@property (nonatomic) double angle;
@property (strong, nonatomic) NSString* startTimerText;
@property (strong, nonatomic) NSString* setTimerText;
@property (strong, nonatomic) NSString* timerRunningText;
@property (nonatomic) NSInteger minutesLeft;
@property (nonatomic) NSInteger secondsLeft;
@property (nonatomic) bool isRunning;

@end

@implementation QTRCircularTimerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.circularTimerView = [[QTRCircularTimerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 210.f, 210.0f)];
//    [self.view addSubview:self.circularTimerView];
    
    self.circularTimerView.minutesLabel.text = @"m";
    self.circularTimerView.secondsLabel.text = @"s";
    self.startTimerText = @"Touch the moon to start\nthe sleep timer";
    self.setTimerText = @"Touch the circle to set\nthe sleep time";
    self.timerRunningText = @"  sleep tight...";
    self.isRunning = false;
    self.circularTimerView.helpLabel.text = self.setTimerText;
    
    [[QTRTimeKeeper sharedInstance] setDeltaT:(15 * 60)]; // 15min
    
    // to restart the animations
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [self.circularTimerView.startStopButton addTarget:self
                                               action:@selector(startStopTimerButtonFired:)
                                     forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self update:nil];
    
    [self showTextTimer];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.updateTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)update:(NSTimer*)timer
{
    
    self.angle = [[QTRTimeKeeper sharedInstance] getTimeLeft] / 3600.0 * 2 * M_PI;
    
    if ( self.angle <= 0.0 )
    {
        self.angle = 0.0001;
//        [[QTRTimeEmitter sharedInstance] pause];
    }
    
    self.minutesLeft = (self.angle / (M_PI * 2)) * 60;
    self.secondsLeft = (int)((self.angle / (M_PI * 2)) * 3600) % 60;
    self.circularTimerView.secondsCounterLabel.text = [NSString stringWithFormat:@"%02ld", (long)self.secondsLeft];
    self.circularTimerView.minutesCounterLabel.text = [NSString stringWithFormat:@"%02ld", (long)self.minutesLeft];
    
    [self.circularTimerView setEndAngle:self.angle];
    [self.circularTimerView setNeedsDisplay];
}

#pragma mark - touch events

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self handleTouches:touches];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self handleTouches:touches];
}

- (void)handleTouches:(NSSet *)touches
{
    if ( !self.isRunning )
    {
        for ( UITouch* touch in touches )
        {
            CGPoint arcCenter = CGPointMake(self.circularTimerView.center.x - self.circularTimerView.frame.origin.x,
                                            self.circularTimerView.center.y - self.circularTimerView.frame.origin.y);
            CGPoint location = [touch locationInView:self.circularTimerView];
            CGFloat atanAngle = atan2((location.y - arcCenter.y), (location.x - arcCenter.x));
            
            self.angle = atanAngle + 0.5 * M_PI;
            if (self.angle < 0.0f)
            {
                self.angle += 2.0f * M_PI;
            }
            
            [[QTRTimeKeeper sharedInstance] setDeltaT:(self.angle / (2 * M_PI) * 3600.0f)];
            
            [self update:nil];
        }
    }
}

#pragma mark - animations

- (void)showTextTimer
{
    [UIView animateWithDuration:0.5
                          delay:5.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.circularTimerView.helpLabel.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         if ( finished && !self.isRunning )
                         {
                             self.circularTimerView.helpLabel.text = self.startTimerText;
                             
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  self.circularTimerView.helpLabel.alpha = 1.0;
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  [self showTextSetTime];
                                                  
                                              }];
                         }
                     }];
}

- (void)showTextSetTime
{
    [UIView animateWithDuration:0.5
                          delay:5.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.circularTimerView.helpLabel.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         if ( finished && !self.isRunning )
                         {
                             self.circularTimerView.helpLabel.text = self.setTimerText;
                         
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  self.circularTimerView.helpLabel.alpha = 1.0;
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  [self showTextTimer];
                                                  
                                              }];
                         }
                     }];
}

- (void)showRunningText
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.circularTimerView.helpLabel.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         if ( finished )
                         {
                             self.circularTimerView.helpLabel.text = self.timerRunningText;
                             
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  self.circularTimerView.helpLabel.alpha = 1.0;
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  
                                              }];
                         }
                     }];
     
}

- (void)showTextSetTimeNoWait
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.circularTimerView.helpLabel.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         if ( finished && !self.isRunning )
                         {
                             self.circularTimerView.helpLabel.text = self.setTimerText;
                             
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  self.circularTimerView.helpLabel.alpha = 1.0;
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  [self showTextTimer];
                                                  
                                              }];
                         }
                     }];
}

- (void)clearAnimations
{
    [CATransaction begin];
    [self.circularTimerView.helpLabel.layer removeAllAnimations];
    [CATransaction commit];
}

- (void)applicationEnteredForeground:(NSNotification *)notification
{
    if ( !self.isRunning )
    {
        [self clearAnimations];
        [self showTextSetTimeNoWait];
    }
}

#pragma mark - user interaction

- (IBAction)startStopTimerButtonFired:(id)sender
{
    [self clearAnimations];

    self.isRunning = !self.isRunning;
    if ( !self.isRunning )
    {
        [self.updateTimer invalidate];
        [[QTRTimeKeeper sharedInstance] pause];
        [self showTextSetTimeNoWait];
    }
    else
    {
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                            target:self
                                                          selector:@selector(update:)
                                                          userInfo:nil
                                                           repeats:YES];
        [[QTRTimeKeeper sharedInstance] run];
        [self showRunningText];
    }
}

- (IBAction)dismissButtonFired:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
