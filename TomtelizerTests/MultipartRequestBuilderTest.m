//
//  MultipartRequestBuilderTest.m
//  sketch1
//
//  Created by Petter Petersson on 11/2/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "MultipartRequestBuilderTest.h"

@implementation MultipartRequestBuilderTest

-(void)testCreateMultiPartRequestForUrl
{
    /* setup */
    NSURL * serverURL = [NSURL URLWithString:@"http://127.0.0.1:3000/movies/list"];
    NSString *data1 = @"some-file-data-1";
    NSString *data2 = @"some-file-data-2";
    
    AthegaPostFile *f1 = [AthegaPostFile alloc];
    f1.data = [NSData dataWithBytes:[data1 UTF8String] length:[data1 length]];
    f1.fieldName = @"myFile1";
    f1.fileName = @"apa.jpg";
    f1.contentType = @"image/jpeg";
    
    AthegaPostFile *f2 = [AthegaPostFile alloc];
    f2.data = [NSData dataWithBytes:[data2 UTF8String] length:[data2 length]];
    f2.fieldName = @"myFile2";
    f2.fileName = @"gnu.jpg";
    f2.contentType = @"image/jpeg";
    
    NSMutableArray *files = [NSMutableArray array];
    [files addObject:f1];
    [files addObject:f2];
    STAssertEquals((NSUInteger)2, [files count], @"expected 2 elements in file array");
    
    AthegaPostParam *p1 = [AthegaPostParam alloc];
    p1.key = @"key1";
    p1.value = @"value1";
    
    NSMutableArray *params = [NSMutableArray array];
    [params addObject:p1];
    STAssertEquals((NSUInteger)1, [params count], @"expected 1 element in param array");
    /* END setup */

    MultipartRequestBuilder * rbuilder = [MultipartRequestBuilder alloc];
    STAssertNotNil(rbuilder, @"expected an instance");
    NSURLRequest * urlRequest = [rbuilder createMultiPartRequestForUrl:serverURL withFiles: files andParameters: params];
    STAssertNotNil(urlRequest, @"expected a request");
    
    NSLog(@"[urlRequest HTTPBody]: %@", [urlRequest HTTPBody] );
    
    
    NSString *body = [NSString stringWithCString:[[urlRequest HTTPBody] bytes] encoding:NSUTF8StringEncoding];
    STAssertNotNil(body, @"expected a request body");
    
    //heisenbug warning - these will fail *sometimes*(!)
    STAssertTrue([body rangeOfString: data1].length > 0, @"expected to find data in request body");
    STAssertTrue([body rangeOfString: data2].length > 0, @"expected to find data in request body");
    STAssertTrue([body rangeOfString: @"myFile1"].length > 0, @"expected to find field value");
    STAssertTrue([body rangeOfString: @"image/jpeg"].length > 0, @"expected to find correct content-type");
    STAssertTrue([body rangeOfString: @"gnu.jpg"].length > 0, @"expected to find file name");
    
    STAssertTrue([body rangeOfString: @"key1"].length > 0, @"expected to find parameter key");
    STAssertTrue([body rangeOfString: @"value1"].length > 0, @"expected to find parameter value");
}

@end
