//
//  View+Extension.swift
//  SwiftUIDemo
//
//  Created by Rahul Chaurasia on 14/06/23.
//

// For For a TextField in SwiftUI, using a ViewModifier is typically more suitable than a ViewBuilder.
import Foundation
import SwiftUI

extension View {
    
    var getWidth: CGFloat {
            UIScreen.main.bounds.width
        }
    
    func circularText() -> some View {
        self.modifier(CircularText())
    }
    
    
    //added :05otp
    func disableWithOpacity(_ condition : Bool) -> some View {
        
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
        
    }
    
    func underlineTextField() -> some View {
            self
                .padding(.vertical, 10)
                .overlay(Rectangle().frame(height: 2).padding(.top, 35).foregroundColor(Color.gray.opacity(0.5)))
                .foregroundColor(Color.black)
                
                .padding(10)
        }
    
    func customTextViewModifier( roundedCornes: CGFloat,
     textColor: Color) -> some View {
        
        self.modifier(CustomTextViewModifier(roundedCornes: roundedCornes, textColor: textColor))
    }
    
    func customTextWithIconViewModifier(roundedCornes: CGFloat, textColor: Color) -> some View {
        self.modifier(CustomTextWithIconViewModifier(roundedCornes: roundedCornes, textColor: textColor))
      }
   
    
    ///  Custom Font 
    func fontBold(color: Color = .black, size: CGFloat) -> some View {
        foregroundColor(color).font(.custom("Circe-Bold", size: size))
    }

    func fontRegular(color: Color = .black, size: CGFloat) -> some View {
        foregroundColor(color).font(.custom("Circe", size: size))
    }
    
    
    
    func hideKeyboard() {
           UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
       }
    
    
    /***********************************************************************/
           // Make View Rounded corner
    /***********************************************************************/

    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corers: corners) )
    }
    
/***********************************************************************/
       // Using  @ViewBuilder
/***********************************************************************/
    @ViewBuilder
   func formattedText(_ text: String, backgroundColor: Color, foregroundColor: Color = .black) -> some View {
           Text(text)
               .font(.largeTitle)
               .frame(width: 250, height: 250)
               .padding()
               .background(backgroundColor)
               .foregroundColor(foregroundColor)
               .cornerRadius(15)
       }

   
/***********************************************************************/
    // Using  Keyboard Handling  
    //Move TextField up when the keyboard has appeared in SwiftUI
/***********************************************************************/
    func adaptsToKeyboard() -> some View {
           return modifier(AdaptsToKeyboard())
       }
    
    func keyboardManagment() -> some View {
           self.modifier(KeyboardManagment())
       }
    
    /***********************************************************************/
        // Using  Swipe Gesture
        //For OnBoard / welcome Screen swape the pages SwiftUI
    /***********************************************************************/
     
    
    func onSwipeGesture(perform action: @escaping (SwipeDirection) -> Void) -> some View {
            modifier(SwipeGestureModifier(onSwipe: action))
        }
   
    
    
    /***********************************************************************/
        // Using  Loader at Zstack level
        //use :
        
//            ScrollView { ... }
//            .loadingOverlay(viewModel.isLoading)
        
    /***********************************************************************/
     
    
    func loadingOverlay(_ isLoading: Bool) -> some View {
            ZStack {
                self
                if isLoading {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView("Loading...")
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                }
            }
        }
    
}


/*
 cornerRadius(_:corner:) → lets you round specific corners (e.g. .topLeft, .bottomRight).

 maxLeft, maxRight, maxCenter → alignment shortcuts.

 t8, v15, h8, etc. → padding shortcuts for consistent UI spacing.
 */
extension View {
    
    func cornerRadius(_ radius: CGFloat, corner:  UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corers: corner))
    }
    
    
    // MARK: - Alignment Helpers
    var maxLeft: some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }

    var maxRight: some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }

    var maxCenter: some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }

    // MARK: - Padding Helpers
    var t8: some View {
        self.padding(.top, 8)
    }

    var t15: some View {
        self.padding(.top, 15)
    }

    var v8: some View {
        self.padding(.vertical, 8)
    }

    var v15: some View {
        self.padding(.vertical, 15)
    }

    var v: some View {
        self.padding(.vertical)
    }

    var h8: some View {
        self.padding(.horizontal, 8)
    }

    var h15: some View {
        self.padding(.horizontal, 15)
    }

    var h: some View {
        self.padding(.horizontal)
    }
}

extension View {
    
    func withDateInputMasking(text: Binding<String>) -> some View {
            self.modifier(DateInputModifier(text: text))
        }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corers: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corers, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
