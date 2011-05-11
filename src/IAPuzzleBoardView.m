//
//  IAPuzzleBoardView.m
//  Slizzle
//
//  Created by Ikhsan Assaat on 5/10/11.
//  Copyright 2011 Beetlebox All rights reserved.
//

#import "IAPuzzleBoardView.h"
#import "IAPuzzleBoard.h"

@interface IAPuzzleBoardView (Private)
- (void)moveTile:(UIImageView *)tile withDirection:(int)direction;
- (void)movingThisTile:(CGPoint)tilePoint;
- (void)drawPuzzle;
@end

@implementation IAPuzzleBoardView;

@synthesize tiles = _tiles;
@synthesize board = _board;
@synthesize tileSize = _tileSize;
@synthesize delegate;

- (id)initWithImage:(UIImage *)image andSize:(NSInteger)size withFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        IAPuzzleBoard *board = [[IAPuzzleBoard alloc] initWithSize:size];
        self.board = board;
        [board release];
        
        _tileSize = image.size.width/size;
        
        _tiles = [[NSMutableArray alloc] init];
        for (int i = 0; i < _board.size; i++) {
            for (int j = 0; j < _board.size; j++) {
                if ((i == _board.size) && (j == _board.size)) {
                    continue;
                }
                
                CGRect frame = CGRectMake(_tileSize*j, _tileSize*i, _tileSize, _tileSize);
                
                CGImageRef tileImageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
                UIImage *tileImage = [UIImage imageWithCGImage:tileImageRef];
                
                UIImageView *tileImageView = [[UIImageView alloc] initWithImage:tileImage];
                CGImageRelease(tileImageRef);
                
                [_tiles addObject:tileImageView];
                [tileImageView release];
            }
        }
    }    
    return self;
}

- (void)playWithImage:(UIImage *)image andSize:(NSInteger)size {
    IAPuzzleBoard *board = [[IAPuzzleBoard alloc] initWithSize:size];
    self.board = board;
    [board release];
    
    _tileSize = image.size.width/size;
    
    _tiles = [[NSMutableArray alloc] init];
    for (int i = 0; i < _board.size; i++) {
        for (int j = 0; j < _board.size; j++) {
            if ((i == _board.size) && (j == _board.size)) {
                continue;
            }
            
            CGRect frame = CGRectMake(_tileSize*j, _tileSize*i, _tileSize, _tileSize);
            
            CGImageRef tileImageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
            UIImage *tileImage = [UIImage imageWithCGImage:tileImageRef];
            
            UIImageView *tileImageView = [[UIImageView alloc] initWithImage:tileImage];
            CGImageRelease(tileImageRef);
            
            [_tiles addObject:tileImageView];
            [tileImageView release];
        }
    }
    
    [self play];
    
    NSLog(@"delegate %@", delegate);
}

- (void)play {
    [_board shuffle:SHUFFLE_TIMES];
    [self drawPuzzle];
}

- (void)drawPuzzle {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 1; i <= _board.size; i++) {
        for (int j = 1; j <= _board.size; j++) {
            NSNumber *value = [_board getTileAtPoint:CGPointMake(i, j)];
            
            if ([value intValue] == 0) {
                continue;
            }
            
            UIImageView *tileImageView = [_tiles objectAtIndex:[value intValue]-1];
            
            CGRect frame = CGRectMake(_tileSize*(i-1), _tileSize*(j-1), _tileSize, _tileSize);
            tileImageView.frame = frame;
            
            [self addSubview:tileImageView];
        }
    }
    
    //NSLog(@"%@", _board);
}

- (void)moveTile:(UIImageView *)tile withDirection:(int)direction {
    
    //NSLog(@"delegate %@", delegate);
    
    
    CGRect newFrame;
    switch (direction) {
        case UP :
            newFrame = CGRectMake(tile.frame.origin.x, tile.frame.origin.y-_tileSize, tile.frame.size.width, tile.frame.size.height);
            break;            
        case RIGHT :
            newFrame = CGRectMake(tile.frame.origin.x+_tileSize, tile.frame.origin.y, tile.frame.size.width, tile.frame.size.height);
            break;            
        case DOWN :
            newFrame = CGRectMake(tile.frame.origin.x, tile.frame.origin.y+_tileSize, tile.frame.size.width, tile.frame.size.height);
            break;            
        case LEFT :
            newFrame = CGRectMake(tile.frame.origin.x-_tileSize, tile.frame.origin.y, tile.frame.size.width, tile.frame.size.height);
            break;            
        default:
            break;
    }
    
    [UIView animateWithDuration:.1 
                          delay:0.0 
                        options:UIViewAnimationCurveEaseOut 
                     animations:^{tile.frame = newFrame;} 
                     completion:^(BOOL finished){
                         if ((finished) && [_board isBoardFinished]) {
                             NSLog(@"board is finished");
                             
                             if(delegate) {
                                 [delegate puzzleFinished];
                             }
                         }
                     }];    
}

- (void)movingThisTile:(CGPoint)tilePoint {
    UIImageView *tileView = nil;
    
    CGRect checkRect = CGRectMake((tilePoint.x-1)*_tileSize + 10, 
                                  (tilePoint.y-1)*_tileSize + 10, 
                                  1.0, 1.0);
    
    for (UIImageView *enumTile in _tiles) {
        if  (CGRectIntersectsRect(enumTile.frame, checkRect)) {
            tileView = enumTile;
            break;
        }
    }
    
    int move = [_board validMove:tilePoint];
    
    CGPoint neighborPoint;
    switch (move) {
        case UP:
            neighborPoint = CGPointMake(tilePoint.x, tilePoint.y-1);
            [_board swapTileAtPoint:tilePoint withPoint:neighborPoint];
            [self moveTile:tileView withDirection:UP];
            break;
        case RIGHT:
            neighborPoint = CGPointMake(tilePoint.x+1, tilePoint.y);
            [_board swapTileAtPoint:tilePoint withPoint:neighborPoint];
            [self moveTile:tileView withDirection:RIGHT];
            break;
        case DOWN:
            neighborPoint = CGPointMake(tilePoint.x, tilePoint.y+1);
            [_board swapTileAtPoint:tilePoint withPoint:neighborPoint];
            [self moveTile:tileView withDirection:DOWN];
            break;
        case LEFT:
            neighborPoint = CGPointMake(tilePoint.x-1, tilePoint.y);
            [_board swapTileAtPoint:tilePoint withPoint:neighborPoint];
            [self moveTile:tileView withDirection:LEFT];
            break;
        default:
            NSLog(@"the tile can't be moved");
            break;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint checkPoint = [touch locationInView:self];
    int x = (checkPoint.x / _tileSize) + 1;
    int y = (checkPoint.y / _tileSize) + 1;
    
    [self movingThisTile:CGPointMake(x, y)];    
}

- (void)dealloc
{
    self.delegate = nil;
    self.tiles = nil;
    self.board = nil;
    [super dealloc];
}

@end
