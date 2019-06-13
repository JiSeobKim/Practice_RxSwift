//
//  Utils.swift
//  Practice_RxSwift
//
//  Created by kimjiseob on 13/06/2019.
//  Copyright © 2019 kimjiseob. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class GeoLocationUtils: NSObject, CLLocationManagerDelegate {
    private var disposeBag = DisposeBag()
    private (set) var location = PublishSubject<CLLocationCoordinate2D>()
    private (set) var authorized = PublishSubject<Bool>()
    private let locationManager: CLLocationManager = CLLocationManager()
    
    
    override init() {
        super.init()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let value = locations.first {
            location.on(Event.next(value.coordinate))
        }
    }

    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            authorized.onNext(true)
        default:
            authorized.onNext(false)
        }
    }
}
