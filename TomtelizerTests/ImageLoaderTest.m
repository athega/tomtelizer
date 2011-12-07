//
//  ImageLoaderTest.m
//  BrowseTomteImages
//
//  Created by Petter Petersson on 12/2/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "ImageLoaderTest.h"
#import <OCMock/OCMock.h>

@implementation ImageLoaderTest {
    NSArray *thumbsToLoad;
}

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

//TODO: this requires backend server to be running!
- (void)testLoadImages
{

    thumbsToLoad = [NSArray arrayWithObjects:
             @"1322151563-4162.jpg",
             @"1322222655-11572.jpg",
             @"1322213496-0385.jpg",
             @"1322216450-42057.jpg",
             @"1322219995-127.jpg",
             @"1322151588-96805.jpg",
             @"1322151633-37853.jpg",
             @"1322216345-69659.jpg",
             @"1322219974-41516.jpg",
             nil];
    
    ImageLoader *imageLoader = [[ImageLoader alloc] initWithHost: ServerHost 
                                                    thumbnailPrefix: @"thumb-"
                                                    imagePrefix: @"hatified-" 
                                                    uri: UploadedImagesPath];
    
    UIImage * testImage = [UIImage imageNamed:@"thumb-1322222655-11572.jpg"];
    STAssertNotNil(testImage, @"expected a test image");
    
    id partialImageLoaderMock = [OCMockObject partialMockForObject:imageLoader];
    [[[partialImageLoaderMock stub] andReturn:testImage] loadImage:[OCMArg any]];

    
    STAssertNotNil(imageLoader, @"expected an image loader");
    
    NSMutableArray *images;
    images = [NSMutableArray arrayWithCapacity:20];
    STAssertEquals((NSUInteger)0, [images count], @"expected to have an empty array initially");
    
    images = [imageLoader loadThumbnails:thumbsToLoad toImageArray: images];
    
    STAssertEquals((NSUInteger)9, [images count], @"expected to have an populated array after op.");
    XmasHat *hat = (XmasHat *)[images objectAtIndex: 0];
    STAssertNotNil(hat, @"expected a XmasHat at first position");
    
    STAssertEqualObjects(@"1322151563-4162.jpg", 
                         hat.imageName, @"expected an url to big image in dto");
    STAssertNotNil(hat.image, @"expected a loaded image");
    //
}

//TODO: remove
- (void)testOCMockPass {
    id mock = [OCMockObject mockForClass:NSString.class];
    [[[mock stub] andReturn:@"mocktest"] lowercaseString];
    NSString *returnValue = [mock lowercaseString];
    STAssertEqualObjects(@"mocktest", returnValue, @"Should have returned the expected string.");
}


@end
