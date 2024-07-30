//
//  OffersManager.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import Foundation
import CoreData
import UIKit

class OffersManager {
    private var provider: OffersProvider

    init(provider: OffersProvider) {
        self.provider = provider
    }

    func setProvider(_ provider: OffersProvider) {
        self.provider = provider
    }

    /// Fetches screen data payload.
    /// If offers are the same as stored, use stored offers,
    /// else save the new offers and use them instead.
    func loadViewConfiguration() async throws -> OffersViewConfiguration {
        let payload = try await provider.fetchOffers()
        let fetchedOffers = payload.record.subscription.offers
        let loadedOffers = await loadOffers()
        if loadedOffers.isEmpty {
            return OffersViewConfiguration(from: payload)
        }

        let storedOffers = Offers(from: loadedOffers)
        if fetchedOffers == storedOffers {
            return OffersViewConfiguration(from: payload, with: storedOffers)
        } else {
            await saveOffers(fetchedOffers.arrayed)
            return OffersViewConfiguration(from: payload)
        }
    }
}

@MainActor
extension OffersManager {
    private var context: NSManagedObjectContext? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }

    private func saveOffers(_ offers: [SubscriptionOffer]) {
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

        do {
            let request: NSFetchRequest<Offer> = Offer.fetchRequest()
            return try context.fetch(request)
        } catch {
            print("Failed to load offers")
            return []
        }
    }
}
