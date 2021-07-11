//
//  DetailView.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 08/07/21.
//

import SwiftUI
import AVKit
import Kingfisher

struct DetailView: View {
    let id: Int
    let type: String
    @ObservedObject var viewModel: DetailViewModel
    @State var player = AVPlayer()
    @State private var isExpanded: Bool = false
    @State private var selection = 0
    
    init(id: Int, type: String) {
        self.id = id
        self.type = type
        self.viewModel = DetailViewModel(id: id, type: type)
    }
    
    var body: some View {
        if let anime = viewModel.anime {
            ScrollView {
                ZStack {
                    VStack {
                        if let trailer = anime.trailerUrl {
                            WebView(request: URLRequest(url: URL(string: trailer)!))
                                .frame(maxWidth: .infinity)
                                .aspectRatio(16/9, contentMode: .fit)
                                .cornerRadius(25, corners: [.bottomLeft, .bottomRight])
                        }
                        Spacer()
                    }
                    
                    VStack {
                        Spacer()
                            .frame(height: type == "anime" ? 150 : 50)
                        
                        KFImage(URL(string: anime.imageUrl ?? ""))
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .frame(width: 200)
                            
                        Text(anime.titleJapanese ?? "")
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        
                        Link(anime.title ?? "", destination: URL(string: anime.url ?? "") ?? URL(string: "https://google.com")!)
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .buttonStyle(PlainButtonStyle())
                            .padding(.horizontal)
                            .lineLimit(2)
                        
                        Text(anime.titleEnglish ?? "")
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                            .frame(height: 20)
                        
                        HStack {
                            Spacer()
                            VStack {
                                HStack(spacing: 0) {
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                    Text(String(format: "%.2f", anime.score ?? 0))
                                        .bold()
                                }
                                Text("Rate")
                            }
                            
                            Spacer()
                            
                            if type == "anime" {
                                VStack {
                                    Text(String(anime.episodes ?? 0))
                                        .bold()
                                    Text("Eps")
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Text(anime.duration ?? "-")
                                        .bold()
                                    Text("Duration")
                                }
                            } else {
                                VStack {
                                    Text(String(anime.volumes ?? 0))
                                        .bold()
                                    Text("Volumes")
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Text(String(anime.chapters ?? 0))
                                        .bold()
                                    Text("Chapters")
                                }
                            }
                            Spacer()
                        }
                        
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Synopsis")
                                    .font(.headline)
                                Spacer()
                            }
                            
                            Spacer()
                                .frame(height: 5)
                            
                            Text("\(anime.synopsis ?? "No Synopsis")")
                                .lineLimit(isExpanded ? nil : 2)
                                .fixedSize(horizontal: false, vertical: true)
                                .overlay(
                                    GeometryReader { proxy in
                                        Button(action: {
                                            isExpanded.toggle()
                                        }) {
                                            Text(isExpanded ? "Less" : "More")
                                                .font(.caption).bold()
                                                .padding(.leading, 8.0)
                                                .padding(.top, 4.0)
                                                .background(Color.white)
                                        }
                                        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomTrailing)
                                    }
                                )
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        
                        VStack() {
                            Text("Characters")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                            if let characters = anime.characters {
                                LazyVStack(alignment: .leading) {
                                    ForEach(0..<(characters.count > 10 ? 10 : characters.count), id: \.self) { index in
                                        HStack {
                                            KFImage(URL(string: characters[index].imageUrl ?? ""))
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75)
                                                .cornerRadius(20)
                                            VStack(alignment: .leading) {
                                                Text(characters[index].name ?? "-")
                                                Text(characters[index].role ?? "")
                                                    .font(.caption)
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            } else {
                                ProgressView()
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ProgressView()
                .onAppear(perform: {
                    viewModel.fetchAnime()
                })
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(id: 11, type: "manga")
    }
}
