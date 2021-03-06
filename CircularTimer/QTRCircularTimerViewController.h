//
//  QTRCircularTimerViewController.h
//  CircularTimer
//
//  Created by -philipp on 07.09.14.
//  Copyright (c) 2014 Quatur. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTRCircularTimerView.h"

@interface QTRCircularTimerViewController : UIViewController
@property (weak, nonatomic) IBOutlet QTRCircularTimerView* circularTimerView;
@property (weak, nonatomic) IBOutlet UIButton* dismissButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

- (void)update:(NSTimer*)timer;

@end
