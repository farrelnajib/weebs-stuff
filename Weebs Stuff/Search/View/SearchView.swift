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
        switch viewModel.status {
        case .loading:
            ProgressView()
            LazyVStack(alignment: .leading) {
                ForEach(0..<viewModel.animeList.count, id: \.self) { idx in
                    NavigationLink(
                        destination: DetailView(id: viewModel.animeList[idx].malId, type: type),
                        label: {
                            SearchCell(anime: viewModel.animeList[idx])
                        }
                    )
                    .buttonStyle(PlainButtonStyle())
                }
            }
        case .success:
            LazyVStack(alignment: .leading) {
                ForEach(0..<viewModel.animeList.count, id: \.self) { idx in
                    NavigationLink(
                        destination: DetailView(id: viewModel.animeList[idx].malId, type: type),
                        label: {
                            SearchCell(anime: viewModel.animeList[idx])
                        }
                    )
                    .buttonStyle(PlainButtonStyle())
                }
            }
        case .failed(let err):
            Text("\(err.localizedDescription)")
        case .idle:
            Text("Type to search...")
                .padding()
                .font(.callout)
                .foregroundColor(.gray)
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
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(anime.title)
                
                if let score = anime.score,
                   score > 0{
                    HStack(spacing: 5) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.2f", score))
                    }
                }
                
                if let airing = anime.airing {
                    if airing {
                        Text("Currently Airing")
                            .font(.caption)
                            .italic()
                    } else if anime.endDate != nil {
                        Text("Finished Airing")
                            .font(.caption)
                            .italic()
                    } else {
                        Text("Not yet Aired")
                            .font(.caption)
                            .italic()
                    }
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

//struct SearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchView(type: "anime", query: "naruto")
//            .environmentObject(SearchViewModel(type: "anime"))
//    }
//}

struct SearchCell_Previews: PreviewProvider {
    static var previews: some View {
        SearchCell(anime: MOCK_ANIME)
    }
}
