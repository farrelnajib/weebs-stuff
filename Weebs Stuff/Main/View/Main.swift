//
//  Main.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 08/07/21.
//

import SwiftUI

struct Main: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                AnimeSection(title: "Most Popular", endpoint: "bypopularity")
                AnimeSection(title: "On-going", endpoint: "airing")
                AnimeSection(title: "Upcoming", endpoint: "upcoming")
            }
            .navigationBarTitle("MyAnimeList")
        }
    }
}

struct AnimeSection: View {
    let title: String
    let endpoint: String
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            NavigationLink(
                destination: AnimeGridView(animeList: viewModel.animeList, title: title),
                label: {
                    Text("See all")
                })
        }
        .padding([.top, .horizontal])
        
        VStack(alignment: .trailing) {
            if viewModel.animeList.count == 0 {
                ActivityIndicator(shouldAnimate: true)
                    .onAppear(perform: {
                        viewModel.fetchAnime(endpoint: endpoint)
                    })
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack {
                        ForEach(0...9, id: \.self) { index in
                            NavigationLink(
                                destination: DetailView(id: viewModel.animeList[index].malId),
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
