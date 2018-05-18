//
//  Endpoint.swift
//  SagaTest
//
//  Created by Daniel Klinkert Houfer on 5/18/18.
//  Copyright © 2018 Daniel Klinkert Houfer. All rights reserved.
//

import Foundation

import Alamofire
import ObjectMapper

fileprivate struct requestConstants {
    static let APIKEY = "e54b3cccf8cdae241d74dc706b28431e"
    fileprivate enum constantUrls {
        static let baseUrl = "https://api.openweathermap.org/data/2.5/"
    }
    
    fileprivate enum constantPaths {
        static let weather = "weather"
    }
}



enum sagaEndpoint {
    case weatherByLatAndLong(lat:Double,lng:Double)
}


extension sagaEndpoint:APIEndpoint {
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: requestConstants.constantUrls.baseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .weatherByLatAndLong(lat: _, lng: _):
                return requestConstants.constantPaths.weather
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .weatherByLatAndLong(lat: let lat, lng: let lng):
            return ["lat":lat,"lon":lng, "appid":requestConstants.APIKEY]
        }
    }
    
    var customParameterEncoding: ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
        
    }
    
    var customHTTPHeaders: [String: String]? {
        switch self {
        default:
            return nil
        }
    }
}
