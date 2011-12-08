//
//  MultipartRequestBuilder.m
//  sketch1
//
//  Created by Petter Petersson on 11/2/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "MultipartRequestBuilder.h"
#import "AthegaPostFile.h"
#import "AthegaPostParam.h"

@implementation MultipartRequestBuilder

- (NSURLRequest *)createMultiPartRequestForUrl: (NSURL *)url withFiles: (NSArray *)files andParameters: (NSArray *) params
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", MPR_BOUNDARY] forHTTPHeaderField: @"Content-Type"];
    NSMutableData *postData = [[NSMutableData alloc] init];
    //would be better to write an utf-8 string and convert it to data after really, instead of the other way around
    for(id o in files) {
        if ([o class] == [AthegaPostFile class]){

            [postData appendData: [[NSString stringWithFormat: @"--%@\r\n", MPR_BOUNDARY] 
                                             dataUsingEncoding:NSUTF8StringEncoding]];
            
            [postData appendData: [[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", 
                                                               ((AthegaPostFile *)o).fieldName, 
                                                               ((AthegaPostFile *)o).fileName]
                                             dataUsingEncoding:NSUTF8StringEncoding]];
            
            [postData appendData:[[NSString stringWithFormat: @"Content-Type: %@\r\n\r\n", ((AthegaPostFile *)o).contentType] 
                                            dataUsingEncoding: NSUTF8StringEncoding]];
            
            [postData appendData: ((AthegaPostFile *)o).data];
            [postData appendData: [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            NSLog(@"fileName: %@", ((AthegaPostFile *)o).fileName);
        }
    }
    
    for(id o in params) {
        if ([o class] == [AthegaPostParam class]){
            NSLog(@"key: %@", ((AthegaPostParam *)o).key);
            
            [postData appendData: [[NSString stringWithFormat: @"--%@\r\n", MPR_BOUNDARY] 
                                   dataUsingEncoding:NSUTF8StringEncoding]];
            
            [postData appendData: [[NSString stringWithFormat:@"content-disposition: form-data; name=\"%@\"\r\n\r\n", ((AthegaPostParam *)o).key]
                                             dataUsingEncoding:NSUTF8StringEncoding]];
            
            [postData appendData: [[NSString stringWithString: ((AthegaPostParam *)o).value] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [postData appendData: [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
    }
    
    [postData appendData: [[NSString stringWithFormat:@"--%@--\r\n", MPR_BOUNDARY] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"BYTES len: %d", [postData length]);
    //see test case - this will *occationally* return nil on identical data
    NSLog(@"%@",[NSString stringWithCString: [postData bytes] encoding: NSUTF8StringEncoding]);
    
    
    [urlRequest setHTTPBody:postData];
    return urlRequest;
}

@end
