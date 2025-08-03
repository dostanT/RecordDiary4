//
//  EmotionControllerViewModel.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 31.07.2025.
//
import Foundation

class EmotionControllerViewModel: ObservableObject {
    
    let emotionSymbols: [String] = [
        // Положительные
        "face.smiling",
        "hand.thumbsup.fill",
        "sun.max.fill",
        "heart.fill",
        "star.fill",
        "sparkles",
        "smiley.fill",
        "person.2.wave.2.fill",
        "music.note",
        "balloon.fill",
        "leaf.fill",
        "face.smiling.inverse",
        "theatermasks.fill",
        "bolt.heart.fill",
        "gift.fill",

        // Нейтральные
        "circle.lefthalf.filled",
        "pause.circle.fill",
        "ellipsis.bubble.fill",
        "questionmark.circle.fill",
        "person.crop.circle.badge.questionmark",
        "cloud.sun.fill",
        "eye.fill",
        "waveform.path.ecg",
        "book.closed.fill",
        "clock.fill",

        // Грусть и уныние
        "cloud.rain.fill",
        "face.dashed.fill",
        "exclamationmark.triangle.fill",
        "drop.fill",
        "bolt.slash.fill",
        "moon.fill",
        "tortoise.fill",
        "zzz",
        "thermometer.snowflake",
        "wind",

        // Гнев
        "flame.fill",
        "burst.fill",
        "hand.raised.fill",
        "exclamationmark.octagon.fill",
        "xmark.octagon.fill",
        "bolt.fill",
        "trash.fill",
        "antenna.radiowaves.left.and.right",
        "scribble.variable",

        // Любовь
        "heart.circle.fill",
        "heart.circle",
        "eyes.inverse",
        "face.smiling.fill"
    ]

    
    func checkEmotionItemsAreNotSimilar(emotions: [EmotionModel], checker: (Bool) -> ()) {
        var check = true
        for emotion in emotions {
            if emotions.filter({ $0.name == emotion.name }).count > 1 {
                check = false
                break
            }
        }
        checker(check)
    }
}
