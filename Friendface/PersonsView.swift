//
//  PersonsView.swift
//  Friendface
//
//  Created by Veselin Nikolov on 24.10.25.
//

import SwiftData
import SwiftUI

struct PersonsView: View {
    @Query private var persons: [Person]
     
     init(sortOrder: SortDescriptor<Person>) {
         _persons = Query(sort: [sortOrder])
     }
    
    var body: some View {
        List {
            ForEach(persons) { person in
                NavigationLink {
                    PersonDetail(person: person)
                } label: {
                    HStack {
                        Text(person.name)
                            .font(.headline)
                            .padding(.vertical, 5)

                        Spacer()

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
        .listStyle(.plain)    }
}

//#Preview {
//    PersonsView(sortOrder: [SortDescriptor(\Person.name)])
//        .modelContainer(for: Person.self)
//}
