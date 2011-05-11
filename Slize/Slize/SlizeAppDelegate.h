//
//  SlizeAppDelegate.h
//  Slize
//
//  Created by Ikhsan Assaat on 5/10/11.
//  Copyright 2011 Beetlebox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PuzzleBoardViewController;

@interface SlizeAppDelegate : NSObject <UIApplicationDelegate> {
    PuzzleBoardViewController *pbvc;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
