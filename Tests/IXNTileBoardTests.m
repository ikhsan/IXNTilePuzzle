//
//  IXNTileBoard.m
//  IXNTilePuzzle
//
//  Created by Ikhsan Assaat on 1/10/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "IXNTileBoard.h"

@interface IXNTileBoardTests : XCTestCase

@property (strong, nonatomic) IXNTileBoard *board;

@end

@implementation IXNTileBoardTests

- (void)setUp
{
    [super setUp];
    
    self.board = [[IXNTileBoard alloc] initWithSize:3];
}

- (void)tearDown
{
    self.board = nil;
    
    [super tearDown];
}

- (void)testBoardInitialization
{
    XCTAssertNil([[IXNTileBoard alloc] init], @"Basic init should not return an object");
    XCTAssertNil([[IXNTileBoard alloc] initWithSize:2], @"Basic init should not return an object if size's below min");
    XCTAssertNil([[IXNTileBoard alloc] initWithSize:10], @"Basic init should not return an object if size's above max");
    
    XCTAssertNotNil(self.board, @"Designated initialization should return a valid board");
}

- (void)testBoardSizeAfterInit
{
    XCTAssertEqual(self.board.size, 3, @"Board should have the correct size");
    
    IXNTileBoard *board = [[IXNTileBoard alloc] initWithSize:5];
    XCTAssertEqual(board.size, 5, @"Board should have the correct size");
}

- (void)testBoardSizeAfterSetter
{
    self.board.size = 5;
    XCTAssertEqual(self.board.size, 5, @"Board should have the correct size");
}

- (void)testBoardSizeAfterInvalidSetter
{
    IXNTileBoard *board = [[IXNTileBoard alloc] initWithSize:3];
    
    board.size = 2;
    XCTAssertEqual(board.size, 3, @"Board setter should not take effect because minimum size is 3");
    
    board.size = 10;
    XCTAssertEqual(board.size, 3, @"Board setter should not take effect because maximum size is 6");
}

- (void)testTileGetterWithUnshuffledBoard
{
    self.board.size = 3;
    XCTAssertEqual([self numberAtX:1 Y:1], 1);
    XCTAssertEqual([self numberAtX:2 Y:1], 2);
    XCTAssertEqual([self numberAtX:1 Y:2], 4);
    XCTAssertEqual([self numberAtX:3 Y:3], 0);
}

- (void)testTileGetterOutOfBounds
{
    XCTAssertNil([self.board tileAtCoordinate:CGPointMake(4, 1)], @"Should be nil because it's out of bounds!");
    XCTAssertNil([self.board tileAtCoordinate:CGPointMake(-1, 1)], @"Should be nil because it's out of bounds!");
    XCTAssertNil([self.board tileAtCoordinate:CGPointMake(0, 1)], @"Should be nil because it's out of bounds!");
    XCTAssertNil([self.board tileAtCoordinate:CGPointMake(1, 4)], @"Should be nil because it's out of bounds!");
}

- (void)testTileSetter
{
    [self.board setTileAtCoordinate:CGPointMake(3, 3) with:@15];
    XCTAssertEqual([self numberAtX:3 Y:3], 15);
    [self.board setTileAtCoordinate:CGPointMake(3, 3) with:@0];
    XCTAssertEqual([self numberAtX:3 Y:3], 0);
}

- (void)testTileSetterOutOfBounds
{
    self.board.size = 3;
    XCTAssertNoThrow([self.board setTileAtCoordinate:CGPointMake(5, 1) with:@1], @"Should not throw out of bounds exception");
    XCTAssertNoThrow([self.board setTileAtCoordinate:CGPointMake(3, 0) with:@1], @"Should not throw out of bounds exception");
}

- (void)testTilesAfterChangeSize
{
    self.board.size = 4;
    XCTAssertEqual([self numberAtX:3 Y:1], 3);
    XCTAssertEqual([self numberAtX:2 Y:4], 14);
    XCTAssertEqual([self numberAtX:4 Y:4], 0);
}

- (void)testTileShouldNotMove
{
    self.board.size = 3;
    XCTAssertFalse([self.board canMoveTile:CGPointMake(1, 1)], @"Tile should not able to be moved");
    XCTAssertFalse([self.board canMoveTile:CGPointMake(3, 3)], @"Empty tile should not able to be moved");
}

- (void)testTileShouldMoveDownward
{
    self.board.size = 3;
    XCTAssertTrue([self.board canMoveTile:CGPointMake(3, 2)], @"Tile should able to be moved downward");
}

- (void)testTileShouldMoveToRight
{
    self.board.size = 3;
    XCTAssertTrue([self.board canMoveTile:CGPointMake(2, 3)], @"Tile should able to be moved to right");
}

- (void)testTileShouldMoveUpward
{
    self.board.size = 3;
    [self.board shouldMove:YES tileAtCoordinate:CGPointMake(3, 2)];
    XCTAssertTrue([self.board canMoveTile:CGPointMake(3, 3)], @"Tile should able to be moved upward");
}

- (void)testTileShouldMoveToLeft
{
    self.board.size = 3;
    [self.board shouldMove:YES tileAtCoordinate:CGPointMake(2, 3)];
    XCTAssertTrue([self.board canMoveTile:CGPointMake(3, 3)], @"Tile should able to be moved to left");
}

- (void)testMoveTileWithInvalidTile
{
    self.board.size = 3;
    
    CGPoint p = CGPointMake(1, 1);
    NSNumber *value = [self.board tileAtCoordinate:p];
    [self.board shouldMove:YES tileAtCoordinate:p];
    XCTAssertEqual([self numberAtX:1 Y:1], [value integerValue], @"Tile should not move");
}

- (void)testMoveTileDownward
{
    self.board.size = 3;
    
    [self.board shouldMove:YES tileAtCoordinate:CGPointMake(3, 2)];
    XCTAssertEqual([self numberAtX:3 Y:2], 0, @"Tile should moved downward");
}

- (void)testMoveTileToRight
{
    self.board.size = 3;
    [self.board shouldMove:YES tileAtCoordinate:CGPointMake(2, 3)];
    XCTAssertEqual([self numberAtX:2 Y:3], 0, @"Tile should moved right");
}

- (void)testMoveTileUpward
{
    self.board.size = 4;
    [self.board shouldMove:YES tileAtCoordinate:CGPointMake(4, 3)];
    XCTAssertEqual([self numberAtX:4 Y:3], 0, @"Tile should moved downward");
    [self.board shouldMove:YES tileAtCoordinate:CGPointMake(4, 4)];
    XCTAssertEqual([self numberAtX:4 Y:4], 0, @"Tile should moved upward");
}

- (void)testMoveTileToLeft
{
    self.board.size = 5;
    [self.board shouldMove:YES tileAtCoordinate:CGPointMake(4, 5)];
    XCTAssertEqual([self numberAtX:4 Y:5], 0, @"Tile should moved to right");
    [self.board shouldMove:YES tileAtCoordinate:CGPointMake(5, 5)];
    XCTAssertEqual([self numberAtX:5 Y:5], 0, @"Tile should moved to left");
}

- (void)testBoardTileIsCorrect
{
    self.board.size = 6;
    XCTAssertTrue([self.board isAllTilesCorrect], @"Board should have all of its tiles in the right place");
    [self.board shouldMove:YES tileAtCoordinate:CGPointMake(5, 6)];
    XCTAssertFalse([self.board isAllTilesCorrect], @"Board should have one incorrect tile");
}

- (void)testShuffleBoard
{
    self.board.size = 3;
    [self.board shuffle:10];
    XCTAssertFalse([self.board isAllTilesCorrect], @"Board's tile should have random order");
}

#pragma mark - convenience methods

- (NSInteger)numberAtX:(int)x Y:(int)y
{
    return [[self.board tileAtCoordinate:CGPointMake(x, y)] integerValue];
}

@end
