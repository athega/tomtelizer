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
    NSMutableArray *thumbsToLoad;
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

- (void)testLoadImages
{

    NSArray * thumbNames = [NSArray arrayWithObjects:
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
    
    thumbsToLoad = [NSMutableArray arrayWithCapacity:10];
    
    for (NSString *thumb in thumbNames){
        NSDictionary *element = [NSDictionary dictionaryWithObjectsAndKeys:
                                 thumb, @"filename",
                                 @"some-checksum", @"checksum",
                                 nil];
        [thumbsToLoad addObject:element];
    }
    
    
    ImageLoader *imageLoader = [[ImageLoader alloc] initWithHost: ServerHost 
                                                    thumbnailPrefix: @"thumb-"
                                                    imagePrefix: @"hatified-" 
                                                    uri: UploadedImagesPath];
    
    UIImage * testImage = [UIImage imageNamed:@"thumb-1322222655-11572.jpg"];
    STAssertNotNil(testImage, @"expected a test image");
    
    id partialImageLoaderMock = [OCMockObject partialMockForObject:imageLoader];
    [[[partialImageLoaderMock stub] andReturn:testImage] loadImage:[OCMArg any]withChecksum:[OCMArg any]];

    
    STAssertNotNil(imageLoader, @"expected an image loader");
    
    NSMutableArray *images;
    images = [NSMutableArray arrayWithCapacity:20];
    STAssertEquals((NSUInteger)0, [images count], @"expected to have an empty array initially");
    
    images = [imageLoader loadThumbnails:thumbsToLoad toImageArray: images];
    
    STAssertEquals((NSUInteger)9, [images count], @"expected to have an populated array after op.");
    XmasHat *hat = (XmasHat *)[images objectAtIndex: 0];
    STAssertNotNil(hat, @"expected a XmasHat at first position");
    
    STAssertEqualObjects(@"1322219974-41516.jpg", 
                         hat.imageName, @"expected an url to big image in dto");
    STAssertEqualObjects(@"some-checksum", 
                         hat.checksum, @"expected checksum in dto");
    STAssertNotNil(hat.image, @"expected a loaded image");
    //
}


@end
