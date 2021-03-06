//
//  WelcomeViewController.swift
//  Spofity
//
//  Created by Pallavi on 14/07/21.
//

import UIKit
class WelcomeViewController: UIViewController {

    private let signInbutton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitle("Login In Spotify", for: .normal)
        btn.setTitleColor(.brown, for: .normal)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
         title = "Spotify"
         view.backgroundColor = .systemPink
         view.addSubview(signInbutton)
         signInbutton.addTarget(self, action: #selector(signedInButtonTapped), for: .touchUpInside)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInbutton.frame = CGRect(x: 20,
                                    y: view.height-50-view.safeAreaInsets.bottom,
                                    width: view.width - 40,
                                    height: 50)
    }
    
    @objc func signedInButtonTapped(){
       let vc  = AuthViewController()
        vc.complicationHandler = { [weak self] success in
            
            DispatchQueue.main.async {
                self?.handleSignIn(sucess: success)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    private func handleSignIn(sucess:Bool){
        // signIn or show error
        guard sucess else {
            let alert = UIAlertController(title: "Oops",
                                          message: "Something went wrong!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        let maintabbar = TabBarViewController()
        maintabbar.modalPresentationStyle = .fullScreen
        present(maintabbar, animated: true)
        
    }

  
}
