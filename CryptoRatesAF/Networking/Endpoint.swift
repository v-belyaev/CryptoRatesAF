//
//  Endpoint.swift
//  CryptoRatesAF
//
//  Created by Владимир Беляев on 17.01.2021.
//

import Foundation

enum Endpoint {
    case rates(currency: String, itemAmount: Int)
    case ping
    
    var url: URL {
        switch self {
        case .rates(let currency, let itemAmount):
            return .makeForEndpoint(
                "coins/markets?" +
                "vs_currency=\(currency)&" +
                "order=market_cap_desc&" +
                "per_page=\(itemAmount)&" +
                "page=1&" +
                "sparkline=false")
        case .ping:
            fallthrough
        @unknown default:
            return .makeForEndpoint("ping/")
        }
    }
}
