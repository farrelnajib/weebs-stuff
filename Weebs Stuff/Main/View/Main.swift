//
//  Main.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 08/07/21.
//

import SwiftUI

struct Main: View {
    @StateObject var viewModel = MainViewModel()
    @State var selection = "Anime"
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ScrollView {
                    AnimeSection(type: "anime", title: "Most Popular", endpoint: "bypopularity")
                    AnimeSection(type: "anime", title: "On-going", endpoint: "airing")
                    AnimeSection(type: "anime", title: "Upcoming", endpoint: "upcoming")
                }
                .tabItem {
                    Label("Anime", systemImage: "tv")
                }
                .tag("Anime")
                
                ScrollView {
                    AnimeSection(type: "manga", title: "Most Popular", endpoint: "bypopularity")
                    AnimeSection(type: "manga", title: "Top Novels", endpoint: "novels")
                    AnimeSection(type: "manga", title: "Top Manhwa", endpoint: "manhwa")
                }
                .tabItem {
                    Label("Manga", systemImage: "book")
                }
                .tag("Manga")
                    
            }
            .navigationBarTitle(selection)
        }
    }
}

struct AnimeSection: View {
    let type: String
    let title: String
    let endpoint: String
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            NavigationLink(
                destination: AnimeGridView(animeList: viewModel.animeList, title: title, type: type),
                label: {
                    Text("See all")
                })
        }
        .padding([.top, .horizontal])
        
        VStack(alignment: .trailing) {
            if viewModel.animeList.count == 0 {
                ActivityIndicator(shouldAnimate: true)
                    .onAppear(perform: {
                        viewModel.fetchAnime(type: type, endpoint: endpoint)
                    })
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(alignment: .top) {
                        ForEach(0...9, id: \.self) { index in
                            NavigationLink(
                                destination: DetailView(id: viewModel.animeList[index].malId, type: type),
                                label: {
                                    AnimeCell(anime: viewModel.animeList[index])
                                        .padding(.leading, 20)
                                }
                            )
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
