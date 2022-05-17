//
//  PhotoService.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import Foundation
import SwiftUI



class MainViewModel: ObservableObject {
    @Published var photos = [Photo]()
    @Published var isLoadingPage = false
    private var canLoadMore = true
    private var mode = Mode.random;
    public var query: String = ""
    private var totalPages: Int = 0;
    private var curPage: Int = 0;
    static let screenWidth = Int(UIScreen.main.bounds.size.width);
    static let screenHeight = Int(UIScreen.main.bounds.size.height);
    
    init() {
        loadMorePhotos()
    }
    
    func loadMorePhotosIfNeeded(currentPhoto ph: Photo?) {
        guard let ph = ph else {
            loadMorePhotos()
            return
        }
        let thresholdIndex = photos.index(photos.endIndex, offsetBy: -5)
        if photos.firstIndex(where: { $0.id == ph.id }) == thresholdIndex {
            loadMorePhotos()
        }
    }
    
    func loadMorePhotos() {
        guard !isLoadingPage && canLoadMore else {
            return
        }
        isLoadingPage = true
        if (self.mode == Mode.search) {
            UnsplashService.searchPhotos(query: self.query, take: 10, page: self.totalPages, completion: {
              search in
                if (self.photos.isEmpty && self.totalPages == 0 && self.curPage == 0)
                {
                    self.totalPages = search.total_pages
                }
                self.photos.append(contentsOf: search.results)
                self.curPage += 1
                if (self.curPage >= self.totalPages) {
                    self.canLoadMore = false
                }
                self.isLoadingPage = false
            })
            return
        }
        UnsplashService.loadRandomPhotos(count: 10, completion: { photos in self.photos.append(contentsOf: photos)
            self.isLoadingPage = false
        })
    }
    
    static func createPhotoUrl(url: String) -> URL {
        let new_url = url + "&w=" + String(MainViewModel.screenWidth) + "&h=" + String(MainViewModel.screenHeight / 5) + "&fit=crop&dpr=2"
        return URL(string: new_url) ?? URL(string: "")!
    }
    
    func setMode(to: Mode, query: String = "")-> Void {
        self.mode = to
        self.photos = []
        if (self.mode == Mode.search) {
            self.totalPages = 0
            self.curPage = 0
            self.query = query
        }
        else
        {
            self.query = ""
        }
        self.canLoadMore = true
        loadMorePhotosIfNeeded(currentPhoto: nil)
    }
}


enum Mode {
    case random
    case search
}
