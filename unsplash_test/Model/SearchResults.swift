//
//  Photo.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import Foundation

struct SearchReuslts: Codable {
    var total: Int
    var total_pages: Int;
    var results: [Photo]
    
    init() {
        total = 0
        total_pages = 0
        results = []
    }
}
