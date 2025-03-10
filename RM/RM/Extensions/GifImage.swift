//
//  GifImage.swift
//  RM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import SwiftUI
import SwiftGifOrigin
import UIKit

struct GifImage: UIViewRepresentable {
    let gifName: String
    
    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.loadGif(name: gifName)
        return imageView
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
        // Обновление не требуется, так как GIF статичен
    }
}
