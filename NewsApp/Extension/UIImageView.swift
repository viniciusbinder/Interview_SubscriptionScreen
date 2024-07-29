//
//  UIImage+URL.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import UIKit

extension UIImageView {
    func loadFromURL(_ urlString: String) {
        self.image = nil

        guard let url = URL(string: urlString) else {
            print("Error loading URL")
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            if let error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }

            if let data {
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data) {
                        self.image = downloadedImage
                    }
                }
            }
        }).resume()
    }
}
