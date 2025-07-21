//
//  CoreDateService.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 18.07.2025.
//
import CoreData
import Combine
import Foundation
import SwiftUI

class CoreDateService {
    private let container: NSPersistentContainer
    private let containerName = "CoreDataStorage"
    private let recordEntityName = "RecordEntity"
    private let emotionEntityName = "EmotionEntity"
    
    @Published var saved: [RecordDataModel] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                print("❌ Ошибка при загрузке хранилища: \(error), \(error.userInfo)")
            } else {
                print("Succes core data fetch")
                self.fetchAll()
            }
        }
        print("📂 Core Data URL: \(container.persistentStoreDescriptions.first?.url?.absoluteString ?? "nil")")

    }
    
    func fetchAll() {
        saved = getRecords()
    }
    
//    func getRecords() -> [RecordDataModel] {
//        let request = NSFetchRequest<RecordEntity>(entityName: recordEntityName)
//
//        do {
//            let fetchedEntities = try container.viewContext.fetch(request)
//
//            return fetchedEntities.compactMap { recordEntity in
//                guard let url = recordEntity.url else {
//                    print("⚠️ Пропущена запись без URL")
//                    return nil
//                }

//                let emotion = EmotionModel(
//                    id: recordEntity.emotion?.id ?? UUID().uuidString,
//                    isShown: recordEntity.emotion?.isShown ?? false,
//                    name: recordEntity.emotion?.name ?? "Error",
//                    iconName: recordEntity.emotion?.iconName ?? "",
//                    color: ColorTheme(rawValue: recordEntity.emotion?.color ?? "") ?? ColorTheme.red
//                )
//
//                return RecordDataModel(
//                    id: recordEntity.id ?? UUID().uuidString,
//                    url: url,
//                    createdDate: recordEntity.createdDate ?? Date(),
//                    emotion: emotion,
//                    nameIdentifier: recordEntity.nameIdentifier ?? ""
//                )
//            }
//
//        } catch {
//            print("❌ Ошибка при загрузке из Core Data: \(error.localizedDescription)")
//            return []
//        }
//    }
    func getRecords() -> [RecordDataModel] {
        let request = NSFetchRequest<RecordEntity>(entityName: recordEntityName)
        
        do {
            let fetchedEntities = try container.viewContext.fetch(request)
            
            return fetchedEntities.compactMap { recordEntity in
                guard let url = recordEntity.url else {
                    print("⚠️ Пропущена запись без URL")
                    return nil
                }
                
                let emotion = EmotionModel(
                    id: recordEntity.emotion?.id ?? UUID().uuidString,
                    isShown: recordEntity.emotion?.isShown ?? false,
                    name: recordEntity.emotion?.name ?? "Error",
                    iconName: recordEntity.emotion?.iconName ?? "",
                    color: ColorTheme(rawValue: recordEntity.emotion?.color ?? "") ?? ColorTheme.red
                )
                
                return RecordDataModel(
                    id: recordEntity.id ?? UUID().uuidString,
                    url: url,
                    createdDate: recordEntity.createdDate ?? Date(),
                    emotion: emotion,
                    nameIdentifier: recordEntity.nameIdentefier ?? "")
            }
        } catch  {
            print("❌ Ошибка при загрузке из Core Data: \(error.localizedDescription)")
            return []
        }
        
    }
    
    func saveRecord(_ record: RecordDataModel) {
        let context = container.viewContext
        
        let emotion = EmotionEntity(context: context)
        emotion.id = record.emotion?.id ?? UUID().uuidString
        emotion.isShown = record.emotion?.isShown ?? false
        emotion.name = record.emotion?.name ?? "Fun"
        emotion.iconName = record.emotion?.iconName ?? "house"
        emotion.color = record.emotion?.color.rawValue ?? "red"
        
        let recordEntity = RecordEntity(context: context)
        recordEntity.id = record.id
        recordEntity.url = record.url
        recordEntity.createdDate = record.createdDate
        recordEntity.emotion = emotion
        recordEntity.nameIdentefier = record.nameIdentifier
        
        do {
            try context.save()
            print("✅ Запись успешно сохранён")
        } catch {
            print("❌ Ошибка при сохранении записи: \(error)")
        }
        fetchAll()
    }
    
    func saveRecords(_ records: [RecordDataModel]) {
        let context = container.viewContext

        for record in records {
            let emotion = EmotionEntity(context: context)
            emotion.id = record.emotion?.id ?? UUID().uuidString
            emotion.isShown = record.emotion?.isShown ?? false
            emotion.name = record.emotion?.name ?? "Fun"
            emotion.iconName = record.emotion?.iconName ?? "house"
            emotion.color = record.emotion?.color.rawValue ?? "red"

            let recordEntity = RecordEntity(context: context)
            recordEntity.id = record.id
            recordEntity.url = record.url
            recordEntity.createdDate = record.createdDate
            recordEntity.emotion = emotion
            recordEntity.nameIdentefier = record.nameIdentifier
        }

        do {
            try context.save()
            print("✅ Все записи успешно сохранены")
        } catch {
            print("❌ Ошибка при сохранении: \(error)")
        }

        fetchAll()
    }

    
    func deleteRecordFromCoreData(record: RecordDataModel) {
        let context = container.viewContext
        let request = NSFetchRequest<RecordEntity>(entityName: recordEntityName)
        request.predicate = NSPredicate(format: "id == %@", record.id)

        do {
            let results = try context.fetch(request)
            if let objectToDelete = results.first {
                context.delete(objectToDelete)
                try context.save()
                print("🗑️ Запись успешно удалена")
                fetchAll() // обновляем @Published saved
            } else {
                print("⚠️ Не удалось найти запись для удаления с id: \(record.id)")
            }
        } catch {
            print("❌ Ошибка при удалении записи: \(error)")
        }
    }

    
    func deleteAllRecordsFromCoreData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: recordEntityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try container.viewContext.execute(deleteRequest)
            try container.viewContext.save()
            print("🗑️ Успешно удалены все HumanEntity")
        } catch {
            print("❌ Ошибка при удалении всех людей: \(error)")
        }
        fetchAll()
    }

}
