//
//  TripCollectionViewCell.swift
//  9-TripCard
//
//  Created by Влад Динеев on 31.01.2021.
//

import UIKit

protocol TripCollectionCellDelegate {
    func didLikeButtonPressed(cell: TripCollectionViewCell)
}

class TripCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var totalDaysLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBAction func likeButtonTapped(sender: AnyObject){
        delegate?.didLikeButtonPressed(cell: self)
    }
    var delegate: TripCollectionCellDelegate?
    var isLiked: Bool = false {
        didSet {
            if isLiked {
                likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            } else {
                likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
}
