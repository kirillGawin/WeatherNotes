//
//  Note.swift
//  WeatherNotes
//
import Foundation

// MARK: - Note

struct Note: Identifiable, Equatable {
    let id:        UUID
    let text:      String
    let createdAt: Date
    let weather:   WeatherSnapshot

    // "May 7, 2026, 9:24 PM"
    var formattedDate: String {
        Note.dateTimeFormatter.string(from: createdAt)
    }

    // "9:24 PM"
    var formattedTime: String {
        Note.timeFormatter.string(from: createdAt)
    }

    // "May 7, 2026"
    var formattedDateOnly: String {
        Note.dateFormatter.string(from: createdAt)
    }

    // MARK: - Static formatters

    private static let dateTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .short
        f.locale = Locale(identifier: "en_US")
        return f
    }()

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .none
        f.timeStyle = .short
        f.locale = Locale(identifier: "en_US")
        return f
    }()

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMMM d, yyyy"
        f.locale = Locale(identifier: "en_US")
        return f
    }()

    static func from(_ entity: NoteEntity) -> Note? {
        guard
            let id        = entity.id,
            let text      = entity.text,
            let createdAt = entity.createdAt
        else { return nil }

        return Note(
            id:        id,
            text:      text,
            createdAt: createdAt,
            weather:   WeatherSnapshot.from(entity)
        )
    }
}

// MARK: - Equatable для WeatherSnapshot

extension WeatherSnapshot: Equatable {
    static func == (lhs: WeatherSnapshot, rhs: WeatherSnapshot) -> Bool {
        lhs.temperature  == rhs.temperature  &&
        lhs.feelsLike    == rhs.feelsLike    &&
        lhs.humidity     == rhs.humidity     &&
        lhs.description  == rhs.description  &&
        lhs.icon         == rhs.icon         &&
        lhs.locationName == rhs.locationName
    }
}
