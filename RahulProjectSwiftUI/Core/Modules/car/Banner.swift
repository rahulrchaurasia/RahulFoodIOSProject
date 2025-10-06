//
//  Banner.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 03/10/25.
//

import Foundation

// MARK: - Model
struct Banner: Identifiable, Decodable {
    let id: String
    let title: String
    let imageUrl: String
}


// This is the temporary struct from your previous code to match the API response
struct PhotoResponse: Decodable {
    let id: String
    let author: String
    let width: Int
    let height : Int
    let url: String
    let download_url: String
}
