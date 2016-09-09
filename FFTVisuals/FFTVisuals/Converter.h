//
//  Converter.h
//  FFTVisuals
//
//  Created by AntonioStilo on 27/08/16.
//  Copyright © 2016 AntonioStilo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Converter : NSObject

+(NSString*)note:(NSInteger)midi;
+(UInt8)midi:(float)freq;

@end
