//
//  ViewController.swift
//  A1_ios_Amandeep_C0779559
//
//  Created by Amandeep Kaur on 25/01/21.

// LONG PRESS TO SEE THE POINT A,B,C
// TAP ANYWHERE TO REMOVE MARKER
// TAP 2 TIMES TO REMOVE EVERYTHING FROM MAP
// PRESS BUTTON TO SEE ROUTE DIRECTIONS




import UIKit
import MapKit
class ViewController: UIViewController , CLLocationManagerDelegate  {
     //  create places Array
    let places = Place.getPlaces()
    
    @IBOutlet weak var directionBtn: UIButton!
    @IBOutlet weak var map: MKMapView!
   
    var destination: CLLocationCoordinate2D!
  
    // create location manager
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
        // Long press gesture
         let longpress = UILongPressGestureRecognizer(target: self, action: #selector(displaylocation))
         map.addGestureRecognizer(longpress)
         map.delegate = self
        
        // tap gesture
        let remove = UITapGestureRecognizer(target: self, action: #selector(removeAll))
        remove.numberOfTapsRequired = 2
        map.addGestureRecognizer(remove)
      
    }
    
   //MARK: - User Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
     
       // UNCOMMENT THIS TO SEE USER LOCATION
//        displayUserLocation(latitude:latitude, longitude: longitude , title: "You are here" ,subtitle: " "  )
        
    }
// MARK:- User Loction Method
   func displayUserLocation(latitude: CLLocationDegrees,longitude: CLLocationDegrees,title: String,subtitle:String) {
        let latDelta:CLLocationDegrees = 0.05
        let lngDelta:CLLocationDegrees = 0.05

       let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
        // define location
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)

        //  define region
       let region = MKCoordinateRegion(center: location, span: span)

       //  set the region for the map
       map.setRegion(region, animated: true)
        //  add annotation
       let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
       annotation.coordinate = location
       map.addAnnotation(annotation)
}
  // MARK:- setting Marker for Location 1
    @objc func displaylocation(gestureRecognizer : UILongPressGestureRecognizer) {
    
    let latitude:CLLocationDegrees =  43.6532
    let longitude:CLLocationDegrees = -79.3832
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    annotation.title = "A"
    annotation.subtitle = " "
    map.addAnnotation(annotation)
    

    let longpress2 = UILongPressGestureRecognizer(target: self, action: #selector(displaylocation1))
    map.addGestureRecognizer(longpress2)
   
    }
    // MARK:- setting Marker for Location 2
    @objc func displaylocation1(gestureRecognizer: UILongPressGestureRecognizer){
    
    let latitude:CLLocationDegrees =  45.4215
    let longitude:CLLocationDegrees = -75.6972
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    annotation.title = "B"
    annotation.subtitle = ""
    map.addAnnotation(annotation)

    let longpress3 = UILongPressGestureRecognizer(target: self, action: #selector(displaylocation2))
 
    map.addGestureRecognizer(longpress3)
    
    let sourceLocation = CLLocationCoordinate2D(latitude: 43.64, longitude: -79.38)
   let destinationLocation = CLLocationCoordinate2D(latitude: 45.4215,longitude: -75.6972)
    createPath(sourceLocation: sourceLocation, destinationLocation: destinationLocation)
    
    
}
    // MARK:- setting Marker for Location 3

@objc   func displaylocation2(gestureRecognizer: UILongPressGestureRecognizer){
    
    let latitude:CLLocationDegrees =  45.5017
    let longitude:CLLocationDegrees = -73.5673
    let annotation = MKPointAnnotation()
    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    annotation.title = "C"
    annotation.subtitle = ""
    map.addAnnotation(annotation)
   
    let destinationLocation = CLLocationCoordinate2D(latitude: 45.4215,longitude: -75.6972)
    let destinationLocation1 = CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673)
    createPath1(destinationLocation: destinationLocation, destinationLocation1: destinationLocation1)
   
    getdistance(from: destinationLocation, to: destinationLocation1)

}
  //MARK:- path method for location A to B
@objc func createPath(sourceLocation: CLLocationCoordinate2D , destinationLocation : CLLocationCoordinate2D) {
     
     let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
     let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
     let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
     let destinationItem = MKMapItem(placemark: destinationPlaceMark)
     let sourceAnnotation = MKPointAnnotation()
     sourceAnnotation.title = "A"
     sourceAnnotation.subtitle = " "
     if let location = sourcePlaceMark.location{
         sourceAnnotation.coordinate = location.coordinate
     }
     let destinationAnnotation = MKPointAnnotation()
     destinationAnnotation.title = "B"
     destinationAnnotation.subtitle = ""
     if let location = destinationPlaceMark.location {
         destinationAnnotation.coordinate = location.coordinate
     }
     self.map.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true)
     
     let direction = MKDirections.Request()
     direction.source = sourceMapItem
     direction.destination = destinationItem
     direction.transportType = .automobile
     
     let dir = MKDirections(request: direction)
    
     dir.calculate{(response, error) in
         guard let response = response else {
             if let error = error {
                 print ("")
             }
            return
         }
         let route = response.routes[0]
         self.map.addOverlay(route.polyline , level: MKOverlayLevel.aboveRoads)
         let rect = route.polyline.boundingMapRect
         self.map.setRegion(MKCoordinateRegion(rect), animated: true)
         
     }
}
    // MARK:- creating path for B to C
   @objc  func createPath1(destinationLocation: CLLocationCoordinate2D , destinationLocation1 : CLLocationCoordinate2D) {
     
     let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
     let destinationPlaceMark1 = MKPlacemark(coordinate: destinationLocation1, addressDictionary: nil)
     let sourceMapItem = MKMapItem(placemark: destinationPlaceMark)
     let destinationItem = MKMapItem(placemark: destinationPlaceMark1)
     let sourceAnnotation = MKPointAnnotation()
     sourceAnnotation.title = "B"
     sourceAnnotation.subtitle = " "
     if let location = destinationPlaceMark.location{
         sourceAnnotation.coordinate = location.coordinate
     }
     let destinationAnnotation = MKPointAnnotation()
     destinationAnnotation.title = "C"
     destinationAnnotation.subtitle = ""
     if let location = destinationPlaceMark1.location {
         destinationAnnotation.coordinate = location.coordinate
     }
     self.map.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true)
     
     let direction = MKDirections.Request()
     direction.source = sourceMapItem
     direction.destination = destinationItem
     direction.transportType = .automobile
     
     let dir = MKDirections(request: direction)
      
    dir.calculate{(response, error) in
         guard let response = response else {
             if let error = error {
                 print ("")
             }
            return
         }
         let route = response.routes[0]
         self.map.addOverlay(route.polyline , level: MKOverlayLevel.aboveRoads)
         let rect = route.polyline.boundingMapRect
         self.map.setRegion(MKCoordinateRegion(rect), animated: true)
         self.addPolygon()
        let removePins = UITapGestureRecognizer(target: self, action: #selector(self.removePin))
        self.map.addGestureRecognizer(removePins)
    }
}
    //MARK: - add annotation for places
    func  addAnnotationForPlaces() {
        map.addAnnotations(places)
        let overlays = places.map {MKCircle(center: $0.coordinate, radius: 2000)}
        map.addOverlays(overlays)
        }
    // MARK: - polyline method
    func addPolyline() {
        let coordinates = places.map {$0.coordinate}
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        map.addOverlay(polyline)
    }
    
    //MARK: - polygon method
    func addPolygon()
    {
        let coordinates = places.map {$0.coordinate}
        let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        map.addOverlay(polygon)
    }
    //MARK: - remove Marker from app
    @objc  func removePin(gestureRecognizer: UITapGestureRecognizer) {
      for annotation in map.annotations {
       map.removeAnnotation(annotation)
    }
       }
    // MARK:- Method to remove everything from map
    @objc func removeAll(gestureRecognizer:UITapGestureRecognizer) {
        map.removeOverlays(self.map.overlays)
        for annotation in map.annotations {
        map.removeAnnotation(annotation)
      
    }
    }
    

    func getdistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        print(CLLocationDistance.self)
        return from.distance(from: to)
        
    }
    // MARK:- Drawing directions for button A to B
    @IBAction func drawRoute(_ sender: UIButton) {
        map.removeOverlays(map.overlays)
        let sourceLocation = CLLocationCoordinate2D(latitude: 43.64, longitude: -79.38)
        let destinationLocation = CLLocationCoordinate2D(latitude: 45.4215,longitude: -75.6972)
        let destinationLocation1 = CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673)
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
         let sourceAnnotation = MKPointAnnotation()
         sourceAnnotation.title = "A"
         sourceAnnotation.subtitle = " "
         if let location = sourcePlaceMark.location{
             sourceAnnotation.coordinate = location.coordinate
         }
         let destinationAnnotation = MKPointAnnotation()
         destinationAnnotation.title = "B"
         destinationAnnotation.subtitle = ""
         if let location = destinationPlaceMark.location {
             destinationAnnotation.coordinate = location.coordinate
         }
         self.map.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true)
   
         let direction = MKDirections.Request()
         direction.source = sourceMapItem
         direction.destination = destinationItem
         direction.transportType = .automobile
         
        let dir = MKDirections(request: direction)
        dir.calculate{(response, error) in
             guard let response = response else {
                 if let error = error {
                     print ("")
                 }
                return
             }
             let route = response.routes[0]
             self.map.addOverlay(route.polyline , level: MKOverlayLevel.aboveRoads)
             let rect = route.polyline.boundingMapRect
             self.map.setRegion(MKCoordinateRegion(rect), animated: true)
             self.Drawroute1()
         }
       
    }
    // MARK:- Drawing directions for button B to C
    func Drawroute1 () {
        let destinationLocation = CLLocationCoordinate2D(latitude: 45.4215,longitude: -75.6972)
        let destinationLocation1 = CLLocationCoordinate2D(latitude: 45.5017, longitude: -73.5673)
        
        let destinationPlaceMark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        let destinationPlaceMark1 = MKPlacemark(coordinate: destinationLocation1, addressDictionary: nil)
        let sourceMapItem = MKMapItem(placemark: destinationPlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark1)
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "B"
        sourceAnnotation.subtitle = " "
        if let location = destinationPlaceMark.location{
            sourceAnnotation.coordinate = location.coordinate
        }
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "C"
        destinationAnnotation.subtitle = ""
        if let location = destinationPlaceMark1.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        self.map.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true)
        
        let direction = MKDirections.Request()
        direction.source = sourceMapItem
        direction.destination = destinationItem
        direction.transportType = .automobile
        
        let dir = MKDirections(request: direction)
        dir.calculate{(response, error) in
            guard let response = response else {
                if let error = error {
                    print ("")
                }
               return
            }
            let route = response.routes[0]
            self.map.addOverlay(route.polyline , level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.map.setRegion(MKCoordinateRegion(rect), animated: true)
        
     }
  }
}
extension ViewController: MKMapViewDelegate {
     //MARK: - renderer for overlay
         func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
           if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.green
            renderer.lineWidth = 5
             return renderer
        }else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = UIColor.red.withAlphaComponent(0.5)
           renderer.strokeColor = UIColor.red
            return renderer
       }
      return MKOverlayRenderer()
        }
}








    
    
