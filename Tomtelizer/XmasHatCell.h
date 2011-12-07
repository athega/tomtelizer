//
//  XmasHatCell.h
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/1/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XmasHatCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *xmasHatImageView;
@property (nonatomic, copy) NSString *imageUrl;

- (void) loadImageFromUrl: (NSString *)url;

@end
