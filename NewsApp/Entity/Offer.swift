//
//  Offer.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import CoreData

@objc(Offer)
public class Offer: NSManagedObject, Decodable {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Offer> {
        return NSFetchRequest<Offer>(entityName: "Offer")
    }

    @NSManaged var price: String
    @NSManaged var information: String

    enum CodingKeys: String, CodingKey {
        case price
        case information = "description"
    }

    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.price = try container.decode(String.self, forKey: .price)
        self.information = try container.decode(String.self, forKey: .information)
    }
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
