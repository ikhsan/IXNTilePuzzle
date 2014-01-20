//
//  IXNViewController.h
//  IXNTilePuzzle
//
//  Created by Ikhsan Assaat on 1/10/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IXNTileBoardView;

@interface IXNViewController : UIViewController

@property (weak, nonatomic) IBOutlet IXNTileBoardView *board;

@end
