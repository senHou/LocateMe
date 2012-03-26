//
//  StartPoint.m
//  LocateMe
//
//  Created by sen hou on 26/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartPoint.h"

@implementation StartPoint

@synthesize title;
@synthesize coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d{
    
    if (self = [super init]){
        title = ttl;
        coordinate = c2d;
    }
    
    return self;
}

@end
