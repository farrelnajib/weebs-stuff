//
//  Anime.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 08/07/21.
//

import Foundation

struct Anime: Decodable {
    let malId: Int
    let title: String
    let url: String
    let imageUrl: String
    let score: Float?
    
    let trailerUrl: String?
    let titleEnglish: String?
    let titleJapanese: String?
    let episodes: Int?
    let duration: String?
    let volumes: Int?
    let chapters: Int?
    let status: String?
    let premiered: String?
    let synopsis: String?
    var characters: [Character]?
    let genres: [Genre]?
    let airing: Bool?
    let endDate: String?
}

struct Responses: Decodable {
    let top: [Anime]
    
}

struct SearchResponse: Decodable {
    let results: [Anime]
}

struct Genre: Decodable {
    let malId: Int
    let name: String?
}

let MOCK_ANIME: Anime = Anime(
    malId: 46471,
    title: "Tantei wa Mou, Shindeiru.",
    url: "https://myanimelist.net/anime/46471/Tantei_wa_Mou_Shindeiru",
    imageUrl: "https://cdn.myanimelist.net/images/anime/1843/115815.jpg?s=6d189029213cb8f106a4690f828b16e9",
    score: 7.79,
    trailerUrl: nil,
    titleEnglish: nil,
    titleJapanese: nil,
    episodes: nil,
    duration: nil,
    volumes: nil,
    chapters: nil,
    status: "Currently Airing",
    premiered: nil,
    synopsis: nil,
    characters: nil,
    genres: nil,
    airing: true,
    endDate: nil
)
