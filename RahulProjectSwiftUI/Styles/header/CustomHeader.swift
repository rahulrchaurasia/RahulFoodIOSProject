//
//  CustomHeader.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 18/09/25.
//

import SwiftUICore
import SwiftUI


struct CustomHeader: View {
    let title: String
    let dismissAction: (() -> Void)?

    var body: some View {
        HStack(alignment: .center) {
            if let dismissAction = dismissAction {
                Button(action: dismissAction) {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .contentShape(Rectangle())
                }
                .padding(.leading, 8)
                .padding(.trailing, 20)
            }

            Text(title)
                .font(.title2)
                .foregroundColor(.white)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.all, 10)
        .background(Color.toolBar) // define in your Assets or extension
        .shadow(color: Color.toolBar.opacity(0.7), radius: 2, x: 3, y: 5)
    }
}
