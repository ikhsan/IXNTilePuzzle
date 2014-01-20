//
//  IXNViewController.m
//  IXNTilePuzzle
//
//  Created by Ikhsan Assaat on 1/10/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import "IXNViewController.h"
#import "IXNTilePuzzle.h"

@interface IXNViewController () <IXNTileBoardViewDelegate>

@end

@implementation IXNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self.board playWithImage:[UIImage imageNamed:@"pug.jpg"] size:4];
    [self.board shuffleTimes:100];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tile Board Delegate Method

- (void)tileBoardView:(IXNTileBoardView *)tileBoardView tileDidMove:(CGPoint)position
{
    NSLog(@"tile move : %@", [NSValue valueWithCGPoint:position]);
}

- (void)tileBoardViewDidFinished:(IXNTileBoardView *)tileBoardView
{
    NSLog(@"tile is completed");
}

@end
