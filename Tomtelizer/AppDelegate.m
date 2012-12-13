//
//  AppDelegate.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/1/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "AppDelegate.h"
#import "XmasHatViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    return YES;
}

//http://stackoverflow.com/questions/3213262/consequence-of-importing-appdelegate-in-a-class-and-the-same-class-in-appdelegat
- (void)registerXmasHatViewController:(XmasHatViewController *)controller
{
    xhvController = (XmasHatViewController *)controller;
    NSLog(@"registered xmashatviewcontroller %@", xhvController);
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    NSLog(@"App entered background!");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
        NSLog(@"App entered foreground!");
    if(xhvController!=NULL){
        [xhvController reloadPerodicalImageLoaderImages];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    NSLog(@"applicationDidBecomeActive!");
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    NSLog(@"applicationWillTerminate!");
}

@end
