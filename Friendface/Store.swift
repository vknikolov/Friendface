//
//  Store.swift
//  Friendface
//
//  Created by Veselin Nikolov on 23.10.25.
//

import SwiftUI

enum FetchState {
    case notStarted
    case loading
    case success
    case failure(Error)
}

@Observable
final class Store {
    var persons: [Person] = []
    var fetchState: FetchState = .notStarted
    private var task: Task<Void, Never>?

    init() {
        fetchPersons()
    }

    deinit {
        task?.cancel()
    }

    func fetchPersons() {
        fetchState = .loading

        task = Task {
            await performFetch()
        }
    }

    @MainActor
    private func performFetch() async {
        let url = URL(
            string: "https://www.hackingwithswift.com/samples/friendface.json"
        )!
        let session = URLSession.shared

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode)
            else {
                throw URLError(.badServerResponse)
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedPersons = try decoder.decode([Person].self, from: data)

            persons = decodedPersons
            fetchState = .success

        } catch {
            print("Failed to fetch persons: \(error.localizedDescription)")
            fetchState = .failure(error)
        }
    }
}
