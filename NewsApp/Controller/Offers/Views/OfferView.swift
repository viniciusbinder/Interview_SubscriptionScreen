//
//  OfferView.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import UIKit

class OfferView: UIView {
    private let priceLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = .systemFont(ofSize: 32, weight: .bold)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = ""
        view.font = .systemFont(ofSize: 12)
        view.textColor = .darkGray
        view.textAlignment = .center
        view.numberOfLines = -1
        view.widthAnchor.constraint(lessThanOrEqualToConstant: 140).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let toggle: UISwitch = {
        let view = UISwitch()
        view.isOn = true
        view.addTarget(OfferView.self, action: #selector(switchToggle(_:)), for: .valueChanged)
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
        addSubview(priceLabel)
        addSubview(descriptionLabel)
        addSubview(toggle)

        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: topAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 4),
            toggle.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            toggle.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            priceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            toggle.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func setPrice(_ price: Double) {
        priceLabel.text = "$\(price)"
    }
    
    func setDescription(_ text: String) {
        descriptionLabel.text = text
    }
    
    @objc func switchToggle(_ sender: UISwitch) {
        if sender.isOn {
            print("Switch is ON")
        } else {
            print("Switch is OFF")
        }
    }
}
