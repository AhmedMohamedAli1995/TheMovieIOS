//
//  ReviewsViewController.swift
//  Online Movies
//
//  Created by Sayed Abdo on 4/13/18.
//  Copyright © 2018 jets. All rights reserved.
//

import UIKit

class ReviewsViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
   
    var arrayOfAuthor:[String] = []
    var arrayOfContent:[String] = []
  

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return arrayOfAuthor.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = arrayOfAuthor[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Reviews"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(mess: arrayOfContent[indexPath.row], tit: arrayOfAuthor[indexPath.row])
    }
    
    func showAlert( mess : String , tit : String){
        let alert = UIAlertController(title: tit, message: mess, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
            print(" \(mess) ")
            
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
 
    
    

}
