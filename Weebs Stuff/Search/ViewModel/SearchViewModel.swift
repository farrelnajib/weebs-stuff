//
//  SearchViewModel.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 12/07/21.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    var searchCancellable: AnyCancellable? = nil
    @Published var searchQuery = ""
    @Published var status: ResultState = .idle
    var animeList = [Anime]()
    private var baseUrl = "https://api.jikan.moe/v3/search"
    
    init(type: String) {
        searchCancellable = $searchQuery
            .removeDuplicates()
            .debounce(for: 0.4, scheduler: RunLoop.main)
            .sink(receiveValue: { str in
                self.status = .loading
                if str != "" {
                    self.searchAnime(type: type, query: self.searchQuery)
                } else {
                    self.status = .idle
                }
            })
    }
    
    func searchAnime(type: String, query: String) {
        let request = "\(baseUrl)/\(type)"
        
        let queryItems = [URLQueryItem(name: "q", value: query)]
        guard var url = URLComponents(string: request) else { return }
        url.queryItems = queryItems
        
        guard let result = url.url else { return }
        
        URLSession.shared.dataTask(with: result) { data, response, error in
            let jsonParser = JSONDecoder()
            jsonParser.keyDecodingStrategy = .convertFromSnakeCase
            
            guard let data = data else { return }
            guard let animu = try? jsonParser.decode(SearchResponse.self, from: data) else { return }

            self.animeList = animu.results
            
            DispatchQueue.main.async {
                self.status = .success
            }
        }.resume()
    }
}
