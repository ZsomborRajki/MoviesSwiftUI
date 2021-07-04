//
//  TabBarView.swift
//  MoviesSwiftUI
//
//  Created by Rajki Zsombor on 2021. 07. 04..
//

import SwiftUI

struct TabbarView: View {
    @State var selectedTab = Tab.trending
    
    enum Tab: Int {
        case trending, search
    }
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MoviesTrendingView(viewModel: MoviesTrendingViewModel())
                .tabItem {
                    tabbarItem(text: "Tranding", image: "film")
                }
                .tag(Tab.trending)
            
            MoviesSearchView(viewModel: MoviesSearchViewModel())
                .tabItem {
                    tabbarItem(text: "Search", image: "magnifyingglass")
                }
                .tag(Tab.search)
            
        }
    }
    
}
