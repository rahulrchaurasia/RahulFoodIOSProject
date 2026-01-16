//
//  AppPermission.swift
//  RahulProjectSwiftUI
//
//  Created by Rahul Chaurasia on 06/12/25.
//

import AVFoundation
import Photos


enum AppPermission {
    case camera(AVAuthorizationStatus)
    case photos(PHAuthorizationStatus)
}
