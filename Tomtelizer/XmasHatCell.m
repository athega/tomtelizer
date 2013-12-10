//
//  XmasHatCell.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/1/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "XmasHatCell.h"

@implementation XmasHatCell {
    NSMutableData *imageData;
}

@synthesize xmasHatImageView, imageUrl;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) loadImageFromUrl:(NSString *)url {
    
    NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString: url]
                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                          timeoutInterval:60.0];
    
    NSURLConnection *conn=[[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if (conn) {
        
        NSLog(@"got connection to url %@", url);
        imageData = [NSMutableData data];
        
    } else {
        NSLog(@"Failed to make connection!");
    }

}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    [imageData appendData:data];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"Received %lu bytes of data",(unsigned long)[imageData length]);
    
    UIImage *image = [UIImage imageWithData:imageData];
    xmasHatImageView.image = image;
}

@end
