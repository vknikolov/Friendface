//
//  Person.swift
//  Friendface
//
//  Created by Veselin Nikolov on 23.10.25.
//

import SwiftUI

struct Friend: Codable, Identifiable {
    var id: String
    let name: String
}

struct Person: Codable, Identifiable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: String
    let tags: [String]
    let friends: [Friend]
}

