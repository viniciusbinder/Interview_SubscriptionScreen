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
        view.backgroundColor = .white
        return view
    }()

    private let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let header = HeaderView()

    private let coverImage: UIImageView = {
        let view = UIImageView(image: nil)
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return view
    }()

    private let titleView = TitleView()

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

        setupScrollView()
        loadConfiguration()
    }

    private func loadConfiguration() {
        Task {
            do {
                let config = try await manager.loadViewConfiguration()

                self.header.setImage(config.headerLogo)
                self.coverImage.loadFromURL(config.coverImage)
                self.titleView.setTitle(config.subscribeTitle)
                self.titleView.setSubtitle(config.subscribeSubtitle)

                // TODO: assign values to views
            } catch {
                // TODO: handle error, assign default values to views
            }
        }
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        configureContainerView()
    }

    private func configureContainerView() {
        containerView.addArrangedSubview(header)
        containerView.addArrangedSubview(coverImage)
        containerView.addArrangedSubview(titleView)
    }
}
