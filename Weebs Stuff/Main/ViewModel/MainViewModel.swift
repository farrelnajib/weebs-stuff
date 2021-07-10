//
//  MainViewModel.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 08/07/21.
//

import Foundation

class MainViewModel: ObservableObject {
//    @Published var airings = [Anime]()
//    @Published var upcoming = [Anime]()
    @Published var animeList = [Anime]()
    private var baseUrl = "https://api.jikan.moe/v3/top/anime/1"
    
    func fetchAnime(endpoint: String) {
        guard let url = URL(string: "\(baseUrl)/\(endpoint)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let jsonParser = JSONDecoder()
            jsonParser.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let data = data else { return }
            guard let animu = try? jsonParser.decode(Responses.self, from: data) else { return }
            
            DispatchQueue.main.async {
                self.animeList = animu.top
            }
        }.resume()
    }
}
