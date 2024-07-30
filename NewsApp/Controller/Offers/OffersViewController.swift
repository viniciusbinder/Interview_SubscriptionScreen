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

    private var selectedOffer: Double?

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

    private let backButton: UIButton = {
        let view = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "chevron.left")?.withConfiguration(configuration)
        view.setImage(image, for: .normal)
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = 100
        return view
    }()

    private let header: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let coverImage: UIImageView = {
        let view = UIImageView(image: nil)
        view.contentMode = .scaleAspectFit
        view.heightAnchor.constraint(equalToConstant: 220).isActive = true
        return view
    }()

    private let titleView = TitleView()

    private let selectionView = SelectionView()

    private let benefitsView = BenefitsView()

    private let subscribeView = SubscribeView()

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
        view.backgroundColor = .black

        setupHeader()
        setupScrollView()
        loadConfiguration()
    }

    private func loadConfiguration() {
        Task {
            do {
                let config = try await manager.loadViewConfiguration()

                header.setImage(config.headerLogo)
                coverImage.loadFromURL(config.coverImage)
                titleView.setTitle(config.subscribeTitle)
                titleView.setSubtitle(config.subscribeSubtitle)

                let offer1 = config.offers.offer1, offer2 = config.offers.offer2
                selectionView.setOffer1(offer1.price, description: offer1.description)
                selectionView.setOffer2(offer2.price, description: offer2.description)
                selectionView.setSelection(offer1.price, true)
                self.selectedOffer = offer1.price

                benefitsView.setBenefits(config.benefits)
                subscribeView.setDisclaimer(config.disclaimer)
            } catch {
                print(error)
                // TODO: show offer unavailability screen
            }
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
