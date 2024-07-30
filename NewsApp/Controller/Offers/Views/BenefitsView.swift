//
//  BenefitsView.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import UIKit

class BenefitsView: UIView {
    private var isExpanded = false
    private var heightConstraint: NSLayoutConstraint!
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "What is \"News+\"?"
        view.font = .systemFont(ofSize: 13)
        view.textColor = .black
        view.textAlignment = .center
        view.numberOfLines = -1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let chevronImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "chevron.down")
        view.tintColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let benefitsView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalSpacing
        view.isHidden = true
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleExpansion))
        addGestureRecognizer(tapGesture)
        
        let titleView = UIStackView(arrangedSubviews: [titleLabel, chevronImageView])
        titleView.axis = .horizontal
        titleView.alignment = .center
        titleView.spacing = 4
        titleView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleView)
        addSubview(benefitsView)
        
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            benefitsView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            benefitsView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            
            titleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            benefitsView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
        heightConstraint = benefitsView.heightAnchor.constraint(equalToConstant: 0)
        heightConstraint.isActive = true
    }
    
    @objc private func toggleExpansion() {
        isExpanded.toggle()
        benefitsView.isHidden = !isExpanded
        
        heightConstraint.isActive = false
        if isExpanded {
            let subviews = benefitsView.arrangedSubviews
            let totalHeight = subviews.reduce(0) { $0 + $1.intrinsicContentSize.height }
                + CGFloat(subviews.count * 4)
            heightConstraint = benefitsView.heightAnchor.constraint(equalToConstant: totalHeight)
        } else {
            heightConstraint = benefitsView.heightAnchor.constraint(equalToConstant: 0)
        }
        heightConstraint.isActive = true
        
        chevronImageView.transform =
            isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
        layoutIfNeeded()
    }
    
    func setBenefits(_ benefits: [String]) {
        benefitsView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for benefit in benefits {
            let benefitLabel = UILabel()
            benefitLabel.text = "• \(benefit)"
            benefitLabel.font = .systemFont(ofSize: 13)
            benefitLabel.translatesAutoresizingMaskIntoConstraints = false
            benefitsView.addArrangedSubview(benefitLabel)
        }
    }
}
