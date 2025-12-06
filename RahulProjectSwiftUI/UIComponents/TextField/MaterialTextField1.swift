//
//  MaterialTextField.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 13/11/25.
//

import SwiftUI


struct MaterialTextField1 : View {
    var leftIcon : String? = nil
    var rightIcon : String? = nil
    var placeHolder : String? = nil
    
    @Binding var text : String
    
    @State private var isEditing = false
    @State private var edges = EdgeInsets(top: 0, leading:45, bottom: 0, trailing: 0)
    
    
    private enum Field : Int, Hashable {
        case fieldName
    }
    
    @FocusState private var focusField : Field?
    
    var body: some View {
        ZStack(alignment : .leading) {
            HStack {
                if(leftIcon != nil){
                    Image(systemName: leftIcon ?? "person")
                        .foregroundColor(Color.secondary)
                }
                TextField("", text: $text) { status in
                    DispatchQueue.main.async {
                        isEditing = status
                        if (isEditing ) {
                            edges = EdgeInsets(top: 0, leading:15, bottom: 60, trailing: 0)
                        }
                        else if (text.count>0 ) {
                            edges = EdgeInsets(top: 0, leading:15, bottom: 60, trailing: 0)
                        }
                        else {
                            edges = EdgeInsets(top: 0, leading:45, bottom: 0, trailing: 0)
                        }
                    }
                }
                .focused($focusField, equals: .fieldName)
                
                if(rightIcon != nil){
                    Image(systemName: rightIcon ?? "person")
                        .foregroundColor(Color.secondary)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color("border")))
            
            Text(placeHolder ?? "")
            
                .background(Color(UIColor.systemBackground))
                .foregroundColor(Color.secondary)
                .padding(edges)
                .animation(Animation.easeInOut(duration: 0.4), value: edges)
                .onTapGesture {
                    self.focusField = .fieldName
                }
            
        }
      .frame(height: 45)//005added Fixed height for smoother animation
       .animation(.easeInOut(duration: 0.4), value: isEditing )
    }
}


#Preview {
    VStack(spacing : 25){
        
        MaterialTextField1(leftIcon : "person", placeHolder: "Name", text: .constant(""))
        
        MaterialTextField1(leftIcon : "person", placeHolder: "Email", text: .constant(""))
    }.padding(.horizontal,30)
}
