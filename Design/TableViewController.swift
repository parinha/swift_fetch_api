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

class TableViewController: UITableViewController {
  
    let URL = "http://localhost:3000/products.json"
//    var productNameArray = ["hi", "hello"]
    var productNameArray = [String]()
  
    var currentItem = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Products"
        self.getProducts()
    }
  
    func getProducts() {
      Alamofire.request(URL).responseArray { (response: DataResponse<[ProductModel]>) in
        let forecastArray = response.result.value
        if let forecastArray = forecastArray {
          for product in forecastArray {
            let productName:String? = product.name
            print(productName)
            self.productNameArray.append("\(productName ?? " ")")
            
            self.tableView.reloadData()
          }
        }
      }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productNameArray.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    
        cell.textLabel?.text = productNameArray[indexPath.row]
        print(productNameArray[indexPath.row])
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      currentItem = productNameArray[indexPath.row]
      print("productArray:", productNameArray)
      performSegue(withIdentifier: "showDetail", sender: nil)
    }
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let viewController = segue.destination as? ViewController {
        viewController.text = currentItem
      }
    }
}

class ProductModel: Mappable {
  var id: Int?
  var name: String?
  var description: String?
  var qty: Decimal?
  var cost: Decimal?
  
  required init?(map: Map){
    
  }
  
  func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    description <- map["description"]
    qty <- map["qty"]
    cost <- map["cost"]
  }
}
