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
    STAssertEquals((NSUInteger)3, [arr count], @"expected 3 elements in array");
    NSDictionary * obj = [arr objectAtIndex:0];
    STAssertNotNil(obj, @"expected a object at index 0");
    STAssertEqualObjects(@"1323767960-29511.jpg", [obj objectForKey:@"filename"], @"unexpected thumbnail name");
    STAssertEqualObjects(@"862e12ae73818474f6d23438751528a7", [obj objectForKey:@"checksum"], @"unexpected checksum for file");
}

@end
