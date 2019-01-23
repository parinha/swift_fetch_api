//
//  TableViewController.swift
//  Design
//
//  Created by Parinha on 1/22/19.
//  Copyright © 2019 Parinha. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import Kingfisher
import Foundation


class HeadlineTableViewCell: UITableViewCell {

  @IBOutlet weak var HeadLineTextLabel: UILabel!
  @IBOutlet weak var HeadLineCostLabel: UILabel!
  @IBOutlet weak var HeadLineImageView: UIImageView!
}

class TableViewController: UITableViewController {
  
    let URL = "https://swift-fetch-json-api-test.herokuapp.com/products.json"
    
    var data:[ProductModel]?
    var currentItem: ProductModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Products"
        self.getProducts()
    }
  
    func getProducts() {
      Alamofire.request(URL).responseArray { (response: DataResponse<[ProductModel]>) in
        self.data = response.result.value
        
        self.tableView.reloadData()
      }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
          as! HeadlineTableViewCell
      
        let image = Foundation.URL(string: "\(data![indexPath.row].avatar!)")
        let imageUrl = ImageResource(downloadURL: image!, cacheKey: "imageCache")

        cell.HeadLineImageView.kf.setImage(with:  imageUrl)
        cell.HeadLineTextLabel?.text = data![indexPath.row].name!
        cell.HeadLineCostLabel?.text = data![indexPath.row].cost!
      
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentItem = data![indexPath.row]
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let viewController = segue.destination as? ViewController {
        viewController.product = currentItem
      }
    }
}

class ProductModel: Mappable {
  var id: Int?
  var name: String?
  var description: String?
  var qty: String?
  var cost: String?
  var avatar: String?
  
  required init?(map: Map){
    
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    description <- map["description"]
    qty <- map["qty"]
    cost <- map["cost"]
    avatar <- map["avatar"]
  }
}
