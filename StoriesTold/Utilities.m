//
//  Utilities.m
//  SilviaBiniCatalogue
//
//  Created by Nautes Spa on 10/8/15.
//  Copyright © 2015 Nautes Spa. All rights reserved.
//

#import "Utilities.h"
#import "AppDelegate.h"
#import <objc/runtime.h>

@implementation Utilities

+ (NSSet *)propertyNamesOfNSObject:(NSObject *)object
{
    NSMutableSet *propNames = [NSMutableSet set];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([object class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        [propNames addObject:propertyName];
    }
    free(properties);
    return propNames;
}

#pragma  mark - Swipe Button Images

+ (UIImage *)swipeImageWithText:(NSString *)text background: (UIColor *)backgroundColor rectSize:(CGSize)rectSize
{
    UIImage * backgroundImage = [Utilities setBackgroundImageByColor:backgroundColor withFrame:CGRectMake(0.f, 0.f, rectSize.width, rectSize.height)]; //background image
    
    UIFont *font = [UIFont systemFontOfSize:19];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, [NSNumber numberWithFloat:1.0], NSBaselineOffsetAttributeName, nil];
    CGSize textSize = [text sizeWithAttributes:attributes];

    UIImage *textImage = [Utilities drawText:text withAttributes:attributes inImage:backgroundImage atPoint:CGPointMake(( rectSize.width - textSize.width)/2, (rectSize.height - textSize.height)/2 )];
    
    return textImage;
}

+ (UIImage*) drawText:(NSString*) text
            withAttributes:(NSDictionary *) attributes
             inImage:(UIImage*) image
             atPoint:(CGPoint) point
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.f);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    [text drawInRect:CGRectIntegral(rect) withAttributes:attributes];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)swipeImageWithImage:(UIImage *)inputImage fillColor: (UIColor *)fillColor backgroundColor: (UIColor *)backgroundColor rectSize:(CGSize)rectSize
{
    UIGraphicsBeginImageContextWithOptions(rectSize, NO, 0.f);
    
    UIImage * backgroundImage = [Utilities setBackgroundImageByColor:backgroundColor withFrame:CGRectMake(0.f, 0.f, rectSize.width, rectSize.height)]; //background image
    
    // Use existing opacity as is
    [backgroundImage drawInRect:CGRectMake(0,0,rectSize.width,rectSize.height)];
    // Apply supplied opacity if applicable
    UIImage *coloredImage = [Utilities fillImage:inputImage withColor:fillColor];
    [coloredImage drawInRect:CGRectMake( (rectSize.width-30)/2,(rectSize.height-30)/2,30,30) blendMode:kCGBlendModeNormal alpha:1];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

+ (UIImage* )setBackgroundImageByColor:(UIColor *)backgroundColor withFrame:(CGRect )rect
{
    // tcv - temporary colored view
    UIView *tcv = [[UIView alloc] initWithFrame:rect];
    [tcv setBackgroundColor:backgroundColor];
    // set up a graphics context of button's size
    CGSize gcSize = tcv.frame.size;
    UIGraphicsBeginImageContext(gcSize);
    // add tcv's layer to context
    [tcv.layer renderInContext:UIGraphicsGetCurrentContext()];
    // create background image now
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage* )fillImage: (UIImage *)image withColor: (UIColor *)color
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, CGRectMake(0, 0, image.size.width, image.size.height), [image CGImage]);
    CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));
    
    UIImage* coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return coloredImg;
}

+ (NSString *)localizedDateString:(NSDate *)date
{
    return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
}

+ (NSString *)localizedDateTimeString:(NSDate *)date
{
    return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
}


+ (NSManagedObject *)getOrCreateEntity:(NSString *)entityName withIdentifier:(NSString *)identifier inManagedObjectContext: (NSManagedObjectContext *)context
{
    NSManagedObject * object = [Utilities getEntity:entityName withIdentifier:identifier inManagedObjectContext:context];
    
    if(!object){
        object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
    }
    
    return object;
}

+ (NSManagedObject *)getOrCreateEntity:(NSString *)entityName withIdentifier:(NSString *)identifier
                withName:(NSString *)name inManagedObjectContext: (NSManagedObjectContext *)context
{
    NSManagedObject * object = [Utilities getEntity:entityName withIdentifier:identifier inManagedObjectContext:context];
    
    if(!object){
        object = [Utilities getEntity:entityName withName:name inManagedObjectContext:context];
        if(!object){
            object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
        }
    }
    
    return object;
}

+ (NSManagedObject *)getEntity:(NSString *)entityName withIdentifier:(NSString *)identifier inManagedObjectContext: (NSManagedObjectContext *)context
{
    @autoreleasepool {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier LIKE %@", identifier];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setFetchLimit:1];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
        
        if (!results || ([results count] == 0)) {
            return nil;
        } else {
            return [results firstObject];
        }
    }
}

+ (NSManagedObject *)getEntity:(NSString *)entityName withName:(NSString *)name inManagedObjectContext: (NSManagedObjectContext *)context
{
    @autoreleasepool {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE %@", name];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setFetchLimit:1];
        
        NSError *error = nil;
        NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
        
        if (!results || ([results count] == 0)) {
            return nil;
        } else {
            return [results firstObject];
        }
    }
}

+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (BOOL)arrayIsSyncronized: (NSArray *)array
{
    NSArray *unsyncObjects = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isSynchronized = %@", [NSNumber numberWithBool:NO]]];
    
    if (unsyncObjects == nil || [unsyncObjects count] == 0) {
        return YES;
    }
    
    return NO;
}

@end
