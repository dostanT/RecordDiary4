//
//  DayCellView.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 15.07.2025.
//
import SwiftUI
struct DayCellView: View {
    let calendarDate: CalendarDate
    let records: [RecordDataModel]
    let isSelected: Bool
//    let settingsManager: SettingsManager
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(calendarDate.dayNumber)")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(calendarDate.isCurrentMonth ? .primary : .secondary)
            
            // record indicators
            if !records.isEmpty {
                HStack(spacing: 2) {
                    ForEach(records.prefix(3), id: \.id) { record in
                        Circle()
                            .fill(record.emotion?.color.color ?? Color.gray)
                            .frame(width: 6, height: 6)
                    }
                }
            }
        }
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? Color.blue.opacity(0.2) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(calendarDate.isToday ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}
