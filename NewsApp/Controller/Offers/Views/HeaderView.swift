//
//  HeaderView.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import UIKit

class HeaderView: UIView {
    private let headerImage: UIImageView = {
        let view = UIImageView(image: nil)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .black
        heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(headerImage)
        
        NSLayoutConstraint.activate([
            headerImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerImage.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setImage(_ urlString: String) {
        headerImage.loadFromURL(urlString)
    }
}
