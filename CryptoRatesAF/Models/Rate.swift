//
//  Rate.swift
//  CryptoRatesAF
//
//  Created by Владимир Беляев on 17.01.2021.
//

import Foundation

struct Rate: Decodable {
    let symbol: String?
    let name: String?
    let imageURL: String?
    let price: Double?
    let priceChangePerDay: Double?
    let priceChangePercentagePerDay: Double?
    
    enum CodingKeys: String, CodingKey {
        case symbol
        case name
        case imageURL = "image"
        case price = "current_price"
        case priceChangePerDay = "price_change_24h"
        case priceChangePercentagePerDay = "price_change_percentage_24h"
    }
}
