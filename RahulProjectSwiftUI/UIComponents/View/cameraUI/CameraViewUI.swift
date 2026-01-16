//
//  CameraViewUI.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 10/12/25.
//

import SwiftUI


struct CameraViewUI: View {
    let onComplete: (UIImage?) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Camera UI (Demo)")
            Button("Take Photo") {
                onComplete(UIImage(systemName: "person.fill"))
            }
            Button("Cancel") {
                onComplete(nil)
            }
        }
        .padding()
    }
}

struct GalleryViewUI: View {
    let onComplete: (UIImage?) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Gallery UI (Demo)")
            Button("Pick Photo") {
                onComplete(UIImage(systemName: "person.fill"))
            }
            Button("Cancel") {
                onComplete(nil)
            }
        }
        .padding()
    }
}

#Preview("Camera + Gallery") {
    VStack(spacing: 20) {
        CameraViewUI { img in
            print("Camera:", img as Any)
        }

        GalleryViewUI { img in
            print("Gallery:", img as Any)
        }
    }
    .padding()
}
