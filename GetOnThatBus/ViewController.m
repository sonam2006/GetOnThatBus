//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Sonam Mehta on 1/21/14.
//  Copyright (c) 2014 Sonam Mehta. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "DetailViewController.h"
#import "BusPointAnnotation.h"

@interface ViewController () <MKMapViewDelegate>
{
    IBOutlet MKMapView *mapView;
    NSArray *busStops;
    CLLocationCoordinate2D busStopLocation;
    
  
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
        NSURL *url = [NSURL URLWithString:@"http://dev.mobilemakers.co/lib/bus.json"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     
    {
       busStops = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError][@"row"];
         NSLog(@"%lu", (unsigned long)busStops.count);
         
         for (NSDictionary* busStop in busStops)
         {
             NSString *longitude;
             NSString *latitude;
             double latitudeOfPin;
             double longitudeOfPin;
             
            
             latitude = busStop [@"location"] [@"latitude"];
             latitudeOfPin = latitude.doubleValue;
             longitude = busStop [@"location"] [@"longitude"];
             longitudeOfPin = longitude.doubleValue;


             busStopLocation = CLLocationCoordinate2DMake(latitudeOfPin, longitudeOfPin);
         
             BusPointAnnotation *annotation = [BusPointAnnotation new];
             annotation.title = busStop [@"cta_stop_name"];
             annotation.subtitle = busStop [@"routes"];
             annotation.coordinate = busStopLocation;
             annotation.busStop = busStop;
             [mapView addAnnotation:annotation];
         
             
         }
    }
     
    ];
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (annotation == mapView.userLocation)
        {
            return nil;
        }
    MKAnnotationView *annotationView = [mV dequeueReusableAnnotationViewWithIdentifier:@"Don Bora the Centaur"];
    if (annotationView == Nil)
        {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Don Bora the Centaur"];
        }
    else
        {
            annotationView.annotation = annotation;
        }
    annotationView.canShowCallout = YES;
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    
    
    return annotationView;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    [self performSegueWithIdentifier:@"DetailSegue" sender:view];
    
    
    
    //DetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SonamIsTheBest"];
    

    
    //[self.navigationController pushViewController:viewController animated:YES];
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView *)sender
{
    if ([segue.identifier isEqualToString:@"DetailSegue"])
    {
        DetailViewController *vc = segue.destinationViewController;
        
        BusPointAnnotation *temp = sender.annotation;
        vc.busStop = temp.busStop;

    }
}




@end
