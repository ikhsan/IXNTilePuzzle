//
//  UIImage+Resize.m
//  Slize
//
//  Created by Ikhsan Assaat on 5/11/11.
//  Copyright 2011 Beetlebox. All rights reserved.
//

#import "UIImage+Resize.h"


@implementation UIImage (Resize)

- (UIImage*) resizedImageWithSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    
    [self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    // An autoreleased image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
