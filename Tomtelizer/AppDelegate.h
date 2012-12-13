//
//  AppDelegate.h
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/1/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XmasHatViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    XmasHatViewController * xhvController;
}

@property (strong, nonatomic) UIWindow *window;

- (void) registerXmasHatViewController: (XmasHatViewController *) controller;
@end
