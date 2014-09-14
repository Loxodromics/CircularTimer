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
