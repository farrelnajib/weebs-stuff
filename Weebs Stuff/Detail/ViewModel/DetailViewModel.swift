//
//  DetailViewModel.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 09/07/21.
//

import Foundation

class DetailViewModel: ObservableObject {
    let id: Int
    @Published var anime: AnimeDetail?
    private var baseUrl = "https://api.jikan.moe/v3/anime/"
    private var request: String
    
    init(id: Int) {
        self.id = id
        self.request = baseUrl + String(id)
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
        guard let url = URL(string: "\(request)/characters_staff") else { return }
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
