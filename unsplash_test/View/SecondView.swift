//
//  SecondView.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import SwiftUI
import SDWebImageSwiftUI
struct SecondView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.added_at)])
    
    var photos: FetchedResults<LikedPhoto>
    //    let item_w = UIScreen.main.bounds.size.width * 0.42;
    //    let columns = [
    //        GridItem(.adaptive(minimum: UIScreen.main.bounds.size.width * 0.42))
    //    ]
    //
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    let width = geo.size.width * 0.42
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: width))], spacing: 1) {
                        ForEach(photos, id: \.self) { item in
                            VStack{
                                NavigationLink(destination: DetailView(likedPhoto: item)) {
                                    WebImage(url: DetailViewModel.createCirclePhotoUrl(url: item.thumb_url!))
                                        .resizable()
                                        .aspectRatio(contentMode: ContentMode.fill)
                                        .frame(width: width,
                                               height: width)
                                        .clipped()
                                }.contentShape(Rectangle())
                                Text(item.username!).font(.system(size: 12)).padding(.bottom, 10)
                                
                            }
                        }
                    }.padding(.horizontal)
                }
            }.navigationTitle("Liked:")
        }
    }
}


struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        SecondView()
    }
}
