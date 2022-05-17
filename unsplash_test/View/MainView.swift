//
//  MainView.swift
//  unsplash_test
//
//  Created by George Tevosov on 16.05.2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainView: View {
    @StateObject private var mainViewModel = MainViewModel()
    @State private var searchText = ""
    @Environment(\.isSearching) private var isSearching: Bool
    @Environment(\.dismissSearch) private var dismissSearch
    
    
    var body: some View {
        TabView {
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(self.mainViewModel.photos, id: \.self.id) { photo in
                            NavigationLink(destination: DetailView(photo: photo)) {
                                WebImage(url:  MainViewModel.createPhotoUrl(url: photo.raw))
                            }.onAppear {
                                self.mainViewModel.loadMorePhotosIfNeeded(currentPhoto: photo)
                            }
                        }
                        if (mainViewModel.isLoadingPage) {
                            HStack() {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                }.navigationTitle("Search:")
            }
            .searchable(text: $searchText).onSubmit(of: .search, {
                self.mainViewModel.setMode(to: .search, query: searchText)
            }).onChange(of: searchText, perform: { value in
                if searchText.isEmpty && !isSearching {
                    self.mainViewModel.setMode(to: .random)
                }
            })
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                Image(systemName: "1.square.fill")
                Text("First")
            }
            SecondView()
                .tabItem {
                    Image(systemName: "2.square.fill")
                    Text("Second")
                }
            
        }
    }
}


