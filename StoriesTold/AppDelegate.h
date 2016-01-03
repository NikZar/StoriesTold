//
//  AppDelegate.h
//  StoriesTold
//
//  Created by Niko Zarzani on 11/10/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
@class AEAudioController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) AEAudioController *audioController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

