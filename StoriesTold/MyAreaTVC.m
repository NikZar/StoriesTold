//
//  MyAreaTVC.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/26/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "MyAreaTVC.h"
#import "Constants.h"
#import "STLoginVC.h"
#import "STSignUpVC.h"
#import "UserInfoManager.h"

@interface MyAreaTVC()

@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) PFUser *user;

@end

@implementation MyAreaTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userImageView.backgroundColor = kDarkBeigeColor;
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width/2;
    self.userImageView.clipsToBounds = YES;
    self.userImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.userImageView.layer.borderWidth = 2.0f;
    
    self.tableView.backgroundColor = kBeigeColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.userImageView.image = [UIImage imageNamed:@"Male"]; // placeholder image
    
    [self setupUI];
    
    [self setupNavBar];
    
    [self setupRightBarButtonItems];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.user = [PFUser currentUser];
    if (self.user) {
        [UserInfoManager getInfoForUser:self.user];
    }
    
    [self setupUI];
}

- (void)setupUI
{
    self.user = [PFUser currentUser];
    
    @try{
        if(self.user){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                PFFile *imageFile = [self.user objectForKey:@"image"];
                if(!imageFile){
                    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[PFUser currentUser] objectForKey:@"pictureURL"]]];
                    if(data){
                        imageFile = [PFFile fileWithData:data];
                        [self.user setObject:imageFile forKey:@"image"];
                    }
                }
                [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    self.userImageView.file = [self.user objectForKey:@"image"];
                    [self.userImageView loadInBackground];
                }];
            });
            
            
            self.nameLabel.text = [[PFUser currentUser] objectForKey:@"name"];
        } else {
            self.userImageView.image = nil;
            self.nameLabel.text = @"Please log in.";
        }
    }
    @catch(NSException *ex){
        NSLog(@"%@", ex);
    }
}

- (void)setupNavBar
{
    //    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = kDarkBeigeColor;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)setupRightBarButtonItems
{
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Logout"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout)];
    logoutButton.tintColor = [UIColor blackColor];    
    
    self.navigationItem.rightBarButtonItems = @[logoutButton];
}

-(void)logout
{
    self.user = nil;
    [PFUser logOut];
    [self showLogin];
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
