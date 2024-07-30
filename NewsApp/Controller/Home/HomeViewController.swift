//
//  HomeViewController.swift
//  NewsApp
//
//  Created by Vinícius on 30/07/24.
//

import UIKit

struct HomeViewConfiguration {
    let offersConfiguration: OffersViewConfiguration
}

class HomeViewController: UIViewController {
    var config: HomeViewConfiguration? {
        didSet {
            button.setTitle("Subscribe", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .boldSystemFont(ofSize: 18)
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }

    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .darkBlue
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "NavigateToOffersButton"
        return button
    }()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.accessibilityIdentifier = "LoadingSpinner"
        spinner.startAnimating()
        return spinner
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.accessibilityIdentifier = "HomeViewController"

        setupButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupButton() {
        view.addSubview(button)
        button.addSubview(spinner)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        button.addTarget(self, action: #selector(navigateToOffers), for: .touchUpInside)
    }

    @objc func navigateToOffers() {
        guard let config = config?.offersConfiguration else {
            showOffersUnavailableAlert()
            return
        }

        let offersViewController = OffersViewController(config: config)
        navigationController?.pushViewController(offersViewController, animated: true)
    }
}

extension HomeViewController {
    func showOffersUnavailableAlert() {
        let title = "Offers Unavailable"
        let message = "Wait for them to load or contact support"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)

        alertController.addAction(action)

        present(alertController, animated: true, completion: nil)
    }
}
