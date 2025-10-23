//
//  ContentView.swift
//  Friendface
//
//  Created by Veselin Nikolov on 23.10.25.
//

import SwiftUI

struct ContentView: View {
    @State private var store = Store()
    @State private var sortOrder: SortOrder = .none

    enum SortOrder {
        case none
        case active
        case inactive
    }

    var body: some View {
        NavigationStack {
            VStack {
                switch store.fetchState {
                case .notStarted:
                    Text("Press the button to load data.")
                case .loading:
                    ProgressView()
                case .success:
                    List {
                        ForEach(sortedPersons(), id: \.id) { person in
                            NavigationLink {
                                PersonDetail(person: person)
                            } label: {
                                HStack {
                                    Text(person.name)
                                        .font(.headline)
                                        .padding(.vertical, 5)

                                    Spacer()

                                    Text("Active:")
                                        .font(.headline)
                                    Circle()
                                        .frame(width: 12, height: 12)
                                        .foregroundColor(
                                            person.isActive ? .green : .red
                                        )
                                        .overlay(
                                            Circle()
                                                .stroke(
                                                    Color.gray.opacity(0.3),
                                                    lineWidth: 1
                                                )
                                        )
                                }
                            }
                        }
                    }
                    .navigationTitle("Friendface")
                    .listStyle(.plain)
                case .failure(let error):
                    Text("Failed to load data: \(error.localizedDescription)")
                        .foregroundColor(.red)
                }
            }
            .toolbar {

                Menu("Sort") {
                    Button("None") { sortOrder = .none }
                    Button("Active") { sortOrder = .active }
                    Button("Inactive") { sortOrder = .inactive }
                }

                if store.persons.isEmpty {
                    Button("Fetch", action: store.fetchPersons)
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func sortedPersons() -> [Person] {
        switch sortOrder {
        case .none:
            return store.persons
        case .active:
            return store.persons.sorted { $0.isActive && !$1.isActive }
        case .inactive:
            return store.persons.sorted { !$0.isActive && $1.isActive }
        }
    }
}

#Preview {
    ContentView()
}
