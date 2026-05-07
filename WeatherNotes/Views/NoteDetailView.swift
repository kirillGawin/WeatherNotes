//
//  NoteDetailView.swift
//  WeatherNotes
//
import SwiftUI

struct NoteDetailView: View {

    @StateObject private var viewModel: NoteDetailViewModel

    init(note: Note) {
        _viewModel = StateObject(wrappedValue: NoteDetailViewModel(note: note))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                noteTextCard
                weatherCard
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Weather Card

    private var weatherCard: some View {
        VStack(spacing: 12) {

            HStack(alignment: .center) {
                Label(viewModel.location, systemImage: "location.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                HStack(spacing: 6) {
                    Image(systemName: WeatherIcon.symbol(for: viewModel.iconCode))
                        .font(.system(size: 18))
                        .foregroundStyle(WeatherIcon.color(for: viewModel.iconCode))

                    Text(viewModel.weatherDescription)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }

                Text(viewModel.temperature)
                    .font(.system(size: 36, weight: .thin, design: .rounded))
            }

            Divider()

            HStack {
                Label(viewModel.dateOnly, systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Label(viewModel.timeOnly, systemImage: "clock")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(cardBackground)
    }

    // MARK: - Note Text Card

    private var noteTextCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Note", systemImage: "note.text")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            Text(viewModel.title)
                .font(.body)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(cardBackground)
    }

    // MARK: - Helpers

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(Color(.secondarySystemGroupedBackground))
    }
}

#Preview {
    NavigationStack {
        NoteDetailView(
            note: Note(
                id: UUID(),
                text: "Morning run in the park",
                createdAt: Date(),
                weather: WeatherSnapshot(
                    temperature: 14, feelsLike: 12, humidity: 78,
                    description: "Light rain", icon: "10d",
                    locationName: "Kyiv"
                )
            )
        )
    }
}
