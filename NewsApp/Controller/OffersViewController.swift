//
//  OffersViewController.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import UIKit
import CoreData

class OffersViewController: UIViewController {
    private var provider: OffersProviderProtocol
    private var offers: [Offer] = []

    private var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }

    init(provider: OffersProvider) {
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        fetchPayload()
    }

    /// Fetches screen data payload.
    /// If offers are the same as stored, use stored offers,
    /// else save the new offers and use them instead.
    private func fetchPayload() {
        Task {
            let storedOffers = loadOffers()
            do {
                let payload = try await provider.fetchOffers()
                let fetchedOffers = payload.subscription.offers.map { $0.value }

                if fetchedOffers == storedOffers {
                    self.offers = storedOffers
                } else {
                    self.offers = fetchedOffers
                    saveOffers(fetchedOffers)
                }
                self.offers = offers
            } catch {
                print(error.localizedDescription)
                self.offers = storedOffers
            }
        }
    }

    private func saveOffers(_ offers: [Offer]) {
        guard let context else {
            print("Failed to save offers: Missing container context")
            return
        }

        for offer in offers {
            let entity = Offer(context: context)
            entity.information = offer.description
            entity.price = offer.price
        }

        do {
            try context.save()
        } catch {
            print("Failed to save offers")
        }
    }

    private func loadOffers() -> [Offer] {
        guard let context else {
            print("Failed to load offers: Missing container context")
            return []
        }

        let request: NSFetchRequest<Offer> = Offer.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to load offers")
            return []
        }
    }
}
