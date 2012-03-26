//
//  RouteInstruction.h
//  LocateMe
//
//  Created by sen hou on 26/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RouteInstruction : NSObject

@property (nonatomic, copy) NSString* instruction;
@property (nonatomic) int length;
@property (nonatomic, copy) NSString* lengthCaption;

-(id) initRouteWithInstruction:(NSString *)routeInstruction length:(int)routeLength andLengthCaption:(NSString *)caption;

@end
