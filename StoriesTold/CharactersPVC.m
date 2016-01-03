//
//  CharactersPVC.m
//  StoriesTold
//
//  Created by Niko Zarzani on 1/1/16.
//  Copyright © 2016 IndieZiOS. All rights reserved.
//

#import "CharactersPVC.h"
#import "Constants.h"
#import "CharactersQTVC.h"
#import <Parse/Parse.h>
#import "Dimension.h"
#import "Character.h"
#import "NewCharacterTVC.h"

@interface CharactersPVC()

@property (strong, nonatomic) NSMutableArray * currentViewControllers;
@property (strong, nonatomic) UIViewController * currentViewController;
@property (strong, nonatomic) UIViewController *placeholderPage;
@property (strong, nonatomic) Dimension *currentDimension;

@property (strong, nonatomic) UIBarButtonItem *editBarButton;
@property (strong, nonatomic) UIBarButtonItem *addBarButton;

@property (strong, nonatomic) UIViewController *pendingViewController;

@end

@implementation CharactersPVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.currentViewControllers = [@[] mutableCopy];

    self.dataSource = self;
    self.delegate = self;

    UIViewController *placeholderPage = [self.storyboard instantiateViewControllerWithIdentifier:@"loadingVC"];
    self.placeholderPage = placeholderPage;
    
    self.dataSource = self;
    self.delegate = self;
    
    [self setViewControllers:@[placeholderPage] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Dimension"];
    
    [query orderByAscending:@"order"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        self.currentViewControllers = [@[] mutableCopy];

        for (PFObject *object in objects) {
            if ([object isKindOfClass:[Dimension class]]) {
                Dimension *dimension = (Dimension *)object;
                
                
                CharactersQTVC *charactersQTVC = (CharactersQTVC *)[self.storyboard
                                                                    instantiateViewControllerWithIdentifier:@"charactersQTVC"];
                charactersQTVC.dimension = dimension;
                
                [self.currentViewControllers addObject:charactersQTVC];
            }
        }
        if([self.currentViewControllers count] > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateNavBarForViewController:[self.currentViewControllers firstObject]];
                [self setViewControllers:@[[self.currentViewControllers firstObject]] direction:UIPageViewControllerNavigationDirectionForward
                                animated:YES
                              completion:^(BOOL finished){
                                  
                              }];
            });
        }
    }];
    
    self.view.backgroundColor = kBeigeColor;
    [self setupNavBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = kBeigeColor;
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = kDarkBeigeColor;
    
}

#pragma mark - NavBar Handling

- (void)updateNavBarForViewController:(UIViewController *)vc
{
    self.currentViewController = vc;
    if([vc isKindOfClass:[CharactersQTVC class]]){
        CharactersQTVC *charactersQTVC = (CharactersQTVC *)vc;
        self.currentDimension = charactersQTVC.dimension;
        self.navigationItem.title = charactersQTVC.dimension.name;
        [self setupRightBarButtonItems];
        [self setupLeftBarButtonItems];
    }
    else {
        self.navigationItem.title = @"Characters";
        self.navigationItem.rightBarButtonItems = nil;
    }

}

- (void)setupNavBar
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = kDarkBeigeColor;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)setupRightBarButtonItems
{
    
    UIImage *image = [[UIImage imageNamed:@"Add"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.addBarButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(newCharacter)];
    self.addBarButton.tintColor = [UIColor blackColor];
    self.addBarButton.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.navigationItem.rightBarButtonItems = @[self.addBarButton];
}

- (void)setupLeftBarButtonItems
{
    UIImage *editImage = [[UIImage imageNamed:@"Delete"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.editBarButton = [[UIBarButtonItem alloc] initWithImage:editImage style:UIBarButtonItemStylePlain target:self action:@selector(editTapped)];
    self.editBarButton.tintColor = [UIColor blackColor];
    self.editBarButton.imageInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    self.navigationItem.leftBarButtonItems = @[self.editBarButton];
}

- (void)editTapped
{
    if([self.editBarButton.tintColor isEqual:[UIColor blackColor]]){
        self.editBarButton.tintColor = [UIColor whiteColor];
    }
    else
    {
        self.editBarButton.tintColor = [UIColor blackColor];
    }
    
    self.addBarButton.enabled = !self.addBarButton.enabled;
    
    if([self.currentViewController isKindOfClass:[CharactersQTVC class]]){
        CharactersQTVC *charactersQTVC = (CharactersQTVC *)self.currentViewController;
        [charactersQTVC editTapped];
    }
}

- (void)newCharacter
{
    [self editCharacter:nil];
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
    newCharacterTVC.dimension = self.currentDimension;
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
            if([self.currentViewController isKindOfClass:[CharactersQTVC class]]){
                CharactersQTVC *charactersQTVC = (CharactersQTVC *)self.currentViewController;
                [charactersQTVC loadObjects];
            }
        });
    }];
}

#pragma mark - UIPageViewConteollerDelegate

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    for (UIViewController *vc in pendingViewControllers) {
        self.pendingViewController = vc;
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if(completed && self.pendingViewController){
        [self updateNavBarForViewController:self.pendingViewController];
        self.pendingViewController = nil;
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.currentViewControllers indexOfObject:viewController];
    
    if ((index <= 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    UIViewController *vc = [self viewControllerAtIndex:index];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.currentViewControllers indexOfObject:viewController];
   
    if (index == NSNotFound || index >= [self.currentViewControllers count] ) {
        return nil;
    }
    
    index++;
    
    UIViewController *vc = [self viewControllerAtIndex:index];
    return vc;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if([self.currentViewControllers count] == 0){
        return self.placeholderPage;
    }
    
    if (([self.currentViewControllers count] == 0) || (index >= [self.currentViewControllers count])) {
        return nil;
    }
    
    UIViewController *pageContentViewController = nil;
    
    if(index < [self.currentViewControllers count]){
        pageContentViewController =  [self.currentViewControllers objectAtIndex:index];
    }
        
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    NSInteger count = [self.currentViewControllers count];
    if(count == 0){
        return 1;
    }
    return [self.currentViewControllers count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
