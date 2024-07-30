//
//  OffersMockProvider.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import Foundation

class OffersMockProvider: OffersProvider {
    func fetchOffers() async throws -> OffersPayload {
        let data = Data(Self.mockOffersJSON.utf8)
        let payload = try JSONDecoder().decode(OffersPayload.self, from: data)
        return payload
    }

    static let mockOffersJSON = """
    {
        "record": {
          "header_logo": "https://cdn.us-corp-qa-3.vip.tnqa.net/nativeapp.www.us-corp-qa-3.tnqa.net/content/tncms/assets/v3/media/9/e0/9e0dae9e-240b-11ef-9068-000c299ccbc9/6661be72a43be.image.png?_fallback=1",
          "subscription": {
            "offer_page_style": "square",
            "cover_image": "https://cdn.us-corp-qa-3.vip.tnqa.net/nativeapp.www.us-corp-qa-3.tnqa.net/content/tncms/assets/v3/media/8/18/818482c0-09d7-11ed-ad65-000c299ccbc9/62dac9c7602ba.image.jpg?resize=750%2C420",
            "subscribe_title": "Get Unlimited Access",
            "subscribe_subtitle": "STLToday.com is where your story lives. Stay in the loop with unlimited access to articles, podcasts, videos and the E-edition. Plus unlock breaking news and customized real-time alerts for sports, weather, and more.",
            "offers": {
              "id0": {
                "price": 35.99,
                "description": "Billed monthly. Renews on MM/DD/YY."
              },
              "id1": {
                "price": 25.99,
                "description": "Billed monthly. Renews on MM/DD/YY."
              }
            },
            "benefits": [
              "Benefit statement 1",
              "Benefit statement 2",
              "Benefit statement 3"
            ],
            "disclaimer": "* Does not extend to E-edition or 3rd party websites such as obituaries, Marketplace, Jobs etc., or our content on social media platforms. By starting your subscription, you agree to our [Terms and Conditions](https://google.com) and [Privacy Policy](https://facebook.com)."
          }
        }
    }
    """
}
