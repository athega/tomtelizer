//
//  HttpBrowser.h
//  sketch1
//
//  Created by Petter Petersson on 11/1/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeatureFinder.h"

extern int const NUM_SLEEP_SECONDS;

@class HttpBrowser;

@protocol HttpBrowserDelegate <NSObject>

- (void)browser: (HttpBrowser *)browser didReceiveBody: (NSString *)body;

@end


@interface HttpBrowser : NSObject {
    BOOL isWorking;
    FeatureFinder  *featureFinder;
}
@property BOOL isWorking;

@property (nonatomic, weak) id <HttpBrowserDelegate> delegate;

- (void) sendImageDict: (NSDictionary *) info toUrl:(NSString *)url;

@end
