//
//  CharactersQTVC.m
//  StoriesTold
//
//  Created by Niko Zarzani on 1/1/16.
//  Copyright © 2016 IndieZiOS. All rights reserved.
//

#import "CharactersQTVC.h"
#import "Constants.h"
#import "CharacterQTVCell.h"
#import "Character.h"
#import "Utilities.h"
#import "NewCharacterTVC.h"

@implementation CharactersQTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kBeigeColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    
}

- (PFQuery *)queryForTable {
    
    self.parseClassName = @"Character";
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
    [query whereKey:@"createdBy" equalTo:[PFUser currentUser]];

    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"characterCell";
    
    CharacterQTVCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell updateFromObject:object];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
//    StoryQTVC *storyQTVC = (StoryQTVC *)segue.destinationViewController;
    
    PFObject *object = [self objectAtIndexPath:selectedIndexPath];
    if([object isKindOfClass:[Character class]]){
//        storyQTVC.story = (Story *)object;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if(self.tableView.isEditing){
        [self.tableView setEditing:NO animated:YES];
    }
}

- (void)editTapped
{
    if(self.tableView.isEditing){
        [self.tableView setEditing:NO animated:YES];
    }
    else {
        [self.tableView setEditing:YES animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [self objectAtIndexPath:indexPath];
    if([object isKindOfClass:[Character class]]){
        Character *character = (Character *)object;
        [self editCharacter:character];
    }
}

#pragma mark - Swipe Actions

-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [self objectAtIndexPath:indexPath];
    if([object isKindOfClass:[Character class]]){
        Character *character = (Character *)object;
        CGFloat cellHeight = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        
        if ([character.createdBy.objectId isEqualToString:[PFUser currentUser].objectId]) {
            //DELETE
            UITableViewRowAction * deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"      " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                [character deleteInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Nothing is needed here
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)editCharacter:(Character *)character
{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UINavigationController *newCharacterNC = (UINavigationController *)[mainStoryboard
                                                                        instantiateViewControllerWithIdentifier:@"newCharacter"];
    NSArray *viewControllers = [newCharacterNC viewControllers];
    
    NewCharacterTVC *newCharacterTVC = (NewCharacterTVC *)[viewControllers lastObject];
    newCharacterTVC.createCharacterDelegate = self;
    newCharacterTVC.dimension = self.dimension;
    newCharacterTVC.character = character;
    
    newCharacterNC.preferredContentSize = kPopoverSize;
    newCharacterTVC.preferredContentSize = kPopoverSize;
    
    newCharacterNC.modalPresentationStyle = UIModalPresentationFormSheet;
    newCharacterNC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:newCharacterNC animated:YES completion:^{
        //        [quickProductPVC takePhoto];
    } ];
    
    // Get the popover presentation controller and configure it.
    //    self.currentPresentationController =
    //    [quickProductNC popoverPresentationController];
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

@end
