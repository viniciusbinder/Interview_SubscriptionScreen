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
    /// If payload is the same as stored use stored, else save and use new payload.
    func loadViewConfiguration() async throws -> OffersViewConfiguration? {
        let payload = try await provider.fetchPayload()
        let configuration = await loadConfiguration()

        if let configuration, payload.id == configuration.id {
            return configuration
        } else {
            return await saveConfiguration(from: payload)
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

    private func saveConfiguration(from payload: OffersPayload) -> OffersViewConfiguration? {
        guard let context else {
            print("Failed to save offers: Missing container context")
            return nil
        }

        deleteConfiguration()

        let entity = OffersViewConfiguration(context: context)
        entity.id = payload.id

        let subscription = payload.record.subscription
        entity.headerLogo = payload.record.headerLogo
        entity.pageStyle = subscription.pageStyle
        entity.coverImage = subscription.coverImage
        entity.subscribeTitle = subscription.subscribeTitle
        entity.subscribeSubtitle = subscription.subscribeSubtitle
        entity.benefits = subscription.benefits
        entity.disclaimer = subscription.disclaimer

        let offers = subscription.offers
        entity.offer1Price = offers.offer1.price
        entity.offer1Description = offers.offer1.description
        entity.offer2Price = offers.offer2.price
        entity.offer2Description = offers.offer2.description

        do {
            try context.save()
            return entity
        } catch {
            print("Failed to save offers")
            return nil
        }
    }

    private func loadConfiguration() -> OffersViewConfiguration? {
        guard let context else {
            print("Failed to load offers: Missing container context")
            return nil
        }

        do {
            let request: NSFetchRequest<OffersViewConfiguration> = OffersViewConfiguration.fetchRequest()
            let configs = try context.fetch(request)
            return configs.last
        } catch {
            print("Failed to load offers")
            return nil
        }
    }

    private func deleteConfiguration() {
        guard let context else {
            print("Failed to load offers: Missing container context")
            return
        }

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = OffersViewConfiguration.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Failed to delete persons: \(error)")
        }
    }
}
