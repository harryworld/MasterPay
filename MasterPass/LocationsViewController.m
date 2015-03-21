//
//  LocationsViewController.m
//  MasterPass
//
//  Created by Harry Ng on 21/3/15.
//  Copyright (c) 2015 David Benko. All rights reserved.
//

#import "LocationsViewController.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController

@synthesize mapView;
@synthesize locationManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    // Map
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
    myAnnotation.coordinate = CLLocationCoordinate2DMake(22.284681, 114.158177);
    myAnnotation.title = @"Matthews Pizza";
    myAnnotation.subtitle = @"Best Pizza in Town";
    [self.mapView addAnnotation:myAnnotation];

    MKPointAnnotation *myAnnotation1 = [[MKPointAnnotation alloc] init];
    myAnnotation1.coordinate = CLLocationCoordinate2DMake(22.284681, 114.168177);
    myAnnotation1.title = @"Cocoon Pizza";
    myAnnotation1.subtitle = @"Best co-working space";
    [self.mapView addAnnotation:myAnnotation1];
    
    [self loadData];
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
}

#pragma mark -

- (void)loadData
{
    NSString *serverAddress = [NSString stringWithFormat:@"http://desolate-river-6178.herokuapp.com"];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/locations/China/HongKong", serverAddress]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if (error) {
            NSLog(@"error: %@", error);
        }
        else{
            NSError * jsonError;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:kNilOptions
                                                                   error:&jsonError];
            if (jsonError) {
                NSLog(@"error: %@", jsonError);
            }
            else {
                NSDictionary *atms = [json objectForKey:@"Atms"];
                NSArray *atm = [atms objectForKey:@"Atm"];
                
                for (NSDictionary *l in atm) {
                    NSDictionary *location = [l objectForKey:@"Location"];
                    NSString *name = [location objectForKey:@"Name"];
                    NSDictionary *address = [location objectForKey:@"Address"];
                    NSString *street = [address objectForKey:@"Line1"];
                    NSDictionary *point = [location objectForKey:@"Point"];
                    NSString *lat = [point objectForKey:@"Latitude"];
                    NSString *lng = [point objectForKey:@"Longitude"];
                    
                    NSLog(@"%@ / %@ / %@", name, lat, lng);
                    
                    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
                    myAnnotation.coordinate = CLLocationCoordinate2DMake([lat floatValue], [lng floatValue]);
                    myAnnotation.title = name;
                    myAnnotation.subtitle = street;
                    [self.mapView addAnnotation:myAnnotation];

                }
            }
            
        }
    }];
}

@end
