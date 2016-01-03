//
//  UserInfoManager.h
//  StoriesTold
//
//  Created by Niko Zarzani on 12/30/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface UserInfoManager : NSObject

+ (void)getInfoForUser:(PFUser *)user;

@end
