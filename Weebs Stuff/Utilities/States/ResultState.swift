//
//  ResultState.swift
//  Weebs Stuff
//
//  Created by Farrel Anshary on 16/07/21.
//

import Foundation

enum ResultState {
    case idle
    case loading
    case success
    case failed(err: Error)
}
