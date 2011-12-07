//
//  ImageLoader.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/2/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "ImageLoader.h"

@implementation ImageLoader

-(id)initWithHost:(NSString *)h thumbnailPrefix:(NSString *)p imagePrefix:(NSString *)i uri:(NSString *)u {
    
    self = [super init];
    
    if(self){ 
        host = h;
        thumbPrefix = p;
        imagePrefix = i;
        uri = u; 
    }
    
    return self;
}

//TODO?: cache images
-(NSMutableArray *) loadThumbnails:(NSArray *)listOfImages toImageArray:(NSMutableArray *) images {
    
    for (NSString *imageName in listOfImages){
        XmasHat *hat = [[XmasHat alloc] init];

        hat.imageName = imageName;

        hat.image = [self loadImage: imageName];
        
        [images addObject:hat];
    }
    
    return images;
}

- (UIImage *) loadImage:(NSString *)imageName {

    NSString * thumbnailUrl = [NSString stringWithFormat: @"%@%@/%@%@",host, uri,thumbPrefix, imageName];
    
    NSLog(@"THUMB - %@", thumbnailUrl);
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString: thumbnailUrl]
                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval:60.0];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data =  [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    return [UIImage imageWithData:data];
}

@end
