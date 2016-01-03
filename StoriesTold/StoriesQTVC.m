//
//  StoriesQTVC.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/27/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "StoriesQTVC.h"
#import "Constants.h"
#import "Story.h"
#import "StoryQTVCell.h"
#import "LoadingQTVCell.h"
#import "StoryQTVC.h"
#import "NewStoryVC.h"
#import "Utilities.h"
#import "JDStatusBarNotification.h"

@implementation StoriesQTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kBeigeColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self setupNavBar];
    
    if(self.dimension){
        [self setupRightBarButtonItems];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupNavBar
{
    //    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = kDarkBeigeColor;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    if(self.dimension){
        self.navigationItem.title = self.dimension.name;
    }
}

- (void)setupRightBarButtonItems
{
    
    UIImage *image = [[UIImage imageNamed:@"Add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIBarButtonItem *plusBarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(newStory)];
    plusBarButton.tintColor = [UIColor blackColor];
    plusBarButton.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    
    self.navigationItem.rightBarButtonItems = @[plusBarButton];
}

- (void)newStory
{
    [self editStory:nil];
}

- (void)editStory:(Story *)story
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UINavigationController *newStoryNC = (UINavigationController *)[mainStoryboard
                                                                        instantiateViewControllerWithIdentifier:@"newStory"];
    NSArray *viewContrlls=[newStoryNC viewControllers];
    
    NewStoryVC *newStoryVC = (NewStoryVC *)[viewContrlls lastObject];
    newStoryVC.createStoryDelegate = self;
    newStoryVC.dimension = self.dimension;
    newStoryVC.story = story;
    
    newStoryNC.preferredContentSize = kPopoverSize;
    newStoryVC.preferredContentSize = kPopoverSize;
    
    newStoryNC.modalPresentationStyle = UIModalPresentationFormSheet;
    newStoryNC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:newStoryNC animated:YES completion:^{
//        [quickProductPVC takePhoto];
    } ];
    
    // Get the popover presentation controller and configure it.
//    self.currentPresentationController =
//    [quickProductNC popoverPresentationController];
}


- (PFQuery *)queryForTable {
    
    self.parseClassName = @"Story";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 8;
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    if(self.dimension){
        [query whereKey:@"dimension" equalTo:self.dimension];
    }
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"homeStoryCell";
    
    StoryQTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell updateFromObject:object];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    StoryQTVC *storyQTVC = (StoryQTVC *)segue.destinationViewController;
    
    PFObject *object = [self objectAtIndexPath:selectedIndexPath];
    if([object isKindOfClass:[Story class]]){
        storyQTVC.story = (Story *)object;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height - scrollView.contentOffset.y < (self.view.bounds.size.height)) {
        if (![self isLoading]) {
            [self loadNextPage];
        }
    }
}

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"loadingStoryCell";
    
    LoadingQTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    return cell;

}

#pragma mark - NewStoryDelegate

- (void)cancelTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneTapped
{
    [self dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadObjects];
        });
    }];
}

#pragma mark - Swipe Actions

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [self objectAtIndexPath:indexPath];
    if([object isKindOfClass:[Story class]]){
        Story *story = (Story *)object;
        CGFloat cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        
        //SHARE
        UITableViewRowAction * shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"       " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            //        [self editProductAtIndexPath: indexPath];
        }];
        UIImage * shareImage = [UIImage imageNamed:@"Send"];
        
        UIImage * shareActionImage = [Utilities swipeImageWithImage:shareImage fillColor:[UIColor blackColor] backgroundColor:[UIColor whiteColor] rectSize:CGSizeMake(62, cellHeight)];
        shareAction.backgroundColor = [UIColor colorWithPatternImage:shareActionImage];
        
        if ([story.createdBy.objectId isEqualToString:[PFUser currentUser].objectId]) {
            //DELETE
            UITableViewRowAction * deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"       " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                [story deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadObjects];
                        [self.tableView reloadData];
                    });
                }];
            }];
            UIImage * deleteImage = [UIImage imageNamed:@"Delete"];
            UIImage * deleteActionImage = [Utilities swipeImageWithImage:deleteImage fillColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] rectSize:CGSizeMake(62, cellHeight)];
            deleteAction.backgroundColor = [UIColor colorWithPatternImage:deleteActionImage];
            
            
            //EDIT
            UITableViewRowAction * editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"       " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                [self editStory:story];
            }];
            UIImage * pencilImage = [UIImage imageNamed:@"Pencil"];
            UIImage * pencilActionImage = [Utilities swipeImageWithImage:pencilImage fillColor:[UIColor blackColor] backgroundColor:kGrayColor rectSize:CGSizeMake(62, cellHeight)];
            editAction.backgroundColor = [UIColor colorWithPatternImage:pencilActionImage];

            return @[deleteAction, editAction, shareAction];
        }
        else {
            return @[shareAction];
        }
    }
    else {
        return @[];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Nothing is needed here
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end

