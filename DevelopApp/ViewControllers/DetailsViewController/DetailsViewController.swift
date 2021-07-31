//
//  DetailsViewController.swift
//  DevelopApp
//
//  Created by Oleksiy Chebotarov on 16/03/2021.
//

import SDWebImage
import UIKit

class DetailsViewController: UIViewController, Storyboarded {
    @LazyInjected var viewModel: DetailsViewModelType
    @IBOutlet var imageName: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var occupationLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var seasonAppearanceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        updateUI()
    }

    private func configUI() {
        imageName.layer.cornerRadius = 5
        imageName.clipsToBounds = true
    }

    private func updateUI() {
        imageName.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(named: "placeholder.png"))
        nameLabel.text = viewModel.name
        occupationLabel.text = viewModel.occupation
        statusLabel.text = viewModel.status
        nicknameLabel.text = viewModel.nickname
        seasonAppearanceLabel.text = viewModel.seasonAppearance
    }
}
