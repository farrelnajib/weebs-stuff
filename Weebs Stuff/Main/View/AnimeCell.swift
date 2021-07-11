//
//  AnimeCell.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 08/07/21.
//

import SwiftUI
import Kingfisher

struct AnimeCell: View {
    let anime: Anime
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage(URL(string: anime.imageUrl))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .cornerRadius(20)
                .padding(0)
            Text(anime.title)
                .lineLimit(2)
            if anime.score > 0 {
                HStack(spacing: 0) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.2f", anime.score))
                }
            }
        }
        .frame(maxWidth: 200)
    }
}

struct AnimeCell_Previews: PreviewProvider {
    static var previews: some View {
        AnimeCell(anime: MOCK_ANIME)
    }
}
