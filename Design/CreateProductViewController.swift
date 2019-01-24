//
//  CreateProductViewController.swift
//  Design
//
//  Created by Parinha on 1/24/19.
//  Copyright © 2019 Parinha. All rights reserved.
//

import UIKit
import Alamofire

class CreateProductViewController: UIViewController {


    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    let URL = "https://swift-fetch-json-api-test.herokuapp.com/products"
//    let URL = "http://localhost:3000/products"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func createButton(_ sender: Any) {
        let productName = nameTextField.text
        let productCost = (costTextField.text! as NSString).doubleValue
        let productDescription = descriptionTextField.text
        
        if (productName!.isEmpty || productDescription!.isEmpty) {
            
            let alert = UIAlertController(title: "Warning!", message: "Please enter your information!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                }}))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            let parameters: Parameters = [
                "product[name]": productName!,
                "product[cost]": productCost,
                "product[description]": productDescription!,
                "product[avatar]": "https://via.placeholder.com/300"
            ]
            
            Alamofire.request(URL, method: .post, parameters: parameters, encoding: URLEncoding.default)
                .validate().responseString { response in
                    switch response.result {
                        case .success:
                            print("Validation Successful")
                            self.navigationController?.popViewController(animated: true)
                        
                        case .failure(let error):
                            print("Validation error")
                            print(error)
                    }
                }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
