//
//  OfferView.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import UIKit

class OfferView: UIView {
    weak var delegate: OfferSelectionDelegate?
    
    private(set) var price: Double = 0.0
    
    private var isSelected: Bool = false
    
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 32, weight: .bold)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .darkGray
        view.textAlignment = .center
        view.numberOfLines = -1
        view.widthAnchor.constraint(lessThanOrEqualToConstant: 140).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkbox: UIImageView = {
        let view = UIImageView(image: nil)
        view.heightAnchor.constraint(equalToConstant: 35).isActive = true
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let checkedImage = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.black)
    private let uncheckedImage = UIImage(systemName: "circle")?.withTintColor(.black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        addGestureRecognizer(tapGesture)
        
        addSubview(priceLabel)
        addSubview(descriptionLabel)
        addSubview(checkbox)

        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: topAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            checkbox.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            checkbox.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkbox.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        setSelection(false)
    }
    
    func setPrice(_ price: Double) {
        self.price = price
        priceLabel.text = "$\(price)"
    }
    
    func setDescription(_ text: String) {
        descriptionLabel.text = text
    }
    
    func setSelection(_ selection: Bool) {
        isSelected = selection
        checkbox.image = isSelected ? checkedImage : uncheckedImage
    }
    
    @objc func tapped() {
        if !isSelected {
            setSelection(true)
            delegate?.selectOffer(price)
        }
    }
}
