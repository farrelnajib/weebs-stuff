//
//  CharacterView.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 19/07/21.
//

import SwiftUI
import Kingfisher

struct CharacterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let id: Int
    @State var isExpanded = false
    @ObservedObject var viewModel: CharacterViewModel
    @ObservedObject var detailViewModel: DetailViewModel
    
    init(id: Int, detailVM: DetailViewModel) {
        self.id = id
        viewModel = CharacterViewModel(id: id)
        detailViewModel = detailVM
    }
    
    var body: some View {
        switch viewModel.state {
        case .idle:
            ProgressView()
                .onAppear(perform: {
                    viewModel.state = .loading
                    viewModel.fetchCharacter()
                })
                .navigationBarTitle(Text("Character"))
        case .loading:
            ProgressView()
                .navigationBarTitle(Text("Character"))
        case .failed(let err):
            Text("\(err.localizedDescription)")
        case .success:
            ScrollView {
                if let character = viewModel.character {
                    VStack {
                        Spacer()
                            .frame(height: 50)
                        if let image = character.imageUrl {
                            KFImage(URL(string: image))
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                                .frame(width: 200)
                                
                        }
                    }
                    
                    Text(character.nameKanji ?? "")
                        .padding([.horizontal, .top])
                        .multilineTextAlignment(.center)
                    
                    Text(character.name ?? "")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                        .lineLimit(2)
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Back")
                    })
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("About")
                                .font(.headline)
                            Spacer()
                        }
                        Spacer()
                            .frame(height: 5)
                        Text(character.about ?? "")
                            .lineLimit(isExpanded ? nil : 3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.horizontal, .top])
                    
                    Button(action: {
                        isExpanded.toggle()
                    }, label: {
                        Text("Show More")
                    })
                    
                    VStack(alignment: .leading) {
                        Text("Voice Actors")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        if let voiceActors = character.voiceActors {
                            LazyVStack {
                                ForEach(0..<voiceActors.count, id: \.self) {idx in
                                    HStack {
                                        if let image = voiceActors[idx].imageUrl {
                                            KFImage(URL(string: image))
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75)
                                                .cornerRadius(8)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(voiceActors[idx].name ?? "")
                                            Text(voiceActors[idx].language ?? "")
                                                .font(.caption)
                                                .italic()
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Animeography")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        if let anime = character.animeography {
                            LazyVStack {
                                ForEach(0..<anime.count, id: \.self) {idx in
                                    Button(action: {
                                        self.presentationMode.wrappedValue.dismiss()
                                        
                                        detailViewModel.id = anime[idx].malId
                                        detailViewModel.type = "anime"
                                        detailViewModel.anime = nil
                                    }, label: {
                                        HStack {
                                            if let image = anime[idx].imageUrl {
                                                KFImage(URL(string: image))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 75)
                                                    .cornerRadius(8)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text(anime[idx].name ?? "")
                                                Text(anime[idx].role ?? "")
                                                    .font(.caption)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Mangaography")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .multilineTextAlignment(.leading)
                        if let manga = character.mangaography {
                            LazyVStack {
                                ForEach(0..<manga.count, id: \.self) {idx in
                                    Button(action: {
                                        self.presentationMode.wrappedValue.dismiss()
                                        
                                        detailViewModel.id = manga[idx].malId
                                        detailViewModel.type = "anime"
                                        detailViewModel.anime = nil
                                    }, label: {
                                        HStack {
                                            if let image = manga[idx].imageUrl {
                                                KFImage(URL(string: image))
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 75)
                                                    .cornerRadius(8)
                                            }
                                            
                                            VStack(alignment: .leading) {
                                                Text(manga[idx].name ?? "")
                                                Text(manga[idx].role ?? "")
                                                    .font(.caption)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    })
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationBarTitle(Text("Character"))
        }
    }
}

struct CharacterView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterView(id: 40, detailVM: DetailViewModel(id: 21, type: "anime"))
    }
}
