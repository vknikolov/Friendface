//
//  FriendfaceApp.swift
//  Friendface
//
//  Created by Veselin Nikolov on 23.10.25.
//

import SwiftData
import SwiftUI

@main
struct FriendfaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
    }
}
