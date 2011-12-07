//
//  AthegaPostFile.h
//  sketch1
//
//  Created by Petter Petersson on 11/14/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AthegaPostFile : NSObject {
    @private NSData * data;
    @private NSString * fieldName;
    @private NSString * fileName;
    @private NSString * contentType;
}

@property (retain) NSData * data;
@property (retain) NSString * fieldName;
@property (retain) NSString * fileName;
@property (retain) NSString * contentType;

@end
