//
//  CalendarView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 21/11/25.
//

import SwiftUICore
import SwiftUI


import SwiftUI

struct CalendarView: View {
    @Binding var selectedDate: Date
    @State private var currentMonth: Date = Date()
    @State private var showMonthYearPicker: Bool = false

    let calendar = Calendar.current
    let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

    var body: some View {
        VStack(spacing: 16) {

            header

            HStack {
                ForEach(days, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.secondary)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(generateCalendarDays(), id: \.self) { date in
                    dayCell(date)
                }
            }

            Spacer()
        }
        .padding()
        // Month-Year picker overlay
        .sheet(isPresented: $showMonthYearPicker) {
            let currentYear = Calendar.current.component(.year, from: Date())
              MonthYearPicker(
                  selectedDate: $currentMonth,
                  minYear: currentYear - 100,  // 100 years ago
                  maxYear: currentYear
              )
        }
    }
}

// MARK: - Header
extension CalendarView {
    var header: some View {
        HStack {
            Button(action: { moveMonth(-1) }) {
                Image(systemName: "chevron.left")
                    .font(.title3)
            }

            Spacer()

            Button(action: { showMonthYearPicker = true }) {
                Text(monthYearString(for: currentMonth))
                    .font(.title2.bold())
                    .underline()
            }

            Spacer()

            Button(action: { moveMonth(1) }) {
                Image(systemName: "chevron.right")
                    .font(.title3)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Day Cell
extension CalendarView {
    func dayCell(_ date: Date) -> some View {
        let isToday = calendar.isDateInToday(date)
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isInMonth = calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)

        return VStack {
            Text("\(calendar.component(.day, from: date))")
                .font(.body)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(8)
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue.opacity(0.9)
                             : isToday ? Color.blue.opacity(0.3)
                             : Color.clear)
                )
                .foregroundColor(isInMonth ? .primary : .secondary.opacity(0.4))
        }
        .frame(height: 40)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedDate = date
        }
    }
}

// MARK: - Calendar Logic
extension CalendarView {

    func generateCalendarDays() -> [Date] {
        let startOfMonth = calendar.date(from:
            calendar.dateComponents([.year, .month], from: currentMonth))!

        let weekday = calendar.component(.weekday, from: startOfMonth)
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!.count

        var dates: [Date] = []

        // Previous month fillers
        for day in 1 ..< weekday {
            if let date = calendar.date(byAdding: .day, value: -(weekday - day), to: startOfMonth) {
                dates.append(date)
            }
        }

        // Current month
        for day in 0..<daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day, to: startOfMonth) {
                dates.append(date)
            }
        }

        // Next month fillers
        while dates.count < 42 {
            if let last = dates.last,
               let next = calendar.date(byAdding: .day, value: 1, to: last) {
                dates.append(next)
            }
        }

        return dates
    }

    func moveMonth(_ value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }

    func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - Month + Year Picker

struct MonthYearPicker: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedDate: Date

    @State private var selectedMonth: Int
    @State private var selectedYear: Int

    private let calendar = Calendar.current
    private let months = Calendar.current.monthSymbols
    private let years: [Int]

    init(selectedDate: Binding<Date>, minYear: Int, maxYear: Int) {
        self._selectedDate = selectedDate

        let year = Calendar.current.component(.year, from: selectedDate.wrappedValue)
        self._selectedYear = State(initialValue: year)

        let month = Calendar.current.component(.month, from: selectedDate.wrappedValue)
        self._selectedMonth = State(initialValue: month - 1)

        self.years = Array(minYear...maxYear).reversed() // only allow years in range
    }

    var body: some View {
        NavigationStack {
            VStack {
                Picker("Month", selection: $selectedMonth) {
                    ForEach(0..<months.count, id: \.self) { index in
                        Text(months[index]).tag(index)
                    }
                }
                .pickerStyle(WheelPickerStyle())

                Picker("Year", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .pickerStyle(WheelPickerStyle())

                Spacer()
            }
            .navigationTitle("Select Month & Year")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        updateSelectedDate()
                        dismiss()
                    }
                }
            }
        }
    }

    private func updateSelectedDate() {
        var components = Calendar.current.dateComponents([.day, .month, .year], from: selectedDate)
        components.month = selectedMonth + 1
        components.year = selectedYear

        if let newDate = Calendar.current.date(from: components) {
            selectedDate = newDate
        }
    }
}



#Preview {
    
    let myDate : Date = Date()
    CalendarView(selectedDate: .constant(myDate))
}



struct MonthYearPicker_Previews: PreviewProvider {
    @State static var selectedDate = Date()
    
    static var previews: some View {
        // Example: Limit years from 1925 to 2007 (assuming current year 2025)
        MonthYearPicker(
            selectedDate: $selectedDate,
            minYear: Calendar.current.component(.year, from: Date()) - 100,
            maxYear: Calendar.current.component(.year, from: Date()) - 18
        )
    }
}
