//
//  DetailViewModel.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import Foundation
import CoreData
import SwiftUI
import MapKit
class DetailViewModel: ObservableObject {
    @Environment(\.managedObjectContext) var managedObjContext
    @Published var data: PhotoFull = PhotoFull()
    @Published var liked: Bool = false
        
    static func generateUrl(url: String) -> URL {
        let new_url = url
        return URL(string: new_url) ?? URL(string: "")!
    }
    
    func loadPhoto(photo: PhotoBase) -> Void {
        UnsplashService.getPhotoInfo(id: photo.id, completion: { res in
            self.data = res
            self.liked = DataController.shared.isLiked(id: self.data.id)
        })
    }
    
    static func createCirclePhotoUrl(url: String) -> URL {
        let new_url = url + "&dpr=2"
        return URL(string: new_url) ?? URL(string: "")!
    }
    
    func loadFromLiked(photo: LikedPhoto) {
        self.data =  PhotoFull(
            id: photo.id!,
            color: photo.color,
            user: User(from: photo.username ?? ""),
            raw: photo.raw_url,
            thumb: photo.thumb_url,
            created_at: photo.created_at,
            location: Location(city: photo.city, country: photo.country, lat: photo.lat, lon: photo.lon),
            downloads: Int(photo.downloads)
        )
        self.liked = DataController.shared.isLiked(id: photo.id!)
    }
}
