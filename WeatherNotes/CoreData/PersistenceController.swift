//
//  PersistenceController.swift
//  WeatherNotes
//
import CoreData
import Foundation

// MARK: - PersistenceController

final class PersistenceController {

    // MARK: - Singleton
    static let shared = PersistenceController()

    // MARK: - Preview
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let ctx = controller.container.viewContext

        let note = NoteEntity(context: ctx)
        note.id                  = UUID()
        note.text                = "Morning run in the park"
        note.createdAt           = Date()
        note.temperature         = 18.5
        note.feelsLike           = 17.0
        note.humidity            = 62
        note.weatherDescription  = "Clear sky"
        note.weatherIcon         = "01d"
        note.locationName        = "Kyiv"

        try? ctx.save()
        return controller
    }()

    // MARK: - Container
    let container: NSPersistentContainer

    // MARK: - Init
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(
            name: "WeatherNotes",
            managedObjectModel: Self.makeModel()
        )

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData failed to load: \(error.localizedDescription)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    // MARK: - Save
    func save() {
        let ctx = container.viewContext
        guard ctx.hasChanges else { return }
        do {
            try ctx.save()
        } catch {
            print("CoreData save error: \(error.localizedDescription)")
        }
    }

    // MARK: - Programmatic Model
    private static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        let entity = NSEntityDescription()
        entity.name = "NoteEntity"
        entity.managedObjectClassName = NSStringFromClass(NoteEntity.self)

        func makeAttr(
            _ name: String,
            type: NSAttributeType,
            optional: Bool = false,
            default defaultValue: Any? = nil
        ) -> NSAttributeDescription {
            let attr = NSAttributeDescription()
            attr.name          = name
            attr.attributeType = type
            attr.isOptional    = optional
            if let defaultValue { attr.defaultValue = defaultValue }
            return attr
        }

        entity.properties = [
            makeAttr("id",                 type: .UUIDAttributeType),
            makeAttr("text",               type: .stringAttributeType),
            makeAttr("createdAt",          type: .dateAttributeType),
            makeAttr("temperature",        type: .doubleAttributeType,    default: 0.0),
            makeAttr("feelsLike",          type: .doubleAttributeType,    default: 0.0),
            makeAttr("humidity",           type: .integer32AttributeType, default: 0),
            makeAttr("weatherDescription", type: .stringAttributeType,    optional: true),
            makeAttr("weatherIcon",        type: .stringAttributeType,    optional: true),
            makeAttr("locationName",       type: .stringAttributeType,    optional: true),
        ]

        model.entities = [entity]
        return model
    }
}
