//
//  UserInfoManager.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/30/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "UserInfoManager.h"
#import <ParseTwitterUtils/ParseTwitterUtils.h>
#import <ParseFacebookUtilsV4/ParseFacebookUtilsV4.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation UserInfoManager

+ (void)getInfoForUser:(PFUser *)user
{
    if([PFTwitterUtils isLinkedWithUser:user]){
        [UserInfoManager getTwitterInfoForUser:user];
    }
    else if([PFFacebookUtils isLinkedWithUser:user]){
        [UserInfoManager getFacebookInfoForUser:user];
    }
    else {
        [user setValue:user.username forKey:@"name"];
        [user saveInBackground];
    }
}

+ (void)getFacebookInfoForUser:(PFUser *)user
{
    // Fetch Facebook details
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            
            NSString *pictureURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
            [user setValue:name forKey:@"name"];
            [user setValue:pictureURL forKey:@"pictureURL"];
            
            [user saveInBackground];
        }
    }];
}

+ (void)getTwitterInfoForUser:(PFUser *)user
{
    // Fetch Twitter details
    NSString * requestString = [NSString stringWithFormat:@"https://api.twitter.com/1.1/users/show.json?screen_name=%@", [PFTwitterUtils twitter].screenName ];
    
    
    NSURL *verify = [NSURL URLWithString:requestString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:verify];
    [[PFTwitterUtils twitter] signRequest:request];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if ( error == nil){
            NSDictionary* result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSString *pictureURL = (NSString *)[result objectForKey:@"profile_image_url_https"];
            pictureURL = [pictureURL stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
            [user setObject:pictureURL
                     forKey:@"pictureURL"];
            
            [user setObject:[result objectForKey:@"name"]
                     forKey:@"name"];
            
            [user saveInBackground];
        }
    }] resume];
}

@end
