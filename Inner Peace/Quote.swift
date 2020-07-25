//
//  Quote.swift
//  Inner Peace
//
//  Created by Oliver Lippold on 18/07/2020.
//  Copyright © 2020 Oliver Lippold. All rights reserved.
//

import Foundation

struct Quote: Codable {
    var text: String
    var author: String
    var shareMesswage: String {
        return "\"\(text)\" - \(author)"
    }
}
