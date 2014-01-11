//
//  IXNTileBoard.h
//  IXNTilePuzzle
//
//  Created by Ikhsan Assaat on 1/10/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IXNTileBoard : NSObject

@property (nonatomic) NSInteger size;

- (instancetype)initWithSize:(NSInteger)size;
- (void)setTileAtCoordinate:(CGPoint)coor with:(NSNumber *)number;
- (NSNumber *)tileAtCoordinate:(CGPoint)coor;

- (BOOL)canMoveTile:(CGPoint)coor;
- (void)moveTileAtCoordinate:(CGPoint)coor;
- (void)shuffle:(NSInteger)times;
- (BOOL)isAllTilesCorrect;

@end
