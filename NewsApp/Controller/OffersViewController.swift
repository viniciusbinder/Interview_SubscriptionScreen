//
//  OffersViewController.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import UIKit
import CoreData

class OffersViewController: UIViewController {
    private var manager: OffersManager

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let scrollContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerImage: UIImageView = {
        let view = UIImageView(image: nil)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return view
    }()

    private let header: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        view.backgroundColor = .black
        return view
    }()

    private let subview2: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        view.backgroundColor = UIColor.cyan
        return view
    }()

    private let subview3: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 400).isActive = true
        view.backgroundColor = UIColor.gray
        return view
    }()

    init(provider: OffersProvider) {
        self.manager = OffersManager(provider: provider)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupScrollView()

        Task {
            do {
                let config = try await manager.loadViewConfiguration()

                self.headerImage.loadFromURL(config.headerLogo)

                // TODO: assign values to views
            } catch {
                // TODO: handle error, assign default values to views
            }
        }
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContainer)

        let margins = view.layoutMarginsGuide
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true

        scrollContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        configureContainerView()
    }

    private func configureContainerView() {
        header.addSubview(headerImage)
        NSLayoutConstraint.activate([
            headerImage.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            headerImage.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
        scrollContainer.addArrangedSubview(header)
    }
}
