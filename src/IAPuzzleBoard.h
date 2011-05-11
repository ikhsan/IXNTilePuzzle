//
//  IAPuzzleBoard.h
//  Slizzle
//
//  Created by Ikhsan Assaat on 5/10/11.
//  Copyright 2011 Beetlebox All rights reserved.
//

#import <Foundation/Foundation.h>

#define NONE 0
#define UP 1
#define RIGHT 2
#define DOWN 3
#define LEFT 4

#define SHUFFLE_TIMES 3


@interface IAPuzzleBoard : NSObject {
    NSInteger _size;
    NSMutableArray *_tiles;
}

@property NSInteger size;
@property (nonatomic, retain) NSMutableArray *tiles;

- (id)initWithSize:(NSInteger)size;
- (NSNumber *)getTileAtPoint:(CGPoint)point;
- (void)swapTileAtPoint:(CGPoint)point1 withPoint:(CGPoint)point2;
- (int)validMove:(CGPoint)tilePoint;
- (BOOL)isBoardFinished;
- (void)shuffle:(NSInteger)times;
- (BOOL)moveTile:(CGPoint)tilePoint;

@end
