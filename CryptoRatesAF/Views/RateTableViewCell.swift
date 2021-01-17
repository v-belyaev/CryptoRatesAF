//
//  RateTableViewCell.swift
//  CryptoRatesAF
//
//  Created by Владимир Беляев on 17.01.2021.
//

import UIKit
import Alamofire

final class RateTableViewCell: UITableViewCell {

    static let identifier = "RateTableViewCell"

    @IBOutlet private(set) var cryptoImage: UIImageView!
    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var subtitleLabel: UILabel!
    @IBOutlet private(set) var priceLabel: UILabel!
    
    func configure(with rate: Rate) {
        guard let name = rate.name,
              let symbol = rate.symbol,
              let price = rate.price else {
            return
        }
        
        titleLabel.text = name
        subtitleLabel.text = symbol.uppercased()
        priceLabel.text = "\(price) $"
        
        if let imageURL = rate.imageURL, let url = URL(string: imageURL) {
            loadImage(url: url)
        }
    }
    
    func loadImage(url: URL) {
        AF.request(url)
          .validate()
          .response { (response) in
            guard let imageData = response.data else { return }
            DispatchQueue.main.async {
                self.cryptoImage.image = UIImage(data: imageData)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cryptoImage.image = nil
    }

}
