//
//  SearchView.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 12/07/21.
//

import SwiftUI
import Kingfisher

struct SearchView: View {
    let type: String
    let query: String
    @EnvironmentObject var viewModel: SearchViewModel
    
    var body: some View {
        if let anime = viewModel.animeList {
            VStack(alignment: .leading) {
                ForEach(0..<anime.count, id: \.self) { idx in
                    NavigationLink(
                        destination: DetailView(id: anime[idx].malId, type: type),
                        label: {
                            SearchCell(anime: anime[idx])
                        }
                    )
                    .buttonStyle(PlainButtonStyle())
                }
            }
        } else {
            if viewModel.searchQuery != "" {
                ProgressView()
            }
        }
    }
}

struct SearchCell: View {
    let anime: Anime
    var body: some View {
        HStack {
            KFImage(URL(string: anime.imageUrl)!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 75)
                .cornerRadius(20)
            VStack(alignment: .leading) {
                Text(anime.title)
                HStack(spacing: 5) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.2f", anime.score))
                    
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(type: "anime", query: "naruto")
    }
}
