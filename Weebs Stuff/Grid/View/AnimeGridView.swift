//
//  AnimeGridView.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 09/07/21.
//

import SwiftUI

struct AnimeGridView: View {
    
    private let gridItems = [
        GridItem(.flexible(), alignment: .top),
        GridItem(.flexible(), alignment: .top)
    ]
    @ObservedObject var viewModel: MainViewModel
    let title: String
    let type: String
    
    var body: some View {
        switch viewModel.status {
        case .loading:
            ProgressView()
                .navigationBarTitle(title)
        case .success:
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 20) {
                    ForEach(0..<viewModel.animeList.count, id: \.self) { index in
                        NavigationLink(
                            destination: DetailView(id: viewModel.animeList[index].malId, type: type),
                            label: {
                                AnimeCell(anime: viewModel.animeList[index])
                                    .padding(5)
                            }
                        )
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
            .navigationBarTitle(title)
        case .idle:
            ProgressView()
                .navigationBarTitle(title)
        case .failed(err: let err):
            Text("\(err.localizedDescription)")
        }
    }
}

struct AnimeGridView_Previews: PreviewProvider {
    static var previews: some View {
        AnimeGridView(viewModel: MainViewModel(), title: "On-going", type: "anime")
    }
}
