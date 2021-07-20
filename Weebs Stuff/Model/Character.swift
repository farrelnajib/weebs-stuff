//
//  Character.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 09/07/21.
//

import Foundation

struct Character: Decodable {
    let malId: Int
    let url: String?
    let imageUrl: String?
    let name: String?
    let role: String?
    let about: String?
    let nameKanji: String?
    let animeography: [Animangaography]?
    let mangaography: [Animangaography]?
    let voiceActors: [VoiceActor]?
}

struct Animangaography: Decodable {
    let malId: Int
    let name: String?
    let url: String?
    let imageUrl: String?
    let role: String?
}

struct VoiceActor: Decodable {
    let malId: Int
    let name: String?
    let url: String?
    let imageUrl: String?
    let language: String?
}

struct CharacterResponse: Decodable {
    let characters: [Character]
}
