//
//  RecordDataModel.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 09.07.2025.
//

import Foundation


struct RecordDataModel: Identifiable {
    var id = UUID().uuidString
    let url: URL
    let createdDate: Date
    var emotion: EmotionModel?
    var nameIdentifier: String?
    
    static var defaultRecordDataModel: RecordDataModel {
        RecordDataModel(url: URL(string: "nil")!, createdDate: Date())
    }
}
struct Recording: Identifiable {
    let id = UUID()
    let url: URL
    let date: Date
    let sequence: Int
}
/*
 */


//enum EmotionEnum: String, CaseIterable {
//    case joy
//    case satisfaction
//    case excitement
//    case pride
//    case relief
//    case inspiration
//    case love
//    
//    case sadness
//    case loneliness
//    case disappointment
//    case melancholy
//    case selfPity
//    case regret
//    case hopelessness
//    
//    case anger
//    case irritation
//    case indignation
//    case aggression
//    case envy
//    case rage
//    case resentment
//    
//    case fear
//    case anxiety
//    case panic
//    case insecurity
//    case nervousness
//    case terror
//    case apprehension
//    
//    case surprise
//    case amazement
//    case confusion
//    case astonishment
//    case admiration
//    case bewilderment
//    case shock
//    
//    case disgust
//    case aversion
//    case contempt
//    case revulsion
//    case detachment
//    case loathing
//    
//    case neutral
//}

