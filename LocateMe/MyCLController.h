//
//  MyCLController.h
//  Location
//
//  Created by sen hou on 7/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
 #import <CoreLocation/CoreLocation.h>


//delegate methods
@protocol MyCLControllerDelegate 
@required
- (void)locationUpdate:(CLLocation *)myLocation;
- (void)locationError:(NSError *)error;
@end



@interface MyCLController : NSObject <CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    id delegate;
}


@property (nonatomic, retain) CLLocationManager *locationManager;  
@property (nonatomic, retain) id delegate;



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;


@end
