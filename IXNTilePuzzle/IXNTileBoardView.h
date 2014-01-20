//
//  IXNTileBoardView.h
//  IXNTilePuzzle
//
//  Created by Ikhsan Assaat on 1/20/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IXNTileBoardView;

@protocol IXNTileBoardViewDelegate <NSObject>

@optional
- (void)tileBoardViewDidFinished:(IXNTileBoardView *)tileBoardView;
- (void)tileBoardView:(IXNTileBoardView *)tileBoardView tileDidMove:(CGPoint)position;

@end

@interface IXNTileBoardView : UIView

@property (assign, nonatomic) IBOutlet id<IXNTileBoardViewDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image size:(NSInteger)size frame:(CGRect)frame;
- (void)playWithImage:(UIImage *)image size:(NSInteger)size;
- (void)shuffleTimes:(NSInteger)times;

@end
