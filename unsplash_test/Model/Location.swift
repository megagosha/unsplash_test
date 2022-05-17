//
//  User.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import Foundation

struct Location: Codable {
    let city: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    
    init(city: String?, country: String?, lat: Double?, lon: Double?) {
        self.country = country
        self.city = city
        self.lat = lat
        self.lon = lon
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        city = try values.decode(String.self, forKey: .city)
        country = try values.decode(String.self, forKey: .country)
        
        let position =  try values.nestedContainer(keyedBy: PositionKeys.self, forKey: .position)
        if (!position.contains(.latitude) || !position.contains(.longitude)) {
            lat = nil
            lon = nil
        }
        else {
            lat = try position.decode(Double.self, forKey: .latitude)
            lon = try position.decode(Double.self, forKey: .longitude)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case city
        case country
        case position
    }
    
    enum PositionKeys: String, CodingKey {
        case latitude
        case longitude
    }
}


