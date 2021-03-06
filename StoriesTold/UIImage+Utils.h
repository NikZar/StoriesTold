//
//  UIImage+Utils.h
//  SilviaBiniCatalogue
//
//  Created by Nautes Spa on 10/6/15.
//  Copyright © 2015 Nautes Spa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

/** Resize the image to be the required size, stretching it as needed.
 *
 * @param newSize      The new size of the image.
 * @param contentMode  The `UIViewContentMode` to be applied when resizing image.
 *                     Either `UIViewContentModeScaleToFill`, `UIViewContentModeScaleAspectFill`, or
 *                     `UIViewContentModeScaleAspectFit`.
 *
 * @return             Return `UIImage` of resized image.
 */

- (UIImage*)imageByScalingToSize:(CGSize)newSize contentMode:(UIViewContentMode)contentMode;

/** Crop the image to be the required size.
 *
 * @param bounds       The bounds to which the new image should be cropped.
 *
 * @return             Cropped `UIImage`.
 */

- (UIImage *)imageByCroppingToBounds:(CGRect)bounds;

/** Resize the image to be the required size, stretching it as needed.
 *
 * @param newSize The new size of the image.
 *
 * @return        Resized `UIImage` of resized image.
 */

- (UIImage*)imageByScalingToFillSize:(CGSize)newSize;

/** Resize the image to fill the rectange of the specified size, preserving the aspect ratio, trimming if needed.
 *
 * @param newSize The new size of the image.
 *
 * @return        Return `UIImage` of resized image.
 */

- (UIImage*)imageByScalingAspectFillSize:(CGSize)newSize;

/** Resize the image to fit within the required size, preserving the aspect ratio, with no trimming taking place.
 *
 * @param newSize The new size of the image.
 *
 * @return        Return `UIImage` of resized image.
 */

- (UIImage*)imageByScalingAspectFitSize:(CGSize)newSize;

@end
