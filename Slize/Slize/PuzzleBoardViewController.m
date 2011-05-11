//
//  PuzzleBoardViewController.m
//  Slize
//
//  Created by Ikhsan Assaat on 5/11/11.
//  Copyright 2011 Beetlebox. All rights reserved.
//

#import "PuzzleBoardViewController.h"
#import "UIImage+Resize.h"

@implementation PuzzleBoardViewController
@synthesize board;
@synthesize startButton;

- (void)dealloc {
    [board release];
    [startButton release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.view.frame = frame;
    
    UIImage *_gambar = [[UIImage imageNamed:@"ff.png"] resizedImageWithSize:board.frame.size];
    gambar = [_gambar retain];
    
    UIImageView *fullImage = [[UIImageView alloc] initWithImage:gambar];
    [board addSubview:fullImage];
    [fullImage release];
}

- (void)viewDidUnload {
    [self setBoard:nil];
    [self setStartButton:nil];
    [super viewDidUnload];
}

#pragma mark - Create puzzle

- (IBAction)start:(id)sender {
    [board setUserInteractionEnabled:YES];
    [board playWithImage:gambar andSize:SHUFFLE_SIZE];
    [startButton setTitle:@"Reset" forState:UIControlStateNormal];
}

#pragma mark - puzzle board view delegate method

- (void)puzzleFinished {
    [UIView animateWithDuration:.4 
                     animations:^{
                         for (id view in board.subviews) {
                             [view setAlpha:0.0];
                         }                     
                     } 
                     completion:^(BOOL finished){
                         for (id view in board.subviews) {
                             [view removeFromSuperview];
                         }
                         
                         UIImageView *fullImage = [[UIImageView alloc]initWithImage:gambar];
                         fullImage.frame = board.bounds;
                         fullImage.alpha = 0.0;
                         [board addSubview:fullImage];
                         
                         [UIView animateWithDuration:.4 
                                               delay:0.0 
                                             options:UIViewAnimationCurveEaseInOut 
                                          animations:^{
                                              fullImage.alpha = 1.0;
                                          } 
                                          completion:^(BOOL finished) {
                                              [board setUserInteractionEnabled:NO];
                                              [startButton setTitle:@"Start" forState:UIControlStateNormal];
                                          }];
                     }];    
}

@end
