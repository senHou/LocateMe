//
//  LocateMeController.h
//  LocateMe
//
//  Created by sen hou on 21/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MyCLController.h"
#import "DropPinAnnotation.h"
@interface LocateMeController : UIViewController <MyCLControllerDelegate>{
    
}

@property (nonatomic, retain ) MKMapView *mapView;
@property (nonatomic, retain) MyCLController *myLocationController;
@property (nonatomic, retain) CLLocation *location;

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

-(IBAction)locateMe:(id)sender;
-(void)handleLongPressGesture:(UILongPressGestureRecognizer*)sender;

@end
