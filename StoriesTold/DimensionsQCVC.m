//
//  DimensionsQCVC.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/26/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "DimensionsQCVC.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "DimensionQCVCell.h"
#import "StoriesQTVC.h"

@interface DimensionsQCVC()

@property (strong, nonatomic) UIPageControl *pageControl;

@end

@implementation DimensionsQCVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = kBeigeColor;
 
    [self setupNavBar];

    [self.queryForCollection countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        [self setupPageControlWithNumberOfPages:number];
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    pageControl.backgroundColor = [UIColor clearColor];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.collectionView.frame.size.width;
    self.pageControl.currentPage = self.collectionView.contentOffset.x / pageWidth;
}

- (void)setupPageControlWithNumberOfPages:(NSInteger) numberOfPages
{
    dispatch_async(dispatch_get_main_queue(), ^{

        if(self.pageControl){
            [self.pageControl removeFromSuperview];
            self.pageControl = nil;
        }
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        self.pageControl.numberOfPages = numberOfPages;
        self.pageControl.currentPage = 0;
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.view addSubview:self.pageControl];
        
        [self.pageControl removeConstraints:self.pageControl.constraints];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1.0
                                                               constant:0.0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:0.0]];
        
        [self.pageControl addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:1.0
                                                                      constant:100]];
        [self.pageControl addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:1.0
                                                                      constant:40]];
        [self.pageControl updateConstraints];
        [self.view updateConstraints];
    });
}

- (void)setupNavBar
{
    self.navigationItem.title = @"";
    self.navigationController.navigationBarHidden = YES;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Adjust cell size for orientation
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 24);
    }
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 24);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.collectionView performBatchUpdates:nil completion:nil];
}

- (PFQuery *)queryForCollection
{
    
    self.parseClassName = @"Dimension";
    self.pullToRefreshEnabled = NO;
    self.paginationEnabled = NO;
    self.objectsPerPage = 5;
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByAscending:@"order"];
    
    return query;
}

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                 object:(PFObject *)object
{
    static NSString *CellIdentifier = @"dimensionCell";
    
    DimensionQCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    [cell updateFromObject:object];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    StoriesQTVC *storyQTVC = (StoriesQTVC *)segue.destinationViewController;
    storyQTVC.dimension = (Dimension *)[self objectAtIndexPath:selectedIndexPath];
}

@end
