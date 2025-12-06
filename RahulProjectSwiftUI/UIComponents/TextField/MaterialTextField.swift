//
//  MaterialTextField.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 24/11/25.
//

import SwiftUI

struct MaterialTextField: View {
    let title: String
    @Binding var text: String
    @FocusState private var isTyping: Bool

    // When label should float
    var floatLabel: Bool {
        isTyping || !text.isEmpty
    }

    var body: some View {
        ZStack(alignment: .leading) {

            // MARK: - TEXT INPUT FIELD
            TextField("", text: $text)
                .padding(.horizontal)
                .frame(height: 55)
                .focused($isTyping)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.appWhiteColor)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(
                            floatLabel ? Color.blue : Color.appBlackColor.opacity(0.4),
                            lineWidth: floatLabel ? 2 : 1
                        )
                )

            // MARK: - FLOATING LABEL
            Text(title)
                .font(.caption)
                .padding(.horizontal, 5)
                .background(Color.appWhiteColor)
                .foregroundColor(floatLabel ? .blue : Color.appBlackColor.opacity(0.8))
                .offset(x: 10, y: floatLabel ? -27 : 0)
                .opacity(floatLabel ? 1 : 0)
                .animation(.easeInOut(duration: 0.20), value: floatLabel)

            // MARK: - PLACEHOLDER (Only when empty + not typing)
            if !floatLabel {
                Text(title)
                    .foregroundColor(Color.appBlackColor.opacity(0.4))
                    .padding(.leading, 16)
                    .animation(.easeInOut(duration: 0.20), value: floatLabel)
            }
        }
        .padding(.top, 15)
    }
}


#Preview {
                
    MaterialTextDemoView()
}

struct MaterialTextDemoView: View {
    @State private var firstName = "dwdwd"
    @State private var lastName = ""

    var body: some View {
        VStack(spacing: 40) {
            MaterialTextField(title: "First Name", text: $firstName)
            MaterialTextField(title: "Last Name", text: $lastName)
        }
        //.background(Color.white)
        .padding()
    }
}
