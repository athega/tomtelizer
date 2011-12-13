//
//  ImageLoader.h
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/2/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmasHat.h"

@interface ImageLoader : NSObject {
    NSString *host;
    NSString *thumbPrefix;
    NSString *imagePrefix;
    NSString *uri;
}

-(id) initWithHost:(NSString *)host thumbnailPrefix:(NSString *)thumbnailPrefix imagePrefix:(NSString *)imagePrefix uri:(NSString *)uri;

-(NSMutableArray *) loadThumbnails:(NSArray *)listOfImages toImageArray:(NSMutableArray *) images;

- (UIImage *) loadImage:(NSString *)imageName withChecksum:(NSString *)checksum;

@end
