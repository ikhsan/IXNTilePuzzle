//
//  PuzzleBoardViewController.h
//  Slize
//
//  Created by Ikhsan Assaat on 5/11/11.
//  Copyright 2011 Beetlebox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAPuzzleBoardDelegate.h"
#import "IAPuzzleBoardView.h"

@interface PuzzleBoardViewController : UIViewController <IAPuzzleBoardDelegate> {
    UIImage *gambar;
    IAPuzzleBoardView *board;
    UIButton *startButton;
}

@property (nonatomic, retain) IBOutlet IAPuzzleBoardView *board;
@property (nonatomic, retain) IBOutlet UIButton *startButton;

- (IBAction)start:(id)sender;

@end
