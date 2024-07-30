//
//  OffersViewConfiguration.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import Foundation

struct OffersViewConfiguration {
    let headerLogo: String
    let pageStyle: String
    let coverImage: String
    let subscribeTitle: String
    let subscribeSubtitle: String
    let benefits: [String]
    let disclaimer: String
    let offers: Offers

    init(headerLogo: String, pageStyle: String, coverImage: String, subscribeTitle: String, subscribeSubtitle: String, benefits: [String], disclaimer: String, offer1: SubscriptionOffer, offer2: SubscriptionOffer) {
        self.headerLogo = headerLogo
        self.pageStyle = pageStyle
        self.coverImage = coverImage
        self.subscribeTitle = subscribeTitle
        self.subscribeSubtitle = subscribeSubtitle
        self.benefits = benefits
        self.disclaimer = disclaimer
        self.offers = Offers(offer1: offer1, offer2: offer2)
    }

    init(from payload: OffersPayload) {
        let record = payload.record
        let subscription = record.subscription
        self.init(
            headerLogo: record.headerLogo,
            pageStyle: subscription.pageStyle,
            coverImage: subscription.coverImage,
            subscribeTitle: subscription.subscribeTitle,
            subscribeSubtitle: subscription.subscribeSubtitle,
            benefits: subscription.benefits,
            disclaimer: subscription.disclaimer,
            offer1: subscription.offers.offer1,
            offer2: subscription.offers.offer2
        )
    }

    init(from payload: OffersPayload, with storedOffers: Offers) {
        let record = payload.record
        let subscription = record.subscription
        self.init(
            headerLogo: record.headerLogo,
            pageStyle: subscription.pageStyle,
            coverImage: subscription.coverImage,
            subscribeTitle: subscription.subscribeTitle,
            subscribeSubtitle: subscription.subscribeSubtitle,
            benefits: subscription.benefits,
            disclaimer: subscription.disclaimer,
            offer1: storedOffers.offer1,
            offer2: storedOffers.offer2
        )
    }
}

struct Offers: Decodable, Equatable {
    let offer1: SubscriptionOffer
    let offer2: SubscriptionOffer

    init(offer1: SubscriptionOffer, offer2: SubscriptionOffer) {
        self.offer1 = offer1
        self.offer2 = offer2
    }

    init?(from offers: [Offer]) {
        guard let first = offers.first, let last = offers.last else { return nil }
        let offer1 = SubscriptionOffer(from: first)
        let offer2 = SubscriptionOffer(from: last)
        self.init(offer1: offer1, offer2: offer2)
    }

    enum CodingKeys: String, CodingKey {
        case offer1 = "id0"
        case offer2 = "id1"
    }

    static func == (lhs: Offers, rhs: Offers) -> Bool {
        lhs.offer1 == rhs.offer2
    }

    var arrayed: [SubscriptionOffer] {
        [offer1, offer2]
    }
}

struct SubscriptionOffer: Decodable, Equatable {
    let price: Double
    let description: String

    init(price: Double, description: String) {
        self.price = price
        self.description = description
    }

    init(from offer: Offer) {
        self.init(price: offer.price, description: offer.information ?? "")
    }

    static func == (lhs: SubscriptionOffer, rhs: SubscriptionOffer) -> Bool {
        lhs.price == rhs.price && lhs.description == rhs.description
    }
}
