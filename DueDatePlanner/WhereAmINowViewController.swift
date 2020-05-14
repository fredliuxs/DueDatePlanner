//
//  WhereAmIViewController.swift
//  DueDatePlanner
//
//  Created by Xusheng Liu on 5/12/20.
//  Copyright © 2020 Rose-Hulman. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class WhereAmINowViewController: UIViewController {
    
    let API_KEY = "AIzaSyBmRm9LfYPW-XJSiYn60tYRl1qTu5sMJDI"
    let RHIT_LONGITUDE = -87.32404
    let RHIT_LATITUDE = 39.4829111
    var locationManager: CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey(self.API_KEY)
        self.locationManager = CLLocationManager()
        var currentLoc: CLLocation?
        if(CLLocationManager.authorizationStatus() == .authorizedAlways ||
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse) {
            currentLoc = locationManager!.location
            if (currentLoc != nil){
                let camera = GMSCameraPosition.camera(withLatitude: currentLoc!.coordinate.latitude, longitude: currentLoc!.coordinate.longitude, zoom: 17.0)
                let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
                self.view.addSubview(mapView)
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: currentLoc!.coordinate.latitude, longitude: currentLoc!.coordinate.longitude)
                marker.title = "Here is my location"
                marker.map = mapView
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "GO!", style: .plain, target: self, action: #selector(self.launchGoogleMapWithStartingLocation))
            } else {
                let alertController = UIAlertController(title: "Woops!", message: "We cannot locate your location. However, we got Rose-Hulman here!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.showRoseHulman()
                present(alertController, animated: true, completion: nil)
            }
        } else {
            self.showRoseHulman()
        }
    }
    
    func showRoseHulman(){
        let camera = GMSCameraPosition.camera(withLatitude: RHIT_LATITUDE, longitude: RHIT_LONGITUDE, zoom: 17.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: RHIT_LATITUDE, longitude: RHIT_LONGITUDE)
        marker.title = "Rose-Hulman Institute of Technology"
        marker.snippet = "5500 Wabash Avenue, Terre Haute IN 47803, USA"
        marker.map = mapView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "GO!", style: .plain, target: self, action: #selector(self.launchGoogleMapWithoutStartingLocation))
    }
    
    @objc func launchGoogleMapWithoutStartingLocation(){
        let url = URL(string: "https://www.google.com/maps/dir//'\(self.RHIT_LATITUDE),\(self.RHIT_LONGITUDE)'")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func launchGoogleMapWithStartingLocation() {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        let currentLoc = locationManager.location!
        let url = URL(string: "https://www.google.com/maps/dir/'\(currentLoc.coordinate.latitude),\(currentLoc.coordinate.longitude)'/'\(self.RHIT_LATITUDE),\(self.RHIT_LONGITUDE)'/")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
