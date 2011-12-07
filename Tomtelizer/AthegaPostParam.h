//
//  AthegaPostParam.h
//  sketch1
//
//  Created by Petter Petersson on 11/14/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AthegaPostParam : NSObject {
    @private NSString * key;
    @private NSString * value;
}
@property (retain) NSString * key;
@property (retain) NSString * value;

@end
