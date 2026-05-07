//
//  NotesListViewModel.swift
//  WeatherNotes
//
import Combine
import CoreData
import Foundation

// MARK: - NotesListViewModel

@MainActor
final class NotesListViewModel: ObservableObject {

    @Published var notes: [Note] = []

    private let context: NSManagedObjectContext
    private var frc: NSFetchedResultsController<NoteEntity>?
    private let frcDelegate = FRCDelegate()

    init(context: NSManagedObjectContext? = nil) {
        self.context = context ?? PersistenceController.shared.container.viewContext
        setupFRC()
    }

    // MARK: - FRC Setup

    private func setupFRC() {
        let controller = NSFetchedResultsController(
            fetchRequest: NoteEntity.sortedFetchRequest(),
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        frcDelegate.onChange = { [weak self] in
            self?.reloadNotes()
        }
        controller.delegate = frcDelegate

        do {
            try controller.performFetch()
        } catch {
            print("FRC performFetch error: \(error.localizedDescription)")
        }

        frc = controller
        reloadNotes()
    }

    // MARK: - Reload

    private func reloadNotes() {
        notes = (frc?.fetchedObjects ?? []).compactMap(Note.from)
    }

    // MARK: - Delete

    func delete(at offsets: IndexSet) {
        offsets.map { notes[$0] }.forEach(deleteNote)
    }

    private func deleteNote(_ note: Note) {
        let request = NoteEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", note.id as CVarArg)
        request.fetchLimit = 1

        do {
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                PersistenceController.shared.save()
            }
        } catch {
            print("Delete error: \(error.localizedDescription)")
        }
    }
}

// MARK: - FRC Delegate

private final class FRCDelegate: NSObject, NSFetchedResultsControllerDelegate {
    var onChange: (() -> Void)?

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>
    ) {
        onChange?()
    }
}
