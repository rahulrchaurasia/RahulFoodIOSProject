//
//  AsyncImageWithPlaceholder.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 27/11/24.
//

import SwiftUICore
import SwiftUI

// Usage:
//AsyncImageWithPlaceholder(url: dish.image, size: 60)

struct AsyncImageWithPlaceholder: View {
    let url: String
    let size: CGFloat
    let radius : CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .cornerRadius(radius)
            case .failure:
                Image(systemName: "photo.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .cornerRadius(radius)
                    .foregroundColor(.gray)
            @unknown default:
                ProgressView()
            }
        }
        .frame(width: size, height: size)
    }
}


#Preview {
    AsyncImageWithPlaceholder(url: "https://cdn.iconscout.com/icon/free/png-256/pizza-618-1114742.png", size: 60, radius: 20)
}


