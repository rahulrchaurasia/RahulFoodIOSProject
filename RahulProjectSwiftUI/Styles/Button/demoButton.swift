//
//  demoButton.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 02/02/24.
//

import SwiftUI

struct demoButton: View {
    
    var action: () -> Void

        var body: some View {
            Button("Create account", action: action)
                .padding()
                .foregroundColor(.white)
                .background(RoundedRectangle(cornerRadius: 20).style(
                    withStroke: Color.black,
        lineWidth: 2,
        fill: Color.blue
    ))
        }
}


struct demoButton_Previews: PreviewProvider {
    static var previews: some View {
        demoButton{
            
            print("done")
        }
    }
}
