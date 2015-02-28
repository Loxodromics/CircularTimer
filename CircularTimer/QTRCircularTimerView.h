//
//  QTRCircularTimerView.h
//  CircularTimer
//
//  Created by -philipp on 07.09.14.
//  Copyright (c) 2014 Quatur. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTRCircularTimerView : UIView

// labels
@property (strong, nonatomic) UILabel* minutesCounterLabel;
@property (strong, nonatomic) UILabel* minutesLabel;
@property (strong, nonatomic) UILabel* secondsCounterLabel;
@property (strong, nonatomic) UILabel* secondsLabel;
@property (strong, nonatomic) UILabel* helpLabel;
@property (strong, nonatomic) UILabel* moonLabel;
@property (strong, nonatomic) UIButton* startStopButton;

// to set the current angle
@property (nonatomic) CGFloat endAngle;

// set the look externaly
@property (nonatomic) CGFloat startAngle;
@property (nonatomic) CGFloat radius;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat initialAngle;
@property (nonatomic, strong) UIColor* circleColor;
@property (nonatomic, strong) UIColor* timerColor;

@end
