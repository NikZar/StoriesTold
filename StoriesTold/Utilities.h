//
//  Utilities.h
//  SilviaBiniCatalogue
//
//  Created by Nautes Spa on 10/8/15.
//  Copyright © 2015 Nautes Spa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Coredata/CoreData.h>

@interface Utilities : NSObject

//MISCELLANEOUS
+ (NSSet *)propertyNamesOfNSObject:(NSObject *)object;

//UI
+ (UIImage *)swipeImageWithText:(NSString *)text background: (UIColor *)backgroundColor rectSize:(CGSize)rectSize;
+ (UIImage *)swipeImageWithImage:(UIImage *)inputImage fillColor: (UIColor *)fillColor backgroundColor: (UIColor *)backgroundColor rectSize:(CGSize)rectSize;
+ (UIImage* )setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect;


//CORE DATA
+ (NSManagedObject *)getOrCreateEntity:(NSString *)entityName withIdentifier:(NSString *)identifier inManagedObjectContext: (NSManagedObjectContext *)context;
+ (NSManagedObject *)getOrCreateEntity:(NSString *)entityName withIdentifier:(NSString *)identifier
                              withName:(NSString *)name inManagedObjectContext: (NSManagedObjectContext *)context;
+ (NSManagedObject *)getEntity:(NSString *)entityName withIdentifier:(NSString *)identifier inManagedObjectContext: (NSManagedObjectContext *)context;
+ (BOOL)arrayIsSyncronized: (NSArray *)array;

//DATE
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)localizedDateString:(NSDate *)date;
+ (NSString *)localizedDateTimeString:(NSDate *)date;

@end
