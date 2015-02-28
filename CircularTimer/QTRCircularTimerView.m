//
//  QTRCircularTimerView.m
//  CircularTimer
//
//  Created by -philipp on 07.09.14.
//  Copyright (c) 2014 Quatur. All rights reserved.
//

#import "QTRCircularTimerView.h"

@interface QTRCircularTimerView()

@end

@implementation QTRCircularTimerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.clearsContextBeforeDrawing = YES;
    
    // default values that look decent
    self.radius = 100.0f;
    self.lineWidth = 1.5f;
    self.initialAngle = 1.5 * M_PI; // The initialAngle is used to start at 12 o'clock
    self.circleColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.20f];
    self.timerColor = [UIColor colorWithRed:0.03f green:0.64f blue:0.83f alpha:1.00f];
    float counterFontSize = 32.0f;
    float fontSize = 16.0f;
    NSString* fontName = @"HelveticaNeue-Thin";
    
    self.minutesCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(53.0, 86.0, 42.0, 47.0)];
    [self.minutesCounterLabel setFont:[UIFont fontWithName:fontName size:counterFontSize]];
    [self.minutesCounterLabel setTextAlignment:NSTextAlignmentRight];
    [self.minutesCounterLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:self.minutesCounterLabel];
    
    self.minutesLabel = [[UILabel alloc] initWithFrame:CGRectMake(96.0, 106.0, 42.0, 21.0)];
    [self.minutesLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    [self.minutesLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:self.minutesLabel];
    
    self.secondsCounterLabel = [[UILabel alloc] initWithFrame:CGRectMake(114.0, 86.0, 38.0, 47.0)];
    [self.secondsCounterLabel setFont:[UIFont fontWithName:fontName size:counterFontSize]];
    [self.secondsCounterLabel setTextAlignment:NSTextAlignmentRight];
    [self.secondsCounterLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:self.secondsCounterLabel];
    
    self.secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(153.0, 106.0, 28.0, 21.0)];
    [self.secondsLabel setFont:[UIFont fontWithName:fontName size:fontSize]];
    [self.secondsLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:self.secondsLabel];
    
    self.helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 135.0, 170.0, 34.0)];
    [self.helpLabel setFont:[UIFont fontWithName:fontName size:12.0f]];
    [self.helpLabel setTextColor:[UIColor whiteColor]];
    [self.helpLabel setTextAlignment:NSTextAlignmentCenter];
    [self.helpLabel setNumberOfLines:2];
    [self addSubview:self.helpLabel];
    
    self.moonLabel = [[UILabel alloc] initWithFrame:CGRectMake(84.0, 40.0, 42.0, 50.0)];
    [self.moonLabel setFont:[UIFont fontWithName:fontName size:42.0f]];
    [self.moonLabel setTextColor:[UIColor whiteColor]];
    [self.moonLabel setText:@"☽"];
    [self addSubview:self.moonLabel];
    
    self.startStopButton = [[UIButton alloc] initWithFrame:CGRectMake(46.0, 40.0, 119.0, 122.0)];
    [self addSubview:self.startStopButton];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    // clear background
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    CGPoint viewCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    // filled, gray static circle in the background
    UIBezierPath* backgroundCircle = [UIBezierPath bezierPath];
    [backgroundCircle addArcWithCenter:viewCenter
                            radius:self.radius
                        startAngle:0
                          endAngle:2 * M_PI
                         clockwise:YES];
    
    [self.circleColor setFill];
    [backgroundCircle fill];
    
    // Create time arc with the correct angles
    UIBezierPath* timeArc = [UIBezierPath bezierPath];
    [timeArc addArcWithCenter:viewCenter
                          radius:self.radius
                      startAngle:self.initialAngle
                        endAngle:self.endAngle - M_PI_2
                       clockwise:YES];

    timeArc.lineWidth = self.lineWidth;
    [self.timerColor setStroke];
    [timeArc stroke];
}

@end
