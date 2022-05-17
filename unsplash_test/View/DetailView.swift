//
//  DetailView.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import SwiftUI
import SDWebImageSwiftUI
import MapKit


struct DetailView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    var photo: Photo?
    
    var likedPhoto: LikedPhoto?
    @StateObject var dVM = DetailViewModel()
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            ScrollView {
                VStack(alignment: .leading) {
                    if  (self.dVM.data.thumb != nil) {
                        WebImage(url: DetailViewModel.createCirclePhotoUrl(url: self.dVM.data.thumb!))
                            .resizable()
                            .indicator(.progress)
                            .frame(width: width, height: nil, alignment: .top)
                            .scaledToFit()
                    }
                    Text(self.dVM.data.user?.username ?? String(""))
                        .font(.title).padding(.leading, 15)
                    
                    HStack {
                        if (self.dVM.data.location != nil && self.dVM.data.location!.city != nil) {
                            Text(self.dVM.data.location!.city!).padding(.leading, 15)
                        }
                        Spacer()
                        if (self.dVM.data.location != nil && self.dVM.data.location!.country != nil) {
                            Text(self.dVM.data.location!.country ?? String("")).padding(.trailing, 15)
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    Divider()
                    HStack {
                        Text("Image info:").font(.title2).padding(.leading, 15)
                        
                        Button(action: {
                            if (!self.dVM.liked) {
                                DataController.shared
                                    .addPhoto(
                                        photo: self.dVM.data,
                                        context: managedObjContext
                                    )
                            }
                            else {
                                DataController.shared.delete(id: self.likedPhoto!.id!)
                            }
                            self.dVM.liked = !self.dVM.liked
                        }) {
                            HStack {
                                if (self.dVM.liked) {
                                    Image(uiImage: UIImage(named: "heart") ?? UIImage()).resizable().frame(width: 24.0, height: 24.0)
                                    Text("Unlike")
                                }
                                else {
                                    Image(uiImage: UIImage(named: "heart-2") ?? UIImage()).resizable().frame(width: 24.0, height: 24.0)
                                    Text("Like")
                                }
                            }}
                    }
                    HStack {
                        Text("Author: ").padding(.leading, 15)
                        Text((String(self.dVM.data.user?.username ?? "")))
                    }
                    HStack {
                        
                        Text("Created at: ").padding(.leading, 15)
                        Text(DetailView.dateToTime(date: self.dVM.data.created_at))
                    }
                    HStack {
                        Text("Downloaded: ").padding(.leading, 15)
                        Text((String(self.dVM.data.downloads ?? 0)))
                    }
                }
                Divider()
                if (self.dVM.data.coordinate != nil) {
                    MapView(coordinate: self.dVM.data.coordinate!)
                        .ignoresSafeArea(edges: .top)
                        .frame(height: 200)
                }
            }
        }.navigationTitle("Details:")
            .onAppear {
                if (self.likedPhoto != nil) {
                    self.dVM.loadFromLiked(photo: self.likedPhoto!)
                }
                else {
                    self.dVM.loadPhoto(photo: photo!)
                }
            }
    }
    static func dateToTime(date: Date?)->String {
        if (date == nil) {
            return String("")
        }
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return outputDateFormatter.string(from: date!)
    }
}

