//
//  AddNoteViewModel.swift
//  WeatherNotes
//
import Combine
import CoreData
import CoreLocation
import Foundation

// MARK: - AddNoteState

enum AddNoteState: Equatable {
    case idle
    case loading
    case success
    case failure(String)
}

// MARK: - AddNoteViewModel

@MainActor
final class AddNoteViewModel: ObservableObject {

    @Published var noteText: String = ""
    @Published var state: AddNoteState = .idle

    var isSaveDisabled: Bool {
        noteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        || state == .loading
    }

    private let weatherService: WeatherServiceProtocol
    private let context: NSManagedObjectContext
    private let locationManager: LocationManager

    init(
        weatherService: WeatherServiceProtocol? = nil,
        context: NSManagedObjectContext? = nil,
        locationManager: LocationManager? = nil
    ) {
        self.weatherService  = weatherService  ?? WeatherService()
        self.context         = context         ?? PersistenceController.shared.container.viewContext
        self.locationManager = locationManager ?? LocationManager.shared
        // Запрашиваем разрешение сразу — диалог появится один раз
        self.locationManager.requestPermissionAndLocation()
    }

    // MARK: - Save

    func save() async {
        let trimmed = noteText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        state = .loading

        do {
            let snapshot: WeatherSnapshot
            if let location = locationManager.location {
                snapshot = try await weatherService.fetchWeather(
                    lat: location.coordinate.latitude,
                    lon: location.coordinate.longitude
                )
            } else {
                snapshot = try await weatherService.fetchWeather(for: "Kyiv")
            }

            let entity                = NoteEntity(context: context)
            entity.id                 = UUID()
            entity.text               = trimmed
            entity.createdAt          = Date()
            entity.temperature        = snapshot.temperature
            entity.feelsLike          = snapshot.feelsLike
            entity.humidity           = Int32(snapshot.humidity)
            entity.weatherDescription = snapshot.description
            entity.weatherIcon        = snapshot.icon
            entity.locationName       = snapshot.locationName

            PersistenceController.shared.save()

            noteText = ""
            state = .success

        } catch let error as WeatherError {
            state = .failure(error.errorDescription ?? "Unknown error")
        } catch {
            state = .failure(error.localizedDescription)
        }
    }

    // MARK: - Reset

    func resetErrorIfNeeded() {
        if case .failure = state { state = .idle }
    }
}

