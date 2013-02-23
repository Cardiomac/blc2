//
//  blc2AppDelegate.h
//  blc2
//
//  Created by Cemil Purut on 11/26/12.
//  Copyright (c) 2012 Cemil Purut. All rights reserved.
//

#import <UIKit/UIKit.h>

@class blc2MainViewController;

@interface blc2AppDelegate : UIResponder <UIApplicationDelegate>{
    bool timeInTenthsYesNo;

}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) blc2MainViewController *mainViewController;

@end
