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

extension TableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            self.tableView.reloadData()
        } else {
            searchingData = data?.filter {
                $0.name?.range(of: searchBar.text!, options: [.caseInsensitive, .diacriticInsensitive ]) != nil ||
                $0.cost?.range(of: searchBar.text!, options: [.caseInsensitive, .diacriticInsensitive ]) != nil
            }
            isSearching = true
            self.tableView.reloadData()
        }
    }
}

class TableViewController: UITableViewController {
  
    @IBOutlet weak var ProductSearchBar: UISearchBar!
    
    let URL = "https://swift-fetch-json-api-test.herokuapp.com/products.json"
//    let URL = "http://localhost:3000/products.json"
    
    var data:[ProductModel]?
    var currentItem: ProductModel?
    var searchingData:[ProductModel]?
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Products"
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        ProductSearchBar.placeholder = "Search"
        ProductSearchBar.delegate = self
        
        self.getProducts()
        self.addRefreshControl()
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to reload!")
        refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    @objc func refreshData() {
        self.getProducts()
        refreshControl?.endRefreshing()
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
        if isSearching {
            return searchingData?.count ?? 0
        } else {
            return data?.count ?? 0
        }
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
          as! HeadlineTableViewCell
        
        if isSearching {
            let image = Foundation.URL(string: "\(searchingData![indexPath.row].avatar!)")
            let imageUrl = ImageResource(downloadURL: image!, cacheKey: "imageCache")
            
            cell.HeadLineImageView.kf.setImage(with:  imageUrl)
            cell.HeadLineTextLabel?.text = searchingData![indexPath.row].name!
            cell.HeadLineCostLabel?.text = searchingData![indexPath.row].cost!
        } else {
            let image = Foundation.URL(string: "\(data![indexPath.row].avatar!)")
            let imageUrl = ImageResource(downloadURL: image!, cacheKey: "imageCache")
            
            cell.HeadLineImageView.kf.setImage(with:  imageUrl)
            cell.HeadLineTextLabel?.text = data![indexPath.row].name!
            cell.HeadLineCostLabel?.text = "$\(data![indexPath.row].cost!)"
        }
      
        return cell
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            currentItem = searchingData![indexPath.row]
        } else {
            currentItem = data![indexPath.row]
        }
        
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
