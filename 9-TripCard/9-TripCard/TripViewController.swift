//
//  ViewController.swift
//  9-TripCard
//
//  Created by Влад Динеев on 31.01.2021.
//

import UIKit

class TripViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TripCollectionViewCell
        // configure cell
        cell.cityLabel.text = trips[indexPath.row].city
        cell.countryLabel.text = trips[indexPath.row].country
        cell.imageView.image = trips[indexPath.row].featuredImage
        cell.priceLabel.text = "$\(String(trips[indexPath.row].price))"
        cell.totalDaysLabel.text = "\(trips[indexPath.row].totalDays) days"
        cell.isLiked = trips[indexPath.row].isLiked
        
        // round corner
        cell.layer.cornerRadius = 4.0
        return cell
    }
    
    private var trips = [
        Trip(tripId: "Paris001", city: "Paris", country: "France", featuredImage: UIImage(named: "paris"), price: 2000, totalDays: 5, isLiked: false),
        Trip(tripId: "Rome001", city: "Rome", country: "Italy", featuredImage: UIImage(named: "rome"), price: 800, totalDays: 3, isLiked: false),
        Trip(tripId: "Istanbul001", city: "Istanbul", country: "Turkey", featuredImage: UIImage(named: "istanbul"), price: 2200, totalDays: 10, isLiked: false)
    ]
    
    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.backgroundColor = UIColor.clear
    }


}

