//
//  PhotoFull.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import Foundation
import CoreLocation

struct PhotoFull: Codable, Identifiable, PhotoBase {
    let id: String
    let color: String?;
    let user: User?
    let raw: String?;
    let thumb: String?;
    let created_at: Date?
    let location: Location?
    let coordinate: CLLocationCoordinate2D?
    
    let downloads: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case color
        case user
        case urls
        case created_at
        case location
        case downloads
    }
    
    enum UrlsKeys: String, CodingKey {
        case raw
        case thumb
    }
    
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: PhotoFull.CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        color = try values.decode(String.self, forKey: .color)
        user = try values.decode(User.self, forKey: .user)
        let time = try values.decode(String.self, forKey: .created_at)
        created_at = PhotoFull.parseTime(time: time)
        downloads = try values.decode(Int.self, forKey: .downloads)
        do {
            location = try values.decode(Location.self, forKey: .location)
            if location != nil {
                coordinate = CLLocationCoordinate2D(latitude: location!.lat!, longitude: location!.lon!)
            } else {
                coordinate = nil
            }
        }
        catch {
            location = nil
            coordinate = nil
        }
        let urls = try values.nestedContainer(keyedBy: UrlsKeys.self, forKey: .urls)
        raw = try urls.decode(String.self, forKey: .raw)
        thumb = try urls.decode(String.self, forKey: .thumb)
    }
    
    
    init( id: String,
          color: String?,
          user: User?,
          raw: String?,
          thumb: String?,
          created_at: Date?,
          location: Location?,
          downloads: Int?) {
        self.id = id
        self.color = color
        self.user =  user
        self.raw = raw
        self.thumb = thumb
        self.created_at = created_at
        
        if (location != nil && location?.lat != 0 && location?.lon != 0) {
            self.coordinate = CLLocationCoordinate2D(latitude: location!.lat!, longitude: location!.lon!)
        }
        else {
            self.coordinate = nil
        }
        self.location = location
        self.downloads = downloads
        
    }
    
    init() {
        id =  ""
        color = nil
        user = nil
        created_at = nil
        downloads = nil
        location = nil
        raw = nil
        thumb = nil
        coordinate = nil
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    static func parseTime(time: String?)-> Date? {
        if (time == nil) {
            return nil
        }
        print(time)
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        var res = RFC3339DateFormatter.date(from: time!)
        print(res)
        return res
    }
}
