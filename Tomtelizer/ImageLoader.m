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

    NSLog(@"images count: %d", [images count]);
    for (NSDictionary *elem in listOfImages){
        
        NSString * filename = [elem objectForKey:@"filename"];
        NSString * checksum = [elem objectForKey:@"checksum"];
        
        if(![self imageWithFilename: filename andChecksum: checksum isPresentInImageList: images]){
            XmasHat *hat = [[XmasHat alloc] init];
            
            hat.imageName = filename;
            hat.checksum =  checksum;
            
            hat.image = [self loadImage: hat.imageName withChecksum: hat.checksum];
            
            [images insertObject:hat atIndex: 0];
        }
    }
    
    return images;
}

- (UIImage *) loadImage:(NSString *)imageName withChecksum:(NSString *)checksum {

    NSString * thumbnailUrl = [NSString stringWithFormat: @"%@%@/%@%@?x=%@",host, uri,thumbPrefix, imageName, checksum];
    
    NSLog(@"THUMB - %@", thumbnailUrl);
    
    NSURLRequest *req = [NSURLRequest requestWithURL: [NSURL URLWithString: thumbnailUrl]
                                         cachePolicy: NSURLRequestUseProtocolCachePolicy
                                     timeoutInterval: 60.0];
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data =  [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
    
    return [UIImage imageWithData:data];
}

- (BOOL) imageWithFilename: (NSString *)filename andChecksum: (NSString *)checksum isPresentInImageList: (NSMutableArray *)images {
    //NSLog(@"checking presence for image with filename %@",filename);
    for (XmasHat *hat in images){
        //NSLog(@"hat list entry image %@",hat.imageName);
        if([hat.imageName isEqualToString: filename] && [hat.checksum isEqualToString: checksum]){
            NSLog(@"Image with filename %@ already in list!",filename);
            return true;
        }
    }
    return FALSE;
}

@end
