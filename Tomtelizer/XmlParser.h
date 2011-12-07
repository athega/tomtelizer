//
//  XmlParser.h
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/5/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmlParser : NSObject <NSXMLParserDelegate> {
    NSMutableArray * imageNames;
    NSString * currentXmlStringValue;
}

-(void) loadThumbnailsFromXml:(NSURL *)url toMutableArray:(NSMutableArray **) arr;

@end
