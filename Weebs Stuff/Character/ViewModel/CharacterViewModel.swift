//
//  CharacterViewModel.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 19/07/21.
//

import Foundation

class CharacterViewModel: ObservableObject {
    private let id: Int
    private let baseUrl = "https://api.jikan.moe/v3/character"
    private let request: String
    @Published var state: ResultState = .idle
    var character: Character?
    
    init(id: Int) {
        self.id = id
        self.request = "\(baseUrl)/\(id)"
    }
    
    func fetchCharacter() {
        self.state = .loading
        
        guard let url = URL(string: request) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            let jsonParser = JSONDecoder()
            jsonParser.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let data = data else { return }
            guard let character = try? jsonParser.decode(Character.self, from: data) else { return }
            
            self.character = character
            DispatchQueue.main.async {
                self.state = .success
            }
        }.resume()
    }
}
