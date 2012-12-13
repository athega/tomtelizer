//
//  XmasHat.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/1/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "XmasHat.h"

@implementation XmasHat

@synthesize image, imageName, checksum;

//http://stackoverflow.com/questions/4089238/implementing-nscopying
//for when making a deep copy of xmasHat array in xmasHatViewController
- (id)copyWithZone:(NSZone *)zone
{
    XmasHat * copy = (XmasHat *)[[[self class] alloc] init];
    
    if (copy) {
        // Copy NSObject subclasses
        copy.image = [[UIImage allocWithZone: zone] initWithCGImage: self.image.CGImage];
        
        copy.imageName = [self.imageName copyWithZone:zone];

        copy.checksum = [self.checksum copyWithZone:zone];
    }
    
    return copy;
}

@end
