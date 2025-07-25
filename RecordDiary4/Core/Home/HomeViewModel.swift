//
//  HomeViewModel.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 22.07.2025.
//

import Foundation

class HomeViewModel: ObservableObject {
    func stopStartRecording(emotion1: EmotionModel?, emotion2NONOptional: EmotionModel , stopRecording: () -> Void, startRecording: () -> Void) {
        guard let emotion1 = emotion1 else {
            startRecording()
            return
        }
        if emotion1.name == emotion2NONOptional.name {
            stopRecording()
        }
    }
    
    func checkOptionalsAndRegularValueIsEqual<T: Equatable>(fisrtOptional: T?, second: T) -> Bool{
        guard let fisrtOptional = fisrtOptional else {
            return false
        }
        if fisrtOptional == second {
            return true
        }
        return false
    }
}
