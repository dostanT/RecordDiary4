//
//  EmotionControllerViewModel.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 31.07.2025.
//
import Foundation

class EmotionControllerViewModel: ObservableObject {
    
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
