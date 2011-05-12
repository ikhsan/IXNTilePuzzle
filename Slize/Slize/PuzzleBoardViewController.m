//
//  PuzzleBoardViewController.m
//  Slize
//
//  Created by Ikhsan Assaat on 5/11/11.
//  Copyright 2011 Beetlebox. All rights reserved.
//

#import "PuzzleBoardViewController.h"

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
    
    // set the image
    // tentukan gambar
    UIImage *_gambar = [UIImage imageNamed:@"ff.png"];
    gambar = [_gambar retain];
    
    // show the full image first in the view
    // tunjukkan dulu gambar penuh di view  
    UIImageView *fullImage = [[UIImageView alloc] initWithImage:gambar];
    fullImage.frame = board.bounds;
    [board addSubview:fullImage];
    [fullImage release];
}

- (void)viewDidUnload {
    [self setBoard:nil];
    [self setStartButton:nil];
    [super viewDidUnload];
}

#pragma mark - puzzle board view delegate method
/*
 This delegate method is fired when the puzzle board is finished
 Prosedur delegasi ini dipanggil bila papan tersebut telah selesai dimainkan
*/
- (void)puzzleFinished {
    // This method is fired every time the board is finished, you can make this method doing whatever you want. Mine, it does two simple animation :
    // 1. Set the alpha of every tile in the board to 0.0, upon completion remove every tiles, add the full image with 0.0 alpha and then start the second animation
    // 2. Set the alpha of the full image to 1.0, upon completion set the view so that it can't interact, and set the label to 'start'
    //
    // Prosedur ini akan terpanggil ketika papan sudah selesai dimainkan. Anda bisa membuat prosedur ini melakukan apa saja. Punya saya, hanya melakukan dua animasi sederhana :
    // 1. Atur alpha dari setiap petak menjadi 0.0 dengan animasi, selesai animasi, hapus setiap petak, tambahkan gambar penuh ke dalam papan dengan alpha 0.0 dan mulai animasi berikutnya
    // 2. Atur alpha dari gambar menjadi 1.0, setelah animasi selesai atur view agar tidak bisa berinteraksi dan ubah label teks menjadi 'start' 
    [UIView animateWithDuration:.4 
                     animations:^{
                         // set the alpha of every tile to 0.0
                         // atur alpha tiap petak menjadi 0.0
                         for (id view in board.subviews) {
                             [view setAlpha:0.0];
                         }                     
                     } 
                     completion:^(BOOL finished){
                         // remove every tile from view
                         // hapus semua petak dari view
                         for (id view in board.subviews) {
                             [view removeFromSuperview];
                         }
                         
                         // add the full image with 0.0 alpha in view
                         // tambahkan gambar penuh dengan alpha 0.0 ke dalam view
                         UIImageView *fullImage = [[UIImageView alloc]initWithImage:gambar];
                         fullImage.frame = board.bounds;
                         fullImage.alpha = 0.0;
                         [board addSubview:fullImage];
                         
                         [UIView animateWithDuration:.4 
                                               delay:0.0 
                                             options:UIViewAnimationCurveEaseInOut 
                                          animations:^{
                                              // set the alpha of full image to 1.0
                                              // atur alpha gambar penuh tersebut menjadi 1.0
                                              fullImage.alpha = 1.0;
                                          } 
                                          completion:^(BOOL finished) {
                                              // set the view interaction and set the label text
                                              // atur status interaksi view dan teks dari label
                                              [board setUserInteractionEnabled:NO];
                                              [startButton setTitle:@"Start" forState:UIControlStateNormal];
                                          }];
                     }];    
}


#pragma mark - IB Actions
/*
 Well, it's for... starting this puzzle game. What else?
 Untuk... memulai bermain puzzle lah.
*/
- (IBAction)start:(id)sender {
    // set the view so that it can interact with touches
    // atur view agar bisa interaksi dengan sentuhan
    [board setUserInteractionEnabled:YES];
    
    // set the label text to 'reset'
    // ubah teks label menjadi 'reset'
    [startButton setTitle:@"Reset" forState:UIControlStateNormal];
    
    // initialize the board, lets play!
    // atur papan, mari bermain!
    [board playWithImage:gambar andSize:BOARD_SIZE];
}

@end
