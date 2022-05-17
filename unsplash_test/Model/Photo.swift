//
//  Photo.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import Foundation

protocol PhotoBase {
    var id: String {get}
}

struct Photo: Codable, Identifiable, PhotoBase {
    let id: String
    let raw: String;
    let thumb: String;

    enum CodingKeys: String, CodingKey {
        case id
        case urls
    }
    
    enum UrlsKeys: String, CodingKey {
        case raw
        case thumb
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: Photo.CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        let urls = try values.nestedContainer(keyedBy: UrlsKeys.self, forKey: .urls)
        raw = try urls.decode(String.self, forKey: .raw)
        thumb = try urls.decode(String.self, forKey: .thumb)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
}
