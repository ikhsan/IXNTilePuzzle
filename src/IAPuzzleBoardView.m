//
//  IAPuzzleBoardView.m
//  Slizzle
//
//  Created by Ikhsan Assaat on 5/10/11.
//  Copyright 2011 Beetlebox All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "IAPuzzleBoardView.h"
#import "IAPuzzleBoard.h"
#import "UIImage+Resize.h"

@interface IAPuzzleBoardView (Private)
- (void)moveTile:(UIImageView *)tile withDirection:(int)direction;
- (void)movingThisTile:(CGPoint)tilePoint;
- (void)drawPuzzle;
- (void)dragging:(UIPanGestureRecognizer *)gestureRecognizer;
- (void)tapMove:(UITapGestureRecognizer *)tapRecognizer;
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
        /*IAPuzzleBoard *board = [[IAPuzzleBoard alloc] initWithSize:size];
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
        }*/
        [self playWithImage:image andSize:size];
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
            
            [tileImageView.layer setShadowColor:[UIColor grayColor].CGColor];
            [tileImageView.layer setShadowOpacity:0.7];
            [tileImageView.layer setShadowRadius:1.0];
            [tileImageView.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
            [tileImageView.layer setShadowPath:[[UIBezierPath bezierPathWithRect:tileImageView.layer.bounds] CGPath]];
            
            [_tiles addObject:tileImageView];
            [tileImageView release];
        }
    }
    
    // add dragging recognizer
    UIPanGestureRecognizer *dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
    [dragGesture setMaximumNumberOfTouches:1];
    [dragGesture setMinimumNumberOfTouches:1];
    [self addGestureRecognizer:dragGesture];
    [dragGesture release];
    
    // add tapping recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMove:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
    
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
 Method for moving the tile with animation (tile, direction)
 Prosedur untuk menggerakkan petak dengan animasi (tile, direction)
*/
- (void)moveTile:(UIImageView *)tile withDirection:(int)direction fromTilePoint:(CGPoint)tilePoint {
    int deltaX = 0;
    int deltaY = 0;
    
    switch (direction) {
        case UP : 
            deltaY = -1; break;
        case RIGHT : 
            deltaX = 1; break;
        case DOWN : 
            deltaY = 1; break;
        case LEFT : 
            deltaX = -1; break;
        default: break;
    }
    CGRect newFrame = CGRectMake((tilePoint.x + deltaX - 1) * _tileWidth, (tilePoint.y + deltaY - 1) * _tileHeight, tile.frame.size.width, tile.frame.size.height);
    
    [UIView animateWithDuration:.1 
                          delay:0.0 
                        options:UIViewAnimationCurveEaseOut 
                     animations:^{
                         tile.frame = newFrame;
                     } 
                     completion:^(BOOL finished){ 
                         [tile setTransform:CGAffineTransformIdentity];   
                         tile.frame = newFrame;
                         
                         if ((finished) && (direction != NONE)) {
                             [_board swapTileAtPoint:tilePoint withPoint:CGPointMake(tilePoint.x + deltaX, tilePoint.y + deltaY)];   
                             if (self.delegate) [self.delegate emptyTileMovedTo:tilePoint];
                             if ([_board isBoardFinished]) {
                                 NSLog(@"board is finished");
                                 
                                 if(self.delegate) {
                                     [self.delegate puzzleFinished];
                                 }
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
            if (self.delegate) [self.delegate emptyTileMovedTo:tilePoint];
            break;
        case RIGHT:
            neighborPoint = CGPointMake(tilePoint.x+1, tilePoint.y);
            [_board swapTileAtPoint:tilePoint withPoint:neighborPoint];
            [self moveTile:tileView withDirection:RIGHT];
            if (self.delegate) [self.delegate emptyTileMovedTo:tilePoint];
            break;
        case DOWN:
            neighborPoint = CGPointMake(tilePoint.x, tilePoint.y+1);
            [_board swapTileAtPoint:tilePoint withPoint:neighborPoint];
            [self moveTile:tileView withDirection:DOWN];
            if (self.delegate) [self.delegate emptyTileMovedTo:tilePoint];
            break;
        case LEFT:
            neighborPoint = CGPointMake(tilePoint.x-1, tilePoint.y);
            [_board swapTileAtPoint:tilePoint withPoint:neighborPoint];
            [self moveTile:tileView withDirection:LEFT];
            if (self.delegate) [self.delegate emptyTileMovedTo:tilePoint];
            break;
        default:
            NSLog(@"the tile can't be moved");
            break;
    }
}

/*
 Overiding dealloc method
*/
- (void)dealloc
{
    self.delegate = nil;
    self.tiles = nil;
    self.board = nil;
    [_draggedTile release];
    [super dealloc];
}

#pragma mark - Dragging gesture methods

/*
 Method to handle dragging from the pan gesture recognizer
 Prosedure untuk mengatur penggeseran dari pan gesture recognizer
*/
- (void)dragging:(UIPanGestureRecognizer *)gestureRecognizer {    
    CGPoint point;
    switch (gestureRecognizer.state) {
        // check if the selected tile can be moved
        // cek bila petak yang dipilih bisa digerakkan
        case UIGestureRecognizerStateBegan :
            point = [gestureRecognizer locationInView:self];
            _direction = [_board validMove:CGPointMake(floorf(point.x / _tileWidth) + 1, floorf(point.y / _tileHeight) + 1)];
            
            if (_direction != NONE) {
                for (UIImageView *tile in _tiles) {
                    if (CGRectContainsPoint(tile.frame, point)) {
                        [_draggedTile release];
                        _draggedTile = [tile retain];
                        break;
                    }
                }
            }
            break;
        // moving the selected tile 
        // menggerakkan petak terpilih
        case UIGestureRecognizerStateChanged :
            if (_draggedTile != nil) {
                CGPoint translation = [gestureRecognizer translationInView:self];
                CGFloat x = 0.0, y = 0.0;
                
                switch (_direction) {
                    case UP :
                        if (translation.y > 0) y = 0.0;
                        else if (translation.y < -_tileHeight) y = -_tileHeight;
                        else y = translation.y;
                        break;
                    case RIGHT:
                        if (translation.x < 0) x = 0.0;
                        else if (translation.x > _tileWidth) x = _tileWidth;
                        else x = translation.x;
                        break;
                    case DOWN :
                        if (translation.y < 0) y = 0.0;
                        else if (translation.y > _tileHeight) y = _tileHeight;
                        else y = translation.y;
                        break; 
                    case LEFT:
                        if (translation.x > 0) x = 0.0;
                        else if (translation.x < -_tileWidth) x = -_tileWidth;
                        else x = translation.x;
                        break;
                    default:
                        return;
                }
                [_draggedTile setTransform:CGAffineTransformMakeTranslation(x, y)];
            }
            break;
        // snap tile to position, update the board model
        // tempatkan petak ke tempat yang sesuai, ubah kembali model board 
        case UIGestureRecognizerStateEnded :
            if (_draggedTile != nil) {
                CGPoint movingTilePoint = CGPointMake(floorf(_draggedTile.center.x / _tileWidth) + 1, floorf(_draggedTile.center.y / _tileHeight) + 1);
                
                if (_draggedTile.transform.ty < 0) {
                    if (_draggedTile.transform.ty < - (_tileHeight/2)) {
                        [self moveTile:_draggedTile withDirection:UP fromTilePoint:movingTilePoint];
                    } else {
                        [self moveTile:_draggedTile withDirection:NONE fromTilePoint:movingTilePoint];
                    }
                } else if (_draggedTile.transform.tx > 0) {
                    if (_draggedTile.transform.tx > (_tileWidth/2)) {
                        [self moveTile:_draggedTile withDirection:RIGHT fromTilePoint:movingTilePoint];
                    } else {
                        [self moveTile:_draggedTile withDirection:NONE fromTilePoint:movingTilePoint];
                    }
                } else if (_draggedTile.transform.ty > 0) {
                    if (_draggedTile.transform.ty > (_tileHeight/2)) {
                        [self moveTile:_draggedTile withDirection:DOWN fromTilePoint:movingTilePoint];
                    } else {
                        [self moveTile:_draggedTile withDirection:NONE fromTilePoint:movingTilePoint];
                    }
                } else if (_draggedTile.transform.tx < 0) {
                    if (_draggedTile.transform.tx < - (_tileWidth/2)) {
                        [self moveTile:_draggedTile withDirection:LEFT fromTilePoint:movingTilePoint];
                    } else {
                        [self moveTile:_draggedTile withDirection:NONE fromTilePoint:movingTilePoint];
                    }
                }
            }
            break;
        default:
            break;
    }    
}

/*
 Method to handle tapping from the tap gesture recognizer
 Prosedure untuk mengatur sentuhan dari tap gesture recognizer
*/                            
- (void)tapMove:(UITapGestureRecognizer *)tapRecognizer {
    CGPoint tapPoint = [tapRecognizer locationInView:self];
    int x = (tapPoint.x / _tileWidth) + 1;
    int y = (tapPoint.y / _tileHeight) + 1;
    
    [self movingThisTile:CGPointMake(x, y)];
}

@end
