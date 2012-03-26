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
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "StartPoint.h"
#import "RouteInstruction.h"

@interface LocateMeController : UIViewController <MyCLControllerDelegate, MKMapViewDelegate, MKAnnotation, ASIHTTPRequestDelegate>{
    IBOutlet MKMapView *mapView;
}

@property (nonatomic, retain ) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MyCLController *myLocationController;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) DropPinAnnotation *myAnnotation;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) UIBarButtonItem *walkItem;
@property (nonatomic, retain) UIBarButtonItem *carItem;
@property (nonatomic, retain) UIBarButtonItem *cyclingItem;
@property (nonatomic, retain) StartPoint *startAnnotation;
@property (nonatomic, retain) UIBarButtonItem *previous;
@property (nonatomic, retain) UIBarButtonItem *next;
@property (nonatomic, retain) UITextField *indexField;
@property (nonatomic) int totalRoute;


@property (nonatomic, retain) MKPolyline* routeLine;
@property (nonatomic, retain) MKPolylineView* routeLineView;
@property (nonatomic) MKMapRect routeRect;



- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

-(IBAction)locateMe:(id)sender;
-(IBAction)walkRoute:(id)sender;
-(IBAction)carRoute:(id)sender;
-(IBAction)cyclingRoute:(id)sender;
-(IBAction)getPrevious:(id)sender;
-(IBAction)getNext:(id)sender;

-(UIButton *) getButtonWithImage:(NSString *)imageName x:(int)x andY:(int)y;

-(void)handleLongPressGesture:(UILongPressGestureRecognizer*)sender;

-(NSDictionary *) getRouteInfo:(NSData *)routeData;

-(void) drawRoute:(NSArray*)routeCoordinate;
-(void) zoomInOnRoute;

-(int) numberOfPinAdded:(NSString *)pinClassName;

@end
