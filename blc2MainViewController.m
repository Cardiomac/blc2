//
//  blc2MainViewController.m
//  blc2
//
//  Created by Cemil Purut on 11/26/12.
//  Copyright (c) 2012 Cemil Purut. All rights reserved.
//
//  This is the basic controller for the Model 3 enlarger lamp from Modern Enlarger Lamps.
//  
//

#import "blc2MainViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface blc2MainViewController ()

@end


@implementation blc2MainViewController


@synthesize showInfo;
@synthesize connectButton;
@synthesize exposeButton;
@synthesize focusButton;
@synthesize redButton;
@synthesize resetButton;
@synthesize timeUpButton;
@synthesize timeDownButton;
@synthesize ContrastUpButton;
@synthesize ContrastDownButton;
@synthesize timeUp;
@synthesize timeDown;
@synthesize backgroundRectangle1;
@synthesize backgroundRectangle2;
@synthesize backgroundRectangle3;
@synthesize logoView;



- (IBAction)exposeButtonPressed:(id)sender{  // This action is taken when the START buton is pressed
    
   
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *metronomeOn = [prefs stringForKey:@"metronome"];
    NSString *delayStartOn = [prefs stringForKey:@"delayStart"];

    
    if (exposeButtonOnOff == NO){
        exposeButtonOnOff = YES;
        
        //turn off the POSITION button
        redOnOff = 0;
        [redButton setBackgroundColor:[UIColor blackColor]];
        [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

        
        //turn off the FOCUS button
        focusOnOff = 0;
        [focusButton setBackgroundColor:[UIColor blackColor]];
        [focusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        if ([delayStartOn isEqual: @"YES"]){
            holdTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(bleShieldSendData:) userInfo:nil repeats:NO];
            [self bleShieldSendFiveSecRed:nil];}
        
        else{
             [self bleShieldSendData:nil];}

        
    }
    
    else{
        [holdTimer invalidate];
        [self bleShieldSendNull:nil];

        exposeButtonOnOff = NO;
        [exposeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [exposeButton setTitle:@"Start" forState:UIControlStateNormal];
        [exposeButton setBackgroundColor:[UIColor blackColor]];
        if ([metronomeOn isEqual: @"YES"]) [audioBeepPlayer play];
        
        //turn off the POSITION button
        redOnOff = 0;
        [redButton setBackgroundColor:[UIColor blackColor]];
        [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
        
        //turn off the FOCUS button
        focusOnOff = 0;
        [focusButton setBackgroundColor:[UIColor blackColor]];
        [focusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

        
    }
}


-(void)bleShieldSendData:(id)sender{
    
    NSString *s;
    NSData *d;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *brightness = [prefs stringForKey:@"brightness"];
    
    
    timeCountDown = timeInTenthSeconds;
    countToTen = 10;
    [self timerTenthTick:nil];
    
    
    if ([brightness isEqual: @"HI"]){brightnessMultiplier = 51;}
    else {brightnessMultiplier = 1;}

    
    // Calculate the Green LED Brightness and format the greenBrightness string properly
    greenBrightness = (5-contrastInUnits)*brightnessMultiplier;
    if (greenBrightness<10)greenBrightnessString = [NSMutableString stringWithFormat:@"00%i", greenBrightness];
    if (greenBrightness>=10 && greenBrightness<100) greenBrightnessString = [NSMutableString stringWithFormat:@"0%i", greenBrightness];
    if (greenBrightness>=100 && greenBrightness<1000) greenBrightnessString = [NSMutableString stringWithFormat:@"%i", greenBrightness];
    
    // Calculate the Blue LED Brightness and format the blueBrightness string properly
    blueBrightness = (contrastInUnits*brightnessMultiplier);
    if (blueBrightness<10)blueBrightnessString = [NSMutableString stringWithFormat:@"00%i", blueBrightness];
    if (blueBrightness>=10 && blueBrightness<100) blueBrightnessString = [NSMutableString stringWithFormat:@"0%i", blueBrightness];
    if (blueBrightness>=100 && blueBrightness<1000) blueBrightnessString = [NSMutableString stringWithFormat:@"%i", blueBrightness];

    
    s = [NSString stringWithFormat:@"000%@000%@%@\r\n",timeInSecondsString, greenBrightnessString, blueBrightnessString];
    d = [s dataUsingEncoding:NSUTF8StringEncoding];
    [bleShield write:d];
    
}

-(void)bleShieldSendFiveSecRed:(id)sender{
    
    NSString *s;
    NSData *d;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *redDimmer = [prefs stringForKey:@"redDimmer"];
    
    timeCountDown = 50;
    countToTen = 10;
    [self timerTenthTick:nil];
    
    //Set the Red Brightness based on user preferences
    if ([redDimmer isEqual:@"HI"]) redBrightnessString = [NSMutableString stringWithFormat:@"255"];
    else redBrightnessString = [NSMutableString stringWithFormat:@"064"];

    
    s = [NSString stringWithFormat:@"0000050%@000000\r\n", redBrightnessString];
    d = [s dataUsingEncoding:NSUTF8StringEncoding];
    [bleShield write:d];
    
}


-(void)bleShieldSendNull:(id)sender{
    
    NSString *s;
    NSData *d;
    
    s = [NSString stringWithFormat:@"0000000000000000\r\n"];
    d = [s dataUsingEncoding:NSUTF8StringEncoding];
    [bleShield write:d];
    
}



- (void)timerTenthTick:(id)sender{    // This is where the countdown occurs.  You arrive here when a data packet is received from the Arduino.  These data packets arrive every 0.1s as countdown is in progress. The arrival of the data packet alone triggers this call; the value of the data itself is not used.
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *metronomeOn = [prefs stringForKey:@"metronome"];
    NSString *precisionTiming = [prefs stringForKey:@"precisionTiming"];
   
    
    // Reset the START button when the countdown reaches 0.
    if (timeCountDown <= 0){
        exposeButtonOnOff = NO;
        countToTen=0;
        [exposeButton setBackgroundColor:[UIColor blackColor]];
        [exposeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [exposeButton setTitle:@"Start" forState:UIControlStateNormal];
        if (([metronomeOn isEqual: @"YES"]) && (redOnOff == 0) && (focusOnOff == 0))[audioBeepPlayer play];
        
        redOnOff = 0;
        [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [redButton setBackgroundColor:[UIColor blackColor]];

    }
    
    // Otherwise display the countdown time on the START buttton
    else{
        if (exposeButtonOnOff == YES){
            if((timeInTenthSeconds > 999) || ([precisionTiming isEqual: @"NO"]))[exposeButton setTitle:[NSString stringWithFormat: @"%i", (timeCountDown+9)/10] forState:UIControlStateNormal];
            else[exposeButton setTitle:[NSString stringWithFormat: @"%i.%i", timeCountDown/10, timeCountDown%10] forState:UIControlStateNormal];
        
            if (([metronomeOn isEqual: @"YES"]) && (countToTen == 10) && (redOnOff == 0) && (focusOnOff == 0)){
                [audioTinkPlayer play];
                countToTen = 0;
            }
            timeCountDown=timeCountDown-1;
            countToTen = countToTen+1;
        }
    }
}



- (IBAction)contrastUp:(id)sender { // This action occurs when the UP CONTRAST button is pressed
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *precisionContrast = [prefs stringForKey:@"precisionContrast"];

    
    if ([precisionContrast isEqual: @"NO"]){
        integerContrastInUnits = contrastInUnits*10;
        if ((integerContrastInUnits % 5) != 0){
            contrastInUnits = (integerContrastInUnits+5)/5;
            contrastInUnits = contrastInUnits/2;
            }
        else {
            integerContrastInUnits=contrastInUnits*10;
            integerContrastInUnits=integerContrastInUnits+5;
            contrastInUnits=(float)integerContrastInUnits/10;
            }
        }    
    else{
        integerContrastInUnits=contrastInUnits*10;
        integerContrastInUnits=integerContrastInUnits+1;
        contrastInUnits=(float)integerContrastInUnits/10;
    }
    if (contrastInUnits > 5) contrastInUnits = 5;
    
    // Format the contrastField text string properly for display
    integerContrastInUnits = contrastInUnits*10;
    if (integerContrastInUnits%10 == 0)[contrastField setText:[NSString stringWithFormat: @"%1.0f", contrastInUnits]];
    else [contrastField setText:[NSString stringWithFormat: @"%1.1f", contrastInUnits]];
    
}


- (IBAction)contrastDown:(id)sender { // This action occurs when the Down CONTRAST button is pressed
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *precisionContrast = [prefs stringForKey:@"precisionContrast"];
    
    if ([precisionContrast isEqual: @"NO"]){
        integerContrastInUnits = contrastInUnits*10;
        if ((integerContrastInUnits % 5) != 0){
            contrastInUnits = integerContrastInUnits/5;
            contrastInUnits = contrastInUnits/2;
        }
        else{
            integerContrastInUnits=contrastInUnits*10;
            integerContrastInUnits=integerContrastInUnits-5;
            contrastInUnits=(float)integerContrastInUnits/10;
        }
    }
    else{
        integerContrastInUnits=contrastInUnits*10;
        integerContrastInUnits=integerContrastInUnits-1;
        contrastInUnits=(float)integerContrastInUnits/10;
        }

    if (contrastInUnits < 0) contrastInUnits = 0;
    
    // Format the contrastField text string properly for display
    integerContrastInUnits=contrastInUnits*10;
    if (integerContrastInUnits%10 == 0)[contrastField setText:[NSString stringWithFormat: @"%1.0f", contrastInUnits]];
    else [contrastField setText:[NSString stringWithFormat: @"%1.1f", contrastInUnits]];
    
}


- (IBAction)timeChangeUpStart:(id)sender {
    holdTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(zipTimeUp:) userInfo:nil repeats:NO];
    [self timeUp:nil];
}

- (void)zipTimeUp:(id)sender{
    holdTimer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(timeUp:) userInfo:nil repeats:YES];
    [holdTimer fire];
}

- (IBAction)timeChangeDownStart:(id)sender {
    holdTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(zipTimeDown:) userInfo:nil repeats:NO];
    [self timeDown:nil];
}

- (void)zipTimeDown:(id)sender{
    holdTimer = [NSTimer scheduledTimerWithTimeInterval:0.06 target:self selector:@selector(timeDown:) userInfo:nil repeats:YES];
    [holdTimer fire];
}



- (IBAction)timeChangeStop:(id)sender {
    [holdTimer invalidate];
}


- (void) timeUp:(id)sender { // This action is taken when the UP SECONDS button is pressed
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *precisionTiming = [prefs stringForKey:@"precisionTiming"];

    if ([precisionTiming isEqual: @"YES"] && timeInTenthSeconds <=999){
        timeInTenthSeconds=timeInTenthSeconds+1;
        if (timeInTenthSeconds >9999) timeInTenthSeconds = 9999;
        [timeField setText:[NSString stringWithFormat: @"%i.%i", timeInTenthSeconds/10, timeInTenthSeconds % 10]];
        }
    else{
        timeInTenthSeconds=timeInTenthSeconds+10;
        if (timeInTenthSeconds >9999) timeInTenthSeconds = 9999;
        [timeField setText:[NSString stringWithFormat: @"%i", timeInTenthSeconds/10]];
        }
    
    if (timeInTenthSeconds < 10) timeInSecondsString = [NSMutableString stringWithFormat: @"000%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=10 && timeInSeconds <100) timeInSecondsString = [NSMutableString stringWithFormat: @"00%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=100 && timeInTenthSeconds <1000) timeInSecondsString = [NSMutableString stringWithFormat: @"0%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=1000) timeInSecondsString = [NSMutableString stringWithFormat: @"%i", timeInTenthSeconds];
}



- (void) timeDown:(id)sender { // This action is taken when the DOWN SECONDS button is pressed
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *precisionTiming = [prefs stringForKey:@"precisionTiming"];

    if ([precisionTiming isEqual: @"YES"] && timeInTenthSeconds <=1000){
        timeInTenthSeconds=timeInTenthSeconds-1;
        if (timeInTenthSeconds < 0) timeInTenthSeconds = 0;
        [timeField setText:[NSString stringWithFormat: @"%i.%i", timeInTenthSeconds/10, timeInTenthSeconds % 10]];
        }
    else{
        timeInTenthSeconds=timeInTenthSeconds-10;
        if (timeInTenthSeconds < 0) timeInTenthSeconds = 0;
        [timeField setText:[NSString stringWithFormat: @"%i", timeInTenthSeconds/10]];
        }
    
    if (timeInTenthSeconds < 10)timeInSecondsString = [NSMutableString stringWithFormat: @"000%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=10 && timeInTenthSeconds <100) timeInSecondsString = [NSMutableString stringWithFormat: @"00%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=100 && timeInTenthSeconds <1000) timeInSecondsString = [NSMutableString stringWithFormat: @"0%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=1000) timeInSecondsString = [NSMutableString stringWithFormat: @"%i", timeInTenthSeconds];
}



- (IBAction)redButtonPressed:(id)sender {  //This action occurs when the POSITION button is pressed. For safety, action is taken only when an exposure is not in progress.

    
    NSString *s;
    NSData *d;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *redDimmer = [prefs stringForKey:@"redDimmer"];

    
    
        if (redOnOff == 0){
            
            if (exposeButtonOnOff == NO){ // Check that an exposure is not in progress

            redOnOff = 1;
            [redButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [redButton setBackgroundColor:[UIColor redColor]];
            
            // Set up the countdown timer and the time display
            exposeButtonOnOff = YES;
            timeCountDown = 3600;
            countToTen = 10;
            [self timerTenthTick:nil];

            //turn off the FOCUS button
            focusOnOff = 0;
            [focusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [focusButton setBackgroundColor:[UIColor blackColor]];
            
            //Set the Red Brightness based on user preferences
            if ([redDimmer isEqual:@"HI"]) redBrightnessString = [NSMutableString stringWithFormat:@"255"];
            else redBrightnessString = [NSMutableString stringWithFormat:@"064"];

            // Send Arduino command to turn on only the red LED for 6 minutes (3600 tenths of a second).
            s = [NSString stringWithFormat:@"0003600%@000000\r\n", redBrightnessString];
            d = [s dataUsingEncoding:NSUTF8StringEncoding];
            [bleShield write:d];
            }
        }
        
        else{
            
            // Reset the FOCUS button
            redOnOff = 0;
            [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [redButton setBackgroundColor:[UIColor blackColor]];
            
            
            // Send the Arduino the command to turn everything off
            [self bleShieldSendNull:nil];
            
            //  Reset the START button
            exposeButtonOnOff = NO;
            [exposeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [exposeButton setTitle:@"Start" forState:UIControlStateNormal];
            [exposeButton setBackgroundColor:[UIColor blackColor]];
            

        }
}

- (IBAction)focusButtonPressed:(id)sender { //This action occurs when the FOCUS button is pressed.  For safety, action is taken only when an exposure is not in progress.
    
    NSString *s;
    NSData *d;
    
        if (focusOnOff == 0){
            
            if (exposeButtonOnOff == NO){ // Check that an exposure is not in progress

            focusOnOff = 1;
            [focusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [focusButton setBackgroundColor:[UIColor redColor]];
            
            // Set up the countdown timer and the time display
            exposeButtonOnOff = YES;
            timeCountDown = 1800;
            countToTen = 10;
            [self timerTenthTick:nil];
            
            //turn off the POSITION button
            redOnOff = 0;
            [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [redButton setBackgroundColor:[UIColor blackColor]];
            
            // Send Arduino command to turn on all LEDs for 3 minutes (1800 tenths of a second).
            s = [NSString stringWithFormat:@"0001800000255255\r\n"];
            d = [s dataUsingEncoding:NSUTF8StringEncoding];
            [bleShield write:d];
            }
        }
        
        else{
            focusOnOff = 0;
            [focusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [focusButton setBackgroundColor:[UIColor blackColor]];
            
            // Send the Arduino the command to turn everything off
            [self bleShieldSendNull:nil];
            
            //  Reset the START button
            exposeButtonOnOff = NO;
            [exposeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [exposeButton setTitle:@"Start" forState:UIControlStateNormal];
            [exposeButton setBackgroundColor:[UIColor blackColor]];
            
        }
    
}


- (IBAction)resetButtonPressed:(id)sender {
    
    NSString *s;
    NSData *d;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *metronomeOn = [prefs stringForKey:@"metronome"];

    // Set Contrast, Time, and Blue brightness to 0, green brightness to 255
    contrastInUnits = 0;
    [contrastField setText:[NSString stringWithFormat: @"%1.0f", contrastInUnits]];
    timeInTenthSeconds = 0;
    timeCountDown = 0;
    timeInSecondsString = [NSMutableString stringWithFormat: @"0000"];
    [timeField setText:[NSString stringWithFormat: @"%i", timeInTenthSeconds]];
    greenBrightness = 255;
    blueBrightness = 0;
    
    // Reset START button (exposeButton)
    exposeButtonOnOff = NO;
    [exposeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [exposeButton setTitle:@"Start" forState:UIControlStateNormal];
    [exposeButton setBackgroundColor:[UIColor blackColor]];
    if ([metronomeOn isEqual: @"YES"]) [audioBeepPlayer play];
    [timer invalidate];
    
    // Reset FOCUS button (focusButton)
    focusOnOff = 0;
    [focusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [focusButton setBackgroundColor:[UIColor blackColor]];
    
    //Reset POSITION button (redButton)
    redOnOff = 0;
    [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [redButton setBackgroundColor:[UIColor blackColor]];
    
    
    s = [NSString stringWithFormat:@"0000000000000000\r\n"];
    d = [s dataUsingEncoding:NSUTF8StringEncoding];
    [bleShield write:d];
}


- (IBAction)connectButtonPressed:(id)sender {
    
    if (bleShield.activePeripheral)
        if(bleShield.activePeripheral.isConnected){
            [self resetButtonPressed:Nil];
            [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
            return;
        }
    
    if (bleShield.peripherals) bleShield.peripherals = nil;
    
    [bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [self.spinner startAnimating];
}


// Called when scan period is over to connect to the first found peripheral
-(void) connectionTimer:(NSTimer *)timer{
    if(bleShield.peripherals.count > 0)[bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    else[self.spinner stopAnimating];
}


- (void) bleDidDisconnect{
    [connectButton setTitle:@"Connect" forState:UIControlStateNormal];
    UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"default" ofType:@"png"]];
    [logoView setImage:img];

}


-(void) bleDidConnect{
    [self.spinner stopAnimating];
    [connectButton setTitle:@"Disconnect" forState:UIControlStateNormal];
    [audioTinkPlayer play];
    UIImage *img = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"ModernEnlargerLogo" ofType:@"png"]];
    [logoView setImage:img];

}


-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    //NSData *d = [NSData dataWithBytes:data length:length];
    //NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
   [self timerTenthTick:nil];


}


-(void) bleDidUpdateRSSI:(NSNumber *)rssi
{
    //self.labelRSSI.text = rssi.stringValue;
}



- (void)viewDidLoad
{
    [super viewDidLoad];


    //BLEShield Stuff
    bleShield = [[BLE alloc] init];
    [bleShield controlSetup:1];
    bleShield.delegate = self;
    
    
    // Initialize variables
    timeInSeconds = 0;
    contrastInUnits = 0;
    redOnOff = 0;
    focusOnOff = 0;
    exposeButtonOnOff = NO;
    countToTen = 0;
    timeInSecondsString = [NSMutableString stringWithFormat:@"0000"];
   
    // Initialize User Preferences
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"YES" forKey:@"metronome"];
    [prefs setObject:@"NO" forKey:@"precisionContrast"];
    [prefs setObject:@"NO" forKey:@"precisionTiming"];
    [prefs setObject:@"NO" forKey:@"delayStartOn"];
    [prefs setObject:@"LO" forKey:@"redDimmer"];
    [prefs setObject:@"HI" forKey:@"brightness"];
   
    
    // Set up Tink audio sound
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Tink.aiff", [[NSBundle mainBundle] resourcePath]]];
    NSError *error;
	audioTinkPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioTinkPlayer.numberOfLoops = 0;
    
    
    //Set up Beep audio sound
    NSURL *url2 = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Beep.aiff", [[NSBundle mainBundle] resourcePath]]];
    NSError *error2;
	audioBeepPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url2 error:&error2];
	audioBeepPlayer.numberOfLoops = 0;
    

    //Create custom buttons
    exposeButton.layer.borderColor = [UIColor redColor].CGColor;
    [[exposeButton layer] setCornerRadius:14.0f];
    [[exposeButton layer] setBorderWidth:8.0f];
    [exposeButton setBackgroundColor:[UIColor blackColor]];
    [exposeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [exposeButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    focusButton.layer.borderColor = [UIColor redColor].CGColor;
    [[focusButton layer] setCornerRadius:8.0f];
    [[focusButton layer] setBorderWidth:3.0f];
    [focusButton setBackgroundColor:[UIColor blackColor]];
    [focusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [focusButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    resetButton.layer.borderColor = [UIColor redColor].CGColor;
    [[resetButton layer] setCornerRadius:8.0f];
    [[resetButton layer] setBorderWidth:3.0f];
    [resetButton setBackgroundColor:[UIColor blackColor]];
    [resetButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    redButton.layer.borderColor = [UIColor redColor].CGColor;
    [[redButton layer] setCornerRadius:8.0f];
    [[redButton layer] setBorderWidth:3.0f];
    [redButton setBackgroundColor:[UIColor blackColor]];
    [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [redButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    timeUpButton.layer.borderColor = [UIColor redColor].CGColor;
    [[timeUpButton layer] setCornerRadius:8.0f];
    [[timeUpButton layer] setBorderWidth:3.0f];
    [timeUpButton setBackgroundColor:[UIColor blackColor]];
    [timeUpButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [timeUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    timeDownButton.layer.borderColor = [UIColor redColor].CGColor;
    [[timeDownButton layer] setCornerRadius:8.0f];
    [[timeDownButton layer] setBorderWidth:3.0f];
    [timeDownButton setBackgroundColor:[UIColor blackColor]];
    [timeDownButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [timeDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    
    ContrastUpButton.layer.borderColor = [UIColor redColor].CGColor;
    [[ContrastUpButton layer] setCornerRadius:8.0f];
    [[ContrastUpButton layer] setBorderWidth:3.0f];
    [ContrastUpButton setBackgroundColor:[UIColor blackColor]];
    [ContrastUpButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [ContrastUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    ContrastDownButton.layer.borderColor = [UIColor redColor].CGColor;
    [[ContrastDownButton layer] setCornerRadius:8.0f];
    [[ContrastDownButton layer] setBorderWidth:3.0f];
    [ContrastDownButton setBackgroundColor:[UIColor blackColor]];
    [ContrastDownButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [ContrastDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];   

    showInfo.layer.borderColor = [UIColor redColor].CGColor;
    [[showInfo layer] setCornerRadius:8.0f];
    [[showInfo layer] setBorderWidth:3.0f];
    [showInfo setBackgroundColor:[UIColor blackColor]];
    [showInfo setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [showInfo setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    connectButton.layer.borderColor = [UIColor redColor].CGColor;
    [[connectButton layer] setCornerRadius:8.0f];
    [[connectButton layer] setBorderWidth:3.0f];
    [connectButton setBackgroundColor:[UIColor blackColor]];
    [connectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [connectButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    backgroundRectangle1.layer.borderColor = [UIColor redColor].CGColor;
    [[backgroundRectangle1 layer] setCornerRadius:8.0f];
    [[backgroundRectangle1 layer] setBorderWidth:3.0f];

    backgroundRectangle2.layer.borderColor = [UIColor redColor].CGColor;
    [[backgroundRectangle2 layer] setCornerRadius:8.0f];
    [[backgroundRectangle2 layer] setBorderWidth:3.0f];
   
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(blc2FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];


    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *precisionTiming = [prefs stringForKey:@"precisionTiming"];


    
    //format the timefield correctly when precisionTiming is changed
    if (([precisionTiming isEqual: @"YES"]) && (timeInTenthSeconds <999))
        [timeField setText:[NSString stringWithFormat: @"%i.%i", timeInTenthSeconds/10, timeInTenthSeconds % 10]];
    else{
        timeInTenthSeconds = timeInTenthSeconds/10;
        timeInTenthSeconds = timeInTenthSeconds*10;
        [timeField setText:[NSString stringWithFormat: @"%i", timeInTenthSeconds/10]];
    }
    
    //set the timeInSecondsString properly to reflect the updated timeInTenthSeconds
    if (timeInTenthSeconds < 10) timeInSecondsString = [NSMutableString stringWithFormat: @"000%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=10 && timeInSeconds <100) timeInSecondsString = [NSMutableString stringWithFormat: @"00%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=100 && timeInTenthSeconds <1000) timeInSecondsString = [NSMutableString stringWithFormat: @"0%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=1000) timeInSecondsString = [NSMutableString stringWithFormat: @"%i", timeInTenthSeconds];
    

}



- (IBAction)showInfo:(id)sender
{    
    blc2FlipsideViewController *controller = [[blc2FlipsideViewController alloc] initWithNibName:@"blc2FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
