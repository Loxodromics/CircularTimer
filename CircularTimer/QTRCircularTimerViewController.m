//
//  QTRCircularTimerViewController.m
//  CircularTimer
//
//  Created by -philipp on 07.09.14.
//  Copyright (c) 2014 Quatur. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "QTRCircularTimerViewController.h"
#import "QTRCircularTimerView.h"
#import "QTRTimeEmitter.h"

@interface QTRCircularTimerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *minutesCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsCounterLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;
@property (weak, nonatomic) IBOutlet QTRCircularTimerView* circularTimerView;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;

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
    
    self.minutesLabel.text = @"m";
    self.secondsLabel.text = @"s";
    self.angle = 0.5 * M_PI;
    self.startTimerText = @"Touch the moon to start\nthe sleep timer";
    self.setTimerText = @"Touch the circle to set\nthe sleep time";
    self.timerRunningText = @"  sleep tight...";
    self.isRunning = false;
    
    [[QTRTimeEmitter sharedInstance] setDeltaT:(15 * 60)];
    
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
    
    self.angle = [[QTRTimeEmitter sharedInstance] getTimeLeft] / 3600.0 * 2 * M_PI;
    
    if ( self.angle <= 0.0 )
    {
        self.angle = 0.0001;
//            [[QTRTimeEmitter sharedInstance] pause];
    }
    
    self.minutesLeft = (self.angle / (M_PI * 2)) * 60;
    self.secondsLeft = (int)((self.angle / (M_PI * 2)) * 3600) % 60;
    self.secondsCounterLabel.text = [NSString stringWithFormat:@"%02ld", (long)self.secondsLeft];
    self.minutesCounterLabel.text = [NSString stringWithFormat:@"%02ld", (long)self.minutesLeft];
    
    [self.circularTimerView setEndAngle:self.angle];
    [self.circularTimerView setNeedsDisplay];
}

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
            
            [[QTRTimeEmitter sharedInstance] setDeltaT:(self.angle / (2 * M_PI) * 3600.0f)];
            
            NSLog(@"location: %f, %f, _percent: %f, time: %f", location.x, location.y, atanAngle, self.angle);
            [self update:nil];
        }
    }
}

- (void)showTextTimer
{
    [UIView animateWithDuration:0.5
                          delay:5.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.helpLabel.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         if ( finished && !self.isRunning )
                         {
                             self.helpLabel.text = self.startTimerText;
                             
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  self.helpLabel.alpha = 1.0;
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
                         self.helpLabel.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         if ( finished && !self.isRunning )
                         {
                             self.helpLabel.text = self.setTimerText;
                         
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  self.helpLabel.alpha = 1.0;
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
                         self.helpLabel.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         
                         if ( finished )
                         {
                             self.helpLabel.text = self.timerRunningText;
                             
                             [UIView animateWithDuration:0.5
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseIn
                                              animations:^{
                                                  self.helpLabel.alpha = 1.0;
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  
                                              }];
                         }
                     }];
     
}

- (IBAction)startStopTimerButtonFired:(id)sender
{
    self.isRunning = !self.isRunning;
    
    [CATransaction begin];
    [self.helpLabel.layer removeAllAnimations];
    [CATransaction commit];
    
    if ( !self.isRunning )
    {
        [self.updateTimer invalidate];
        [[QTRTimeEmitter sharedInstance] pause];
        [self showTextSetTime];
    }
    else
    {
        self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(update:) userInfo:nil repeats:YES];
        [[QTRTimeEmitter sharedInstance] run];
        [self showRunningText];
    }
}

//Touch to start timer

@end
