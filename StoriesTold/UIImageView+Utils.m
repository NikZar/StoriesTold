//
//  UIImageView+Utils.m
//  SilviaBiniCatalogue
//
//  Created by Nautes Spa on 9/30/15.
//  Copyright © 2015 Nautes Spa. All rights reserved.
//

#import "UIImageView+Utils.h"

@implementation UIImageView (Utils)

- (void)setImageRenderingMode:(UIImageRenderingMode)renderMode
{
    NSAssert(self.image, @"Image must be set before setting rendering mode");
    self.image = [self.image imageWithRenderingMode:renderMode];
}

@end
