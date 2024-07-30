//
//  SelectionView.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import UIKit

class SelectionView: UIView {
    private let offerView1: OfferView = {
        let view = OfferView()
        view.widthAnchor.constraint(equalToConstant: 130).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let offerView2: OfferView = {
        let view = OfferView()
        view.widthAnchor.constraint(equalToConstant: 130).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.heightAnchor.constraint(equalToConstant: 130).isActive = true
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(offerView1)
        addSubview(divider)
        addSubview(offerView2)
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            
            divider.centerXAnchor.constraint(equalTo: centerXAnchor),
            offerView1.trailingAnchor.constraint(equalTo: divider.leadingAnchor, constant: -20),
            offerView2.leadingAnchor.constraint(equalTo: divider.trailingAnchor, constant: 20),
            
            offerView1.bottomAnchor.constraint(equalTo: bottomAnchor),
            offerView2.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setOffer1(_ price: Double, description: String) {
        offerView1.setPrice(price)
        offerView1.setDescription(description)
    }
    
    func setOffer2(_ price: Double, description: String) {
        offerView2.setPrice(price)
        offerView2.setDescription(description)
    }
}
