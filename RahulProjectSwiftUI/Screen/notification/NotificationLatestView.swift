//
//  NotificationLatestView.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 23/10/25.
//

/*
 
 // ignoresSafeArea handling way
 
  1. Industry Preference Reasons
 Large Codebases:
 swift
 // Pattern 1 scales better in complex views
 var body: some View {
     ZStack {
         // Layer 1: Background
         Color.bg.ignoresSafeArea()
         
         // Layer 2: Content
         ScrollView { ... }
         
         // Layer 3: Overlays
         floatingButtons
         loadingIndicator
     }
 }
 
 2. Explicit Control & Readability
 swift
 var body: some View {
     ZStack (alignment: .top) {
         // Background that ignores safe areas
         Color.bg.ignoresSafeArea()
         
         // Content that respects safe areas
         contentLayer
     }
 }
 ✅ Clear separation of background vs content
 ✅ Easier to debug - you can see exactly what's ignoring safe areas
 ✅ More flexible for complex layouts with multiple layers


 
 3. Performance & Behavior
 Both patterns have identical performance, but Pattern 2 gives you more control:
 swift
 // Pattern 1 allows selective ignoring
 ZStack {
     Color.bg.ignoresSafeArea(.all)           // Full screen background
     Gradient.ignoresSafeArea([.top, .bottom]) // Partial ignoring
     contentLayer                              // Respects all safe areas
 }
 // vs Pattern 2 - all or nothing
 .background(Color.bg.ignoresSafeArea()) // Everything gets the same treatment
 
 
 
 Team Collaboration:
 swift
 // Easier for multiple developers to understand
 var body: some View {
     ZStack {
         // 🎨 Background (expands to edges)
         backgroundLayer
         
         // 📱 Main Content (respects safe areas)
         mainContentLayer
         
         // 🔝 Overlays (custom safe area handling)
         topOverlays
     }
 }

 */

import SwiftUI
import ScalingHeaderScrollView

struct NotificationLatestView: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    
    @State var progress: CGFloat = 0
    
    private let minHeight = 110.0
    private let maxHeight = 372.0
    
    //@ObservedObject var userViewModel : UserViewModel
    @EnvironmentObject var viewModel : UserViewModel
    
    var body: some View {
        
        ZStack {
            
            ScalingHeaderScrollView {
                
                ZStack {
                    Color.bg.ignoresSafeArea(.all)
                    largeHeader(progress: progress)
                }
            } content: {
                notificationContentView
            }
            .height(min: minHeight, max: maxHeight)
            .collapseProgress($progress)
            .allowsHeaderGrowth()
            
            topButtons
        }
        .ignoresSafeArea(.container,edges: .top)
    }
    
    
    
   
}

extension NotificationLatestView {
    
private func largeHeader(progress: CGFloat) -> some View {
        
    
    ZStack {
            Image("profile2")
                .resizable()
                .scaledToFill()
                .frame(height: maxHeight)
                .opacity(1 - progress)
            
            VStack {
                Spacer()
                
                HStack(spacing: 4.0) {
                    Capsule()
                        .frame(width: 40.0, height: 3.0)
                        .foregroundColor(.white)
                    
                    Capsule()
                        .frame(width: 40.0, height: 3.0)
                        .foregroundColor(.white.opacity(0.2))
                    
                    Capsule()
                        .frame(width: 40.0, height: 3.0)
                        .foregroundColor(.white.opacity(0.2))
                }
                
                ZStack(alignment: .leading) {

                    // 1️⃣ Blurred background with rounded top only
//                       TopRoundedRectangle(radius: 40)
//                           .fill(.regularMaterial)
//                           .padding(.horizontal)
//                           .offset(y:20)
//                           .frame(height: 80)
                    
                    VisualEffectView(effect: UIBlurEffect(style: .regular))
                        .mask(Rectangle().cornerRadius(40, corners: [.topLeft, .topRight]))
                        .offset(y: 10.0)
                        .frame(height: 80.0)

                    // 2️⃣ Gradient overlay
                    RoundedRectangle(cornerRadius: 40.0, style: .circular)
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.white.opacity(0.0), .white]), startPoint: .top, endPoint: .bottom)
                        )
                        // 3️⃣ Foreground content
                        HStack {
                            Image("a1")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            Text("John Doe")
                                .font(.title3.bold())
                        }
                        .padding(.leading, 24.0)
                        .padding(.top, 10.0)
                        .opacity(1 - max(0, min(1, (progress - 0.75) * 4.0)))
               
                      

                    smallHeader
                        .padding(.leading, 70.0)
                        .opacity(progress)
                        .opacity(max(0, min(1, (progress - 0.75) * 4.0)))
                }
                .frame(height: 80.0)
               // .padding(.horizontal,10)
            }
        }
    }
    
    
    private var smallHeader: some View {
        HStack(spacing: 12.0) {
            Image("choclate")
                .resizable()
                .frame(width: 40.0, height: 40.0)
                .clipShape(RoundedRectangle(cornerRadius: 6.0))

            Text("John Doe")
                .fontRegular(color: .appDarkGray, size: 17)
        }
    }
    
    private var topButtons : some View {
        
        VStack{
            
            HStack {
             
                Button {
                    coordinator.navigate(to: .home(.home))
                } label: {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                        .padding(16) // expand hit area
                        .contentShape(Rectangle()) // makes entire padded area tappable

                }
                .padding(.leading, 17)
               
                Spacer()
                
                Button {
                    print("Tapped!")
                } label: {
                    
                    Image(systemName: "ellipsis")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
                        .padding(16) // expand hit area
                        .contentShape(Rectangle()) // makes entire padded area tappable
                }
                .padding(.trailing,17)
               

            }
            .padding(.top, 50)
            Spacer()
        }
        .ignoresSafeArea()
    }
}

extension NotificationLatestView {
    
    private var notificationContentView: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 20) {
                    profession
                    address
                    NotrificationList()

                  //  Color.clear.frame(height: 100)
                }
                .padding(.horizontal, 12)
            }
        }
    }
    
//    private var notificationInfo: some View {
//        VStack(alignment: .leading) {
//            profession
//            address
//            NotrificationList()
//           // Color.clear.frame(height: 100)
//        }
//        .padding(.horizontal, 24)
//    }
    
   
    private var profession: some View {
        Text(viewModel.email)
            .fontRegular(color: .textPrimary, size: 16)
    }

    private var address: some View {
        Text(viewModel.address)
            .fontRegular(color: .secondaryText, size: 16)
    }
    
    
    

}

#Preview {
    NotificationLatestView()
        .environmentObject(UserViewModel())
}
