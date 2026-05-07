//
//  NoteDetailViewModel.swift
//  WeatherNotes
//
import Combine
import Foundation

@MainActor
final class NoteDetailViewModel: ObservableObject {

    @Published var note: Note

    init(note: Note) {
        self.note = note
    }

    var title: String        { note.text }
    var dateOnly: String     { note.formattedDateOnly }
    var timeOnly: String     { note.formattedTime }
    var temperature: String  { note.weather.temperatureFormatted }
    var weatherDescription: String { note.weather.description }
    var location: String     { note.weather.locationName }
    var iconCode: String     { note.weather.icon }
}
