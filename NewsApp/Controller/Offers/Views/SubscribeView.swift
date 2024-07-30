//
//  SubscribeView.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import UIKit

class SubscribeView: UIView {
    var buttonAction: (() -> Void)?
    
    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Subscribe Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.backgroundColor = .darkBlue
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let disclaimerText: UITextView = {
        let view = UITextView()
        view.textColor = .black
        view.isScrollEnabled = false
        view.isEditable = false
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
        addSubview(button)
        addSubview(disclaimerText)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            disclaimerText.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 4),
            disclaimerText.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            disclaimerText.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 10),
            disclaimerText.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -10),
        ])
        
        button.addTarget(self, action: #selector(subscribe), for: .touchUpInside)
        disclaimerText.delegate = self
    }
    
    @objc func subscribe() {
        if let buttonAction {
            buttonAction()
        }
    }
    
    func setDisclaimer(_ text: String) {
        disclaimerText.attributedText = text.parseLinks()
        disclaimerText.sizeToFit()
        textViewDidChange(disclaimerText)
    }
}

extension SubscribeView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if interaction == .invokeDefaultAction {
            UIApplication.shared.open(URL)
            return false
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 11)
    }
}
