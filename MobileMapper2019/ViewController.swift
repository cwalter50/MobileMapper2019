//
//  ViewController.swift
//  MobileMapper2019
//
//  Created by Christopher Walter on 11/10/19.
//  Copyright © 2019 Christopher Walter. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // Latitude / Longitude of Havertown, PA
    // 39.9764° N, 75.3150° W
    
    // Latitude / Longitude of Chicago, IL
    // 41.8781° N, 87.6298° W
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var parks: [MKMapItem] = [MKMapItem]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0]
    }

    
    @IBAction func whenSearchPressed(_ sender: UIBarButtonItem)
    {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "Pizza"
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        request.region = MKCoordinateRegion(center: currentLocation.coordinate, span: span)
        
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else { return }
            for mapItem in response.mapItems
            {
                self.parks.append(mapItem)
                let annotation = MKPointAnnotation()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.name
                self.mapView.addAnnotation(annotation)
            }
        }
        
    }
    
    @IBAction func whenZoomPressed(_ sender: UIBarButtonItem)
    {

        
        let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let center = currentLocation.coordinate
        let region = MKCoordinateRegion(center: center, span: coordinateSpan)
        mapView.setRegion(region, animated: true)
        
    }
    
    // MARK: Mapview Delegate Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        // this check will remove the image from userLocation Pin...
        if annotation.isEqual(mapView.userLocation)
        {
            return nil
        }
        
        
        let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.image = UIImage(named: "MobileMakerIconPinImage")
        pin.canShowCallout = true
    
        let button = UIButton(type: .detailDisclosure)
        pin.rightCalloutAccessoryView = button
        
        // for a stretch make the button do something cool....
        
        return pin
    }
    
}

