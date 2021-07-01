//
//  LocationViewController.swift
//  PizzApp
//
//  Created by Arturo Iván Chávez Gómez on 25/06/21.
//

import UIKit
import CoreLocation
import MapKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapSearchBar: UISearchBar!
    @IBOutlet weak var locationMapView: MKMapView!
    
    let db = Firestore.firestore()
    
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var altitude: Double?
    var manager = CLLocationManager()
    var globalLocation = CLLocation(latitude: 19.780510, longitude: -101.134921)
    var globalDestination: CLLocation?
    var totalDistance: Double?
    var locationManager = CLLocationManager()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapSearchBar.delegate = self
        manager.delegate = self
        locationMapView.delegate = self
        
        let user = Auth.auth().currentUser?.email
        db.collection("users").document(user!).getDocument { (documentSnapshot, error) in
            if let document = documentSnapshot, error == nil {
                if let location = document.get("location") as? String {
                    if location == "Current User Location" {
                        self.mapSearchBar.text = ""
                    } else {
                        self.mapSearchBar.text = location
                    }
                } else {
                    self.mapSearchBar.text = ""
                }
            }
        }
        
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            let alert = UIAlertController(title: "Error", message: "Your location isn't avaliable. Try again later.", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
            alert.addAction(accept)
            present(alert, animated: true)
            return
        }
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        altitude = location.altitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
    @IBAction func currentUserLocationButtonAction(_ sender: UIButton) {
        
        let location = CLLocationCoordinate2D(latitude: latitude ?? 0, longitude: longitude ?? 0)
        globalDestination = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let stringLocation = "Current User Location"
        let spanMap = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: location, span: spanMap)
        locationMapView.setRegion(region, animated: true)
        locationMapView.showsUserLocation = true
        
        totalDistance = globalLocation.distance(from: globalDestination ?? CLLocation(latitude: 0.0, longitude: 0.0))
        let distance = String(format: "%.2f", Float(totalDistance ?? 0.0))
        
        if totalDistance! > 30000.00 {
            
            let alert = UIAlertController(title: "Location isn't avaliable", message: "Your current location is outside of our delivery zone. Your distance is longer than 30km.", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
            alert.addAction(accept)
            present(alert, animated: true)
            
        } else {
            
            let routeToRemove = locationMapView.overlays
            locationMapView.removeOverlays(routeToRemove)
            let anotationToRemove = locationMapView.annotations
            locationMapView.removeAnnotations(anotationToRemove)
            
            let annotationDestination = MKPointAnnotation()
            annotationDestination.coordinate = (globalDestination?.coordinate)!
            annotationDestination.title = "You"
            
            let annotationLocation = MKPointAnnotation()
            annotationLocation.coordinate = (globalLocation.coordinate)
            annotationLocation.title = "Pizza"
            
            let alert = UIAlertController(title: "Current Location Set", message: "Distance from restaurant to your delivery location is \(distance) meters. The delivery route is on the map and your delivery location was saved successfully!", preferredStyle: .alert)
            let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
            alert.addAction(accept)
            present(alert, animated: true)
            let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            let region = MKCoordinateRegion(center: annotationDestination.coordinate, span: span)
            self.locationMapView.setRegion(region, animated: true)
            
            self.locationMapView.addAnnotation(annotationDestination)
            self.locationMapView.selectAnnotation(annotationDestination, animated: true)
            
            self.locationMapView.addAnnotation(annotationLocation)
            self.makeRoute(destinationCoordinates: globalDestination!.coordinate)
            
            let user = Auth.auth().currentUser?.email
            db.collection("users").document(user!).setData([
                "location": stringLocation,
            ], merge: true)
            
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        mapSearchBar.resignFirstResponder()
        let geocoder = CLGeocoder()
        if let direction = mapSearchBar.text {
            
            geocoder.geocodeAddressString(direction) { [self] (places: [CLPlacemark]?, error: Error?) in
                guard let destinationRoute = places?.first?.location else {
                    
                    let alert = UIAlertController(title: "Error", message: "\(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
                    alert.addAction(accept)
                    present(alert, animated: true)
                    return
                    
                }
                if error == nil {
                    
                    globalDestination = CLLocation(latitude: destinationRoute.coordinate.latitude, longitude: destinationRoute.coordinate.longitude)
                    totalDistance = globalLocation.distance(from: globalDestination ?? CLLocation(latitude: 0.0, longitude: 0.0))
                    let distance = String(format: "%.2f", Float(totalDistance ?? 0.0))
                    
                    if totalDistance! > 20000.00 {
                        
                        let alert = UIAlertController(title: "Location isn't avaliable", message: "This location is outside of our delivery zone. Your distance is longer than 20km.", preferredStyle: .alert)
                        let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
                        alert.addAction(accept)
                        present(alert, animated: true)
                        
                    } else {
                        
                        let user = Auth.auth().currentUser?.email
                        db.collection("users").document(user!).setData([
                            "location": direction,
                        ], merge: true)
                        
                        let routeToRemove = locationMapView.overlays
                        locationMapView.removeOverlays(routeToRemove)
                        let anotationToRemove = locationMapView.annotations
                        locationMapView.removeAnnotations(anotationToRemove)
                        
                        let place = places?.first
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = (place?.location?.coordinate)!
                        annotation.title = "\(direction)"
                        
                        let annotationLocation = MKPointAnnotation()
                        annotationLocation.coordinate = (globalLocation.coordinate)
                        annotationLocation.title = "Pizza"
                        
                        let alert = UIAlertController(title: "Location set", message: "Distance from restaurant to your delivery location is \(distance) meters. The delivery route is on the map and your delivery location was saved successfully!", preferredStyle: .alert)
                        let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
                        alert.addAction(accept)
                        present(alert, animated: true)
                        
                        let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
                        let region = MKCoordinateRegion(center: annotation.coordinate, span: span)
                        self.locationMapView.setRegion(region, animated: true)
                        
                        self.locationMapView.addAnnotation(annotation)
                        self.locationMapView.selectAnnotation(annotation, animated: true)
                        
                        self.locationMapView.addAnnotation(annotationLocation)
                        
                        self.makeRoute(destinationCoordinates: destinationRoute.coordinate)
                        
                    }
                } else {
                    
                    let alert = UIAlertController(title: "Error", message: "Sorry, we couldn't find that location, try again please.", preferredStyle: .alert)
                    let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
                    alert.addAction(accept)
                    present(alert, animated: true)
                    return
                    
                }
            }
        }
    }
    
    func makeRoute(destinationCoordinates: CLLocationCoordinate2D) {
        
        let originPlaceMark = MKPlacemark(coordinate: globalLocation.coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationCoordinates)
        
        let originItem = MKMapItem(placemark: originPlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = originItem
        destinationRequest.destination = destinationItem
        
        destinationRequest.transportType = .automobile
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        directions.calculate { (response, error) in
            guard let secureResponse = response else {
                
                if let error = error {
                    
                    let alert = UIAlertController(title: "Error", message: "Sorry, we couldn't make the route. :c", preferredStyle: .alert)
                    let accept = UIAlertAction(title: "Accept", style: .default, handler: nil)
                    alert.addAction(accept)
                    self.present(alert, animated: true)
                    return
                    
                }
                
                return
                
            }
            
            let route = secureResponse.routes[0]
            self.locationMapView.addOverlay(route.polyline)
            self.locationMapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: false)
            
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.lineWidth = 4.0
        render.strokeColor = .systemOrange
        render.alpha = 1.0
        return render
    }
    
}
