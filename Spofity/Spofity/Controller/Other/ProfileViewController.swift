//
//  ProfileViewController.swift
//  Spofity
//
//  Created by Pallavi on 14/07/21.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Profile"
        
        APIManager.shared.getcurrentUserProfile { result in
            switch result{
                case .success(let model):
                  break
                case .failure(let error):
                    print(error.localizedDescription)
                    break
                
            }
        }


    }
    

  

}
