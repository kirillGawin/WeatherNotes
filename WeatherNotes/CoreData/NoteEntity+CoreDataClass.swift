//
//  NoteEntity+CoreDataClass.swift
//  WeatherNotes
//

import CoreData
import Foundation

// MARK: - NoteEntity

@objc(NoteEntity)
public class NoteEntity: NSManagedObject {
    @NSManaged public var id:                 UUID?
    @NSManaged public var text:               String?
    @NSManaged public var createdAt:          Date?
    @NSManaged public var temperature:        Double
    @NSManaged public var feelsLike:          Double
    @NSManaged public var humidity:           Int32
    @NSManaged public var weatherDescription: String?
    @NSManaged public var weatherIcon:        String?
    @NSManaged public var locationName:       String?
}

// MARK: - Fetch Request
extension NoteEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteEntity> {
        NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
    }

    static func sortedFetchRequest() -> NSFetchRequest<NoteEntity> {
        let request = fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "createdAt", ascending: false)
        ]
        return request
    }
}

// MARK: - Identifiable
extension NoteEntity: Identifiable {}
