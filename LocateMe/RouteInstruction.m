//
//  RouteInstruction.m
//  LocateMe
//
//  Created by sen hou on 26/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RouteInstruction.h"

@implementation RouteInstruction

@synthesize instruction;
@synthesize length;
@synthesize lengthCaption;

-(id) initRouteWithInstruction:(NSString *)routeInstruction length:(int)routeLength andLengthCaption:(NSString *)caption{
    
    if (self = [super init]){
        instruction = routeInstruction;
        lengthCaption = caption;
        length = routeLength;
    }
    
    return self;
}

@end
