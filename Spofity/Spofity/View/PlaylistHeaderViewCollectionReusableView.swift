//
//  PlaylistHeaderViewCollectionReusableView.swift
//  Spofity
//
//  Created by Pallavi on 06/08/21.
//

import UIKit
import SDWebImage
final class PlaylistHeaderViewCollectionReusableView: UICollectionReusableView {
        static let identifier = "PlaylistHeaderViewCollectionReusableView"
    private var nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white

        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private var discriptionLabel:UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    private var ownerLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()
    private var imageview:UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.image = UIImage(systemName: "photo")
        return imageview
    }()
    private let platAllButton : UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .systemGreen
        let image = UIImage(systemName: "play.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular))

        btn.setImage(image, for: .normal)
        btn.tintColor = .white
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        return btn
    }()
    // MARK - INIR
    override init(frame: CGRect) {
        super.init(frame: frame)
       // backgroundColor = .red
        addSubview(imageview)
        addSubview(ownerLabel)
        addSubview(nameLabel)
        addSubview(discriptionLabel)
        addSubview(platAllButton)
        platAllButton.addTarget(self, action: #selector(didTapButtonAll), for: .touchUpInside)
    }
    @objc func didTapButtonAll(){
        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagesize :CGFloat = height/1.5
        imageview.frame = CGRect(x: (width-imagesize)/2, y: 20, width: imagesize, height: imagesize)
        nameLabel.frame = CGRect(x: 10, y: imageview.bottom, width: width - 20, height: 44)
        discriptionLabel.frame = CGRect(x: 10, y: nameLabel.bottom, width: width - 20, height: 44)
        ownerLabel.frame = CGRect(x: 10, y: discriptionLabel.bottom, width: width - 20, height: 44)
        platAllButton.frame = CGRect(x: width - 80, y: height - 80, width: 70, height: 50)
        
    }
    func configaure(with viewmodel:PlaylistHeaderViewModel){
        self.nameLabel.text = viewmodel.playlistname
        self.ownerLabel.text = viewmodel.ownername
        self.discriptionLabel.text = viewmodel.discription
        self.imageview.sd_setImage(with: viewmodel.artwork, completed: nil)
    }
    
}
