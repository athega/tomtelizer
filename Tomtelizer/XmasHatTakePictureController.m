//
//  XmasHatTakePictureController.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/6/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "XmasHatTakePictureController.h"

@interface XmasHatTakePictureController()
- (void) enableCtrls;
- (void) disableCtrls;
@end

@implementation XmasHatTakePictureController

@synthesize hatModeSegmentedCtrl, takePictureButton, progressIndicator, iPadPopoverController;

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


- (void) enableCtrls {
    takePictureButton.enabled = YES;
    hatModeSegmentedCtrl.enabled = YES;
    progressIndicator.hidden = YES;
    [progressIndicator stopAnimating];
    
}
- (void) disableCtrls {
    takePictureButton.enabled = NO;
    hatModeSegmentedCtrl.enabled = NO;
    progressIndicator.hidden = NO;
    [progressIndicator startAnimating];
}

- (IBAction) buttonPressed:(id)sender {
    
    if(![browser isWorking]){
        
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        
        if([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeCamera)]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            /* we need camera meta data */
            /*
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No camera found!" 
                                                            message:@"Image picker is not supported" 
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            return;
            */
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        [self disableCtrls];
        
        NSLog(@"%ld", (long)hatModeSegmentedCtrl.selectedSegmentIndex);
        switch (hatModeSegmentedCtrl.selectedSegmentIndex) {
            case 0:
                processFeatureData = YES;
                break;
            case 1:
            default:
                processFeatureData = NO;
                break;
        }
        
        switch (UI_USER_INTERFACE_IDIOM()) {
            case UIUserInterfaceIdiomPhone:
                //
                [self presentViewController:picker animated:YES completion:nil];
                break;
            case UIUserInterfaceIdiomPad:
                NSLog(@"We're an iPad - must wrap picker in a popover");
                //TODO: wrap
                iPadPopoverController = [[UIPopoverController alloc] initWithContentViewController:picker];
                self.iPadPopoverController = iPadPopoverController;          
                iPadPopoverController.delegate = self;
                NSLog(@"presentPopoverFromBarButtonItem:");

                [iPadPopoverController presentPopoverFromRect: takePictureButton.frame 
                                                       inView: [self view] 
                                     permittedArrowDirections: UIPopoverArrowDirectionAny 
                                                     animated: YES];
            default:
                break;
        }
        
    } else {
        NSLog(@"browser is working - ignoring buttonPressed...");
    }
}

#pragma mark - UIPopoverControllerDelegate REMOVE??

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    NSLog(@"popoverControllerDidDismissPopover");
    [self.iPadPopoverController dismissPopoverAnimated:YES];
    
    [self enableCtrls];
}

#pragma mark - HttpBrowserDelegate

- (void)browser: (HttpBrowser *)browser didReceiveBody: (NSString *)body {
    [self performSelectorOnMainThread:@selector(enableCtrls) withObject:nil waitUntilDone:NO];
}

- (void)failedToSendData {
    [self performSelectorOnMainThread:@selector(displayError) withObject:nil waitUntilDone:NO];
}
- (void)displayError {
    
    [self enableCtrls];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Server error" 
                                                    message: [@"Failed to send data to host " stringByAppendingString: ServerHost]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK" 
                                          otherButtonTitles: nil];
    [alert show];

}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSLog(@"imagePickerController:didFinishPickingMediaWithInfo:");
    
    UIImage* image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObject:image forKey: @"image"];
    
    NSDictionary * metaData = [info objectForKey:@"UIImagePickerControllerMediaMetadata"];
    if(metaData){
        [params setObject: metaData forKey: @"metadata"];
    }
    [params setObject:(processFeatureData ? @"true" : @"false") forKey: @"processFeatures"];
    
    [browser sendImageDict: params toUrl: NewImageUrl];

    [picker dismissModalViewControllerAnimated:YES];
    [self.iPadPopoverController dismissPopoverAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"imagePickerControllerDidCancel");
    
    [picker dismissModalViewControllerAnimated:YES];
    [self.iPadPopoverController dismissPopoverAnimated:YES];

    [self enableCtrls];
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
