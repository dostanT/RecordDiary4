//
//  HapticsService.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 01.08.2025.
//
import SwiftUI

class HapticService: ObservableObject {
    
    static let instance = HapticService() // Singleton
    
    @Published var isAvialable: Bool = true
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func light() {
        if isAvialable{
            impact(style: .light)
        }
    }
    
}
