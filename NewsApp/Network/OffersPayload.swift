//
//  OffersPayload.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import Foundation

struct OffersPayload: Decodable {
    let id: UUID
    let record: Record
}

struct Record: Decodable {
    let headerLogo: String
    let subscription: Subscription

    enum CodingKeys: String, CodingKey {
        case headerLogo = "header_logo"
        case subscription
    }
}

struct Subscription: Decodable {
    let pageStyle: String
    let coverImage: String
    let subscribeTitle: String
    let subscribeSubtitle: String
    let offers: Offers
    let benefits: [String]
    let disclaimer: String

    enum CodingKeys: String, CodingKey {
        case pageStyle = "offer_page_style"
        case coverImage = "cover_image"
        case subscribeTitle = "subscribe_title"
        case subscribeSubtitle = "subscribe_subtitle"
        case offers
        case benefits
        case disclaimer
    }
}

struct Offers: Decodable {
    let offer1: OfferInformation
    let offer2: OfferInformation

    enum CodingKeys: String, CodingKey {
        case offer1 = "id0"
        case offer2 = "id1"
    }
}

struct OfferInformation: Decodable {
    let price: Double
    let description: String
}
