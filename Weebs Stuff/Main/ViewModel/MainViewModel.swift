//
//  MainViewModel.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 08/07/21.
//

import Foundation

class MainViewModel: ObservableObject {
    var animeList = [Anime]()
    @Published var status: ResultState = .loading
    private var baseUrl = "https://api.jikan.moe/v3/top/"
    
    func fetchAnime(type: String, endpoint: String) {
        guard let url = URL(string: "\(baseUrl)\(type)/1/\(endpoint)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let jsonParser = JSONDecoder()
            jsonParser.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let data = data else { return }
            guard let animu = try? jsonParser.decode(Responses.self, from: data) else { return }
            self.animeList = animu.top
            
            DispatchQueue.main.async {
                self.status = .success
            }
        }.resume()
    }
}
