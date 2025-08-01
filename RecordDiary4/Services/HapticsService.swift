//
//  HapticsService.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 01.08.2025.
//
import SwiftUI

class HapticService {
    
    static let instance = HapticService() // Singleton
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func light() {
        impact(style: .light)
    }
    
}
