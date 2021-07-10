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
    @ObservedObject var viewModel: DetailViewModel
    @State var player = AVPlayer()
    @State private var isExpanded: Bool = false
    @State private var selection = 0
    
    init(id: Int) {
        self.id = id
        self.viewModel = DetailViewModel(id: id)
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
                            .frame(height: 125)
                        
                        KFImage(URL(string: anime.imageUrl ?? ""))
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(20)
                            .frame(width: 250)
                            
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
                                .animation(.easeOut)
                                .transition(.slide)
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
                        
                        VStack(alignment: .leading) {
                            Text("Characters")
                                .font(.headline)
                            if let characters = anime.characters {
                                LazyVStack(alignment: .leading) {
                                    ForEach(0..<characters.count, id: \.self) { index in
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
                                ActivityIndicator(shouldAnimate: true)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ActivityIndicator(shouldAnimate: true)
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
        DetailView(id: 45577)
    }
}
