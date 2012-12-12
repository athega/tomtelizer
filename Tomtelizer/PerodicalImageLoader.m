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
}

@synthesize delegate, images;

- (void) startWorking {
    
    NSLog(@" %s",  self.isWorking ? "true" : "false");

    NSLog(@"initializing images array");
    images = [[NSMutableArray array] init];
    
    if(!self.isWorking){
        
        NSLog(@"Starting thread...");
        
        imageLoader = [[ImageLoader alloc] initWithHost: ServerHost
                                        thumbnailPrefix: ThumbnailPrefix
                                            imagePrefix: HatifiedImagePrefix 
                                                    uri: UploadedImagesPath];
        
        NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                     selector:@selector(doWork)
                                                       object:nil];
        
        self.isWorking = YES;
        [myThread start];
    }
}

- (void) stopWorking {
    self.isWorking = NO;
}

- (void) doWork {
    while (self.isWorking) {
        NSLog(@"doing work");
        
        NSMutableArray *thumbsToLoad = [[NSMutableArray array] init];
        
        
        NSURL *xmlURL = [NSURL URLWithString: LatestImagesUrl];
        
        NSLog(@"loading thumbnails...");
        parser = [XmlParser alloc];
        [parser loadThumbnailsFromXml:xmlURL toMutableArray: &thumbsToLoad];
        
        
        images = [imageLoader loadThumbnails:thumbsToLoad toImageArray: images];
    
        
        [self.delegate perodicalImageLoader: self didReceiveXmasHats: images];
        
        [NSThread sleepForTimeInterval: 5];
    }
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

@end
