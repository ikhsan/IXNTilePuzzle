//
//  UIImage+Resize.h
//  IXNTilePuzzle
//
//  Created by Ikhsan Assaat on 1/20/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

- (UIImage *)resizedImageWithSize:(CGSize)size;
- (UIImage *)cropImageFromFrame:(CGRect)frame;

@end
