//
//  PuzzleBoardViewController.h
//  Slize
//
//  Created by Ikhsan Assaat on 5/11/11.
//  Copyright 2011 Beetlebox. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "IAPuzzleBoardView.h"

@interface PuzzleBoardViewController : UIViewController <IAPuzzleBoardDelegate> {
    UIImage *gambar;
    IAPuzzleBoardView *board;
    UIButton *startButton;
    IBOutlet UISegmentedControl *boardSize;
    
    NSInteger step;
    AVAudioPlayer *clickSound;
    AVAudioPlayer *slideSound;
}

@property (nonatomic, retain) IBOutlet IAPuzzleBoardView *board;
@property (nonatomic, retain) IBOutlet UIButton *startButton;

/*
 Well, it's for... starting this puzzle game. What else?
 Untuk... memulai bermain puzzle lah.
*/
- (IBAction)start:(id)sender;

@end
