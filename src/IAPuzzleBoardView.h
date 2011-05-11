//
//  IAPuzzleBoardView.h
//  Slizzle
//
//  Created by Ikhsan Assaat on 5/10/11.
//  Copyright 2011 Beetlebox All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IAPuzzleBoardDelegate.h"

@class IAPuzzleBoard;

@interface IAPuzzleBoardView : UIView {
    id <IAPuzzleBoardDelegate> delegate;
    CGFloat _tileSize;
    IAPuzzleBoard *_board;
    NSMutableArray *_tiles;
}

@property (retain) IBOutlet id <IAPuzzleBoardDelegate> delegate;
@property CGFloat tileSize;
@property (nonatomic, retain) IAPuzzleBoard *board;
@property (nonatomic, retain) NSMutableArray *tiles;


- (id)initWithImage:(UIImage *)image andSize:(NSInteger)size withFrame:(CGRect)frame;
- (void)playWithImage:(UIImage *)image andSize:(NSInteger)size;
- (void)play;

@end


