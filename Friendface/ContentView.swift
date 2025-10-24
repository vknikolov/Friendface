import SwiftData
import SwiftUI

enum FetchState {
    case notStarted
    case loading
    case success
    case failure(Error)
}

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var persons: [Person]

    @State private var sortOrder: SortDescriptor<Person> = SortDescriptor(
        \Person.name
    )

    @State private var fetchState: FetchState = .notStarted

    var body: some View {
        NavigationStack {
            VStack {
                switch fetchState {
                case .success:
                    PersonsView(sortOrder: sortOrder)
                case .loading:
                    ProgressView()
                case .failure(let error):
                    Text("Failed to load data: \(error.localizedDescription)")
                        .foregroundColor(.red)
                default:
                    Text("No Persons to show.")
                    Button("Fetch Data") {
                        fetchData()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .toolbar {
                ToolbarItem {
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sortOrder) {
                            Text("Sort by name")
                                .tag(SortDescriptor(\Person.name))
                            Text("Sort by age")
                                .tag(SortDescriptor(\Person.age))
                        }

                    }
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            fetchData()
        }
    }

    func fetchData() {
        fetchState = .loading
        Task {
            await performFetch()
        }
    }

    private func performFetch() async {
        let url = URL(
            string: "https://www.hackingwithswift.com/samples/friendface.json"
        )!
        let session = URLSession.shared

        do {
            let (data, _) = try await session.data(from: url)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedPersons = try decoder.decode([Person].self, from: data)

            try deleteAllPersons(modelContext: modelContext)

            for person in decodedPersons {
                modelContext.insert(person)
            }

            try modelContext.save()
            fetchState = .success
        } catch {
            print("Failed to fetch persons: \(error.localizedDescription)")
            fetchState = .failure(error)
        }
    }

    private func deleteAllPersons(modelContext: ModelContext) throws {
        try modelContext.delete(model: Person.self)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Person.self)
}
