//
//  DimensionQCVCell.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/26/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "DimensionQCVCell.h"
#import "Constants.h"
#import <ParseUI/ParseUI.h>

@interface DimensionQCVCell()

@property (weak, nonatomic) IBOutlet PFImageView *dimensionImageView;
@property (weak, nonatomic) IBOutlet UILabel *dimensionNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation DimensionQCVCell

- (void)updateFromObject:(nullable PFObject *)object
{
    if ([object isKindOfClass:[Dimension class]]) {
        Dimension *dimension = (Dimension *)object;
        self.backgroundColor = kBeigeColor;
        [self.infoButton setImage:[self.infoButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        self.infoButton.tintColor = [UIColor whiteColor];
        self.dimensionNameLabel.text = dimension.name;
        
        // Set vertical effect
        UIInterpolatingMotionEffect *verticalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.y"
         type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-10);
        verticalMotionEffect.maximumRelativeValue = @(10);
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect =
        [[UIInterpolatingMotionEffect alloc]
         initWithKeyPath:@"center.x"
         type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-10);
        horizontalMotionEffect.maximumRelativeValue = @(10);
        
        // Create group to combine both
        UIMotionEffectGroup *group = [UIMotionEffectGroup new];
        group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
        self.dimensionImageView.image = [UIImage imageNamed:@""]; // placeholder image
        self.dimensionImageView.file = dimension.image; // remote image
        
        [self.dimensionImageView loadInBackground];
        
        // Add both effects to your view
        [self.dimensionImageView addMotionEffect:group];
    }
}

- (IBAction)infoButtonTapped:(id)sender {
    
}

@end
