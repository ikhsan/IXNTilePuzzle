//
//  IAPuzzleBoard.m
//  Slizzle
//
//  Created by Ikhsan Assaat on 5/10/11.
//  Copyright 2011 Beetlebox All rights reserved.
//

#import "IAPuzzleBoard.h"

@interface IAPuzzleBoard (Private)
- (NSMutableArray *)makeBoardWithSize:(NSInteger)size;
- (void)setTileAtX:(int)x andY:(int)y withValue:(NSNumber *)value;
- (BOOL)isTileExist:(CGPoint)point;
- (BOOL)isTileEmpty:(CGPoint)point;
@end

@implementation IAPuzzleBoard

@synthesize size = _size;
@synthesize tiles = _tiles;

- (id)initWithSize:(NSInteger)size {
    if ((self = [super init])) {
        self.size = size;
        self.tiles = [self makeBoardWithSize:self.size];
    }
    
    return self;
}

- (NSMutableArray *)makeBoardWithSize:(NSInteger)size {
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:size];
    
    int value = 1;
    for (int x = 0; x < size; x++) {
        NSMutableArray *columns = [NSMutableArray arrayWithCapacity:size];
        for (int y = 0; y < size; y++) {
            if (value == size*size) {
                [columns addObject:[NSNumber numberWithInt:0]];
            } else {
                [columns addObject:[NSNumber numberWithInt:value++]];
            }
            
        }
        [rows addObject:columns];
    }  
    
    return rows;
}

- (NSNumber *)getTileAtPoint:(CGPoint)point {    
    return (NSNumber *)[[self.tiles objectAtIndex:point.y-1] objectAtIndex:point.x-1];
}

- (BOOL)isTileExist:(CGPoint)point {
    if ((point.x > 0) && (point.y > 0) && (point.x <= _size) && (point.y <= _size)) {
        return YES;
    }
    return NO;
}

- (BOOL)isTileEmpty:(CGPoint)point {
    if ([[self getTileAtPoint:point] intValue] == 0) {
        return YES;
    }
    return NO;
}

- (void)setTileAtPoint:(CGPoint)point withValue:(NSNumber *)value {
    [[self.tiles objectAtIndex:point.y-1] replaceObjectAtIndex:point.x-1 withObject:value];
//    [[self.tiles objectAtIndex:point.y-1] removeObjectAtIndex:point.x-1];
//    [[self.tiles objectAtIndex:point.y-1] insertObject:value atIndex:point.x-1];
}

- (void)swapTileAtPoint:(CGPoint)point1 withPoint:(CGPoint)point2 {
    int temp = [(NSNumber *)[self getTileAtPoint:point1] intValue];
    [self setTileAtPoint:point1 withValue:[self getTileAtPoint:point2]]; 
    [self setTileAtPoint:point2 withValue:[NSNumber numberWithInt:temp]];
}

- (int)validMove:(CGPoint)tilePoint {    
    CGPoint above = CGPointMake(tilePoint.x, tilePoint.y-1);
    CGPoint right = CGPointMake(tilePoint.x+1, tilePoint.y);
    CGPoint below = CGPointMake(tilePoint.x, tilePoint.y+1);
    CGPoint left = CGPointMake(tilePoint.x-1, tilePoint.y);
    
    if (([self isTileExist:above]) && [self isTileEmpty:above]) {
        //NSLog(@"up is empty");
        return UP;
    }
    
    if (([self isTileExist:right]) && [self isTileEmpty:right]) {
        //NSLog(@"right is empty");
        return RIGHT;
    }
    
    if (([self isTileExist:below]) && [self isTileEmpty:below]) {
        //NSLog(@"down is empty");
        return DOWN;
    }
    
    if (([self isTileExist:left]) && [self isTileEmpty:left]) {
        //NSLog(@"left is empty");
        return LEFT;
    }
    
    return NONE;
}

- (BOOL)moveTile:(CGPoint)tilePoint {
    int move = [self validMove:tilePoint];
    CGPoint neighborPoint;
    
    switch (move) {
        case UP:
            neighborPoint = CGPointMake(tilePoint.x, tilePoint.y-1);
            [self swapTileAtPoint:tilePoint withPoint:neighborPoint];
            break;
        case RIGHT:
            neighborPoint = CGPointMake(tilePoint.x+1, tilePoint.y);
            [self swapTileAtPoint:tilePoint withPoint:neighborPoint];
            break;
        case DOWN:
            neighborPoint = CGPointMake(tilePoint.x, tilePoint.y+1);
            [self swapTileAtPoint:tilePoint withPoint:neighborPoint];
            break;
        case LEFT:
            neighborPoint = CGPointMake(tilePoint.x-1, tilePoint.y);
            [self swapTileAtPoint:tilePoint withPoint:neighborPoint];
            break;
        default:
            NSLog(@"the tile can't be moved");
            return NO;
            break;
    }
    
    return YES;
}

- (BOOL)isBoardFinished {
    int value = 1;
    
    for (int i=1; i <= self.size; i++) {
        for (int j=1; j <= self.size; j++) {
            if ([[self getTileAtPoint:CGPointMake(j, i)] intValue] == value++) {
                continue;
            } else if ((i == self.size) && (j == self.size)) {
                continue;
            } else {
                return NO;
            }
        }
    }
    return YES;
}

- (void)shuffle:(NSInteger)times {    
    NSMutableArray *validMoves = [[NSMutableArray alloc] init];
    
    srandom(time(NULL));
    
    for (int i=0; i < times; i++) {
        [validMoves removeAllObjects];
        
        for (int i=1; i <= self.size; i++) {
            for (int j=1; j <= self.size; j++) {
                if ([self validMove:CGPointMake(j, i)] != NONE) {
                    [validMoves addObject:[NSValue valueWithCGPoint:CGPointMake(j, i)]];
                }
            }
        }
        
        NSInteger pick = random()%[validMoves count];
        CGPoint moveThisTile = [(NSValue *)[validMoves objectAtIndex:pick] CGPointValue];
        [self moveTile:moveThisTile];
    }
    
    [validMoves release];
}

- (NSString *)description {
    NSString *desc = @"\n";
    
    for (id rows in self.tiles) {
        for (NSNumber *column in rows) {
            if ([column integerValue] > 9) {
                desc = [desc stringByAppendingString:[NSString stringWithFormat:@"%@ ", column]];
            } else {
                desc = [desc stringByAppendingString:[NSString stringWithFormat:@"%@  ", column]];
            }
            
        }
        desc = [desc stringByAppendingString:@"\n"];
    }
    
    return desc;
}

- (void)dealloc {
    self.tiles = nil;    
    [super dealloc];
}

@end
