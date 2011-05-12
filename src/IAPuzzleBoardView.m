//
//  IAPuzzleBoardView.m
//  Slizzle
//
//  Created by Ikhsan Assaat on 5/10/11.
//  Copyright 2011 Beetlebox All rights reserved.
//

#import "IAPuzzleBoardView.h"
#import "IAPuzzleBoard.h"
#import "UIImage+Resize.h"

@interface IAPuzzleBoardView (Private)
- (void)moveTile:(UIImageView *)tile withDirection:(int)direction;
- (void)movingThisTile:(CGPoint)tilePoint;
- (void)drawPuzzle;
@end

@implementation IAPuzzleBoardView;

@synthesize tiles = _tiles;
@synthesize board = _board;
@synthesize delegate = _delegate;
@synthesize tileWidth = _tileWidth;
@synthesize tileHeight = _tileHeight;

/*
 Initialize this view with image, size of the board, and frame size in the controller. This initializer can be used when you make this using code not from IB. (image, size, frame)
 Inisialisasi view ini dengan image, ukuran papan dan ukuran frame di controller. Inisialisasi ini digunakan bila membuat dengan kode, bukan IB. (image, size, frame)
*/
- (id)initWithImage:(UIImage *)image andSize:(NSInteger)size withFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        IAPuzzleBoard *board = [[IAPuzzleBoard alloc] initWithSize:size];
        self.board = board;
        [board release];
        
        UIImage *resizedImage = [image resizedImageWithSize:frame.size];
        _tileWidth = resizedImage.size.width/size;
        _tileHeight = resizedImage.size.height/size;
        
        _tiles = [[NSMutableArray alloc] init];
        for (int i = 0; i < _board.size; i++) {
            for (int j = 0; j < _board.size; j++) {
                if ((i == _board.size) && (j == _board.size)) {
                    continue;
                }
                
                CGRect frame = CGRectMake(_tileWidth*j, _tileHeight*i, _tileWidth, _tileHeight);
                
                CGImageRef tileImageRef = CGImageCreateWithImageInRect(resizedImage.CGImage, frame);
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

/*
 Method to start playing the puzzle. This should be used when you initiliazed the board with IB (image, size)
 Prosedur untuk memulai memainkan puzzle. Ini digunakakn ketika papan dibuat menggunakan IB. (image, size)
*/
- (void)playWithImage:(UIImage *)image andSize:(NSInteger)size {
    IAPuzzleBoard *board = [[IAPuzzleBoard alloc] initWithSize:size];
    self.board = board;
    [board release];
    
    UIImage *resizedImage = [image resizedImageWithSize:self.frame.size];
    _tileWidth = resizedImage.size.width/size;
    _tileHeight = resizedImage.size.height/size;
    
    _tiles = [[NSMutableArray alloc] init];
    for (int i = 0; i < _board.size; i++) {
        for (int j = 0; j < _board.size; j++) {
            if ((i == _board.size) && (j == _board.size)) {
                continue;
            }
            
            CGRect frame = CGRectMake(_tileWidth*j, _tileHeight*i, _tileWidth, _tileHeight);
            
            CGImageRef tileImageRef = CGImageCreateWithImageInRect(resizedImage.CGImage, frame);
            UIImage *tileImage = [UIImage imageWithCGImage:tileImageRef];
            
            UIImageView *tileImageView = [[UIImageView alloc] initWithImage:tileImage];
            CGImageRelease(tileImageRef);
            
            [_tiles addObject:tileImageView];
            [tileImageView release];
        }
    }
    
    [self play];
}

/*
 Shuffle the board (SHUFFLE_TIMES) times, and then draw the puzzle board.
 Acak papan sebanyak SHUFFLE_TIMES kali, dan gambar papan puzzle.
*/
- (void)play {
    [_board shuffle:SHUFFLE_TIMES];
    [self drawPuzzle];
}

/*
 Method for drawing the coresponding tiles from the board model
 Prosedur untuk menggambar petak-petak yang bersesuaian dengan board model
*/
- (void)drawPuzzle {
    for (id view in self.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 1; i <= _board.size; i++) {
        for (int j = 1; j <= _board.size; j++) {
            NSNumber *value = [_board getTileAtPoint:CGPointMake(i, j)];
            
            if ([value intValue] == 0) {
                continue;
            }
            
            UIImageView *tileImageView = [_tiles objectAtIndex:[value intValue]-1];
            
            CGRect frame = CGRectMake(_tileWidth*(i-1), _tileHeight*(j-1), _tileWidth, _tileHeight);
            tileImageView.frame = frame;
            
            [self addSubview:tileImageView];
        }
    }
}

/*
 Method for moving the tile with animation (tile, direction)
 Prosedur untuk menggerakkan petak dengan animasi (tile, direction)
*/
- (void)moveTile:(UIImageView *)tile withDirection:(int)direction {
    CGRect newFrame;
    switch (direction) {
        case UP :
            newFrame = CGRectMake(tile.frame.origin.x, tile.frame.origin.y-_tileHeight, tile.frame.size.width, tile.frame.size.height);
            break;            
        case RIGHT :
            newFrame = CGRectMake(tile.frame.origin.x+_tileWidth, tile.frame.origin.y, tile.frame.size.width, tile.frame.size.height);
            break;            
        case DOWN :
            newFrame = CGRectMake(tile.frame.origin.x, tile.frame.origin.y+_tileHeight, tile.frame.size.width, tile.frame.size.height);
            break;            
        case LEFT :
            newFrame = CGRectMake(tile.frame.origin.x-_tileWidth, tile.frame.origin.y, tile.frame.size.width, tile.frame.size.height);
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
                             
                             if(self.delegate) {
                                 [self.delegate puzzleFinished];
                             }
                         }
                     }];    
}

/*
 Method for moving the tile, if its valid then move the tile in the model and view. (tilePoint)
 Prosedur untuk menggerakkan petak, bila valid maka gerakkan petak tersebut di model dan view-nya. (tilePoint)
*/
- (void)movingThisTile:(CGPoint)tilePoint {
    UIImageView *tileView = nil;
    CGRect checkRect = CGRectMake((tilePoint.x-1)*_tileWidth + 1, 
                                  (tilePoint.y-1)*_tileHeight + 1, 
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

/*
 Method to check every touch
*/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint checkPoint = [touch locationInView:self];
    int x = (checkPoint.x / _tileWidth) + 1;
    int y = (checkPoint.y / _tileHeight) + 1;
    
    [self movingThisTile:CGPointMake(x, y)];    
}

/*
 Overiding dealloc method
*/
- (void)dealloc
{
    self.delegate = nil;
    self.tiles = nil;
    self.board = nil;
    [super dealloc];
}

@end
