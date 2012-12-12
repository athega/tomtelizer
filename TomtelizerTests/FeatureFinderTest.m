//
//  FeatureFinderTest.m
//  sketch1
//
//  Created by Petter Petersson on 11/15/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "FeatureFinderTest.h"

@implementation FeatureFinderTest

//NOT USED(?)
typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);
typedef void (^AssetGroupEnumerator)(ALAssetsGroup *group, BOOL *stop);


//FIXME: test fixtures are build in main target! - should be in test target
- (void)testReadFeaturedImageFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"front" ofType:@"jpg"];

    NSLog(@"%@", filePath);

    UIImage *image = [UIImage imageWithContentsOfFile: filePath];
    STAssertNotNil(image, @"expected an image from resource");
    NSLog(@"image: %@", image);
    
    CGSize s = image.size;
    
    NSLog(@"size: %f", s.height);
    NSLog(@"size: %f", s.width);
    
    FeatureFinder *finder = [FeatureFinder alloc];
    NSArray *result = [finder getFeaturesFromImage:image];
    //only one feature expected
    NSDictionary *res = [result objectAtIndex:0];

    //IMPORTANT: These asserts will fail on the phone (by a odd pixel value) but work in the simulator
    STAssertEqualObjects([NSNumber numberWithInt: 201] , [res valueForKey:@"leftEyePositionX"], nil);
    STAssertEqualObjects([NSNumber numberWithInt: 396] , [res valueForKey:@"leftEyePositionY"], nil);
    STAssertEqualObjects([NSNumber numberWithInt: 240] , [res valueForKey:@"mouthPositionX"], nil);
    STAssertEqualObjects([NSNumber numberWithInt: 289] , [res valueForKey:@"mouthPositionY"], nil);
    STAssertEqualObjects([NSNumber numberWithInt: 294] , [res valueForKey:@"rightEyePositionX"], nil);
    STAssertEqualObjects([NSNumber numberWithInt: 384] , [res valueForKey:@"rightEyePositionY"], nil);
}

- (void)testVeryBigFeaturedImageFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"front-big" ofType:@"jpg"];
    
    NSLog(@"%@", filePath);
    
    UIImage *image = [UIImage imageWithContentsOfFile: filePath];
    STAssertNotNil(image, @"expected an image from resource");
    NSLog(@"image: %@", image);
    
    FeatureFinder *finder = [FeatureFinder alloc];
    NSArray *result = [finder getFeaturesFromImage:image];
    STAssertNotNil(result, @"expected features to be found.");
    //only one feature expected
    NSDictionary *res = [result objectAtIndex:0];
    
    STAssertEquals(374 , [(NSNumber *)[res valueForKey:@"leftEyePositionX"] intValue], nil);
    STAssertEquals(1275, [(NSNumber *)[res valueForKey:@"leftEyePositionY"] intValue], nil);
    STAssertEquals(554, [(NSNumber *)[res valueForKey:@"mouthPositionX"] intValue], nil);
    STAssertEquals(918 , [(NSNumber *)[res valueForKey:@"mouthPositionY"] intValue], nil);
    STAssertEquals(711 , [(NSNumber *)[res valueForKey:@"rightEyePositionX"] intValue], nil);
    STAssertEquals(1280, [(NSNumber *)[res valueForKey:@"rightEyePositionY"] intValue], nil);
}

- (void)testReadNonFeaturedImageFile
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"athega_logo" ofType:@"png"];
    
    NSLog(@"%@", filePath);
    
    UIImage *image = [UIImage imageWithContentsOfFile: filePath];
    STAssertNotNil(image, @"expected an image from resource");

    FeatureFinder *finder = [FeatureFinder alloc];
    NSArray *result = [finder getFeaturesFromImage:image];
    STAssertEquals(0, (int)[result count], nil);

}

@end
