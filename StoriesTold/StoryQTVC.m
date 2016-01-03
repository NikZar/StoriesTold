//
//  StoryQTVC.m
//  StoriesTold
//
//  Created by Niko Zarzani on 12/2/15.
//  Copyright © 2015 IndieZiOS. All rights reserved.
//

#import "StoryQTVC.h"
#import "Constants.h"
#import <Parse/Parse.h>
#import "VoiceQTVCell.h"
#import "RecordVC.h"
#import "Voice.h"
#import "Utilities.h"

@interface StoryQTVC()

@property (strong, nonatomic) RecordVC *recordVC;

@end

@implementation StoryQTVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kBeigeColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.recordVC  = [sb instantiateViewControllerWithIdentifier:@"recordVC"];
    self.recordVC.recordDelegate = self;
    self.recordVC .story = self.story;
    
    [self setupNavBar];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = nil;
    if (section == [tableView numberOfSections] - 1) {
        view = self.recordVC.view;
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (void)setupNavBar
{
    //    self.navigationController.navigationBar.translucent = NO;
    NSString *title =self.story[@"title"];
    self.navigationItem.title = title;
    self.navigationController.navigationBar.barTintColor = kDarkBeigeColor;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (PFQuery *)queryForTable {
    
    self.parseClassName = @"Voice";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 25;
    
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    if(self.story){
        [query whereKey:@"story" equalTo:self.story];
    }
    
    [query orderByAscending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"storyVoiceCell";
    
    VoiceQTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell updateFromObject:object];
    
    return cell;
}

#pragma mark - RecordVCDelegate

-(void)recordFinished
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadObjects];
    });
}

#pragma mark - Swipe Actions

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [self objectAtIndexPath:indexPath];
    if([object isKindOfClass:[Voice class]]){
        Voice *voice = (Voice *)object;
        CGFloat cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        
        if ([voice.createdBy.objectId isEqualToString:[PFUser currentUser].objectId]) {
            //DELETE
            UITableViewRowAction * deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"      " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                [voice deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadObjects];
                        [self.tableView reloadData];
                    });
                }];
            }];
            UIImage * deleteImage = [UIImage imageNamed:@"Delete"];
            UIImage * deleteActionImage = [Utilities swipeImageWithImage:deleteImage fillColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] rectSize:CGSizeMake(62, cellHeight)];
            deleteAction.backgroundColor = [UIColor colorWithPatternImage:deleteActionImage];
            
            return @[deleteAction];
        }
        else {
            return @[];
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
    PFObject *object = [self objectAtIndexPath:indexPath];
    if([object isKindOfClass:[Voice class]]){
        Voice *voice = (Voice *)object;
        return [voice.createdBy.objectId isEqualToString:[PFUser currentUser].objectId];
    }
    else{
        return NO;
    }
}

@end
