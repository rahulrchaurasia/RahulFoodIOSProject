//
//  DetailsView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 21/10/25.
//


//Mark : Generic View

import SwiftUI

struct DetailsView<Content : View > : View {
    
    let size: CGSize
        let safeArea: EdgeInsets
        let percentageHeight: CGFloat
        @State private var contentOffset: CGFloat = 0
        let content: Content
    
    init(percentageHeight: CGFloat, size: CGSize, safeArea: EdgeInsets, @ViewBuilder content: () -> Content) {
            self.percentageHeight = percentageHeight
            self.size = size
            self.safeArea = safeArea
            self.content = content()
        }
    var body: some View {
       
        ZStack(alignment: .top) {
            
            ScrollView(showsIndicators: false) {
                
                VStack(spacing:0){
                    
                    content
                        .padding(.top,size.height * percentageHeight + 14 )
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: ContentOffsetKey.self, value: geo.frame(in: .named("scrollView")).minY)
                            }
                            
                        )
                
                }
            }
            .coordinateSpace(name: "scrollView")
            .onPreferenceChange(ContentOffsetKey.self) { value in
                            self.contentOffset = value
                        }
            VStack{
                
                StickyHeaderView(size: size, safeArea: safeArea,
                                 contentOffset: $contentOffset,
                                 percentageHeight: percentageHeight)
                
                Spacer()
            }
        }
    }
}

//#Preview {
//    DetailsView()
//}
