//
//  XmasHatViewController.h
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/1/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XmasHatCell.h"
#import "XmasHat.h"
#import "XmasHatDetailsController.h"
#import "PerodicalImageLoader.h"
#import "Constants.h"
@class AppDelegate;

@interface XmasHatViewController : UITableViewController <PerodicalImageLoaderDelegate> {
    PerodicalImageLoader * loader;
}

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

-(void) reloadPerodicalImageLoaderImages;

@end
