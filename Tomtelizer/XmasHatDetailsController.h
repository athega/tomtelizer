//
//  XmasHatDetailsController.h
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/1/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XmasHatDetailsController : UIViewController<NSURLConnectionDelegate>

@property (nonatomic, strong) NSString *urlToBigImage;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *progressIndicator;

@end
