//
//  Anime.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 08/07/21.
//

import Foundation

struct Anime: Decodable {
    let malId: Int
    let rank: Int
    let title: String
    let url: String
    let imageUrl: String
    let type: String
    let episodes: Int?
    let startDate: String?
    let members: Int
    let score: Float
}

struct Responses: Decodable {
    let top: [Anime]
    
}

let MOCK_ANIME: Anime = Anime(
    malId: 46471,
    rank: 18,
    title: "Tantei wa Mou, Shindeiru.",
    url: "https://myanimelist.net/anime/46471/Tantei_wa_Mou_Shindeiru",
    imageUrl: "https://cdn.myanimelist.net/images/anime/1843/115815.jpg?s=6d189029213cb8f106a4690f828b16e9",
    type: "TV",
    episodes: 12,
    startDate: "Jul 2021",
    members: 124580,
    score: 7.79
)
