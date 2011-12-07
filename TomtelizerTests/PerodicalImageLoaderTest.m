//
//  PerodicalImageLoaderTest.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/6/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "PerodicalImageLoaderTest.h"
#import "objc/runtime.h"
#import "XmlParser.h"

//POINTLESS test - kept for showing (static/class) how to do method swizzling
@implementation PerodicalImageLoaderTest

- (void)setUp
{
    //Method allocXmlParserMethod = class_getClassMethod([PerodicalImageLoader class], @selector(alloc));
    
    Method allocXmlParserMethod = class_getInstanceMethod([PerodicalImageLoader class], @selector(doWork));
    
	Method allocXmlParserMethodSwizzle = class_getInstanceMethod([self class], @selector(createXmlParserMock));
    
	method_exchangeImplementations(allocXmlParserMethod, allocXmlParserMethodSwizzle);
}

- (void)createXmlParserMock
{
    NSLog(@"createXmlParserMock");
    //id loaderMock = [OCMockObject mockForClass:[PerodicalImageLoader class]];
	//return (XmlParser *) loaderMock;
}

- (void)testStart
{
    /*
    id loaderMock = [OCMockObject mockForClass:[PerodicalImageLoader class]];
    [[loaderMock stub] doWork];
    
    [loaderMock startWorking];
    */
    
    PerodicalImageLoader * loader = [PerodicalImageLoader alloc];
    loader.isWorking = YES;
    [loader doWork];
}

@end
