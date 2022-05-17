//
//  User.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import Foundation

struct User: Codable, Identifiable {
    let id: String?
    let username: String
    let location: String?
    let html: String?
    
    init (from username: String) {
        self.username = username
        id = nil
        location = nil
        html = nil
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        username = try values.decode(String.self, forKey: .username)
        do {
        location = try values.decode(String.self, forKey: .location)
        }
        catch {
            location = ""
        }
        
        let links = try values.nestedContainer(keyedBy: linksKeys.self, forKey: .links)
        html = try links.decode(String.self, forKey: .html)
    }
    
    func encode(to encoder: Encoder) throws {
        
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case location
        case links
    }
    
    enum linksKeys: String, CodingKey {
        case html
    }
}


