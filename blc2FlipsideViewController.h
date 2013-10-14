//
//  blc2FlipsideViewController.h
//  blc2
//
//  Created by Cemil Purut on 11/26/12.
//  Copyright (c) 2012 Cemil Purut. All rights reserved.
//

#import <UIKit/UIKit.h>

@class blc2FlipsideViewController;
@class timeTenths;

@protocol blc2FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(blc2FlipsideViewController *)controller;
@end

@interface blc2FlipsideViewController : UIViewController{

}

@property (weak, nonatomic) id <blc2FlipsideViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *metronomeSwitch;
@property (weak, nonatomic) IBOutlet UIButton *precisionContrastSwitch;
@property (weak, nonatomic) IBOutlet UIButton *precisionTimingSwitch;
@property (weak, nonatomic) IBOutlet UIButton *delayStartSwitch;
@property (weak, nonatomic) IBOutlet UIButton *redDimmerSwitch;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *backgroundRectangle;
@property (weak, nonatomic) IBOutlet UIButton *brightnessSwitch;


- (IBAction)done:(id)sender;



@end
