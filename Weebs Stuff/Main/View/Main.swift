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
                HStack {
                    Text("On-going")
                        .font(.headline)
                    Spacer()
                    NavigationLink(
                        destination: AnimeGridView(animeList: viewModel.airings, title: "On-going"),
                        label: {
                            Text("See all")
                        })
                }
                .padding([.top, .horizontal])
                
                VStack(alignment: .trailing) {
                    if viewModel.airings.count == 0 {
                        ActivityIndicator(shouldAnimate: true)
                            .onAppear(perform: {
                                viewModel.fetchAnime(endpoint: "airing")
                            })
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(0...9, id: \.self) { index in
                                    NavigationLink(
                                        destination: DetailView(id: viewModel.airings[index].malId),
                                        label: {
                                            AnimeCell(anime: viewModel.airings[index])
                                                .padding(.leading, 20)
                                        }
                                    )
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                }
                
                HStack {
                    Text("Upcoming")
                        .font(.headline)
                    Spacer()
                    NavigationLink(
                        destination: AnimeGridView(animeList: viewModel.upcoming, title: "Upcoming"),
                        label: {
                            Text("See all")
                        })
                }
                .padding([.top, .horizontal])
                
                VStack(alignment: .trailing) {
                    if viewModel.upcoming.count == 0 {
                        ActivityIndicator(shouldAnimate: true)
                            .onAppear(perform: {
                                viewModel.fetchAnime(endpoint: "upcoming")
                            })
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack {
                                ForEach(0...9, id: \.self) { index in
                                    NavigationLink(
                                        destination: DetailView(id: viewModel.upcoming[index].malId),
                                        label: {
                                            AnimeCell(anime: viewModel.upcoming[index])
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
            .navigationBarTitle("MyAnimeList")
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
