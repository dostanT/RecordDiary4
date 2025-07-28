//
//  Date.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 17.07.2025.
//

import Foundation

extension Date {
    func getFormattedHourMinutesAMPM() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"              // Пример: 3:45 PM
        formatter.locale = Locale(identifier: "en_US_POSIX") // Гарантирует AM/PM
        return formatter.string(from: self)
    }
    
    //convert Date to ex: 16 January
    func getformattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        formatter.locale = Locale(identifier: "en_US") // чтобы было "January"
        return formatter.string(from: self)
    }
    
    //convert Date to Week day ex: Monday
    func getformattedWeekDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "en_US") // чтобы было "Monday"
        return formatter.string(from: self)
    }
    
    // convert Date to "2025 July 18"
    func getFormattedYearMonthDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM dd"
        formatter.locale = Locale(identifier: "en_US") // чтобы месяц был на английском
        return formatter.string(from: self)
    }
    
    func getFormattedYearMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MMMM"
        formatter.locale = Locale(identifier: "en_US") // чтобы месяц был на английском
        return formatter.string(from: self)
    }
}
