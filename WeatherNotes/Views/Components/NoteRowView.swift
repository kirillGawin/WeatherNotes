//
//  NoteRowView.swift
//  WeatherNotes
//
import SwiftUI

// MARK: - NoteRowView

struct NoteRowView: View {

    let note: Note

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: WeatherIcon.symbol(for: note.weather.icon))
                .font(.system(size: 26))
                .foregroundStyle(WeatherIcon.color(for: note.weather.icon))
                .frame(width: 48, height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color(.secondarySystemBackground))
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(note.text)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text(note.formattedDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Text(note.weather.temperatureFormatted)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Preview

#Preview {
    List {
        NoteRowView(note: .sunny)
        NoteRowView(note: .rainy)
        NoteRowView(note: .snowy)
    }
}

private extension Note {
    static let sunny = Note(
        id: UUID(), text: "Morning run in the park", createdAt: Date(),
        weather: WeatherSnapshot(temperature: 21, feelsLike: 20, humidity: 55,
                                 description: "Clear sky", icon: "01d", locationName: "Kyiv")
    )
    static let rainy = Note(
        id: UUID(), text: "Commute to work", createdAt: Date().addingTimeInterval(-3600),
        weather: WeatherSnapshot(temperature: 11, feelsLike: 9, humidity: 88,
                                 description: "Rain", icon: "10d", locationName: "Kyiv")
    )
    static let snowy = Note(
        id: UUID(), text: "Walk in the snow", createdAt: Date().addingTimeInterval(-7200),
        weather: WeatherSnapshot(temperature: -3, feelsLike: -6, humidity: 90,
                                 description: "Snow", icon: "13d", locationName: "Kyiv")
    )
}
