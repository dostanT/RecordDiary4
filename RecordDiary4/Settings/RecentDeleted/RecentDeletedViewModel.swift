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
        for record in selectedData {
            if !restoreData.contains(record) {
                recentDeletedData.append(record)
            } else {
                audioService.deleteRecording(url: record.url)
            }
        }
        isEditing = false
        return recentDeletedData
    }
    func restoreSelected(restoreData: [RecordDataModel], function: @escaping () -> Void) -> [RecordDataModel] {
        var recentDeletedData: [RecordDataModel] = []
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            function()
        }
        
        isEditing = false
        return recentDeletedData
    }
}
