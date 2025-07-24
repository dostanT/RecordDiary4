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
                .foregroundColor(calendarDate.isCurrentMonth ? ColorTheme.pink.color : ColorTheme.pink.color.opacity(0.3))
                .pinkAndCozyTextModifier(fontSize: 20)
            
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
            Rectangle()
                .fill(isSelected ? ColorTheme.pink.color.opacity(0.1) : Color.clear)
        )
        .overlay(
            Rectangle()
                .stroke(calendarDate.isToday ? ColorTheme.pink.color : Color.clear, lineWidth: 2)
        )
    }
}
