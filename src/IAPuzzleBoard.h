//
//  IAPuzzleBoard.h
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

#import <Foundation/Foundation.h>

#define NONE 0
#define UP 1
#define RIGHT 2
#define DOWN 3
#define LEFT 4

@interface IAPuzzleBoard : NSObject {
    NSInteger _size;
    NSMutableArray *_tiles;
}

@property NSInteger size;
@property (nonatomic, retain) NSMutableArray *tiles;

/*
 Method for initialize a puzzle board, with size x size (size)
 Method untuk inisialisasi papan puzzle, dengan ukuran size x size (size)
*/
- (id)initWithSize:(NSInteger)size;

/*
 Value getter for its specified point (point)
 Getter untuk mendapatkan nilai suatu (point)
*/
- (NSNumber *)getTileAtPoint:(CGPoint)point;

/*
 Method for swapping value from two tiles given (point1 & point2)
 Prosedur untuk mengganti nilai dari dua buah petak (point1 & point2)
*/
- (void)swapTileAtPoint:(CGPoint)point1 withPoint:(CGPoint)point2;

/*
 Function to test a tile, whether it can be moved or not (tilePoint)
 Fungsi untuk mengecek sebuah petak, apakah bisa digerakkan atau tidak (tilePoint)
*/
- (int)validMove:(CGPoint)tilePoint;

/*
 Function to test the board whether it's finished or not
 Fungsi untuk mengecek papan sudah selesai atau belum
*/
- (BOOL)isBoardFinished;

/*
 Method for shuffling the tiles of the board (times)
 Prosedur untuk mengacak petak-petak dari papan (times)
*/
- (void)shuffle:(NSInteger)times;

/*
 Function for moving specified tile, returns boolean if its moved or not (tilePoint)
 Fungsi untuk menggerakkan sebuah petak, mengembalikan boolean apakah pemindahan sukses atau tidak (tilePoint)
*/
- (BOOL)moveTile:(CGPoint)tilePoint;

@end
