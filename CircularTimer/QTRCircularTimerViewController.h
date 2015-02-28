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
@property (weak, nonatomic) IBOutlet QTRCircularTimerView *circularTimerView;

- (void)update:(NSTimer*)timer;

@end
