//
//  CalendarDateModel.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 15.07.2025.
//
import Foundation
import SwiftUI

struct CalendarDate: Identifiable {
    let id = UUID()
    let date: Date
    let isCurrentMonth: Bool
    let isToday: Bool
    
    var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }
}
