import SwiftUI
import SwiftfulRouting

struct CalendarPickerSheetView: View {
    
    let months = Calendar.current.monthSymbols
    
    @Binding var changableDate: Date
    @Binding var showSheet: Bool
    
    let onEnded: () -> Void
    
    @State private var day: Int
    @State private var monthIndex: Int
    @State private var year: Int
    
    var selectedDate: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = day
        components.month = monthIndex + 1 // DateComponents: 1–12
        components.year = year
        return calendar.date(from: components) ?? Date()
    }
    
    // MARK: - Init
    init(selectedDate: Date, changableDate: Binding<Date>, showSheet: Binding<Bool> ,onEnded: @escaping () -> Void) {
        self._changableDate = changableDate
        self._showSheet = showSheet
        self.onEnded = onEnded
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: selectedDate)

        _day = State(initialValue: components.day ?? 1)
        _monthIndex = State(initialValue: (components.month ?? 1) - 1)
        _year = State(initialValue: components.year ?? 2024)
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            ColorTheme.white.color.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()

                HStack {
                    // День
                    VStack(spacing: 4) {
                        Image(systemName: "chevron.up")
                            .pinkBorderedAndCozyImageTextButtonModifier(fontSize: 28) {
                                if day < maxDayInMonth() {
                                    day += 1
                                }
                            }
                        
                        Text("\(day)")
                            .pinkAndCozyTextModifier(fontSize: 28)
                        
                        Image(systemName: "chevron.down")
                            .pinkBorderedAndCozyImageTextButtonModifier(fontSize: 28) {
                                if day > 1 {
                                    day -= 1
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Месяц
                    VStack(spacing: 4) {
                        Image(systemName: "chevron.up")
                            .pinkBorderedAndCozyImageTextButtonModifier(fontSize: 28) {
                                monthIndex = (monthIndex + 1) % 12
                                if day > maxDayInMonth() {
                                    day = maxDayInMonth()
                                }
                            }
                        
                        Text(months[monthIndex])
                            .pinkAndCozyTextModifier(fontSize: 28)
                        
                        Image(systemName: "chevron.down")
                            .pinkBorderedAndCozyImageTextButtonModifier(fontSize: 28) {
                                monthIndex = (monthIndex - 1 + 12) % 12
                                if day > maxDayInMonth() {
                                    day = maxDayInMonth()
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Год
                    VStack(spacing: 4) {
                        Image(systemName: "chevron.up")
                            .pinkBorderedAndCozyImageTextButtonModifier(fontSize: 28) {
                                year += 1
                                if day > maxDayInMonth() {
                                    day = maxDayInMonth()
                                }
                            }
                        
                        Text("\(year)")
                            .pinkAndCozyTextModifier(fontSize: 28)
                        
                        Image(systemName: "chevron.down")
                            .pinkBorderedAndCozyImageTextButtonModifier(fontSize: 28) {
                                year -= 1
                                if day > maxDayInMonth() {
                                    day = maxDayInMonth()
                                }
                            }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding()
                
                VStack(spacing: 14) {
                    Text("Jump to \(selectedDate, style: .date)")
                        .pinkBorderedAndCozyTextModifier(fontSize: 28) {
                            changableDate = selectedDate
                            onEnded()
                            showSheet = false
                        }
                    
                    HStack {
                        Text("Today")
                            .pinkBorderedAndCozyTextModifier(fontSize: 28) {
                                let today = Date()
                                let components = Calendar.current.dateComponents([.day, .month, .year], from: today)
                                day = components.day ?? 1
                                monthIndex = (components.month ?? 1) - 1
                                year = components.year ?? 2024
                                changableDate = today
                                onEnded()
                                showSheet = false
                            }
                        
                        Text("Cancel")
                            .pinkBorderedAndCozyTextModifier(fontSize: 28) {
                                onEnded()
                                showSheet = false
                            }
                    }
                }
                Spacer()
            }
        }
    }
    
    // MARK: - Helpers
    private func maxDayInMonth() -> Int {
        var components = DateComponents()
        components.year = year
        components.month = monthIndex + 1
        let calendar = Calendar.current
        let date = calendar.date(from: components)!
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 31
    }
}
