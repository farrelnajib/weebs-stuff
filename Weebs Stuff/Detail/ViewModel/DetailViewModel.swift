//
//  DetailViewModel.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 09/07/21.
//

import Foundation

class DetailViewModel: ObservableObject {
    let id: Int
    let type: String
    @Published var anime: AnimeDetail?
    private var baseUrl = "https://api.jikan.moe/v3"
    private var request: String
    
    init(id: Int, type: String) {
        self.id = id
        self.type = type
        self.request = baseUrl + "/" + type + "/" + String(id)
    }
    
    func fetchAnime() {
        guard let url = URL(string: request) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let jsonParser = JSONDecoder()
            jsonParser.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let data = data else { return }
            guard let animu = try? jsonParser.decode(AnimeDetail.self, from: data) else { return }
            
            DispatchQueue.main.async {
                self.anime = animu
                self.fetchCharacters()
            }
        }.resume()
    }
    
    func fetchCharacters() {
        let endpoint = self.type == "anime" ? "characters_staff" : "characters"
        guard let url = URL(string: "\(request)/\(endpoint)") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let jsonParser = JSONDecoder()
            jsonParser.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let data = data else { return }
            guard let chara = try? jsonParser.decode(CharacterResponse.self, from: data) else { return }
            
            DispatchQueue.main.async {
                self.anime?.characters = chara.characters
            }
        }.resume()
    }
}
