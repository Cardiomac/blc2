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



- (IBAction)exposeButtonPressed:(id)sender{
    
   
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *metronomeOn = [prefs stringForKey:@"metronome"];
    NSString *delayStartOn = [prefs stringForKey:@"delayStart"];

    
    if (exposeButtonOnOff == NO){
        exposeButtonOnOff = YES;
        
        redOnOff = 0;
        [redButton setBackgroundColor:[UIColor blackColor]];
        [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

        
        //turn off the focus button
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
        
        [self bleShieldSendNull:nil];

        exposeButtonOnOff = NO;
        [exposeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [exposeButton setTitle:@"Start" forState:UIControlStateNormal];
        [exposeButton setBackgroundColor:[UIColor blackColor]];
        if ([metronomeOn isEqual: @"YES"]) [audioBeepPlayer play];
        
    }
}


-(void)bleShieldSendData:(id)sender{
    
    NSString *s;
    NSData *d;
    
    timeCountDown = timeInTenthSeconds;
    countToTen = 10;
    [self timerTenthTick:nil];

    
    s = [NSString stringWithFormat:@"000%@000%@%@\r\n",timeInSecondsString, greenBrightnessString, blueBrightnessString];
    d = [s dataUsingEncoding:NSUTF8StringEncoding];
    [bleShield write:d];
    
}

-(void)bleShieldSendFiveSecRed:(id)sender{
    
    NSString *s;
    NSData *d;
    
    timeCountDown = 50;
    countToTen = 10;
    [self timerTenthTick:nil];
    
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


- (void)timerTenthTick:(id)sender{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *metronomeOn = [prefs stringForKey:@"metronome"];
    NSString *precisionTiming = [prefs stringForKey:@"precisionTiming"];
   
    
    if (timeCountDown <= 0){
        exposeButtonOnOff = NO;
        countToTen=0;
        [exposeButton setBackgroundColor:[UIColor blackColor]];
        [exposeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [exposeButton setTitle:@"Start" forState:UIControlStateNormal];
        if ([metronomeOn isEqual: @"YES"])[audioBeepPlayer play];
    }
    
    else{
        if (exposeButtonOnOff == YES){
            if((timeInTenthSeconds > 999) || ([precisionTiming isEqual: @"NO"]))[exposeButton setTitle:[NSString stringWithFormat: @"%i", (timeCountDown+9)/10] forState:UIControlStateNormal];
            else[exposeButton setTitle:[NSString stringWithFormat: @"%i.%i", timeCountDown/10, timeCountDown%10] forState:UIControlStateNormal];
        
            if (([metronomeOn isEqual: @"YES"]) && (countToTen == 10)){
                [audioTinkPlayer play];
                countToTen = 0;
            }
            timeCountDown=timeCountDown-1;
            countToTen = countToTen+1;
        }
    }
}



- (IBAction)contrastUp:(id)sender {
    
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
    
    // Format the contrastField text string properly
    integerContrastInUnits = contrastInUnits*10;
    if (integerContrastInUnits%10 == 0){
        [contrastField setText:[NSString stringWithFormat: @"%1.0f", contrastInUnits]];
    }
    else [contrastField setText:[NSString stringWithFormat: @"%1.1f", contrastInUnits]];
    
    // Calculate the Green LED Brightness and format the greenBrightness string properly
    greenBrightness = (5-contrastInUnits)*51;
    if (greenBrightness<10)greenBrightnessString = [NSString stringWithFormat:@"00%i", greenBrightness];
    if (greenBrightness>=10 && greenBrightness<100) greenBrightnessString = [NSString stringWithFormat:@"0%i", greenBrightness];
    if (greenBrightness>=100 && greenBrightness<1000) greenBrightnessString = [NSString stringWithFormat:@"%i", greenBrightness];
    
    // Calculate the Blue LED Brightness and format the blueBrightness string properly
    blueBrightness = (contrastInUnits*51);
    if (blueBrightness<10)blueBrightnessString = [NSString stringWithFormat:@"00%i", blueBrightness];
    if (blueBrightness>=10 && blueBrightness<100) blueBrightnessString = [NSString stringWithFormat:@"0%i", blueBrightness];
    if (blueBrightness>=100 && blueBrightness<1000) blueBrightnessString = [NSString stringWithFormat:@"%i", blueBrightness];
}


- (IBAction)contrastDown:(id)sender {
    
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
    
    // Format the contrastField text string properly
    integerContrastInUnits=contrastInUnits*10;
    if (integerContrastInUnits%10 == 0)[contrastField setText:[NSString stringWithFormat: @"%1.0f", contrastInUnits]];
    else [contrastField setText:[NSString stringWithFormat: @"%1.1f", contrastInUnits]];
    
    // Calculate the Green LED Brightness and format the greenBrightness string properly
    greenBrightness = (5-contrastInUnits)*51;
    if (greenBrightness<10)greenBrightnessString = [NSString stringWithFormat:@"00%i", greenBrightness];
    if (greenBrightness>=10 && greenBrightness<100) greenBrightnessString = [NSString stringWithFormat:@"0%i", greenBrightness];
    if (greenBrightness>=100 && greenBrightness<1000) greenBrightnessString = [NSString stringWithFormat:@"%i", greenBrightness];
    
    // Calculate the Blue LED Brightness and format the blueBrightness string properly
    blueBrightness = contrastInUnits*51;
    if (blueBrightness<10)blueBrightnessString = [NSString stringWithFormat:@"00%i", blueBrightness];
    if (blueBrightness>=10 && blueBrightness<100) blueBrightnessString = [NSString stringWithFormat:@"0%i", blueBrightness];
    if (blueBrightness>=100 && blueBrightness<1000) blueBrightnessString = [NSString stringWithFormat:@"%i", blueBrightness];
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


- (void) timeUp:(id)sender {
    
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
    
    if (timeInTenthSeconds < 10) timeInSecondsString = [NSString stringWithFormat: @"000%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=10 && timeInSeconds <100) timeInSecondsString = [NSString stringWithFormat: @"00%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=100 && timeInTenthSeconds <1000) timeInSecondsString = [NSString stringWithFormat: @"0%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=1000) timeInSecondsString = [NSString stringWithFormat: @"%i", timeInTenthSeconds];
}


- (void) timeDown:(id)sender {
    
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
    
    if (timeInTenthSeconds < 10)timeInSecondsString = [NSString stringWithFormat: @"000%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=10 && timeInTenthSeconds <100) timeInSecondsString = [NSString stringWithFormat: @"00%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=100 && timeInTenthSeconds <1000) timeInSecondsString = [NSString stringWithFormat: @"0%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=1000) timeInSecondsString = [NSString stringWithFormat: @"%i", timeInTenthSeconds];
}


- (IBAction)redButtonPressed:(id)sender {
    
    NSString *s;
    NSData *d;
    
    if (![timer isValid]){  //button is active only when timer is inactive
        
        if (redOnOff == 0){
            redOnOff = 1;
            [redButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [redButton setBackgroundColor:[UIColor redColor]];
            
            //turn off the focus button
            focusOnOff = 0;
            [focusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [focusButton setBackgroundColor:[UIColor blackColor]];
            
            s = [NSString stringWithFormat:@"0023600%@000000\r\n", redBrightnessString];
            d = [s dataUsingEncoding:NSUTF8StringEncoding];
            [bleShield write:d];
        }
        
        else{
            redOnOff = 0;
            [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [redButton setBackgroundColor:[UIColor blackColor]];
           
            [self bleShieldSendNull:nil];

        }
    }
}

- (IBAction)focusButtonPressed:(id)sender {
    
    NSString *s;
    NSData *d;
    
    if (![timer isValid]){  //button is active only when timer is inactive
        
        if (focusOnOff == 0){
            focusOnOff = 1;
            [focusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [focusButton setBackgroundColor:[UIColor redColor]];
            
            //turn off the red (position) button
            redOnOff = 0;
            [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [redButton setBackgroundColor:[UIColor blackColor]];
            
            s = [NSString stringWithFormat:@"0011800255255255\r\n"];
            d = [s dataUsingEncoding:NSUTF8StringEncoding];
            [bleShield write:d];
        }
        
        else{
            focusOnOff = 0;
            [focusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [focusButton setBackgroundColor:[UIColor blackColor]];
            
            s = [NSString stringWithFormat:@"0000000000000000\r\n"];
            d = [s dataUsingEncoding:NSUTF8StringEncoding];
            [bleShield write:d];
        }
    }
}


- (IBAction)resetButtonPressed:(id)sender {
    
    NSString *s;
    NSData *d;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *metronomeOn = [prefs stringForKey:@"metronome"];

    
    contrastInUnits = 0;
    [contrastField setText:[NSString stringWithFormat: @"%1.0f", contrastInUnits]];
    timeInTenthSeconds = 0;
    timeCountDown = 0;
    timeInSecondsString = [NSString stringWithFormat: @"0000"];
    [timeField setText:[NSString stringWithFormat: @"%i", timeInTenthSeconds]];
    greenBrightness = 255;
    greenBrightnessString = [NSString stringWithFormat:@"255"];
    blueBrightness = 0;
    blueBrightnessString = [NSString stringWithFormat:@"000"];
    
    // Reset exposeButton
    exposeButtonOnOff = NO;
    [exposeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [exposeButton setTitle:@"Start" forState:UIControlStateNormal];
    [exposeButton setBackgroundColor:[UIColor blackColor]];
    if ([metronomeOn isEqual: @"YES"]) [audioBeepPlayer play];
    [timer invalidate];
    
    // Reset focusButton
    focusOnOff = 0;
    [focusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [focusButton setBackgroundColor:[UIColor blackColor]];
    
    //Reset redButton
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
    
    timeInSecondsString = [NSString stringWithFormat:@"0000"];
    redBrightnessString = [NSString stringWithFormat:@"064"];
    greenBrightnessString = [NSString stringWithFormat:@"255"];
    blueBrightnessString = [NSString stringWithFormat:@"000"];
   
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"NO" forKey:@"precisionTiming"];
    [prefs setObject:@"NO" forKey:@"precisionContrast"];
    [prefs setObject:@"YES" forKey:@"metronome"];
    [prefs setObject:@"LO" forKey:@"redDimmer"];


    //NSString *myString = [prefs stringForKey:@"precisionTiming"];
    //NSLog(@"tenthSeconds = %@", myString);
    
    
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
    
    //set up and invalidate timer once to reserve memory
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [timer invalidate];
    

    
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
    NSString *redDimmer = [prefs stringForKey:@"redDimmer"];


    
    //format the timefield correctly when precisionTiming is changed
    if (([precisionTiming isEqual: @"YES"]) && (timeInTenthSeconds <999))
        [timeField setText:[NSString stringWithFormat: @"%i.%i", timeInTenthSeconds/10, timeInTenthSeconds % 10]];
    else{
        timeInTenthSeconds = timeInTenthSeconds/10;
        timeInTenthSeconds = timeInTenthSeconds*10;
        [timeField setText:[NSString stringWithFormat: @"%i", timeInTenthSeconds/10]];
    }
    
    //set the timeInSecondsString properly to reflect the updated timeInTenthSeconds
    if (timeInTenthSeconds < 10) timeInSecondsString = [NSString stringWithFormat: @"000%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=10 && timeInSeconds <100) timeInSecondsString = [NSString stringWithFormat: @"00%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=100 && timeInTenthSeconds <1000) timeInSecondsString = [NSString stringWithFormat: @"0%i", timeInTenthSeconds];
    if (timeInTenthSeconds >=1000) timeInSecondsString = [NSString stringWithFormat: @"%i", timeInTenthSeconds];
    
    //Set the Red Brightness
    if ([redDimmer isEqual:@"HI"]) redBrightnessString = [NSString stringWithFormat:@"255"];
    else redBrightnessString = [NSString stringWithFormat:@"064"];

}

- (IBAction)showInfo:(id)sender
{    
    blc2FlipsideViewController *controller = [[blc2FlipsideViewController alloc] initWithNibName:@"blc2FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

@end
