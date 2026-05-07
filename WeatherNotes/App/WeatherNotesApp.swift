//
//  WeatherNotesApp.swift
//  WeatherNotes
//
import CoreData
import SwiftUI

// MARK: - WeatherNotesApp
@main
struct WeatherNotesApp: App {

    private let persistence = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NotesListView()
                .environment(
                    \.managedObjectContext,
                     persistence.container.viewContext
                )
        }
    }
}
