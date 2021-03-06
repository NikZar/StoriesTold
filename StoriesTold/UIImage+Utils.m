//
//  UIImage+Utils.m
//  SilviaBiniCatalogue
//
//  Created by Nautes Spa on 10/6/15.
//  Copyright © 2015 Nautes Spa. All rights reserved.
//

#import "UIImage+Utils.h"

@implementation UIImage (Utils)

- (UIImage*)imageByScalingToSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode
{
    if (contentMode == UIViewContentModeScaleToFill)
    {
        return [self imageByScalingToFillSize:newSize];
    }
    else if ((contentMode == UIViewContentModeScaleAspectFill) ||
             (contentMode == UIViewContentModeScaleAspectFit))
    {
        CGFloat horizontalRatio   = self.size.width  / newSize.width;
        CGFloat verticalRatio     = self.size.height / newSize.height;
        CGFloat ratio;
        
        if (contentMode == UIViewContentModeScaleAspectFill)
            ratio = MIN(horizontalRatio, verticalRatio);
        else
            ratio = MAX(horizontalRatio, verticalRatio);
        
        CGSize  sizeForAspectScale = CGSizeMake(self.size.width / ratio, self.size.height / ratio);
        
        UIImage *image = [self imageByScalingToFillSize:sizeForAspectScale];
        
        // if we're doing aspect fill, then the image still needs to be cropped
        
        if (contentMode == UIViewContentModeScaleAspectFill)
        {
            CGRect  subRect = CGRectMake(floor((sizeForAspectScale.width - newSize.width) / 2.0),
                                         floor((sizeForAspectScale.height - newSize.height) / 2.0),
                                         newSize.width,
                                         newSize.height);
            image = [image imageByCroppingToBounds:subRect];
        }
        
        return image;
    }
    
    return nil;
}

- (UIImage *)imageByCroppingToBounds:(CGRect)bounds
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

- (UIImage*)imageByScalingToFillSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 1.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*)imageByScalingAspectFillSize:(CGSize)newSize
{
    return [self imageByScalingToSize:newSize contentMode:UIViewContentModeScaleAspectFill];
}

- (UIImage*)imageByScalingAspectFitSize:(CGSize)newSize
{
    return [self imageByScalingToSize:newSize contentMode:UIViewContentModeScaleAspectFit];
}

@end
