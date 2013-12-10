//
//  FeatureFinder.m
//  sketch1
//
//  Created by Petter Petersson on 11/15/11.
//  Copyright (c) 2011 Athega AB. All rights reserved.
//

#import "FeatureFinder.h"


@implementation FeatureFinder

-(NSArray *) getFeaturesFromImage:(UIImage *)image {
    
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace 
                                              context:nil 
                                              options:[NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh forKey:CIDetectorAccuracy]];
    
    CIImage *ciImage = [[CIImage alloc] initWithImage: image];
    NSArray *features = [detector featuresInImage: ciImage];
    NSLog(@"Number of features detected: %lu", (unsigned long)[features count]);
    
    NSMutableArray *result = [NSMutableArray array];
    
    //to minimize dependencies we'll return a simple array of dics containing numbers
    for(CIFaceFeature* feature in features)
    {
        NSMutableDictionary *res = [NSMutableDictionary dictionary];
        
        NSLog(@"%@", feature);
        NSLog(@"[feature hasMouthPosition] %@",[feature hasMouthPosition] ? @"yes" : @"no");
        NSLog(@"[feature hasLeftEyePosition] %@",[feature hasLeftEyePosition] ? @"yes" : @"no");
        NSLog(@"[feature hasRightEyePosition] %@",[feature hasRightEyePosition] ? @"yes" : @"no");
        
        if ([feature hasLeftEyePosition]){
            CGPoint leftEyePos = [feature leftEyePosition];
            [res setObject: [NSNumber numberWithFloat: leftEyePos.x] forKey:@"leftEyePositionX"];
            [res setObject: [NSNumber numberWithFloat: leftEyePos.y] forKey:@"leftEyePositionY"];
        }
        if ([feature hasRightEyePosition]){
            CGPoint rightEyePos = [feature rightEyePosition];
            [res setObject: [NSNumber numberWithFloat: rightEyePos.x] forKey:@"rightEyePositionX"];
            [res setObject: [NSNumber numberWithFloat: rightEyePos.y] forKey:@"rightEyePositionY"];
        }
        if ([feature hasMouthPosition]){
            CGPoint mouthPos = [feature mouthPosition];
            //NSLog(@"[feature mouthPosition] %f %f", mouthPos.x, mouthPos.y);
            [res setObject: [NSNumber numberWithFloat: mouthPos.x] forKey:@"mouthPositionX"];
            [res setObject: [NSNumber numberWithFloat: mouthPos.y] forKey:@"mouthPositionY"];
        }
        
        
        NSLog(@"%@", res);
        
        [result addObject:res];
    } 
        


    return result;
}
@end
