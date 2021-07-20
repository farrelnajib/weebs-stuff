//
//  Main.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 08/07/21.
//

import SwiftUI

struct Main: View {
//    @StateObject var viewModel = MainViewModel()
    @State var selection = "Anime List"
    @State var search = ""
    @State var isSearch = false
    @StateObject var animeSearch = SearchViewModel(type: "anime")
    @StateObject var mangaSearch = SearchViewModel(type: "manga")
    
    var body: some View {
        NavigationView {
            TabView(selection: $selection) {
                ScrollView {
                    SearchBar(text: $animeSearch.searchQuery, isEditing: $isSearch)
                    if isSearch {
                        SearchView(type: "anime", query: search)
                    }
                    else {
                        AnimeSection(type: "anime", title: "Most Popular", endpoint: "bypopularity")
                        AnimeSection(type: "anime", title: "On-going", endpoint: "airing")
                        AnimeSection(type: "anime", title: "Upcoming", endpoint: "upcoming")
                    }
                }
                .tabItem {
                    Label("Anime", systemImage: "tv")
                }
                .tag("Anime List")
                .environmentObject(animeSearch)
                
                ScrollView {
                    SearchBar(text: $mangaSearch.searchQuery, isEditing: $isSearch)
                    if isSearch {
                        SearchView(type: "manga", query: search)
                    } else {
                        AnimeSection(type: "manga", title: "Most Popular", endpoint: "bypopularity")
                        AnimeSection(type: "manga", title: "Top Novels", endpoint: "novels")
                        AnimeSection(type: "manga", title: "Top Manhwa", endpoint: "manhwa")
                    }
                }
                .tabItem {
                    Label("Manga", systemImage: "book")
                }
                .tag("Manga List")
                .environmentObject(mangaSearch)
                    
            }
            .onChange(of: selection, perform: { value in
                isSearch = false
            })
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
                destination: AnimeGridView(viewModel: viewModel, title: title, type: type),
                label: {
                    Text("See all")
                })
        }
        .padding([.top, .horizontal])
        
        VStack(alignment: .trailing) {
            switch(viewModel.status) {
            case .loading:
                ProgressView()
                    .onAppear(perform: {
                        viewModel.fetchAnime(type: type, endpoint: endpoint)
                    })
            case .success:
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
            case .failed(err: let err):
                Text("\(err.localizedDescription)")
            case .idle:
                Text("Idling...")
            }
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
