//
//  DetailViewModel.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 09/07/21.
//

import Foundation

class DetailViewModel: ObservableObject {
    var id: Int
    var type: String
    @Published var anime: Anime?
    var isExpandable = false
    @Published var isExpanded = false
    @Published var displayedCount = 0
    private var baseUrl = "https://api.jikan.moe/v3"
    private var request: String = ""
    
    init(id: Int, type: String) {
        self.id = id
        self.type = type
    }
    
    func fetchAnime() {
        request = baseUrl + "/" + type + "/" + String(id)
        guard let url = URL(string: request) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let jsonParser = JSONDecoder()
            jsonParser.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let data = data else { return }
            guard let animu = try? jsonParser.decode(Anime.self, from: data) else { return }
            
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
                if chara.characters.count > 10 {
                    self.isExpandable = true
                    self.displayedCount = 10
                } else {
                    self.displayedCount = chara.characters.count
                }
            }
        }.resume()
    }
}
