//
//  StickyHeaderView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 21/10/25.
//

/*
 
 You don’t need to manually write " init(...)" if you don’t need any custom logic.
 
 We only write a custom initializer when we want to:

 ✅ Add custom setup logic,
 ✅ Provide default values for some parameters,
 ✅ Do transformations or computed assignments, or
 ✅ Need to handle special property wrappers (like @Binding, @State, etc).
 
 
 🧩 3. What is _contentOffset = contentOffset?

 This is a special SwiftUI rule for property wrappers like @Binding, @State, @ObservedObject.

 When you define:

 @Binding var contentOffset: CGFloat


 Swift automatically creates an internal storage variable called _contentOffset (with an underscore).

 So:

 contentOffset → the wrapped value (like a normal variable)

 _contentOffset → the Binding wrapper itself

 When you manually initialize a @Binding, you must assign the wrapper like this:

 _contentOffset = contentOffset
 */
import SwiftUI
import Accelerate


struct StickyHeaderView: View {
    let size : CGSize
    let safeArea : EdgeInsets
    private let minHeight : CGFloat
    let percentageHeight :CGFloat
    
    @State private var progress : CGFloat = 0
    @Binding  var contentOffset : CGFloat
    
    
    init(size: CGSize,
         safeArea: EdgeInsets,
         contentOffset:  Binding<CGFloat> ,
         percentageHeight: CGFloat,) {
        
        self.size = size
        self.safeArea = safeArea
       
       
        self.minHeight = 60 + safeArea.top
        _contentOffset = contentOffset
        self.percentageHeight = percentageHeight
    }
    
    
    var body: some View {
        
        ZStack{
            GeometryReader { geo in
                
                let rect = geo.frame(in: .global)
                
                Image("denver")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: rect.size.width + (52 - rect.width) * progress,
                        height: rect.size.height + (52 - rect.height) * progress
                        
                    )
                    .clipShape(
                        RoundedRectangle(cornerRadius: 120 * (1 - progress), style: .continuous)
                    )
                    .offset(
                        x: 52 * progress,
                        y: (safeArea.top - 4) * progress
                    )
                    .onChange(of: contentOffset) { newValue in
                        
                        let scroll = newValue / minHeight
                        progress = min(max(scroll, 0), 1)
                    }
            }
            
            VStack(alignment: .leading) {
                
                Spacer()
                Text("Succeed").font(.title.bold())
                    .foregroundStyle(.blue)
                
                Text("IOS Developer")
                    .foregroundStyle(.secondary)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .scaleEffect(1 - 0.4 * progress, anchor: .leading)
            .offset(x : 100 * progress)
            .padding(.horizontal)
            .padding(.bottom , max(10 - progress * 100 , 0))
            
            VStack{
                
                
                HStack(alignment: .top) {
                    
                    Image(systemName: "arrow.left")
                        .imageScale(.large)
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.top , safeArea.top + 12)
                .padding(.leading)
                Spacer()
                
            }
        }
        .frame(height: height())
        .background(
            
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(1 * progress)
        )
        .clipped()
    }
}
extension StickyHeaderView {
    
    func height() -> CGFloat {
            let calculatedHeight = size.height * percentageHeight + contentOffset
            return calculatedHeight < minHeight ? minHeight : calculatedHeight
        }
    
}

//#Preview {
//    StickyHeaderView()
//}

