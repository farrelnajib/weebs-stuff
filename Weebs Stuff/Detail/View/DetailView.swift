//
//  DetailView.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 08/07/21.
//

import SwiftUI
import AVKit
import Kingfisher
import WrappingHStack

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
                KFImage(URL(string: anime.imageUrl ))
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(8)
                    .frame(width: 200)
                    .padding(.vertical)
                    
                VStack {
                    Text(anime.titleJapanese ?? "-")
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                    
                    Link(anime.title , destination: (URL(string: anime.url ) ?? URL(string: "https://google.com"))!)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .buttonStyle(PlainButtonStyle())
                        .padding(.horizontal)
                        .lineLimit(2)
                    
                    Text(anime.titleEnglish ?? "-")
                        .padding(.horizontal)
                        .multilineTextAlignment(.center)
                }
                
                if let genres = anime.genres {
                    WrappingHStack(genres, id: \.self, alignment: .center) { genre in
                        Text(genre.name ?? "")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Capsule().stroke())
                            .padding(.vertical, 5)
                    }
                    .padding()
                }
                
                HStack {
                    Spacer()
                    VStack {
                        HStack(spacing: 0) {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color(UIColor.systemYellow))
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
                
                
                HStack {
                    Spacer()
                    
                    VStack {
                        Text(anime.status ?? "Unknown Status")
                            .font(.callout)
                            .bold()
                        Text("Status")
                    }
                    
                    Spacer()
                    
                    VStack {
                        Text(anime.premiered ?? "-")
                            .font(.callout)
                            .bold()
                        Text("Premiered")
                    }
                    
                    Spacer()
                }
                .padding()
                
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Synopsis")
                            .font(.headline)
                        Spacer()
                    }
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text("\(anime.synopsis ?? "No Synopsis")")
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
                .padding(.bottom, 5)
                
                VStack {
                    if type == "anime" {
                        HStack {
                            Text("Trailer")
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                            .frame(height: 5)
                        
                        if let trailer = anime.trailerUrl {
                            WebView(request: URLRequest(url: URL(string: trailer)!))
                                .frame(maxWidth: .infinity)
                                .aspectRatio(16/9, contentMode: .fit)
                                .cornerRadius(8)
                        } else {
                            Text("No trailer for this \(type)")
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack {
                    Text("Characters")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    if let characters = anime.characters {
                        LazyVStack(alignment: .leading) {
                            ForEach(0..<viewModel.displayedCount, id: \.self) { index in
                                NavigationLink(
                                    destination: CharacterView(id: characters[index].malId, detailVM: viewModel),
                                    label: {
                                        HStack {
                                            KFImage(URL(string: characters[index].imageUrl ?? ""))
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 75)
                                                .cornerRadius(8)
                                            VStack(alignment: .leading) {
                                                Text(characters[index].name ?? "-")
                                                Text(characters[index].role ?? "")
                                                    .font(.caption)
                                            }
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            Spacer()
                                        }
                                    }
                                )
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    } else {
                        ProgressView()
                    }
                    
                    if viewModel.isExpandable {
                        Button(action: {
                            if viewModel.isExpanded {
                                viewModel.displayedCount = 10
                                viewModel.isExpanded = false
                            } else {
                                viewModel.displayedCount = anime.characters!.count
                                viewModel.isExpanded = true
                            }
                        }, label: {
                            if viewModel.isExpanded {
                                Text("Show less")
                            } else {
                                Text("Show more")
                            }
                        })
                    }
                }
                .padding()
            }
            .navigationBarTitle("Anime")
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ProgressView()
                .onAppear(perform: {
                    viewModel.fetchAnime()
                })
                .navigationBarTitle("Anime")
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
        DetailView(id: 41487, type: "anime")
    }
}
