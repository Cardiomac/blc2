//
//  blc2FlipsideViewController.m
//  blc2
//
//  Created by Cemil Purut on 11/26/12.
//  Copyright (c) 2012 Cemil Purut. All rights reserved.
//

#import "blc2FlipsideViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface blc2FlipsideViewController ()

@end

@implementation blc2FlipsideViewController

@synthesize doneButton;
@synthesize metronomeSwitch;
@synthesize precisionTimingSwitch;
@synthesize precisionContrastSwitch;
@synthesize delayStartSwitch;
@synthesize redDimmerSwitch;
@synthesize backgroundRectangle;
@synthesize brightnessSwitch;
@synthesize preflashSwitch;




- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set switches to proper position based on user preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *precisionTiming = [prefs stringForKey:@"precisionTiming"];
    if ([precisionTiming isEqual: @"YES"])
        [precisionTimingSwitch setTitle:[NSString stringWithFormat: @"          On"] forState:UIControlStateNormal];
    else [precisionTimingSwitch setTitle:[NSString stringWithFormat: @"  Off"] forState:UIControlStateNormal];
  
    NSString *precionContrast = [prefs stringForKey:@"precisionContrast"];
    if ([precionContrast isEqual: @"YES"])
        [precisionContrastSwitch setTitle:[NSString stringWithFormat: @"          On"] forState:UIControlStateNormal];
    else [precisionContrastSwitch setTitle:[NSString stringWithFormat: @"  Off"] forState:UIControlStateNormal];

    NSString *metronomeOn = [prefs stringForKey:@"metronome"];
    if ([metronomeOn isEqual: @"YES"])
        [metronomeSwitch setTitle:[NSString stringWithFormat: @"          On"] forState:UIControlStateNormal];
    else [metronomeSwitch setTitle:[NSString stringWithFormat: @"  Off"] forState:UIControlStateNormal];
    
    
    NSString *delayStartOn = [prefs stringForKey:@"delayStart"];
    if ([delayStartOn isEqual: @"YES"])
        [delayStartSwitch setTitle:[NSString stringWithFormat: @"          On"] forState:UIControlStateNormal];
    else [delayStartSwitch setTitle:[NSString stringWithFormat: @"  Off"] forState:UIControlStateNormal];
    
    NSString *redDimmer = [prefs stringForKey:@"redDimmer"];
    if ([redDimmer isEqual: @"HI"])
        [redDimmerSwitch setTitle:[NSString stringWithFormat: @"           Hi"] forState:UIControlStateNormal];
    else [redDimmerSwitch setTitle:[NSString stringWithFormat: @"  Lo"] forState:UIControlStateNormal];
    
    NSString *preflash = [prefs stringForKey:@"preflash"];
    if ([preflash isEqual: @"YES"])
        [preflashSwitch setTitle:[NSString stringWithFormat: @"          On"] forState:UIControlStateNormal];
    else [preflashSwitch setTitle:[NSString stringWithFormat: @"  Off"] forState:UIControlStateNormal];

    NSString *brightness = [prefs stringForKey:@"brightness"];
    if ([brightness isEqual: @"HI"])
        [brightnessSwitch setTitle:[NSString stringWithFormat: @"           Hi"] forState:UIControlStateNormal];
    else [brightnessSwitch setTitle:[NSString stringWithFormat: @"  Lo"] forState:UIControlStateNormal];
    
    
    //define custom buttons
    doneButton.layer.borderColor = [UIColor redColor].CGColor;
    [[doneButton layer] setCornerRadius:8.0f];
    [[doneButton layer] setBorderWidth:3.0f];
    [doneButton setBackgroundColor:[UIColor blackColor]];
    [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    metronomeSwitch.layer.borderColor = [UIColor redColor].CGColor;
    [[metronomeSwitch layer] setCornerRadius:8.0f];
    [[metronomeSwitch layer] setBorderWidth:3.0f];
    [metronomeSwitch setBackgroundColor:[UIColor blackColor]];
    [metronomeSwitch setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [metronomeSwitch setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    precisionTimingSwitch.layer.borderColor = [UIColor redColor].CGColor;
    [[precisionTimingSwitch layer] setCornerRadius:8.0f];
    [[precisionTimingSwitch layer] setBorderWidth:3.0f];
    [precisionTimingSwitch setBackgroundColor:[UIColor blackColor]];
    [precisionTimingSwitch setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [precisionTimingSwitch setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    precisionContrastSwitch.layer.borderColor = [UIColor redColor].CGColor;
    [[precisionContrastSwitch layer] setCornerRadius:8.0f];
    [[precisionContrastSwitch layer] setBorderWidth:3.0f];
    [precisionContrastSwitch setBackgroundColor:[UIColor blackColor]];
    [precisionContrastSwitch setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [precisionContrastSwitch setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    delayStartSwitch.layer.borderColor = [UIColor redColor].CGColor;
    [[delayStartSwitch layer] setCornerRadius:8.0f];
    [[delayStartSwitch layer] setBorderWidth:3.0f];
    [delayStartSwitch setBackgroundColor:[UIColor blackColor]];
    [delayStartSwitch setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [delayStartSwitch setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    redDimmerSwitch.layer.borderColor = [UIColor redColor].CGColor;
    [[redDimmerSwitch layer] setCornerRadius:8.0f];
    [[redDimmerSwitch layer] setBorderWidth:3.0f];
    [redDimmerSwitch setBackgroundColor:[UIColor blackColor]];
    [redDimmerSwitch setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [redDimmerSwitch setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    brightnessSwitch.layer.borderColor = [UIColor redColor].CGColor;
    [[brightnessSwitch layer] setCornerRadius:8.0f];
    [[brightnessSwitch layer] setBorderWidth:3.0f];
    [brightnessSwitch setBackgroundColor:[UIColor blackColor]];
    [brightnessSwitch setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [brightnessSwitch setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    preflashSwitch.layer.borderColor = [UIColor redColor].CGColor;
    [[preflashSwitch layer] setCornerRadius:8.0f];
    [[preflashSwitch layer] setBorderWidth:3.0f];
    [preflashSwitch setBackgroundColor:[UIColor blackColor]];
    [preflashSwitch setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [preflashSwitch setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    backgroundRectangle.layer.borderColor = [UIColor redColor].CGColor;
    [[backgroundRectangle layer] setCornerRadius:8.0f];
    [[backgroundRectangle layer] setBorderWidth:3.0f];
    [backgroundRectangle setBackgroundColor:[UIColor blackColor]];



	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)metronomeSwitch:(id)sender{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *metronomeOn = [prefs stringForKey:@"metronome"];

    
    if ([metronomeOn isEqual: @"YES"]){
        [prefs setObject:@"NO" forKey:@"metronome"];
        [metronomeSwitch setTitle:[NSString stringWithFormat: @"  Off"] forState:UIControlStateNormal];

    }
    else{
        [prefs setObject:@"YES" forKey:@"metronome"];
        [metronomeSwitch setTitle:[NSString stringWithFormat: @"          On"] forState:UIControlStateNormal];

    }
    
}


- (IBAction)precisionContrastSwitch:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *precisionContrast = [prefs stringForKey:@"precisionContrast"];
    
    if ([precisionContrast isEqual: @"NO"]){
        [prefs setObject:@"YES" forKey:@"precisionContrast"];
        [precisionContrastSwitch setTitle:[NSString stringWithFormat: @"          On"] forState:UIControlStateNormal];
    }
    else{
        [prefs setObject:@"NO" forKey:@"precisionContrast"];
        [precisionContrastSwitch setTitle:[NSString stringWithFormat: @"  Off"] forState:UIControlStateNormal];
    }
    
}

- (IBAction)precisionTimingSwitch:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *precisionTiming = [prefs stringForKey:@"precisionTiming"];
    
    if ([precisionTiming isEqual: @"NO"]){
        [prefs setObject:@"YES" forKey:@"precisionTiming"];
        [precisionTimingSwitch setTitle:[NSString stringWithFormat: @"          On"] forState:UIControlStateNormal];
    }
    else{
        [prefs setObject:@"NO" forKey:@"precisionTiming"];
        [precisionTimingSwitch setTitle:[NSString stringWithFormat: @"  Off"] forState:UIControlStateNormal];

    }
    
    //NSLog(@"tenthSeconds = %@",[prefs stringForKey:@"precisionTiming"]);
    
}


- (IBAction)delayStartSwitch:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *delayStartOn = [prefs stringForKey:@"delayStart"];
    
    if ([delayStartOn isEqual: @"NO"]){
        [prefs setObject:@"YES" forKey:@"delayStart"];
        [delayStartSwitch setTitle:[NSString stringWithFormat: @"          On"] forState:UIControlStateNormal];
    }
    else{
        [prefs setObject:@"NO" forKey:@"delayStart"];
        [delayStartSwitch setTitle:[NSString stringWithFormat: @"  Off"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)redDimmerSwitch:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *redDimmer = [prefs stringForKey:@"redDimmer"];
    
    if ([redDimmer isEqual: @"LO"]){
        [prefs setObject:@"HI" forKey:@"redDimmer"];
        [redDimmerSwitch setTitle:[NSString stringWithFormat: @"           Hi"] forState:UIControlStateNormal];
    }
    else{
        [prefs setObject:@"LO" forKey:@"redDimmer"];
        [redDimmerSwitch setTitle:[NSString stringWithFormat: @"  Lo"] forState:UIControlStateNormal];
        
    }
}

- (IBAction)preflashSwitch:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *preflash = [prefs stringForKey:@"preflash"];
    
    if ([preflash isEqual: @"NO"]){
        [prefs setObject:@"YES" forKey:@"preflash"];
        [preflashSwitch setTitle:[NSString stringWithFormat: @"          On"] forState:UIControlStateNormal];
    }
    else{
        [prefs setObject:@"NO" forKey:@"preflash"];
        [preflashSwitch setTitle:[NSString stringWithFormat: @"  Off"] forState:UIControlStateNormal];
        
    }
}


- (IBAction)brightnessSwitch:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *brightness = [prefs stringForKey:@"brightness"];
    
    if ([brightness isEqual: @"LO"]){
        [prefs setObject:@"HI" forKey:@"brightness"];
        [brightnessSwitch setTitle:[NSString stringWithFormat: @"           Hi"] forState:UIControlStateNormal];
    }
    else{
        [prefs setObject:@"LO" forKey:@"brightness"];
        [brightnessSwitch setTitle:[NSString stringWithFormat: @"  Lo"] forState:UIControlStateNormal];
        
    }
}


- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
