//
//  FullScreenLoaderView.swift
//  RM
//
//  Created by Денис Ефименков on 10.03.2025.
//

import UIKit
import SwiftGifOrigin

class FullScreenLoaderView: UIView {
    private let gifImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .white.withAlphaComponent(0.9)
        addSubview(gifImageView)
        
        // Загружаем GIF
        gifImageView.loadGif(name: "loaderSummer")
        
        // Центрируем GIF
        gifImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
}
