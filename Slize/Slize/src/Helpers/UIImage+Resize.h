//
//  UIImage+Resize.h
//  Slize
//
//  Created by Ikhsan Assaat on 5/11/11.
//  Copyright 2011 Beetlebox. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage (Resize)

- (UIImage*)resizedImageWithSize:(CGSize)size;
- (UIImage*)cropImageFromFrame:(CGRect)frame;

@end
