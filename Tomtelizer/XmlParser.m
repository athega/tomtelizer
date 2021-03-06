//
//  XmlParser.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/5/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "XmlParser.h"

@implementation XmlParser {
    NSString *currentFilename;
    NSString *currentChecksum;
}

-(void) loadThumbnailsFromXml:(NSURL *)url toMutableArray:(NSMutableArray **) arr {
    
    NSLog(@"loadThumbnailsFromXml: toMutableArray: url: %@", url);
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL: url];
    parser.delegate = self;
    imageNames = *arr;

    [parser parse];

    NSLog(@"parse done");
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    currentXmlStringValue = [NSString stringWithString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement: (NSString *)elementName 
  				      namespaceURI: (NSString *)namespaceURI 
				     qualifiedName: (NSString *)qName {
    
    
    if ( [elementName isEqualToString:@"filename"] ) {
        currentFilename = [currentXmlStringValue copy];
        return;
    }
    if ( [elementName isEqualToString:@"hatified-file-checksum"] ) {
        currentChecksum = [currentXmlStringValue copy];
        return;
    }
    if ( [elementName isEqualToString:@"image"] ) {
        NSDictionary *obj = [NSDictionary dictionaryWithObjectsAndKeys:
                             currentFilename, @"filename",
                             currentChecksum, @"checksum",
                             nil];
        [imageNames addObject:obj];
        
    }
    if ( [elementName isEqualToString:@"images"] ) {
        NSLog(@"DONE!");
        NSLog(@"%lu", (unsigned long)[imageNames count]);
    }
}

@end
