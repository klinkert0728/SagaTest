//
//  Weather.swift
//  SagaTest
//
//  Created by Daniel Klinkert Houfer on 5/18/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import AlamofireObjectMapper
import RealmSwift
import CoreLocation
import ReachabilitySwift

@objcMembers
class Weather:Object,Mappable {
    
    dynamic var temp                = 0.0
    dynamic var humidity            = 0
    dynamic var maxTemp             = 0.0
    dynamic var minTemp             = 0.0
    dynamic var tempDescription     = ""
    dynamic var lat                 = 0.0
    dynamic var lng                 = 0.0
    dynamic var name                = ""
    
    private var locationCoordinates:CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    override class func ignoredProperties() -> [String] {
        return ["locationCoordinates"]
    }
    
    convenience required init?(map: Map) {
        self.init()
    }
    
    
    func mapping(map: Map) {
        
        temp            <- map["main.temp"]
        humidity        <- map["main.humidity"]
        maxTemp         <- map["main.temp_max"]
        minTemp         <- map["main.temp_min"]
        tempDescription <- map["weather.0.description"]
        lat             <- map["coord.lat"]
        lng             <- map["coord.lon"]
        name            <- map["name"]
        
    }
    
    class func requestUserWeatherLocation(endPoint:sagaEndpoint,successClosure: @escaping (_ weather:Weather)->(),errorClosure:@escaping (_ error:Error)->()) {
        
        let reachability = Reachability()!
        
        if  reachability.currentReachabilityStatus == .notReachable {
            var lastWeather:Weather?
            Realm.update(updateClosure: { (realm) in
                lastWeather = realm.objects(Weather.self).last
            })
            guard let last = lastWeather else {
                return
            }
            successClosure(last)
        }
        
        APIClient.sharedClient.requestObject(endpoint: endPoint, completionHandler: { (currentWeather:Weather) in
            Realm.update(updateClosure: { (realm) in
                realm.add(currentWeather)
            })
            successClosure(currentWeather)
        }, errorClosure: { error in
            errorClosure(error)
        })
    }
}
