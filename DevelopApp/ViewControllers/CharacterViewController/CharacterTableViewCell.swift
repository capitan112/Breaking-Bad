//
//  CharacterTableViewCell.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import SDWebImage
import UIKit

class CharacterTableViewCell: UITableViewCell {
    static let reuseIdentifierCell = "CharacterCellID"
    @IBOutlet var characterImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!

    var viewModel: CharacterCellViewModelType? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        characterImageView.layer.cornerRadius = 5
        characterImageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        characterImageView.image = nil
        nameLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        characterImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(named: "placeholder.png"))
        nameLabel.text = viewModel.name
    }
}
