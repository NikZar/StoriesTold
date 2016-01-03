//
//  Constants.h
//  StoriesTold
//
//  Created by Niko Zarzani on 11/10/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#pragma mark - Config
// CHANGE HERE TO SWITCH PRODUCTION/TEST
#define TEST_VERSION NO

#pragma mark - Default Image Size and Compression
#define kProductImageCompression 0.35
#define kProductImageWidth 480.0f
#define kProductImageHeight 640.0f
#define kProductImageSize CGSizeMake(kProductImageWidth, kProductImageHeight)

#pragma mark - Popover Sizes
#define kPopoverWidth 440.0f
#define kPopoverHeight 600.0f
#define kPopoverSize CGSizeMake(kPopoverWidth, kPopoverHeight)
#define kSmallPopoverSize CGSizeMake(kPopoverWidth-60, kPopoverHeight-100)

#pragma mark - UI Colors

#define kPinkColor [UIColor colorWithRed:233/255.0 green:150/255.0 blue:150/255.0 alpha:1.0]
#define kLightPinkColor [UIColor colorWithRed:241/255.0 green:188/255.0 blue:189/255.0 alpha:1.0]
#define kLightGrayColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0]
#define kMediumGrayColor [UIColor colorWithRed:233/255.0 green:234/255.0 blue:235/255.0 alpha:1.0]
#define kGrayColor [UIColor colorWithRed:214/255.0 green:219/255.0 blue:220/255.0 alpha:1.0]
#define kRedColor [UIColor colorWithRed:230/255.0 green:60/255.0 blue:60/255.0 alpha:1.0]
#define kBeigeColor [UIColor colorWithRed:228/255.0 green:218/255.0 blue:200/255.0 alpha:1.0]
#define kDarkBeigeColor [UIColor colorWithRed:218/255.0 green:204/255.0 blue:180/255.0 alpha:1.0]
#define kWallnutColor [UIColor colorWithRed:200/255.0 green:160/255.0 blue:130/255.0 alpha:1.0]

#pragma mark - StatusBar Notifications

#define kBlackNotification @"STBlackNotification"
#define KRedNotification @"STRedNotification"

#pragma mark - Standard Defaults Keys

#define kProductMode @"product_mode"
#define kProductModePhoto @"photo"
#define kProductModeGallery @"gallery"

#define kLoggedUserIdentifier @"logged_identifier"
#define kLoggedUserName @"logged_name"
#define kLoggedUserSurname @"logged_surname"
#define kLoggedUserEmail @"logged_email"
#define kLoggedUserPassword @"logged_password"
#define kLoggedUserImageURL @"logged_imagepath"
#define kLoggedUserRole @"logged_role"

#pragma mark - Entities Properties Keys
#define kImageFirst @"imageFirst"
#define kImageSecond @"imageSecond"
#define kImageThird @"imageThird"
#define kImageFourth @"imageFourth"
#define kProductImagesKeys @[kImageFirst,kImageSecond,kImageThird]
#define kCatalogImagesKeys @[kImageFirst,kImageSecond,kImageThird,kImageFourth]

#pragma mark - Mandatory Catalog Values
#define kCatalogGender @"gender"
#define kCatalogDesigner @"designer"
#define kCatalogCollection @"collection"
#define kCatalogDate @"date"
#define kCatalogDeadline @"dateDeadline"
#define kCatalogDeliveryFirst @"dateDeliveryFirst"
#define kCatalogDeliverySecond @"dateDeliverySecond"
#define kCatalogMandatoryValues @[kCatalogGender,kCatalogDesigner,kCatalogCollection,kCatalogDate, kCatalogDeadline, kCatalogDeliveryFirst, kCatalogDeliverySecond]

#pragma mark - Mandatory Product Values
#define kProductName @"name"
#define kProductCode @"code"
#define kProductSizeFamily @"sizeFamily"
#define kProductPriceBuy @"priceBuy"

#define kProductMandatoryValues @[kProductName,kProductCode,kProductSizeFamily,kProductPriceBuy]

#pragma mark - Cluster List Keys
#define kClusterAll @"cluster_all"
#define kClusterMembers @"cluster_members"
#define kClusterNonMembers @"cluster_non_members"

#pragma mark - Web Pages
#define kBaseWebsiteURLTEST @"http://intra05.nautes.eu/silviabinishowroom/"
#define kBaseWebsiteURL @"http://svbcatalogue.nautes.eu/"

#pragma mark - Images
#define kBaseImageURLTEST @"http://intra05.nautes.eu/silviabinishowroom/media/"
#define kBaseImageURL @"http://svbcatalogue.nautes.eu/media/"
#define kProductImagesURL @"products"
#define kCustomerImagesURL @"customers"
#define kUserImagesURL @"users"

#pragma mark - Synchronization
#define kBaseURLTEST @"http://intra05.nautes.eu/silviabinishowroom/restservice.svc/"
#define kBaseURL @"http://svbcatalogue.nautes.eu/restservice.svc/"

//CATALOG API
#define kCatalogListURL @"cataloggetlist"
#define kCatalogUploadURL @"catalogupload"
#define kCatalogDeleteURL @"catalogdelete"
#define kCatalogArchiveURL @"catalogstore"
#define KCatalogLockURL @"cataloglock"
#define kCatalogSendURL @"catalogsend"

#define kCatalogProductListURL @"productgetlist"

#define kProductUploadURL @"productupload"
#define kProductDeleteURL @"productdelete"

#define kCollectionsURL @"collectiongetlist"
#define kCollectionUploadURL @"collectionupload"

#define kGendersURL @"genregetlist"

#define kDesignersURL @"designergetlist"
#define kDesignerUploadURL @"designerupload"

#define kColorsURL @"colorgetlist"
#define kColorsUploadURL @"colorupload"

#define kMaterialsURL @"materialgetlist"
#define kMaterialUploadURL @"materialupload"

#define kSizeFamiliesURL @"sizegetlist"

#define kClustersURL @"clustergetlist"
#define kClusterCustomersURL @"customergetlist"
#define kClusterUploadURL @"clusterupload"
#define kClusterDeleteURL @"clusterdelete"

#define kCustomersURL @"customergetlistall"
#define kCustomerUploadURL @"customerupload"
#define kCustomerDeleteURL @"customerdelete"

#define kImageUploadURL @"imageupload"

#define kLoginURL @"userlogin"
#define kPasswordRecoveryURL @"passwordrecovery"

//in seconds                            sec     min
#define kAutoSyncTimeInterval   1.0     *60     *5

#pragma mark - Resource Keys

#define kResourcePrefix @"resource_"
#define kCatalogsResourceName @"catalogs"

#define kDesignersResourceName @"designers"
#define kCollectionsResourceName @"collections"

#define kProductsResourceName @"products"

#define kColorsResourceName @"colors"
#define kGendersResourceName @"genders"
#define kMaterialsResourceName @"materials"
#define kSizeFamiliesResourceName @"sizefamilies"

#define kCustomersResourceName @"customers"
#define kClustersResourceName @"clusters"

#pragma mark - Notification Center

#define kStartSync @"StartSync"
#define kEndSync @"EndSync"

#endif /* Constants_h */
