//
//  STSignUpVC.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/4/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "STSignUpVC.h"
#import "Constants.h"

@implementation STSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kBeigeColor;
    
//    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
//    logoView.contentMode = UIViewContentModeScaleAspectFit;
//    logoView.frame = CGRectMake(logoView.frame.origin.x, logoView.frame.origin.y+200, logoView.frame.size.width, 400);
//    self.signUpView.logo = logoView; // logo can be any UIView
    
    // Create a UIView to "cover up" original Parse logo
    UIView *blankRect=[[UIView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               self.signUpView.logo.frame.size.width,
                                                               self.signUpView.logo.frame.size.height)];
    [blankRect setBackgroundColor:self.signUpView.backgroundColor];
    [self.signUpView.logo addSubview:blankRect];
    
    // Add a subview with the new logo to the original logo's view
    UIImageView *newLogo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    [newLogo setContentMode:UIViewContentModeScaleAspectFit];
    [newLogo setFrame:CGRectMake(0,0,self.signUpView.logo.frame.size.width,self.signUpView.logo.frame.size.height)];
    [self.signUpView.logo addSubview:newLogo];
}

@end
