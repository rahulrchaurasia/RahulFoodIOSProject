//
//  DOBField.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 21/11/25.
//

import SwiftUI

struct DOBField: View {
    @Binding var dob: Date
    @Binding var showCalendar: Bool
    @Binding var isFocused: Bool     // 👈 ADD THIS
    var title: String
    var error: String
    
    let formatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Button {
                isFocused = true 
                showCalendar = true
            } label: {
                HStack {
                    Text(formatter.string(from: dob))
                        .foregroundStyle(Color.appBlackColor)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .foregroundStyle(.gray)
                }
                .padding()
                .background(Color.systemGray6)
                .cornerRadius(10)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            error.isEmpty ?
                            (isFocused ? Color.blue : Color.gray.opacity(0.4))
                            : Color.red,
                            lineWidth: 1)
                }
            }
            
            if !error.isEmpty {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

#Preview {
    DOBField(dob: .constant(Date()), showCalendar: .constant(true), isFocused: .constant(true), title: "Date", error: "")
        .padding()
}
