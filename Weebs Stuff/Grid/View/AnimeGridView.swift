//
//  AnimeGridView.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 09/07/21.
//

import SwiftUI

struct AnimeGridView: View {
    
    private let gridItems = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let animeList: [Anime]
    let title: String
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: 20) {
                ForEach(0..<animeList.count, id: \.self) { index in
                    NavigationLink(
                        destination: DetailView(id: animeList[index].malId),
                        label: {
                            AnimeCell(anime: animeList[index])
                                .padding(5)
                        }
                    )
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
        .navigationBarTitle(title)
    }
}

struct AnimeGridView_Previews: PreviewProvider {
    static var previews: some View {
        AnimeGridView(animeList: [MOCK_ANIME], title: "On-going")
    }
}
