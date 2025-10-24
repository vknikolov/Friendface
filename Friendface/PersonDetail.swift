//
//  PersonDetail.swift
//  Friendface
//
//  Created by Veselin Nikolov on 23.10.25.
//

import SwiftData
import SwiftUI

struct PersonDetail: View {
    let person: Person
    let iso = ISO8601DateFormatter()
    @Environment(\.openURL) private var openURL

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // Active Status Section
                HStack {
                    Text("Active:")
                        .font(.headline)
                    Circle()
                        .frame(width: 12, height: 12)
                        .foregroundColor(person.isActive ? .green : .red)
                        .overlay(
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                // Name Section
                Text(person.name)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .padding(.bottom, 5)

                // Overview Section
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(
                        imageName: "person.fill",
                        text: "Age: \(person.age)",
                        color: .blue
                    )
                    InfoRow(
                        imageName: "briefcase.fill",
                        text: "Company: \(person.company)",
                        color: .orange
                    )
                    InfoRow(
                        imageName: "location.fill",
                        text: "Address: \(person.address)",
                        color: .green
                    )

                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.purple)
                        Text(person.email)
                            .font(.subheadline)
                            .foregroundColor(.purple)
                            .underline()
                            .onTapGesture {
                                if let url = URL(string: "mailto:\(person.email)") {
                                    openURL(url)
                                }
                            }
                    }
                }
                .padding(.bottom, 15)

                // About Section
                SectionHeader(title: "About")
                Text(person.about)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.secondary)
                    .lineSpacing(4)

                // Registered Section
                SectionHeader(title: "Registered")
                if let date = iso.date(from: person.registered) {
                 Text(date, format: .dateTime.year().month().day().hour().minute())
                } else {
                 Text(person.registered)
                }
                
                // Tags Section
                SectionHeader(title: "Tags")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(person.tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.system(.caption, design: .monospaced))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.accentColor.opacity(0.15))
                                .foregroundColor(.accentColor)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.bottom, 15)
                    .padding(.horizontal)
                }

                // Friends Section
                SectionHeader(title: "Friends")
                ForEach(person.friends, id: \.id) { friend in
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundColor(.teal)
                        Text(friend.name)
                            .padding(.leading, 5)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Person Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoRow: View {
    let imageName: String
    let text: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(color)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
    }
}

struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.secondary)
            .padding(.vertical, 8)
            .textCase(.uppercase)
    }
}

#Preview {
    let sample = Person(
        id: "1",
        isActive: true,
        name: "Cheyenne Brooks",
        age: 29,
        company: "Acme Co",
        email: "cheyenne@example.com",
        address: "123 Main St, City",
        about:
            "Passionate iOS developer who loves Swift and good coffee. Enjoys hiking and cats.",
        registered: "2023-06-01",
        tags: [
            "swift", "ios", "developer", "coffee", "swift's", "ios's", "developer's",
            "coffee's",
        ],
        friends: [
            Friend(id: "f1", name: "Alex"), Friend(id: "f2", name: "Maya"),
        ]
    )
    PersonDetail(person: sample)
        .preferredColorScheme(.dark)
}
