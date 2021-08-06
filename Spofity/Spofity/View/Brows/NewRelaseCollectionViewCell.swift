//
//  NewRelaseCollectionViewCell.swift
//  Spofity
//
//  Created by Pallavi on 01/08/21.
//

import UIKit
import SDWebImage
class NewRelaseCollectionViewCell: UICollectionViewCell {
    static let identifier = "NewRelaseCollectionViewCell"
    
    private let albumCoverImage : UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(systemName: "photo")
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private let albumNameLabel : UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 20, weight: .semibold)
        name.numberOfLines = 0

        return name
    }()
    private let numberOfTracksLabel : UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 15, weight: .light)
        name.numberOfLines = 0
        return name
    }()
    private let artistNameLabel : UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 17, weight: .regular)
        name.numberOfLines = 0

        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(albumNameLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(albumCoverImage)

        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .secondarySystemBackground

        let imageSize:CGFloat = contentView.height - 10

        let albumlabelSize = albumNameLabel.sizeThatFits(CGSize(width: contentView.width - imageSize - 10, height: contentView.height - 10))
        artistNameLabel.sizeToFit()
        numberOfTracksLabel.sizeToFit()
        
        albumCoverImage.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        
        albumNameLabel.frame = CGRect(x: albumCoverImage.right + 10, y: 5  , width: albumlabelSize.width, height: min(50, albumlabelSize.height))
        
        artistNameLabel.frame = CGRect(x: albumCoverImage.right + 10, y: albumNameLabel.bottom  , width: contentView.width - albumCoverImage.right - 5, height: min(30, albumlabelSize.height))

        numberOfTracksLabel.frame = CGRect(x: albumCoverImage.right + 10, y: contentView.bottom - 44 , width: numberOfTracksLabel.width + 3, height: 44)

       
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImage.image = nil
    }
   
    func configaureViewmodel(with ViewModel:NewReleaseCellViewModel) {
        albumNameLabel.text = ViewModel.name
        artistNameLabel.text = ViewModel.artistName
        numberOfTracksLabel.text = ("Tracks :\(ViewModel.numberofTracks)")
        albumCoverImage.sd_setImage(with: ViewModel.artworkURL, completed: nil)
        
    }
}
