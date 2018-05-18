//
//  MapViewController.swift
//  SagaTest
//
//  Created by Daniel Klinkert Houfer on 5/18/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import SVProgressHUD


class SagaMapViewController: UIViewController {
    
    
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager         = CLLocationManager()
    fileprivate var userSelectedLocation    = MKPointAnnotation()
    
    let viewModel = MapViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMap()
        setupLocationManager()
        // Do any additional setup after loading the view.
    }
    
    fileprivate func configureMap() {
        mapView.delegate                    = self
        mapView.isZoomEnabled               = true
        userSelectedLocation.coordinate     = mapView.userLocation.coordinate
        mapView.addAnnotation(userSelectedLocation)
        setPointAnnotation(coords: mapView.userLocation.coordinate)
    }
    
    fileprivate func setPointAnnotation(coords:CLLocationCoordinate2D) {
        userSelectedLocation.coordinate = coords
        let region = mapView.regionThatFits(MKCoordinateRegionMake(coords, MKCoordinateSpan(latitudeDelta: 0.0020, longitudeDelta: 0.0020)))
        mapView.setRegion(region, animated: true)
    }
    
    fileprivate func setupLocationManager() {
        locationManager.delegate        = self
        locationManager.desiredAccuracy =  kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func  createAnnotation(location:CLLocationCoordinate2D) {
        mapView.removeAnnotation(userSelectedLocation)
        userSelectedLocation.coordinate = location
        mapView.addAnnotation(userSelectedLocation)
    }
    
    fileprivate func requestWeatherWithLocation(location:CLLocationCoordinate2D) {
        SVProgressHUD.show()
        viewModel.fetchWeatherAtLocation(lat: location.latitude, lng: location.longitude, successClosure: {
            self.userSelectedLocation.title = self.viewModel.lasSelectedWeatherLocation?.name
            SVProgressHUD.dismiss()
        }, errorClosure: { error in
            SVProgressHUD.dismiss()
            SVProgressHUD.showInfo(withStatus: error.localizedDescription)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            let nextVc = segue.destination as! DetailViewController
            guard let selectedWeather = viewModel.lasSelectedWeatherLocation else {
                return
            }
            nextVc.viewModel.detailWeather = selectedWeather
        }
    }
   
}

extension SagaMapViewController:UIGestureRecognizerDelegate {
    //    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    //        return !(touch.view is MKPinAnnotationView)
    //    }
}

extension SagaMapViewController:CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location    = locations.last! as CLLocation
        let center      = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region      = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        if location.coordinate.longitude != 0.0 && location.coordinate.latitude != 0.0 {
            createAnnotation(location: location.coordinate)
           requestWeatherWithLocation(location: location.coordinate)
        }
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.coordinate.longitude == 0.0 && annotation.coordinate.latitude == 0.0 {
            return nil
        }
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let annotationView                          = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        annotationView.isDraggable                  = true
        annotationView.canShowCallout               = true
        annotationView.rightCalloutAccessoryView    = UIButton(type: UIButtonType.detailDisclosure)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        guard let _ = view.annotation else
        {
            return
        }
        
        performSegue(withIdentifier: "detailSegue", sender: nil)
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == .ending {
            guard let annotation = view.annotation else {
                return
            }
            requestWeatherWithLocation(location: annotation.coordinate)
        }
    }
    
}

extension SagaMapViewController:MKMapViewDelegate {
    
    
}
