//
//  SettingsModel.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 23.07.2025.
//

import Foundation

struct SettingsModel: Codable {
    var isPremium: Bool
    var apearanceIsLight: Bool
    var pointInCalendarVisable: Bool
    var language: String
    var recentDeleted: [RecordDataModel]
    var disableRecentDeleted: Bool
    var delete: DeletingType
    var emotionInUse: [EmotionModel]
}


enum DeletingType: String, CaseIterable, Codable {
    case days7 = "days7"
    case days30 = "days30"
    case days60 = "days60"
    case never = "never"
}
