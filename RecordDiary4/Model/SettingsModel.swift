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
    var disableRecentDeleted: Bool
    var delete: DeletingType
    var emotionInUse: [EmotionModel]
}


enum DeletingType: String, CaseIterable, Codable {
    case days7 = "7 days"
    case days30 = "30 days"
    case days60 = "60 days"
    case never = "never"
}
