//
//  UnsplashService.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import Foundation
import Combine
import SwiftUI

class UnsplashService {
    
    static func searchPhotos(query: String, take: Int = 10, page: Int = 0, completion:@escaping (SearchReuslts) -> ()) {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/search/photos")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: UIApplication.apiKey),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "per_page", value: String(take)),
            URLQueryItem(name: "page", value: String(page)),
            
        ]
        let url = urlComponents?.url?.absoluteURL
        if (url == nil) {
            print ("Invalid url...")
            return
        }
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                //                                let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String?
                //                                print(outputStr!)
                if let error = error {
                    self.handleError(error: error)
                    completion(SearchReuslts())
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.handleError(error: NSError(domain:"", code: 500, userInfo:nil))
                    completion(SearchReuslts())
                    return
                }
                if (data == nil)
                {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    completion(SearchReuslts())
                    return
                }
                let photos =  try JSONDecoder().decode(SearchReuslts.self, from: data!)
                DispatchQueue.main.async {
                    completion(photos)
                }
            }
            catch let error {
                self.handleError(error: NSError(domain:"", code: 500, userInfo:nil))
                print (error)
            }
        }.resume()
    }
    
    static func handleError(error: Error) {
        
        NotificationCenter.default.post(name: .showAlert,
                                        object: AlertData(title: Text("Error occured"),
                                                          message: Text("Network error!"),
                                                          dismissButton: .default(Text("OK")) {
            print("Alert dismissed")
        }))
    }
    
    
    static func loadRandomPhotos(count: Int, completion:@escaping ([Photo]) -> ()) {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/photos/random")
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: UIApplication.apiKey),
            URLQueryItem(name: "count", value: "10"),
            
        ]
        let url = urlComponents?.url?.absoluteURL
        if (url == nil) {
            print ("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                //                                let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String?
                //                                print(outputStr!)
                if let error = error {
                    self.handleError(error: error)
                    completion([])
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.handleError(error: NSError(domain:"", code: 500, userInfo:nil))
                    completion([])
                    return
                }
                if (data == nil)
                {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    completion([])
                    return
                }
                let photos =  try JSONDecoder().decode([Photo].self, from: data!)
                DispatchQueue.main.async {
                    completion(photos)
                }
            }
            catch let error {
                self.handleError(error: NSError(domain:"", code: 500, userInfo:nil))
                print (error)
            }
        }.resume()
    }
    
    static func loadImage(url: String, completion:@escaping (Data) -> ()) {
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: UIApplication.apiKey),
            URLQueryItem(name: "w", value: "1500"),
            URLQueryItem(name: "dpr", value: "2")
            
        ]
        let url = urlComponents?.url?.absoluteURL
        if (url == nil) {
            completion(Data())
        }
        URLSession.shared.dataTask(with: url!) { data, response, error in
            guard let data = data, error == nil else {
                completion(Data())
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
    
    static func getPhotoInfo(id: String, completion:@escaping (PhotoFull) -> ()) {
        var urlComponents = URLComponents(string: "https://api.unsplash.com/photos/" + id)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: UIApplication.apiKey),
        ]
        let url = urlComponents?.url?.absoluteURL
        if (url == nil) {
            print ("Invalid url...")
            return
        }
        
        URLSession.shared.dataTask(with: url!) { data, response, error in
            do {
                //                                let outputStr  = String(data: data!, encoding: String.Encoding.utf8) as String?
                //                                print(outputStr!)
                if let error = error {
                    self.handleError(error: error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    self.handleError(error: NSError(domain:"", code: 500, userInfo:nil))
                    return
                }
                if (data == nil)
                {
                    self.handleError(error: NSError(domain: "", code: 500, userInfo: nil))
                    return
                }
                let photo =  try JSONDecoder().decode(PhotoFull.self, from: data!)
                DispatchQueue.main.async {
                    completion(photo)
                }
            }
            catch let error {
                self.handleError(error: NSError(domain:"", code: 500, userInfo:nil))
                print (error)
            }
        }.resume()
    }
}

extension UIApplication {
    static var apiKey: String? {
        return Bundle.main.object(forInfoDictionaryKey: "UnsplashApiKey") as? String
    }
}

public extension Notification.Name {
    static let showAlert = Notification.Name("showAlert")
}
