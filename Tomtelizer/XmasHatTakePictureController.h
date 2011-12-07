//
//  XmasHatTakePictureController.h
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/6/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpBrowser.h"
#import "Constants.h"

@interface XmasHatTakePictureController : UIViewController <UIImagePickerControllerDelegate, 
                                                            UINavigationControllerDelegate,
                                                            HttpBrowserDelegate> {
    BOOL processFeatureData;
    HttpBrowser *browser;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *hatModeSegmentedCtrl;
@property (nonatomic, retain) IBOutlet UIButton *takePictureButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *progressIndicator;

@end
