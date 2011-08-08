//
//  SlizeAppDelegate.m
//  Slize
//
//  Created by Ikhsan Assaat on 5/10/11.
//  Copyright 2011 Beetlebox. All rights reserved.
//

#import "SlizeAppDelegate.h"

#import "PuzzleBoardViewController.h"

@implementation SlizeAppDelegate


@synthesize window=_window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    pbvc = [[PuzzleBoardViewController alloc] init];
    [self.window addSubview:pbvc.view];
    
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)dealloc {
    [pbvc release];
    [_window release];
    [super dealloc];
}

@end
