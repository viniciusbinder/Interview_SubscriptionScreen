//
//  OffersPayload.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import Foundation

struct OffersPayload: Decodable {
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
    let offers: [String: Offer]
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
