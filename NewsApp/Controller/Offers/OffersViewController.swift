//
//  OffersViewController.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import UIKit
import CoreData

class OffersViewController: UIViewController {
    private var config: OffersViewConfiguration

    private var selectedOffer: Double?

    // MARK: Views

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "ScrollView"
        return view
    }()

    private let containerView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "ContainerView"
        return view
    }()

    private let backButton: UIButton = {
        let view = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "chevron.left")?.withConfiguration(configuration)
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.layer.zPosition = 100
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "BackButton"
        return view
    }()

    private let header: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.accessibilityIdentifier = "Header"
        return view
    }()

    private let coverImage: UIImageView = {
        let view = UIImageView(image: nil)
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 220).isActive = true
        view.accessibilityIdentifier = "CoverImage"
        return view
    }()

    private let titleView: TitleView = {
        let view = TitleView()
        view.accessibilityIdentifier = "TitleView"
        return view
    }()

    private let selectionView: SelectionView = {
        let view = SelectionView()
        view.accessibilityIdentifier = "SelectionView"
        return view
    }()

    private let benefitsView: BenefitsView = {
        let view = BenefitsView()
        view.accessibilityIdentifier = "BenefitsView"
        return view
    }()

    private let subscribeView: SubscribeView = {
        let view = SubscribeView()
        view.accessibilityIdentifier = "SubscribeView"
        return view
    }()

    // MARK: Initialization

    init(config: OffersViewConfiguration) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        setupHeader()
        setupScrollView()
        loadConfiguration()
    }

    private func loadConfiguration() {
        Task {
            header.setImage(config.headerLogo ?? "")
            coverImage.loadFromURL(config.coverImage ?? "")
            titleView.setTitle(config.subscribeTitle ?? "")
            titleView.setSubtitle(config.subscribeSubtitle ?? "")

            selectionView.setOffer1(config.offer1Price, description: config.offer1Description ?? "")
            selectionView.setOffer2(config.offer2Price, description: config.offer2Description ?? "")
            selectionView.setSelection(config.offer1Price, true)
            self.selectedOffer = config.offer1Price

            benefitsView.setBenefits(config.benefits ?? [])
            subscribeView.setDisclaimer(config.disclaimer ?? "")
        }
    }

    private func setupHeader() {
        view.addSubview(header)
        header.addSubview(backButton)

        NSLayoutConstraint.activate([
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),

            backButton.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 10),
            backButton.centerYAnchor.constraint(equalTo: header.centerYAnchor),
        ])

        backButton.addTarget(self, action: #selector(popController), for: .touchUpInside)
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: header.bottomAnchor),
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
        containerView.addArrangedSubview(coverImage)
        containerView.addArrangedSubview(titleView)
        containerView.addArrangedSubview(selectionView)
        containerView.addArrangedSubview(benefitsView)
        containerView.addArrangedSubview(subscribeView)

        selectionView.delegate = self
        subscribeView.buttonAction = {
            self.showConfirmOfferAlert()
        }
    }

    @objc private func popController() {
        navigationController?.popViewController(animated: true)
    }
}

extension OffersViewController: OfferSelectionDelegate {
    func selectOffer(_ price: Double) {
        selectedOffer = price
        selectionView.setSelection(price, true)
    }
}

extension OffersViewController {
    func showConfirmOfferAlert() {
        guard let selectedOffer else { return }

        let title = "Subscription Confirmation"
        let message = "Buy $\(selectedOffer) subscription?"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            self.popController()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
