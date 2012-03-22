//
//  DropPinAnnotation.m
//  LocateMe
//
//  Created by sen hou on 22/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DropPinAnnotation.h"

@implementation DropPinAnnotation

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
