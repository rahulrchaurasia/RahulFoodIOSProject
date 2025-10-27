//
//  NotificationMain.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 22/10/25.
//

import SwiftUI

struct NotificationMain: View {
    var body: some View {
        
//        GeometryReader { geo in
//            DetailsView(percentageHeight: 0.5,
//                        size: geo.size,
//                        safeArea: geo.safeAreaInsets) {
//                
//               NotrificationList()
//                    .padding(.horizontal, 10)
//               
//            }
//        }
        
        
//        GeometryReader { geo in
//            CollapsibleContainerView(
//                headerHeightPercentage: 0.35, // Better proportion
//                size: geo.size,
//                safeArea: geo.safeAreaInsets
//            ) {
//                NotrificationList()
//                    .padding(.horizontal, 16)
//            }
//        }
        GeometryReader { geo in
                    CollapsibleContainerView3(
                        percentageHeight: 0.5,
                        size: geo.size,
                        safeArea: geo.safeAreaInsets
                    ) {
                        NotrificationList()
                            .padding(.horizontal, 10)
                    }
                }
                .ignoresSafeArea()
       
    }
}

#Preview {
    NotificationMain()
}
