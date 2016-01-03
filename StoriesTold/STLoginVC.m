//
//  STLoginVC.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/4/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "STLoginVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "Constants.h"

@implementation STLoginVC

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
                                                               self.logInView.logo.frame.size.width,
                                                               self.logInView.logo.frame.size.height)];
    [blankRect setBackgroundColor:self.logInView.backgroundColor];
    [self.logInView.logo addSubview:blankRect];
    
    // Add a subview with the new logo to the original logo's view
    UIImageView *newLogo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
    [newLogo setContentMode:UIViewContentModeScaleAspectFit];
    [newLogo setFrame:CGRectMake(0,0,self.logInView.logo.frame.size.width,self.logInView.logo.frame.size.height)];
    [self.logInView.logo addSubview:newLogo];
}

//-(void)_loginWithFacebook
//{
//
//
//}

//
//- (void)handleFacebookSession {
//    if ([PFUser currentUser]) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(logInViewController:didLogInUser:)]) {
//            [self.delegate performSelector:@selector(logInViewController:didLogInUser:) withObject:[PFUser currentUser]];
//        }
//        return;
//    }
//    
//    if (![FBSDKAccessToken currentAccessToken]) {
//        NSLog(@"Login failure. FB Access Token or user ID does not exist");
//        return;
//    }
//        
//    [PFFacebookUtils logInInBackgroundWithAccessToken:[FBSDKAccessToken currentAccessToken] block:^(PFUser *user, NSError *error) {
//        if (!error) {
//            if (self.delegate) {
//                if ([self.delegate respondsToSelector:@selector(logInViewController:didLogInUser:)]) {
//                    [self.delegate performSelector:@selector(logInViewController:didLogInUser:) withObject:user];
//                }
//            }
//        } else {
//            [self cancelLogIn:error];
//        }
//    }];
//}
//
//- (void)cancelLogIn:(NSError *)error {
//    
//    if (error) {
//        [self handleLogInError:error];
//    }
//    
//    [FBSDKAccessToken setCurrentAccessToken:nil];
//    [PFUser logOut];
//}
//
//- (void)handleLogInError:(NSError *)error {
//    if (error) {
//        NSLog(@"Error: %@", [[error userInfo] objectForKey:@"com.facebook.sdk:ErrorLoginFailedReason"]);
//        NSString *title = NSLocalizedString(@"Login Error", @"Login error title in PAPLogInViewController");
//        NSString *message = NSLocalizedString(@"Something went wrong. Please try again.", @"Login error message in PAPLogInViewController");
//        
//        if ([[[error userInfo] objectForKey:@"com.facebook.sdk:ErrorLoginFailedReason"] isEqualToString:@"com.facebook.sdk:UserLoginCancelled"]) {
//            return;
//        }
//        
//        if (error.code == kPFErrorFacebookInvalidSession) {
//            NSLog(@"Invalid session, logging out.");
//            [FBSDKAccessToken setCurrentAccessToken:nil];
//            return;
//        }
//        
//        if (error.code == kPFErrorConnectionFailed) {
//            NSString *ok = NSLocalizedString(@"OK", @"OK");
//            NSString *title = NSLocalizedString(@"Offline Error", @"Offline Error");
//            NSString *message = NSLocalizedString(@"Something went wrong. Please try again.", @"Offline message");
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                            message:message
//                                                           delegate:nil
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:ok, nil];
//            [alert show];
//            
//            return;
//        }
//        
//        NSString *ok = NSLocalizedString(@"OK", @"OK");
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
//                                                            message:message
//                                                           delegate:self
//                                                  cancelButtonTitle:nil
//                                                  otherButtonTitles:ok, nil];
//        [alertView show];
//    }
//}

@end
