//
//  EmotionModel.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 12.07.2025.
//
import Foundation
import SwiftUI

struct EmotionModel: Identifiable {
    var id = UUID().uuidString
    var isShown: Bool
    var name: String
    var iconName: String?
    var color: ColorTheme
    
    static func defaultEmotion() -> EmotionModel {
        EmotionModel(
            isShown: false,
            name: "Non emotion",
            color: ColorTheme.grayLight)
    }
}
