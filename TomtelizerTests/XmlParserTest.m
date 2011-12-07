//
//  XmlParserTest.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/5/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "XmlParserTest.h"

@implementation XmlParserTest

- (void) testLoadXml {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"latest" ofType:@"xml"];
    NSLog(@"%@", path);
    STAssertNotNil(path, @"expected a path to test file");
    
    NSURL *xmlURL = [NSURL fileURLWithPath: path];
    
    XmlParser *parser = [XmlParser alloc];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    [parser loadThumbnailsFromXml:xmlURL toMutableArray: &arr];
    STAssertNotNil(arr, @"expected result from parsing xml");
    STAssertEquals((NSUInteger)100, [arr count], @"expected elements in array");
}

@end
