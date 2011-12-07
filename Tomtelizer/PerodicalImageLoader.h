//
//  PerodicalImageLoader.h
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/5/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageLoader.h"
#import "XmlParser.h"
#import "Constants.h"

@class PerodicalImageLoader;

@protocol PerodicalImageLoaderDelegate <NSObject>

- (void)perodicalImageLoader: (PerodicalImageLoader *)loader didReceiveXmasHats: (NSMutableArray *)xmasHats;

@end


@interface PerodicalImageLoader : NSObject

@property (nonatomic, weak) id <PerodicalImageLoaderDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic) BOOL isWorking;


- (void) startWorking;
- (void) stopWorking;

//private
- (void) doWork;

@end
