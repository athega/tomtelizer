//
//  HttpBrowser.m
//  sketch1
//
//  Created by Petter Petersson on 11/1/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "HttpBrowser.h"
#import "MultipartRequestBuilder.h"
#import "AthegaPostFile.h"
#import "AthegaPostParam.h"
#import "ImageHelpers.h"

int const NUM_SLEEP_SECONDS = 5;

//private methods - in a interface category
@interface HttpBrowser() 
- (void) makeActualRequest:(NSMutableDictionary *)dict;
@end

@implementation HttpBrowser{
    NSString * urlStr;
}

//FIXME: this must be SYNCHRONIZED:
@synthesize isWorking, delegate;

- (id)init {
    self = [super init];
    if (self) {
        isWorking=NO;
        featureFinder = [FeatureFinder alloc];
    }
    return self;
}
- (void) sendImageDict: (NSDictionary *) info toUrl:(NSString *)url{

    if(!isWorking){
        NSLog(@"not working");
        
        isWorking = YES;
        urlStr = url;
        
        NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                     selector:@selector(makeActualRequest:)
                                                       object:info];
        
        [myThread start];  
        
    } else {
        NSLog(@"working, ignoring call.");
    }
     NSLog(@"send message done.");
}

- (void)makeActualRequest:(NSMutableDictionary *)dict {
    
    UIImage* image = [dict objectForKey: @"image"];
    NSDictionary *info = [dict objectForKey:@"metadata"];
    NSString * processFeaturesStr = [dict objectForKey:@"processFeatures"];
    NSLog(@"%@", processFeaturesStr);
    
    CGSize newSize;
    newSize.width = 600;
    newSize.height = 600;
    
    UIImage* scaled = [image scaleToSize: newSize];
    
    NSArray * features = [featureFinder getFeaturesFromImage: scaled];
 
    NSData* imagedata = UIImageJPEGRepresentation(scaled, 1.0);
    NSLog(@"Image size: %d", imagedata.length);
    
    NSLog(@"making actual request to url: <%@>", urlStr);
    
    MultipartRequestBuilder * rbuilder = [MultipartRequestBuilder alloc];
    
    NSURL * url = [NSURL URLWithString: urlStr];
    
    AthegaPostFile *imageFile = [AthegaPostFile alloc];
    imageFile.contentType = @"image/jpeg";
    imageFile.fieldName = @"uploaded";
    imageFile.fileName = @"image.jpg";
    imageFile.data = imagedata;
    
    AthegaPostParam *orientation = [AthegaPostParam alloc];
    orientation.key = @"orientation";
    orientation.value = [NSString stringWithFormat:@"%@", [info objectForKey:@"Orientation"]];
    
    AthegaPostParam *processFeatures = [AthegaPostParam alloc];
    processFeatures.key = @"processFeatures";
    processFeatures.value = processFeaturesStr;
    
    NSMutableArray *params = [NSMutableArray array];
    [params addObject:orientation];
    [params addObject:processFeatures];
    
    if ((int)[features count]>0){
        
        for(NSDictionary* feature in features){
            
            AthegaPostParam *leftEyePositionX = [AthegaPostParam alloc];
            leftEyePositionX.key = @"features[][left_eye_x]";
            leftEyePositionX.value = [NSString stringWithFormat:@"%@", [feature objectForKey:@"leftEyePositionX"]];
            
            AthegaPostParam *leftEyePositionY = [AthegaPostParam alloc];
            leftEyePositionY.key = @"features[][left_eye_y]";
            leftEyePositionY.value = [NSString stringWithFormat:@"%@", [feature objectForKey:@"leftEyePositionY"]];
            
            AthegaPostParam *mouthPositionX = [AthegaPostParam alloc];
            mouthPositionX.key = @"features[][mouth_x]";
            mouthPositionX.value = [NSString stringWithFormat:@"%@", [feature objectForKey:@"mouthPositionX"]];
            
            AthegaPostParam *mouthPositionY = [AthegaPostParam alloc];
            mouthPositionY.key = @"features[][mouth_y]";
            mouthPositionY.value = [NSString stringWithFormat:@"%@", [feature objectForKey:@"mouthPositionY"]];
            
            AthegaPostParam *rightEyePositionX = [AthegaPostParam alloc];
            rightEyePositionX.key = @"features[][right_eye_x]";
            rightEyePositionX.value = [NSString stringWithFormat:@"%@", [feature objectForKey:@"rightEyePositionX"]];
           
            AthegaPostParam *rightEyePositionY = [AthegaPostParam alloc];
            rightEyePositionY.key = @"features[][right_eye_y]";
            rightEyePositionY.value = [NSString stringWithFormat:@"%@", [feature objectForKey:@"rightEyePositionY"]];
     
            [params addObject:leftEyePositionX];
            [params addObject:leftEyePositionY];
            [params addObject:mouthPositionX];
            [params addObject:mouthPositionY];
            [params addObject:rightEyePositionX];
            [params addObject:rightEyePositionY];
        }
    
    }
    NSMutableArray *files = [NSMutableArray array];
    [files addObject:imageFile];

    NSURLRequest * urlRequest = [rbuilder createMultiPartRequestForUrl:url withFiles:files andParameters: params];
    NSLog(@"request builder done.");
    
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];

    NSLog(@"%@", error);
    
    isWorking=NO;
    
    if(data){
        NSString *body = [NSString stringWithCString:[data bytes] encoding:NSUTF8StringEncoding];
        [self.delegate browser:self didReceiveBody:body];
    } else {
        [self.delegate failedToSendData];
    }
}


@end
