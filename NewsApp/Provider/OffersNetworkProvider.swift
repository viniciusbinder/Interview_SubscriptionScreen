//
//  OffersProvider.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import Foundation

protocol OffersProvider {
    func fetchPayload() async throws -> OffersPayload
}

class OffersNetworkProvider: OffersProvider {
    private let url = URL(string: "https://api.jsonbin.io/v3/qs/66a78250e41b4d34e418bc8e")!

    func fetchPayload() async throws -> OffersPayload {
        let (data, _) = try await URLSession.shared.data(from: url)
        let payload = try JSONDecoder().decode(OffersPayload.self, from: data)
        return payload
    }
}
