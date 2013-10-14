//
//  blc2MainViewController.h
//  blc2
//
//  Created by Cemil Purut on 11/26/12.
//  Copyright (c) 2012 Cemil Purut. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "blc2FlipsideViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BLE.h"


@interface blc2MainViewController : UIViewController <blc2FlipsideViewControllerDelegate, BLEDelegate>
{
    float contrastInUnits;
    float timeInSeconds;
    int timeInTenthSeconds;
    int integerContrastInUnits;
    
    int redOnOff;
    int countToTen;
    int focusOnOff;
    int timeCountDown;
    int brightnessMultiplier;
    
    bool exposeButtonOnOff;
    id timer;
    id holdTimer;
    int blueBrightness;
    int greenBrightness;
    bool timeInTenthsYesNo;
    
    
    
    
    NSMutableString *timeInSecondsString;
    NSMutableString *redBrightnessString;
    NSMutableString *greenBrightnessString;
    NSMutableString *blueBrightnessString;
    
    
    
    
    AVAudioPlayer *audioTinkPlayer;
    AVAudioPlayer *audioBeepPlayer;
    BLE *bleShield;
    
    
    
    IBOutlet UILabel *timeField;
    IBOutlet UILabel *contrastField;
    
    
}

@property (weak, nonatomic) IBOutlet UIButton *showInfo;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UIButton *redButton;
@property (weak, nonatomic) IBOutlet UIButton *exposeButton;
@property (weak, nonatomic) IBOutlet UIButton *focusButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *timeUpButton;
@property (weak, nonatomic) IBOutlet UIButton *timeDownButton;
@property (weak, nonatomic) IBOutlet UIButton *ContrastUpButton;
@property (weak, nonatomic) IBOutlet UIButton *ContrastDownButton;
@property (weak, nonatomic) IBOutlet UIButton *timeUp;
@property (weak, nonatomic) IBOutlet UIButton *timeDown;
@property (weak, nonatomic) IBOutlet UIButton *backgroundRectangle1;
@property (weak, nonatomic) IBOutlet UIButton *backgroundRectangle2;
@property (weak, nonatomic) IBOutlet UIButton *backgroundRectangle3;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;




- (IBAction)showInfo:(id)sender;

@end
