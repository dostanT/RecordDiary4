//
//  CalendarPickerSheetView.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 26.07.2025.
//
import SwiftUI
import SwiftfulRouting

struct CalendarPickerSheetView: View {
    
    @State var selectedDate: Date
    @Binding var changableDate: Date
    @Binding var showSheet: Bool
    let onEnded: () -> Void
    
    init(selectedDate: Date, changableDate: Binding<Date>, showSheet: Binding<Bool> ,onEnded: @escaping () -> Void) {
        self.selectedDate = selectedDate
        self._changableDate = changableDate
        self.onEnded = onEnded
        self._showSheet = showSheet
    }
    
    var body: some View{
        ZStack{
            //background
            ColorTheme.white.color.ignoresSafeArea()
            
            VStack(spacing: 0) {
                DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                    .datePickerStyle(.wheel)
                    .foregroundStyle(ColorTheme.pink.color)
                    .padding()
                
                VStack(spacing: 14){
                    Text("Jump to \(selectedDate, style: .date)")
                        .pinkBorderedAndCozyTextModifier(fontSize: 28) {
                            changableDate = selectedDate
                            onEnded()
                            showSheet = false
                        }
                    
                    Text("Cancel")
                        .pinkBorderedAndCozyTextModifier(fontSize: 28) {
                            onEnded()
                            showSheet = false
                        }
                }
                Spacer()
                
            }
        }
    }
}
