//
//  DetailViewController.m
//  GetOnThatBus
//
//  Created by Sonam Mehta on 1/21/14.
//  Copyright (c) 2014 Sonam Mehta. All rights reserved.
//

#import "DetailViewController.h"
#import "BusPointAnnotation.h"
#import <AddressBookUI/AddressBookUI.h>

@interface DetailViewController ()
{
    
    __weak IBOutlet UILabel *transfersLabel;
    __weak IBOutlet UILabel *routeLabel;
    __weak IBOutlet UILabel *addressLabel;
}

@end

@implementation DetailViewController
@synthesize busStop;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CLLocationCoordinate2D busStopCoordinates;
    NSString *latitudeString;
    NSString *longitudeString;
    double latitude;
    double longitude;
    
    
    self.navigationItem.title = busStop[@"cta_stop_name"];
	
    routeLabel.text = busStop[@"routes"];
    
    transfersLabel.text = busStop[@"inter_modal"];
    
    latitudeString = busStop [@"location"] [@"latitude"];
    longitudeString =busStop [@"location"] [@"longitude"];
    
    latitude = latitudeString.doubleValue;
    longitude = longitudeString.doubleValue;
    
    busStopCoordinates = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocation * newCoordinates = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    
    CLGeocoder *geoCoder = [CLGeocoder new];
    [geoCoder reverseGeocodeLocation:newCoordinates completionHandler:^(NSArray *placemarks, NSError *error)
        {
                   for (CLPlacemark* placemark in placemarks)
            {
                addressLabel.text = ABCreateStringWithAddressDictionary (placemark.addressDictionary, NO);
                
            }
        }
    ];
    
}


@end
