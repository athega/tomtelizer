//
//  XmasHatTakePictureController.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/6/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "XmasHatTakePictureController.h"

@implementation XmasHatTakePictureController 

@synthesize hatModeSegmentedCtrl, takePictureButton, progressIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (IBAction) buttonPressed:(id)sender {
    
    if(![browser isWorking]){
        takePictureButton.enabled = NO;
        hatModeSegmentedCtrl.enabled = NO;
        progressIndicator.hidden = NO;
        [progressIndicator startAnimating];
        
        NSLog(@"%d", hatModeSegmentedCtrl.selectedSegmentIndex);
        switch (hatModeSegmentedCtrl.selectedSegmentIndex) {
            case 0:
                processFeatureData = YES;
                break;
            case 1:
            default:
                processFeatureData = NO;
                break;
        }
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        if([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentModalViewController:picker animated:YES];
    } else {
        NSLog(@"browser is working - ignoring buttonPressed...");
    }
}
#pragma mark - HttpBrowserDelegate

- (void)browser: (HttpBrowser *)browser didReceiveBody: (NSString *)body {
    NSLog(@"browser: didReceiveBody:");

    takePictureButton.enabled = YES;
    hatModeSegmentedCtrl.enabled = YES;
    [progressIndicator stopAnimating];
    progressIndicator.hidden = YES;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:image forKey: @"image"];
    [params setObject:[info objectForKey:@"UIImagePickerControllerMediaMetadata"] forKey: @"metadata"];
    [params setObject:(processFeatureData ? @"true" : @"false") forKey: @"processFeatures"];
    
    [browser sendImageDict: params toUrl: NewImageUrl];

    [picker dismissModalViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissModalViewControllerAnimated:YES];

    takePictureButton.enabled = YES;
    hatModeSegmentedCtrl.enabled = YES;
    progressIndicator.hidden = YES;
    [progressIndicator stopAnimating];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"allocating and initializing browser..");
    browser = [[HttpBrowser alloc] init];
    browser.delegate = self;
    progressIndicator.hidden = YES;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
