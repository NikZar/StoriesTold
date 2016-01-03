//
//  NewCharacterTVC.m
//  StoriesTold
//
//  Created by Niko Zarzani on 1/2/16.
//  Copyright © 2016 IndieZiOS. All rights reserved.
//

#import "NewCharacterTVC.h"
#import "Constants.h"
#import <ParseUI/ParseUI.h>
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "TheAmazingAudioEngine.h"
#import "AERecorder.h"
#import "TPOscilloscopeLayer.h"
#import "AEReverbFilter.h"
#import "AELowPassFilter.h"
#import "AEDistortionFilter.h"
#import "AENewTimePitchFilter.h"

@interface NewCharacterTVC()

@property (nonatomic, strong) AEAudioController *audioController;
@property (nonatomic, strong) AERecorder *recorder;
@property (nonatomic, strong) AEAudioFilePlayer *player;

@property (strong, nonatomic) UIBarButtonItem *doneBarButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet PFImageView *characterImageView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playStopButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderSegmentedControl;
@property (strong, nonatomic) PFFile *audioDescription;
@property (strong, nonatomic) NSData *characterImage;
@property (weak, nonatomic) IBOutlet UIButton *dimesionButton;

@end

@implementation NewCharacterTVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kBeigeColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    
    
    self.recordButton.layer.cornerRadius = self.recordButton.frame.size.width/2;
    self.recordButton.imageView.image = [self.recordButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.playStopButton.layer.cornerRadius = self.recordButton.frame.size.width/2;
    self.playStopButton.imageView.image = [self.recordButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.characterImageView.backgroundColor = kLightGrayColor;
    self.characterImageView.layer.cornerRadius = self.characterImageView.frame.size.width / 2;
    self.characterImageView.layer.borderColor = kDarkBeigeColor.CGColor;
    self.characterImageView.layer.borderWidth = 2.0;
    [self loadImage];
    
    [self.nameTextField becomeFirstResponder];
    
    self.nameTextField.text = self.character.name;
    
    self.audioDescription = self.character.audioDescription;
    
    self.genderSegmentedControl.selectedSegmentIndex = [self.character.gender integerValue];
    
    if(self.character){
        self.dimension = self.character.dimension;
        [self.dimension fetchIfNeeded];
    }
    
    [self.dimesionButton setTitle:self.dimension.name forState:UIControlStateNormal];
    self.dimesionButton.enabled = NO;
    
    [self setupNavBar];
    
    [self setupLeftBarButtonItems];
    [self setupRightBarButtonItems];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupNavBar
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = kDarkBeigeColor;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = self.character.name ? self.character.name : @"New Character";
}

- (void)setupLeftBarButtonItems
{
    UIBarButtonItem *cancelBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelTapped)];
    cancelBarButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.leftBarButtonItems = @[cancelBarButton];
}

- (void)setupRightBarButtonItems
{
    self.doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneTapped)];
    self.doneBarButton.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItems = @[self.doneBarButton];
}

- (void)cancelTapped
{
    [self.createCharacterDelegate cancelTapped];
}

- (void)doneTapped
{
    self.doneBarButton.enabled = NO;
    
    Character * character = self.character;
    if(!character){
        character = [Character object];
        character.createdBy = [PFUser currentUser];
    }
    character.dimension = self.dimension;
    character.audioDescription = self.audioDescription;
    character.gender = [NSNumber numberWithInteger:self.genderSegmentedControl.selectedSegmentIndex];
    character.name = self.nameTextField.text;

    if(self.characterImage){
        character.image = [PFFile fileWithData:self.characterImage];
    }
    
    [character saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.createCharacterDelegate doneTapped];
            });
        }
    }];
}

#pragma mark - Audio Handling

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAudio];
    [super viewWillDisappear:animated];
}

- (void)stopAudio
{
    [self stop];
    [self stopRecord];
}

#pragma mark - Play Abstract

- (AEAudioController *)audioController
{
    if(!_audioController){
        AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
        _audioController = appDelegate.audioController;
    }
    return _audioController;
}

- (void)play
{
    if(!self.player){
        [self.audioDescription getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Audio.m4a"];
            [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            
            self.player = [AEAudioFilePlayer audioFilePlayerWithURL:[NSURL fileURLWithPath:path] error:&error];
            
            if ( !self.player ) {
                NSLog(@"player not set");
            }
            
            self.player.removeUponFinish = YES;
            
            __weak NewCharacterTVC *weakSelf = self;
            self.player.completionBlock = ^{
                NewCharacterTVC *strongSelf = weakSelf;
                weakSelf.player = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                    strongSelf.playStopButton.selected = NO;
                });
            };
            
            [self.audioController addChannels:@[self.player]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.playStopButton.selected = YES;
            });
        }];
    }
}

- (void)stop
{
    if(self.player){
        [self.audioController removeChannels:@[self.player]];
        self.player = nil;
        self.playStopButton.selected = NO;
    }
}

- (IBAction)playStopTapped:(id)sender {
    if (self.player) {
        [self stop];
    } else {
        [self play];
    }
}

#pragma mark - Record Abstract

-(void)setAudioDescription:(PFFile *)audioDescription
{
    self.playStopButton.enabled = audioDescription != nil;
    _audioDescription = audioDescription;
}

- (void)record
{
    self.recorder = [[AERecorder alloc] initWithAudioController:self.audioController];
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.m4a"];
    NSError *error = nil;
    if ( ![self.recorder beginRecordingToFileAtPath:path fileType:kAudioFileM4AType error:&error] ) {
        NSLog(@"Couldn't start recording: %@", [error localizedDescription]);
        self.recorder = nil;
        return;
    }
    
    self.recordButton.selected = YES;
    self.recordButton.backgroundColor = kRedColor;
    
    [self.audioController addOutputReceiver:self.recorder];
    [self.audioController addInputReceiver:self.recorder];
}

- (void)stopRecord
{
    if (self.recorder) {
        [self.recorder finishRecording];
        [self.audioController removeOutputReceiver:self.recorder];
        [self.audioController removeInputReceiver:self.recorder];
        self.recorder = nil;
        
        self.recordButton.selected = NO;
        self.recordButton.backgroundColor = [UIColor whiteColor];
        
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [documentsFolders[0] stringByAppendingPathComponent:@"Recording.m4a"];
        
        if ( [[NSFileManager defaultManager] fileExistsAtPath:path] ) {
            self.audioDescription = [PFFile fileWithData:[[NSFileManager defaultManager] contentsAtPath:path]];
        }
    }
}

- (IBAction)recordButtonDidTapped:(id)sender {
    if (self.recorder) {
        [self stopRecord];
    } else {
        [self record];
    }
}

#pragma mark - Image Handling

- (IBAction)changeImageTapped:(id)sender {
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}

- (BOOL)startMediaBrowserFromViewController: (UIViewController*) controller
                              usingDelegate: (id <UIImagePickerControllerDelegate,
                                              UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    mediaUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = delegate;
    
    [controller presentViewController:mediaUI animated:YES completion:^{
        
    }];
    
    return YES;
}

- (void)loadImage
{
    if(self.characterImage){
        self.characterImageView.image = [UIImage imageWithData:self.characterImage];
        self.characterImageView.file = nil; // remote image
    }
    else {
        self.characterImageView.image = [UIImage imageNamed:@"Male"];
        self.characterImageView.file = self.character.image; // remote image
        [self.characterImageView loadInBackground];
    }
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    self.characterImage = UIImageJPEGRepresentation(image, 0.7);

    [self loadImage];
    [self dismissViewControllerAnimated:YES completion:NULL];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
