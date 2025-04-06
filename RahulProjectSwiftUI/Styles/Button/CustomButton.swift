//
//  CustomButton.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 26/12/24.
//

import SwiftUI

struct CustomButton: View {
    let title: String
        let action: () -> Void
    var body: some View {
        
        Button(action: action) {
                    Text(title)
                .font(.system(size: 20,weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 50)
                        .background(
                            CustomShape()
                                .fill(Color.blue)
                        )
                        .cornerRadius(15)
                }
    }
}


struct CustomShape: Shape {
    func path(in rect: CGRect) -> Path {
        let arcSize = CGSize(width: rect.width, height: rect.height)
        return Path(
            roundedRect: CGRect(origin: .zero, size: arcSize),
            cornerRadius: 15,
            style: .continuous
        )
    }
}


struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(title: "Submit", action: {
            print("action triggered")
        })
    }
}
//
//#Preview {
//    CustomButton()
//}
