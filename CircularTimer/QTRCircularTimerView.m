//
//  QTRCircularTimerView.m
//  CircularTimer
//
//  Created by -philipp on 07.09.14.
//  Copyright (c) 2014 Quatur. All rights reserved.
//

#import "QTRCircularTimerView.h"

@interface QTRCircularTimerView()

@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat lineWidth;

@end

@implementation QTRCircularTimerView

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setup];
        self.clearsContextBeforeDrawing = YES;
    }
    return self;
}

- (void)setup
{
    self.radius = 100.0f;
    self.lineWidth = 1.5f;
    self.circleColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.20f];
    self.timerColor = [UIColor colorWithRed:0.03f green:0.64f blue:0.83f alpha:1.00f];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    
    CGPoint viewCenter = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    // Gray static circle in the background, set to Red when there's no time left
    UIBezierPath *marginCircle = [UIBezierPath bezierPath];
    [marginCircle addArcWithCenter:viewCenter
                            radius:self.radius
                        startAngle:0
                          endAngle:2 * M_PI
                         clockwise:YES];
    marginCircle.lineWidth = self.lineWidth;
    [self.circleColor setFill];
    [marginCircle fill];
    
    // Create our arc, with the correct angles
    // The initialAngleFactor is the extra angular distance the stroke will cover from
    // angle zero to the desired initial angle. For example, if you want it to start from
    // angle zero, the factor will be zero. In this case, we'll start from 12 o'clock,
    // which is angle 3M_PI/2 or 1.5M_PI
    float initialAngleFactor = 1.5 * M_PI;
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:viewCenter
                          radius:self.radius
                      startAngle:0 + initialAngleFactor
                        endAngle:self.endAngle - M_PI_2
                       clockwise:YES];

    // Are you wondering where the previous formula comes from?
    // (_percent * M_PI) / 30.0 + initialAngleFactor
    // Well, M_PI covers just half of the circle, which can display as much as 30 seconds.
    // That's the number of pieces in which the half circle is divided: 30 on each piece.
    bezierPath.lineWidth = self.lineWidth;
    [self.timerColor setStroke];
    [bezierPath stroke];
}

@end
