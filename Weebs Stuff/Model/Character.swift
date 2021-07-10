//
//  Character.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 09/07/21.
//

import Foundation

struct Character: Decodable {
    let malId: Int?
    let url: String?
    let imageUrl: String?
    let name: String?
    let role: String?
}

struct CharacterResponse: Decodable {
    let characters: [Character]
}
