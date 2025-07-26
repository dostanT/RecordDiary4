//
//  CalendarPickerSheetView.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 26.07.2025.
//
import SwiftUI
import SwiftfulRouting

struct CalendarPickerSheetView: View {
    
    @Environment(\.router) var router
    @State var selectedDate: Date
    @Binding var changableDate: Date
    let onEnded: () -> Void
    
    init(selectedDate: Date, changableDate: Binding<Date>, onEnded: @escaping () -> Void) {
        self.selectedDate = selectedDate
        self._changableDate = changableDate
        self.onEnded = onEnded
    }
    
    var body: some View{
        VStack(spacing: 20) {
            Text("Выбрана дата:")
            Text(selectedDate, style: .date) // отображение выбранной даты

            DatePicker("Выберите дату", selection: $selectedDate, displayedComponents: [.date])
                .datePickerStyle(.wheel) // .compact, .graphical, .wheel (в зависимости от стиля)
                .padding()
            
            Button("Accept") {
                changableDate = selectedDate
                onEnded()
                router.dismissScreen()
            }
        }
    }
}
