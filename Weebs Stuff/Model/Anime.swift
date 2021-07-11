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
    let score: Float
}

struct Responses: Decodable {
    let top: [Anime]
    
}

let MOCK_ANIME: Anime = Anime(
    malId: 46471,
    title: "Tantei wa Mou, Shindeiru.",
    url: "https://myanimelist.net/anime/46471/Tantei_wa_Mou_Shindeiru",
    imageUrl: "https://cdn.myanimelist.net/images/anime/1843/115815.jpg?s=6d189029213cb8f106a4690f828b16e9",
    score: 7.79
)
