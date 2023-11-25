//
//  LocationManager.swift
//  PhonePeProject
//
//  Created by LOVISH on 25/11/23.
//

import SwiftUI
import CoreLocation

class LocationService: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    var currentLat: Double?
    var currentLng: Double?

    private var locationManager = CLLocationManager()

    private override init() {
        super.init()
        setupLocationManager()
    }
    
    func getUpdatedLocation() {
        locationManager.startUpdatingLocation()
    }

    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLat = location.coordinate.latitude
            currentLng = location.coordinate.longitude
        }
    }
}


