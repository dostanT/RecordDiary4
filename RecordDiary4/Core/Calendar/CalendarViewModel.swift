//
//  CalendarViewModel.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 15.07.2025.
//

import SwiftUI

class CalendarViewModel: ObservableObject {
    @Published var currentMonth: Date = Date()
    
    @Published var shownRecordsAfterFiltering: [RecordDataModel] = []
    @Published var selectedRecord: RecordDataModel? = nil
    
    func filterRecordsWithEmotion(records: [RecordDataModel], emotion: EmotionModel?, shownDate: Date, inMouth: Bool) {
        var newArr: [RecordDataModel] = []
        
        guard let emotion = emotion else {
            for record in records {
                if let shownDayRec = record.shownDay {
                    if !inMouth {
                        if shownDayRec.getFormattedYearMonth() == shownDate.getFormattedYearMonth() {
                            newArr.append(record)
                        }
                    } else {
                        if shownDayRec.getFormattedYearMonthDay() == shownDate.getFormattedYearMonthDay() {
                            newArr.append(record)
                        }
                    }
                }
                shownRecordsAfterFiltering = newArr
            }
            return
        }
        for record in records {
            guard let recordEmotion = record.emotion else {
                print("❌Error Filtering: filterRecordsWithEmotion()")
                shownRecordsAfterFiltering = []
                return
            }
            
            if recordEmotion.name == emotion.name {
                if let shownDayRec = record.shownDay {
                    if shownDayRec.getFormattedYearMonthDay() == shownDate.getFormattedYearMonthDay() {
                        newArr.append(record)
                    }
                }
            }
        }
        shownRecordsAfterFiltering = newArr
        return
    }
    
    func getDaysInMonth() -> [CalendarDate] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let endOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.end ?? currentMonth
        
        let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: startOfMonth)?.start ?? startOfMonth
        let endOfWeek = calendar.dateInterval(of: .weekOfYear, for: endOfMonth)?.end ?? endOfMonth
        
        var dates: [CalendarDate] = []
        var currentDate = startOfWeek
        
        while currentDate < endOfWeek {
            let isCurrentMonth = calendar.isDate(currentDate, equalTo: currentMonth, toGranularity: .month)
            let isToday = calendar.isDateInToday(currentDate)
            
            let calendarDate = CalendarDate(
                date: currentDate,
                isCurrentMonth: isCurrentMonth,
                isToday: isToday
            )
            
            dates.append(calendarDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
    
    func nextMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }
    
    func previousMonth() {
        currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
    
    func getWeekDays() -> [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        return formatter.shortWeekdaySymbols
    }
    
    func getMonthYearString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth).capitalized
    }
    
    func getPointFromRecords(data: [RecordDataModel], selectedDate: Date) -> [RecordDataModel]{
        //MARK: WWW
        //Можно будет сделать так что бы выбирала только те цвета которые больше всех
        var newData: [RecordDataModel] = []
        for record in data {
            if let shownDay = record.shownDay {
                if Calendar.current.isDate(selectedDate, inSameDayAs: shownDay) {
                    newData.append(record)
                }
            }
        }
        return newData
    }
}
