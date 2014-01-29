//
//  IXNTileBoard.m
//  IXNTilePuzzle
//
//  Created by Ikhsan Assaat on 1/10/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import "IXNTileBoard.h"

static const NSInteger TileMinSize = 3;
static const NSInteger TileMaxSize = 6;

@interface IXNTileBoard ()

@property (strong, nonatomic) NSMutableArray *tiles;

@end


@implementation IXNTileBoard

- (instancetype)init
{
    return nil;
}

- (instancetype)initWithSize:(NSInteger)size
{
    if (!(self = [super init]) || ![self isSizeValid:size]) return nil;

    self.size = size;
    
    return self;
}

- (BOOL)isSizeValid:(NSInteger)size
{
    return (size >= TileMinSize && size <= TileMaxSize);
}

- (BOOL)isCoordinateInBound:(CGPoint)coor
{
    return (coor.x > 0 && coor.x <= self.size && coor.y > 0 && coor.y <= self.size);
}

- (NSMutableArray *)tileValuesForSize:(NSInteger)size
{
    int value = 1;
    NSMutableArray *tiles = [NSMutableArray arrayWithCapacity:size];
    for (int i = 0; i < size; i++)
    {
        NSMutableArray *values = [NSMutableArray arrayWithCapacity:size];
        for (int j = 0; j < size; j++)
            values[j] = (value != pow(size, 2))? @(value++) : @0;
        tiles[i] = values;
    }
    
    return tiles;
}

- (void)setSize:(NSInteger)size
{
    if ([self isSizeValid:size]) _tiles = [self tileValuesForSize:size];
}

- (NSInteger)size
{
    return [_tiles count];
}

- (void)setTileAtCoordinate:(CGPoint)coor with:(NSNumber *)number
{
    if ([self isCoordinateInBound:coor])
        self.tiles[(int)coor.y-1][(int)coor.x-1] = number;
}

- (NSNumber *)tileAtCoordinate:(CGPoint)coor
{
    if ([self isCoordinateInBound:coor])
        return self.tiles[(int)coor.y-1][(int)coor.x-1];
    
    return nil;
}

- (BOOL)canMoveTile:(CGPoint)coor
{
    return ( [[self tileAtCoordinate:CGPointMake(coor.x, coor.y-1)] isEqualToNumber:@0] || // upper neighbor
             [[self tileAtCoordinate:CGPointMake(coor.x+1, coor.y)] isEqualToNumber:@0] || // right neighbor
             [[self tileAtCoordinate:CGPointMake(coor.x, coor.y+1)] isEqualToNumber:@0] || // lower neighbor
             [[self tileAtCoordinate:CGPointMake(coor.x-1, coor.y)] isEqualToNumber:@0] ); // left neighbor
}

- (CGPoint)shouldMove:(BOOL)move tileAtCoordinate:(CGPoint)coor
{
    if (![self canMoveTile:coor]) return CGPointZero;
    
    CGPoint lowerNeighbor = CGPointMake(coor.x, coor.y+1);
    CGPoint rightNeighbor = CGPointMake(coor.x+1, coor.y);
    CGPoint upperNeighbor = CGPointMake(coor.x, coor.y-1);
    CGPoint leftNeighbor  = CGPointMake(coor.x-1, coor.y);
    
    CGPoint neighbor;
    if ([[self tileAtCoordinate:lowerNeighbor] isEqualToNumber:@0])
        neighbor = lowerNeighbor;
    else if ([[self tileAtCoordinate:rightNeighbor] isEqualToNumber:@0])
        neighbor = rightNeighbor;
    else if ([[self tileAtCoordinate:upperNeighbor] isEqualToNumber:@0])
        neighbor = upperNeighbor;
    else if ([[self tileAtCoordinate:leftNeighbor] isEqualToNumber:@0])
        neighbor = leftNeighbor;
    
    if (move)
    {
        NSNumber *number = [self tileAtCoordinate:coor];
        [self setTileAtCoordinate:coor with:[self tileAtCoordinate:neighbor]];
        [self setTileAtCoordinate:neighbor with:number];        
    }
    
    return neighbor;
}

- (void)shuffle:(NSInteger)times
{
    for (int t = 0; t < times; t++) {
        NSMutableArray *validMoves = [NSMutableArray array];
        
        for (int j = 1; j <= self.size; j++)
        {
            for (int i = 1; i <= self.size; i++)
            {
                CGPoint p = CGPointMake(i, j);
                if ([self canMoveTile:p])
                    [validMoves addObject:[NSValue valueWithCGPoint:p]];
            }
        }
        
        NSValue *v = validMoves[arc4random_uniform([validMoves count])];
        CGPoint p = [v CGPointValue];
        [self shouldMove:YES tileAtCoordinate:p];
    }
}

- (BOOL)isAllTilesCorrect
{
    int i = 1;
    BOOL correct = YES;
    
    for (NSArray *values in self.tiles)
    {
        for (NSNumber *value in values)
        {
            if ([value integerValue] != i)
            {
                correct = NO;
                break;
            }
            else
            {
                i = (i < pow(self.size, 2) - 1)? i+1 : 0;
            }

        }
    }
    
    return correct;
}

@end
