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

    // MARK: Views

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
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 220).isActive = true
        return view
    }()

    private let titleView = TitleView()

    private let selectionView = SelectionView()

    private let benefitsView = BenefitsView()

    // MARK: Initialization

    init(provider: OffersProvider) {
        self.manager = OffersManager(provider: provider)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

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

                let offer1 = config.offers.offer1, offer2 = config.offers.offer2
                self.selectionView.setOffer1(offer1.price, description: offer1.description)
                self.selectionView.setOffer2(offer2.price, description: offer2.description)

                self.benefitsView.setBenefits(config.benefits)

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
            containerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])

        configureContainerView()
    }

    private func configureContainerView() {
        containerView.addArrangedSubview(header)
        containerView.addArrangedSubview(coverImage)
        containerView.addArrangedSubview(titleView)
        containerView.addArrangedSubview(selectionView)
        containerView.addArrangedSubview(benefitsView)

        let label = UILabel()
        label.text = "––––––––––––––––––––––––"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.addArrangedSubview(label)
    }
}
