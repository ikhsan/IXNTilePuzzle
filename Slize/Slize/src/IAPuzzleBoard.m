//
//  IAPuzzleBoard.m
//  Slizzle
//
//  Created by Ikhsan Assaat on 5/10/11.
//  Copyright 2011 Beetlebox All rights reserved.
//
//  A Model Class to make a puzzle board. A 3x3 board example :
//  1   2   3
//  4   5   6
//  7   8   0
//
//
//  Kelas model untuk membuat sebuah papan puzzle. Contoh papan 3x3 :
//  1   2   3
//  4   5   6
//  7   8   0
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

/*
 Function for initialize a puzzle board, with size x size (size)
 Fungsi untuk inisialisasi papan puzzle, dengan ukuran size x size (size)
*/
- (id)initWithSize:(NSInteger)size {
    if ((self = [super init])) {
        self.size = size;
        self.tiles = [self makeBoardWithSize:self.size];
    }
    
    return self;
}

/*
 Helper function for initializing values for every tiles in the board
 Fungsi bantu untuk iniliasasi nilai untuk tiap petak di dalam papan
*/
- (NSMutableArray *)makeBoardWithSize:(NSInteger)size {
    int value = 1;
    
    // initiliaze 2 dimensional NSMutableArray with a specified value in NSNumber
    // inisialisasi NSMutableArray 2 dimensi dengan NSNumber yang diberi nilai yang sesuai
    NSMutableArray *rows = [NSMutableArray arrayWithCapacity:size];
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

/*
 Value getter for its specified point (point)
 Getter untuk mendapatkan nilai suatu (point)
*/
- (NSNumber *)getTileAtPoint:(CGPoint)point {    
    return (NSNumber *)[[self.tiles objectAtIndex:point.y-1] objectAtIndex:point.x-1];
}

/*
 Helper function for tile validation (point)
 Fungsi bantu untuk validasi petak (point)
*/
- (BOOL)isTileExist:(CGPoint)point {
    if ((point.x > 0) && (point.y > 0) && (point.x <= _size) && (point.y <= _size)) {
        return YES;
    }
    return NO;
}

/*
 Helper function for checking whether the specified tile is empty (point)
 Fungsi bantu untuk mengecek sebuah petak kosong atau tidak (point)
*/
- (BOOL)isTileEmpty:(CGPoint)point {
    if ([[self getTileAtPoint:point] intValue] == 0) {
        return YES;
    }
    return NO;
}

/*
 Helper method for setting a specified tile with a specified value (point, value)
 Prosedur bantu untuk mengubah isi sebuah petak dengan sebuah nilai tertentu (point, value)
*/
- (void)setTileAtPoint:(CGPoint)point withValue:(NSNumber *)value {
    [[self.tiles objectAtIndex:point.y-1] replaceObjectAtIndex:point.x-1 withObject:value];
}

/*
 Method for swapping value from two tiles given (point1 & point2)
 Prosedur untuk mengganti nilai dari dua buah petak (point1 & point2)
*/
- (void)swapTileAtPoint:(CGPoint)point1 withPoint:(CGPoint)point2 {
    int temp = [(NSNumber *)[self getTileAtPoint:point1] intValue];
    [self setTileAtPoint:point1 withValue:[self getTileAtPoint:point2]]; 
    [self setTileAtPoint:point2 withValue:[NSNumber numberWithInt:temp]];
}

/*
 Function to test a tile, whether it can be moved or not (tilePoint)
 Fungsi untuk mengecek sebuah petak, apakah bisa digerakkan atau tidak (tilePoint)
*/
- (int)validMove:(CGPoint)tilePoint {
    // check every neighbour of tile
    // cek tiap tetangga petak tsb
    CGPoint above = CGPointMake(tilePoint.x, tilePoint.y-1);
    CGPoint right = CGPointMake(tilePoint.x+1, tilePoint.y);
    CGPoint below = CGPointMake(tilePoint.x, tilePoint.y+1);
    CGPoint left = CGPointMake(tilePoint.x-1, tilePoint.y);
    
    // return direction of the neighbour that's empty
    // mengembalikan arah dari tetangganya yang kosong
    if (([self isTileExist:above]) && [self isTileEmpty:above]) {
        return UP;
    }
    
    if (([self isTileExist:right]) && [self isTileEmpty:right]) {
        return RIGHT;
    }
    
    if (([self isTileExist:below]) && [self isTileEmpty:below]) {
        return DOWN;
    }
    
    if (([self isTileExist:left]) && [self isTileEmpty:left]) {
        return LEFT;
    }
    
    return NONE;
}

/*
 Function for moving specified tile, returns boolean if its moved or not (tilePoint)
 Fungsi untuk menggerakkan sebuah petak, mengembalikan boolean apakah pemindahan sukses atau tidak (tilePoint)
*/
- (BOOL)moveTile:(CGPoint)tilePoint {
    // get valid direction
    // dapatkan arah gerak yang valid
    int move = [self validMove:tilePoint];
    CGPoint neighborPoint;
    
    // swap the tile with the empty one
    // tuker petak bersangkutan dengan yang kosong
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
    }
    
    return YES;
}

/*
 Function to test the board whether it's finished or not
 Fungsi untuk mengecek papan sudah selesai atau belum
*/
- (BOOL)isBoardFinished {
    int value = 1;
    
    // check every tile if its in the right position
    // cek setiap petak, apakah sudah dalam posisi benar
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

/*
 Method for shuffling the tiles of the board (times)
 Prosedur untuk mengacak petak-petak dari papan (times)
*/
- (void)shuffle:(NSInteger)times {
    // create mutable array for every valid moves
    // buat mutable array untuk semua gerakan yang valid
    NSMutableArray *validMoves = [[NSMutableArray alloc] init];
    
    srandom(time(NULL));
    
    for (int i=0; i < times; i++) {
        [validMoves removeAllObjects];
        
        // check every tile, if it can be moved than add that tile to array
        // cek tiap petak, bila bisa digerakkan masukkan ke dalam array
        for (int i=1; i <= self.size; i++) {
            for (int j=1; j <= self.size; j++) {
                if ([self validMove:CGPointMake(j, i)] != NONE) {
                    [validMoves addObject:[NSValue valueWithCGPoint:CGPointMake(j, i)]];
                }
            }
        }
        
        // pick every 
        NSInteger pick = random()%[validMoves count];
        CGPoint moveThisTile = [(NSValue *)[validMoves objectAtIndex:pick] CGPointValue];
        [self moveTile:moveThisTile];
    }
    
    [validMoves release];
}

/*
 Overiding description to print the board
*/
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

/*
 Overiding dealloc method
*/
- (void)dealloc {
    self.tiles = nil;    
    [super dealloc];
}

@end
