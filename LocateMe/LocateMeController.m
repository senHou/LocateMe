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
    [self.view addSubview:mapView];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0,416,320,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    [toolBar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionBottom barMetrics:1];
    
    UIImage *image = [UIImage imageNamed:@"locateme.png"];
    
    
    UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [aButton setImage:image forState:UIControlStateNormal];
    aButton.frame = CGRectMake(10, 425, image.size.width, image.size.height);
    
    [aButton addTarget:self action:@selector(locateMe:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithCustomView:aButton];
    
    NSArray *items = [NSArray arrayWithObject:button];
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
    if (sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateChanged)
        return;
    else {
        
        CGPoint point = [sender locationInView:self.mapView];
        CLLocationCoordinate2D coordinate =  [self.mapView convertPoint:point toCoordinateFromView:self.mapView] ;
        CLLocation *myLocation = [[CLLocation  alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];

        
        [geocoder reverseGeocodeLocation:myLocation completionHandler:^(NSArray *placemarks, NSError *error){
            NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
            
            if (error){
                NSLog(@"Geocode failed with error: %@", error);            
                return;
                
            }
            
            if(placemarks && placemarks.count > 0){
                CLPlacemark *topResult = [placemarks objectAtIndex:0];
                NSString *tmp = [NSString stringWithFormat:@"%@ %@,%@", 
                                        [topResult name],[topResult administrativeArea],
                                        [topResult  country]];
                
                NSLog(@"%@",tmp);
                DropPinAnnotation *annotaion = [[DropPinAnnotation alloc] initWithTitle:tmp andCoordinate:coordinate];
                [self.mapView addAnnotation:annotaion];

            }
        }];
        
    }
}

-(IBAction)locateMe:(id)sender{
    
    MKCoordinateRegion region;
    
	region.span.longitudeDelta = 0.219727;
	region.span.latitudeDelta = 0.221574;
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView showsUserLocation];
    
	region.center.latitude = location.coordinate.latitude;
	region.center.longitude = location.coordinate.longitude;
    
	[mapView setRegion:region animated:YES];
}

- (void)locationError:(NSError *)error{
    NSLog(@"%@",[error debugDescription]);
}

@end
