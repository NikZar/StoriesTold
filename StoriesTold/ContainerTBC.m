//
//  ContainerTBC.m
//  SilviaBiniCatalogue
//
//  Created by Nautes Spa on 9/30/15.
//  Copyright © 2015 Nautes Spa. All rights reserved.
//

#import "ContainerTBC.h"
#import "Constants.h"
#import "STLoginVC.h"
#import "STSignUpVC.h"
#import "UserInfoManager.h"

@interface ContainerTBC ()

@end

@implementation ContainerTBC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = kDarkBeigeColor;
    self.tabBar.backgroundColor = [UIColor blackColor];
    self.selectedIndex = 2;
    self.tabBar.translucent = NO;
}

#pragma mark - Check User Logged

- (void)viewDidAppear:(BOOL)animated {
    if (![PFUser currentUser]) { // No user logged in
        [self showLogin];
    }
}

- (void)showLogin
{
    // Create the log in view controller
    STLoginVC *logInViewController = [[STLoginVC alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    logInViewController.fields = (PFLogInFieldsUsernameAndPassword
                                  | PFLogInFieldsLogInButton
                                  | PFLogInFieldsSignUpButton
                                  | PFLogInFieldsPasswordForgotten
                                  | PFLogInFieldsDismissButton
                                  | PFLogInFieldsFacebook
                                  | PFLogInFieldsTwitter);
    
    // Create the sign up view controller
    STSignUpVC *signUpViewController = [[STSignUpVC alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    signUpViewController.fields = (PFSignUpFieldsUsernameAndPassword
                                   | PFSignUpFieldsSignUpButton
                                   | PFSignUpFieldsEmail
                                   | PFSignUpFieldsDismissButton);
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];

}

- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {

    [UserInfoManager getInfoForUser:user];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [UserInfoManager getInfoForUser:user];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
