//
//  RecommendedCollectionViewCell.swift
//  Spofity
//
//  Created by Pallavi on 01/08/21.
//

import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedCollectionViewCell"
    private let albumCoverImageview : UIImageView = {
        let imageview = UIImageView()
        imageview.layer.cornerRadius = 8
        imageview.image = UIImage(systemName: "photo")
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private let TrackNameLabel : UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 18, weight: .regular)
        name.numberOfLines = 0
        name.textAlignment = .left
        return name
    }()
   
    private let artistNameLabel : UILabel = {
        let name = UILabel()
        name.font = .systemFont(ofSize: 15, weight: .thin)
        name.numberOfLines = 0
        name.textAlignment = .left

        return name
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(TrackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        contentView.addSubview(albumCoverImageview)

        
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        albumCoverImageview.frame = CGRect(x: 3, y: 2, width: contentView.height - 4, height: contentView.height - 4)
        backgroundColor = .secondarySystemBackground
        TrackNameLabel.frame = CGRect(x: albumCoverImageview.right + 10, y: 0, width: contentView.width - albumCoverImageview.right - 15, height: contentView.height/2)
        artistNameLabel.frame = CGRect(x: albumCoverImageview.right + 10, y: contentView.height/2, width: contentView.width - albumCoverImageview.right - 15, height: contentView.height/2)
        
        
        
        
    }
    func configaureViewmodel(with ViewModel:RecommendedTrackCellViewModel) {
        TrackNameLabel.text = ViewModel.name
        artistNameLabel.text = ViewModel.artistName
        albumCoverImageview.sd_setImage(with: ViewModel.artworkURL, completed: nil)
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        TrackNameLabel.text = nil
        artistNameLabel.text = nil
        albumCoverImageview.image = nil
    }

}
