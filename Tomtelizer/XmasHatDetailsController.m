//
//  XmasHatDetailsController.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/1/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "XmasHatDetailsController.h"

@implementation XmasHatDetailsController {
    NSMutableData * imageData;
}

@synthesize urlToBigImage, imageView , progressIndicator;

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

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", urlToBigImage);
    
    // Create the request.
    
    NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString: urlToBigImage]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                           timeoutInterval:10.0];

    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if (conn) {

        NSLog(@"got connection!");
        imageData = [NSMutableData data];
        
        progressIndicator.hidden = NO;
        [progressIndicator startAnimating];

        
    } else {
        //
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    //NSLog(@"didReceiveData - length: %d", data.length);
    [imageData appendData:data];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"Received %lu bytes of data",(unsigned long)[imageData length]);
    
    UIImage *image = [UIImage imageWithData:imageData];
    imageView.image = image;
    
    progressIndicator.hidden = YES;
    [progressIndicator stopAnimating];

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
