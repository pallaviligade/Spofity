//
//  ProfileViewController.swift
//  Spofity
//
//  Created by Pallavi on 14/07/21.
//

import UIKit
import SDWebImage
class ProfileViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
   
    
    private let tableview : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return table
    }()
    private var models = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableview)
        tableview.delegate = self
        tableview .dataSource = self
        title = "Profile"
      
        view.backgroundColor = .systemBackground
        fetchProfile()
        

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableview.frame = view.bounds
    }
    private func fetchProfile(){
        APIManager.shared.getcurrentUserProfile { result in
            DispatchQueue.main.async {
                switch result{
                    case .success(let model):
                        self.updateUI(with: model)
                      break
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.failedTogetProfile()
                        break
                    
                }
            }
        }

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    private func updateUI(with Model:UserProfile){
        tableview.isHidden = false
        models.append("Full name :\(Model.display_name)")
        models.append("User Email :\(Model.email)")
        models.append("User ID :\(Model.id)")
        models.append("Plan :\(Model.product)")

        createTableHeader(with:Model.images.first?.url)
        tableview.reloadData()
        
    }
    private func createTableHeader(with string:String?){
        guard let urlstring = string, let url = URL(string: urlstring) else {
            return
            
        }
        
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        let imagesize : CGFloat = headerview.height/2
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: imagesize, height: imagesize))
        headerview.addSubview(imageview)
        imageview.contentMode = .scaleAspectFit
        imageview.sd_setImage(with: url, completed: nil)
        imageview.layer.masksToBounds = true
        imageview.layer.cornerRadius = imagesize/2
        tableview.tableHeaderView = headerview
    }
    private func failedTogetProfile(){
        tableview.isHidden = true

        let lable = UILabel(frame: .zero)
        lable.text = "Faild to load Profile"
        lable.sizeToFit()
        lable.textColor = .secondaryLabel
        view.addSubview(lable)
        lable.center = view.center
        
    }

  

}
