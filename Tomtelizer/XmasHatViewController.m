//
//  XmasHatViewController.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/1/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "XmasHatViewController.h"

//Add reverse to mutable array:
// http://stackoverflow.com/questions/586370/how-can-i-reverse-a-nsarray-in-objective-c
//
@implementation NSMutableArray (Reverse)

- (void)reverse {
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        i++;
        j--;
    }
}
@end


@implementation XmasHatViewController {
    ImageLoader *imageLoader;
}

@synthesize images, tableView;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
#ifndef TEST
    PerodicalImageLoader * loader = [PerodicalImageLoader alloc];
    loader.delegate = self;
    [loader startWorking];
#endif
}

#pragma mark PerodicalImageLoaderDelegate

- (void)perodicalImageLoader: (PerodicalImageLoader *)loader didReceiveXmasHats:(NSMutableArray *)xmasHats {
    
    NSLog(@"perodicalImageLoader: didReceiveThumbnailList");
    images = xmasHats;
    [self performSelectorOnMainThread:@selector(refreshTableView) withObject:nil waitUntilDone:NO];
}
- (void) refreshTableView
{
    NSLog(@"refreshTableView");
    //[images reverse];
    [tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.images count];
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XmasHatCell *cell = (XmasHatCell *)[tView dequeueReusableCellWithIdentifier:@"XmasHatCell"];
    
	XmasHat *hat = [self.images objectAtIndex:indexPath.row];
    NSLog(@"%@", hat.imageName);
    
    cell.xmasHatImageView.image = hat.image;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    NSLog(@"prepareForSegue:");
    
    XmasHatCell *cell = (XmasHatCell *) sender;
    NSIndexPath *indexPath = [(UITableView *)cell.superview indexPathForCell: cell];
    NSLog(@"indexPath: %@", indexPath);
    XmasHat *hat = [images objectAtIndex:indexPath.row];
    
	if ([segue.identifier isEqualToString:@"ViewBigImage"])
	{
		XmasHatDetailsController *xController = segue.destinationViewController;

        xController.urlToBigImage = [NSString stringWithFormat: @"%@%@/%@%@", ServerHost, UploadedImagesPath, HatifiedImagePrefix, hat.imageName];
        //[images reverse];
        [tableView reloadData];
	}
}


@end
