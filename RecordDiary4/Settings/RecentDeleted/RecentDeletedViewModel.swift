//
//  RecentDeletedViewModel.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 29.07.2025.
//

import Foundation

class RecentDeletedViewModel: ObservableObject {
    @Published var selectedData: [RecordDataModel] = []
    @Published var isEditing: Bool = false
    @Published var selectedRecord: RecordDataModel?
    
    func deleteSlected(restoreData: [RecordDataModel], audioService: AudioInputOutputService) -> [RecordDataModel] {
        var recentDeletedData: [RecordDataModel] = []
        if selectedData.isEmpty{
            for record in restoreData {
                audioService.deleteRecording(url: record.url)
            }
        } else {
            for record in selectedData {
                if !restoreData.contains(record) {
                    recentDeletedData.append(record)
                } else {
                    audioService.deleteRecording(url: record.url)
                }
            }
        }
        selectedData = []
        isEditing = false
        return recentDeletedData
    }
    func restoreSelected(restoreData: [RecordDataModel], function: @escaping () -> Void) -> [RecordDataModel] {
        var recentDeletedData: [RecordDataModel] = []
        if selectedData.isEmpty{
            for record in restoreData {
                var uRecord = record
                uRecord.itemIsDeleted = false
                uRecord.deletedDay = nil
                recentDeletedData.append(uRecord)
            }
        } else {
            for record in selectedData {
                if restoreData.contains(record) {
                    var uRecord = record
                    uRecord.itemIsDeleted = false
                    uRecord.deletedDay = nil
                    recentDeletedData.append(uRecord)
                } else{
                    recentDeletedData.append(record)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            function()
        }
        selectedData = []
        isEditing = false
        return recentDeletedData
    }
    
    func deleteAllItemsWhichAreEnspired(restoreData: [RecordDataModel], audioService: AudioInputOutputService, deletingType: DeletingType) -> [RecordDataModel]{
        var newData: [RecordDataModel] = []
        print("deleteAllItemsWhichAreEnspired()")
        var deletingInt: Int {
            switch deletingType {
            case .days7:
                7
            case .days30:
                30
            case .days60:
                60
            case .never:
                -1
            }
        }
        if deletingInt == -1 {
            return restoreData
        }
        for record in restoreData {
            if let deletedDate = record.deletedDay {
                if daysBetween(deletedDate, Date()) > deletingInt  {
                    audioService.deleteRecording(url: record.url)
                    print("Deleted in deleteAllItemsWhichAreEnspired()")
                } else {
                    newData.append(record)
                    print("Appended in deleteAllItemsWhichAreEnspired()")
                }
            }
            else {
                newData.append(record)
                print("Appended in deleteAllItemsWhichAreEnspired()")
            }
            
        }
        return newData
    }
    
    func daysBetween(_ from: Date, _ to: Date) -> Int {
        let calendar = Calendar.current
        let startOfFrom = calendar.startOfDay(for: from)
        let startOfTo = calendar.startOfDay(for: to)
        let components = calendar.dateComponents([.day], from: startOfFrom, to: startOfTo)
        return components.day ?? 0
    }

}
