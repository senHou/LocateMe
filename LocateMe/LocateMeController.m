//
//  LocateMeController.m
//  LocateMe
//
//  Created by sen hou on 21/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocateMeController.h"

@interface LocateMeController ()

@end

@implementation LocateMeController

@synthesize mapView;
@synthesize myLocationController;
@synthesize location;
@synthesize coordinate;
@synthesize myAnnotation;
@synthesize name;
@synthesize walkItem;
@synthesize carItem;
@synthesize cyclingItem;
@synthesize routeLine;
@synthesize routeRect;
@synthesize routeLineView;
@synthesize startAnnotation;
@synthesize previous;
@synthesize next;
@synthesize indexField;
@synthesize totalRoute;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    myLocationController = [[MyCLController alloc] init];
    
    self.myLocationController.delegate = self;
    self.mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView showsUserLocation];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    indexField = [[UITextField alloc] initWithFrame:CGRectMake(87, 7, 145, 31)];
    [indexField setTextAlignment:UITextAlignmentCenter];
    [indexField setTextColor:[UIColor whiteColor]];
    [indexField setText:@"16 of 16"];
    
    UIBarButtonItem *routeNumber = [[UIBarButtonItem alloc] initWithCustomView:indexField];
    
    UIToolbar *topToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,320, 44) ];
    [topToolBar setBarStyle:UIBarStyleDefault];
    
    previous = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStyleBordered target:self action:@selector(getPrevious:)];
    
    next = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStyleBordered target:self action:@selector(getNext:)];
    NSArray *routeItems = [NSArray arrayWithObjects:previous,flexibleSpace,routeNumber,flexibleSpace,next,nil];
    [topToolBar setItems:routeItems];
    
    [self.mapView addSubview:topToolBar];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,416,320,44)];
    
    [toolBar setBarStyle:UIBarStyleDefault];
    
    //create locate me button
    UIButton *locateMeButton = [self getButtonWithImage:@"locateme.png" x:10 andY:425];      
    [locateMeButton addTarget:self action:@selector(locateMe:) forControlEvents:UIControlEventTouchUpInside];       
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:locateMeButton];
    
    
    //create walk button
    UIButton *walkButton = [self getButtonWithImage:@"walk.png" x:200 andY:425];
    [walkButton addTarget:self action:@selector(walkRoute:) forControlEvents:UIControlEventTouchUpInside];
    walkItem = [[UIBarButtonItem alloc] initWithCustomView:walkButton];
    [walkItem setEnabled:NO];
    
    
    //create cycling button
    UIButton *cyclingButton = [self getButtonWithImage:@"cycling.png" x:200 andY:425];
    [cyclingButton addTarget:self action:@selector(cyclingRoute:) forControlEvents:UIControlEventTouchUpInside];
    cyclingItem = [[UIBarButtonItem alloc] initWithCustomView:cyclingButton];
    [cyclingItem setEnabled:NO];
    
    
    //create car button
    UIButton *carButton = [self getButtonWithImage:@"car.png" x:200 andY:425];
    [carButton addTarget:self action:@selector(carRoute:) forControlEvents:UIControlEventTouchUpInside];
    carItem = [[UIBarButtonItem alloc] initWithCustomView:carButton];
    [carItem setEnabled:NO];
    
    NSArray *items = [NSArray arrayWithObjects:button,flexibleSpace,walkItem,cyclingItem,carItem,flexibleSpace,nil];
    [toolBar setItems:items];
    
    [self.view addSubview:toolBar];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]
                                                      initWithTarget:self 
                                                      action:@selector(handleLongPressGesture:)];
    [self.view addGestureRecognizer:longPressGesture];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)locationUpdate:(CLLocation *)myLocation{
    self.location = myLocation;
}


// long press on the map and drop the pin at the point you pressed.
-(void)handleLongPressGesture:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateChanged){
        return;
    }
    else {
        
        CGPoint point = [sender locationInView:self.mapView];
        coordinate =  [self.mapView convertPoint:point toCoordinateFromView:self.mapView] ;
        
        NSLog(@"la = %f long = %f",coordinate.latitude,coordinate.longitude);
        
        
        CLLocation *myLocation = [[CLLocation  alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];

        
        
        [geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error){
            NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
            [walkItem setEnabled:YES];
            [cyclingItem setEnabled:YES];
            [carItem setEnabled:YES];
            
            
            if (error){
                NSLog(@"Geocode failed with error: %@", error);            
                return;
                
            }
            
            if(placemarks && placemarks.count > 0){
                CLPlacemark *topResult = [placemarks objectAtIndex:0];

                name = [NSString stringWithFormat:@"%@ %@,%@", 
                                 [topResult name],[topResult administrativeArea],
                                 [topResult  country]];
                if ([self numberOfPinAdded:@"DropPinAnnotation"] == 0){
                    
                    myAnnotation = [[DropPinAnnotation alloc] initWithTitle:NULL andCoordinate:coordinate];
                    [myAnnotation setTitle:name];
                    [self.mapView addAnnotation:myAnnotation];
                }else {
                    DropPinAnnotation *tmpAnnotaton = myAnnotation;
                    
                    myAnnotation = [[DropPinAnnotation alloc] initWithTitle:NULL andCoordinate:coordinate];
                    [myAnnotation setTitle:name];
                    [self.mapView removeAnnotation:tmpAnnotaton];
                    [self.mapView addAnnotation:myAnnotation];
                }
            }
            
            if ([[self.mapView overlays] count] != 0){
                [self.mapView removeOverlay:routeLine];
                routeLine = nil;
                self.routeLineView = nil;
            }
        }];
    }
}


//delegate method
- (MKAnnotationView *) mapView:(MKMapView *)mapView 
             viewForAnnotation:(id <MKAnnotation>) annotation {
    
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] 
                                  initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    
    if ([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    
    if ([annotation isKindOfClass:[StartPoint class]]){
        annView.pinColor = MKPinAnnotationColorGreen;
    }
    
    if ([annotation isKindOfClass:[DropPinAnnotation class]])
        annView.pinColor = MKPinAnnotationColorRed;
    
    annView.animatesDrop = YES;
    annView.canShowCallout = YES;
    
    return annView;
}

-(UIButton *) getButtonWithImage:(NSString *)imageName x:(int)x andY:(int)y{
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:image forState:UIControlStateNormal];
    aButton.frame = CGRectMake(x, y, image.size.width, image.size.height);
    
    
    return aButton;
}


// locate my current location
-(IBAction)locateMe:(id)sender{
    
    MKCoordinateRegion region;
    
	region.span.longitudeDelta = 0.219727;
	region.span.latitudeDelta = 0.221574;
    
	region.center.latitude = location.coordinate.latitude;
	region.center.longitude = location.coordinate.longitude;
    
	[mapView setRegion:region animated:YES];

    [self.mapView setShowsUserLocation:YES];
    [self.mapView showsUserLocation];
}


//walk route
-(IBAction)walkRoute:(id)sender{
    
    if ([[self.mapView overlays] count] != 0){
        [self.mapView removeOverlay:routeLine];
        routeLine = nil;
        self.routeLineView = nil;
    }
    
    if ([self numberOfPinAdded:@"StartPoint"] == 0 ){
        CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
        startAnnotation = [[StartPoint alloc]initWithTitle:@"Current Location" andCoordinate:startCoordinate];
        [self.mapView addAnnotation:startAnnotation];
    }
    
    NSLog(@"walk");
    NSString *urlString = [NSString stringWithFormat:@"http://routes.cloudmade.com/4fefed3d2b3144eba08b8f00fad99da4/api/0.3/%f,%f,%f,%f/foot.js?token=f2b73a932da044698f25dc5ed3ec074c&units=km",location.coordinate.latitude,location.coordinate.longitude,myAnnotation.coordinate.latitude,myAnnotation.coordinate.longitude];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setDelegate:self];
    [request startAsynchronous];
}

//car route
-(IBAction)carRoute:(id)sender{
 
    if ([[self.mapView overlays] count] != 0){
        [self.mapView removeOverlay:routeLine];
        routeLine = nil;
        self.routeLineView = nil;
    }
    
    if ([self numberOfPinAdded:@"StartPoint"] == 0){
        CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
        startAnnotation = [[StartPoint alloc]initWithTitle:@"Current Location" andCoordinate:startCoordinate];
        [self.mapView addAnnotation:startAnnotation];
    }
    
    NSLog(@"car");
    
    
    NSString *urlString = [NSString stringWithFormat:@"http://routes.cloudmade.com/4fefed3d2b3144eba08b8f00fad99da4/api/0.3/%f,%f,%f,%f/car.js?token=f2b73a932da044698f25dc5ed3ec074c&units=km",location.coordinate.latitude,location.coordinate.longitude,myAnnotation.coordinate.latitude,myAnnotation.coordinate.longitude];
    NSURL *URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setDelegate:self];
    [request startAsynchronous];
}

// cycling route
-(IBAction)cyclingRoute:(id)sender{
    
    NSLog(@"cycling");
    if ([[self.mapView overlays] count] != 0){
        [self.mapView removeOverlay:routeLine];
        routeLine = nil;
        self.routeLineView = nil;
    }
    
    if ([self numberOfPinAdded:@"StartPoint"] == 0){
        CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude,location.coordinate.longitude);
        startAnnotation = [[StartPoint alloc]initWithTitle:@"Current Location" andCoordinate:startCoordinate];
        [self.mapView addAnnotation:startAnnotation];
    }
    
    NSString *urlString = [NSString stringWithFormat:@"http://routes.cloudmade.com/4fefed3d2b3144eba08b8f00fad99da4/api/0.3/%f,%f,%f,%f/bicycle.js?token=f2b73a932da044698f25dc5ed3ec074c&units=km",location.coordinate.latitude,location.coordinate.longitude,myAnnotation.coordinate.latitude,myAnnotation.coordinate.longitude];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    [request setDelegate:self];
    [request startAsynchronous];
}

-(void) requestFinished: (ASIHTTPRequest *) request {
    
    // [request responseString]; is how we capture textual output like HTML or JSON
    // [request responseData]; is how we capture binary output like images
    // Then to create an image from the response we might do something like
    // UIImage *image = [[UIImage alloc] initWithData:[request responseData]];
    routeLine = nil;
    
    NSData *data = [request responseData];
    
//    NSString *string = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//    NSLog(@"%@",string);

    NSDictionary * routeDictionary = [self getRouteInfo:data];
    
    NSArray *routeCoordinate = [routeDictionary objectForKey:@"route_geometry"];
    
    [self drawRoute:routeCoordinate];
    [self zoomInOnRoute];
    
    
    if (routeLine != nil){
        [self.mapView addOverlay:routeLine];
    }
}


// get route information start point and end point
-(NSDictionary *) getRouteInfo:(NSData *)routeData{
    
    SBJsonParser *parser = [[SBJsonParser alloc] init]; 
    NSMutableDictionary  * datas = [parser objectWithData:routeData];
    
    NSArray *coordinates = [datas objectForKey:@"route_geometry"];
    
    NSMutableArray *routeCoordinates = [[NSMutableArray alloc] init];
    NSMutableArray *routeInstructions = [[NSMutableArray alloc] init];
    CLLocation *routeLocation;
    
    NSArray *instruction = [datas objectForKey:@"route_instructions"];
    //RouteInstruction *routeInstruction;
    
    RouteInstruction *routeInstruction;
    int length;
    
    for (int i = 0; i < instruction.count; i ++){
        NSLog(@"%@",[[instruction objectAtIndex:i] objectAtIndex:0]);
        
        length = [[[instruction objectAtIndex:i]objectAtIndex:1] intValue];
        routeInstruction = [[RouteInstruction alloc] initRouteWithInstruction:[[instruction objectAtIndex:i] objectAtIndex:0]
                                                                       length:length
                                                             andLengthCaption:[[instruction objectAtIndex:i]objectAtIndex:4]];
        [routeInstructions addObject:routeInstruction];
    }
    
    
    double latitude;
    double longitude;
    
    for (int i = 0; i < coordinates.count; i ++){
        
        latitude = [[[coordinates objectAtIndex:i] objectAtIndex:0]doubleValue];
        longitude = [[[coordinates objectAtIndex:i] objectAtIndex:1] doubleValue];
        
        routeLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
        [routeCoordinates addObject:routeLocation];
    }
    
    
    
    NSArray *key = [[NSArray alloc] initWithObjects:@"route_geometry",@"route_instructions" ,nil];
    NSArray *value = [[NSArray alloc] initWithObjects:routeCoordinates, routeCoordinates,nil];
    
    NSDictionary *routeDictionary = [[NSDictionary alloc] initWithObjects:value forKeys:key];
    
    return routeDictionary;
}


//get all the coordinate and draw a line
-(void) drawRoute:(NSArray*)routeCoordinate{
    
    CLLocationCoordinate2D points[routeCoordinate.count];
    
    MKMapPoint northEastPoint;
    MKMapPoint southWestPoint;
    
    for (int i = 0; i < routeCoordinate.count ; i ++){
        
        CLLocation *currentPoint = [routeCoordinate objectAtIndex:i];

        
        CLLocationDegrees latitude  = currentPoint.coordinate.latitude;
		CLLocationDegrees longitude = currentPoint.coordinate.longitude;
        
        
		// create our coordinate and add it to the correct spot in the array 
		CLLocationCoordinate2D routeCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
        
		MKMapPoint point = MKMapPointForCoordinate(routeCoordinate);
        
        points[i] = routeCoordinate;
        
        
        //get the max x and y from all the coordinate.
        if (i == 0){
            northEastPoint = point;
            southWestPoint = point;
        }else {
            if (point.x > northEastPoint.x) 
				northEastPoint.x = point.x;
			if(point.y > northEastPoint.y)
				northEastPoint.y = point.y;
			if (point.x < southWestPoint.x) 
				southWestPoint.x = point.x;
			if (point.y < southWestPoint.y) 
				southWestPoint.y = point.y;
        }
    }    
    
    routeLine = [MKPolyline polylineWithCoordinates:points count:routeCoordinate.count];
    
    
    // box to show the route.
	routeRect = MKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
}


//zoom in the map
-(void) zoomInOnRoute{
    [self.mapView setVisibleMapRect:routeRect];
}

- (void)locationError:(NSError *)error{
    NSLog(@"%@",[error debugDescription]);
}



//draw the route
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
    
    if(overlay == routeLine)
	{
		//if we have not yet created an overlay view for this overlay, create it now. 
		if(nil == self.routeLineView)
		{
			self.routeLineView = [[MKPolylineView alloc] initWithPolyline:routeLine];
            
            //UIColor *color = [UIColor colorWithRed:0.1 green:0.53 blue:0.95 alpha:0.5];
            UIColor *color = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
            self.routeLineView.fillColor = [UIColor redColor];
            
			self.routeLineView.strokeColor = color;
			self.routeLineView.lineWidth = 4;
		}
		overlayView = self.routeLineView;
	}
	return overlayView;
}

-(int) numberOfPinAdded:(NSString *)pinClassName{
    
    NSArray *pins = [self.mapView annotations];
    int count = 0;
    NSString *className;
    
    for (int i = 0; i < pins.count; i ++){
        
        className = [NSString stringWithFormat:@"%@",[[pins objectAtIndex:i] class]];
        
        if ([className isEqualToString:pinClassName]){
            count ++;
        }
    }
    return count;
}

-(IBAction)getPrevious:(id)sender{
    
}
-(IBAction)getNext:(id)sender{
    
}

@end
