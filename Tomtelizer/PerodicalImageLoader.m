//
//  PerodicalImageLoader.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/5/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "PerodicalImageLoader.h"

@implementation PerodicalImageLoader {
    BOOL isWorking;
    XmlParser *parser;
    ImageLoader *imageLoader;
    NSThread* myThread;
    BOOL timeToReloadImages;
}

@synthesize delegate, images;


- (void) initThread {
    NSLog(@"initThread!!");
    self.isWorking = YES;
    
    imageLoader = [[ImageLoader alloc] initWithHost: ServerHost
                                    thumbnailPrefix: ThumbnailPrefix
                                        imagePrefix: HatifiedImagePrefix
                                                uri: UploadedImagesPath];
    
    myThread = [[NSThread alloc] initWithTarget:self
                                       selector:@selector(doWork)
                                         object:nil];
    [myThread start];
}

- (void) stopWorking {
    self.isWorking = NO;
    NSLog(@"STOP WORKING");
}

- (void) doWork {
    while (self.isWorking) {
        NSLog(@"doing work");
        
        NSMutableArray *thumbsToLoad = [[NSMutableArray array] init];
        
        
        NSURL *xmlURL = [NSURL URLWithString: LatestImagesUrl];
        
        NSLog(@"loading thumbnails...");
        parser = [XmlParser alloc];
        [parser loadThumbnailsFromXml:xmlURL toMutableArray: &thumbsToLoad];
        
        NSLock *arrayLock = [[NSLock alloc] init];
        [arrayLock lock];
        if(images==NULL || self.timeToReloadImages){
            NSLog(@"INFO: initializing images array.");
            images = [[NSMutableArray array] init];
            self.timeToReloadImages = NO;
        }
        images = [imageLoader loadThumbnails:thumbsToLoad toImageArray: images];
        [arrayLock unlock];
        
        [self.delegate perodicalImageLoader: self didReceiveXmasHats: images];
        
        [NSThread sleepForTimeInterval: 15];
    }
    //[NSThread exit];
    NSLog(@"STOPPING update thread");
}

- (BOOL)isWorking {
    BOOL b;
    @synchronized(self) {
        b = isWorking;
    }
    return b;
}

- (void)setIsWorking:(BOOL)b {
    @synchronized(self) {
        if (b != isWorking) {
            isWorking = b;
        }
    }
}
- (BOOL)timeToReloadImages {
    NSLog(@"timeToReloadImages getter");
    BOOL b;
    @synchronized(self) {
        b = timeToReloadImages;
    }
    return b;
}

- (void)setTimeToReloadImages:(BOOL)b {
    NSLog(@"timeToReloadImages setter");
    @synchronized(self) {
        if (b != timeToReloadImages) {
            timeToReloadImages = b;
        }
    }
}

@end
