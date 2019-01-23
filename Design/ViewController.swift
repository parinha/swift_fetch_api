//
//  ViewController.swift
//  Design
//
//  Created by Parinha on 1/22/19.
//  Copyright © 2019 Parinha. All rights reserved.
//

import UIKit
import Kingfisher
import Foundation

class ViewController: UIViewController {
  
    @IBOutlet weak var ProductImageView: UIImageView!
    @IBOutlet weak var ProductNameLabel: UILabel!
    @IBOutlet weak var ProductDescriptionLabel: UITextView!
    @IBOutlet weak var ProductCostLabel: UILabel!
    
    var product:ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        textView.text = product?.name
        
        let image = Foundation.URL(string: product?.avatar! ?? "")
        let imageUrl = ImageResource(downloadURL: image!,cacheKey: "productImage")
        
        ProductImageView.kf.setImage(with:  imageUrl)
        
        ProductNameLabel.text = product?.name
        ProductCostLabel.text = product?.cost
        ProductDescriptionLabel.text = product?.description
    }
    
}

