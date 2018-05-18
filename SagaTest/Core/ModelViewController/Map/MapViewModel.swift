//
//  MapViewModel.swift
//  SagaTest
//
//  Created by Daniel Klinkert Houfer on 5/18/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation

class MapViewModel {
    
    var lasSelectedWeatherLocation:Weather?
    
    func fetchWeatherAtLocation(lat:Double,lng:Double,successClosure:@escaping ()->(),errorClosure:@escaping (_ error:Error)->()) {
        Weather.requestUserWeatherLocation(endPoint: sagaEndpoint.weatherByLatAndLong(lat: lat, lng: lng), successClosure: { (weather:Weather) in
            self.lasSelectedWeatherLocation = weather
            successClosure()
        }, errorClosure: errorClosure)
    }
    
    
}
