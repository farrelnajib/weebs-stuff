//
//  AnimeDetail.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 09/07/21.
//

import Foundation

struct AnimeDetail: Decodable {
    let malId: Int?
    let url: String?
    let imageUrl: String?
    let trailerUrl: String?
    let title: String?
    let titleEnglish: String?
    let titleJapanese: String?
    let episodes: Int?
    let duration: String?
    let volumes: Int?
    let chapters: Int?
    let status: String?
    let score: Float?
    let synopsis: String?
    var characters: [Character]?
    let genres: [Genre]?
}

struct Genre: Decodable {
    let malId: Int
    let name: String?
}
