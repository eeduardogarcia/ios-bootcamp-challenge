//
//  CardView.swift
//  iOS Bootcamp Challenge
//
//  Created by Marlon David Ruiz Arroyave on 28/09/21.
//

import UIKit

class CardView: UIView {

    private let margin: CGFloat = 30
    var card: Card?

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var abilitiesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var baseExperienceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    required init(card: Card) {
        self.card = card
        super.init(frame: .zero)
        setup()
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
        setupUI()
    }

    private func setup() {
        guard let card = card else { return }

        titleLabel.text = card.title
        backgroundColor = .white
        layer.cornerRadius = 20
        
        //Abilities
        abilitiesLabel.text = card.items[0].title + ": \n"
        
        for ability in card.items[0].description {
            abilitiesLabel.text?.append(ability.description)
        }
        
        //Weight
        weightLabel.text = card.items[1].title + ": \n" + card.items[1].description
        //Exp
        baseExperienceLabel.text = card.items[2].title + ": \n" + card.items[2].description
    }

    private func setupUI() {
        addSubview(titleLabel)
        addSubview(abilitiesLabel)
        addSubview(weightLabel)
        addSubview(baseExperienceLabel)
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: margin * 2).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        titleLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.70).isActive = true

        abilitiesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24).isActive = true
        abilitiesLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        abilitiesLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.70).isActive = true
        
        weightLabel.topAnchor.constraint(equalTo: abilitiesLabel.bottomAnchor, constant: 0).isActive = true
        weightLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        weightLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.70).isActive = true
        
        baseExperienceLabel.topAnchor.constraint(equalTo: weightLabel.bottomAnchor, constant: 16).isActive = true
        baseExperienceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: margin).isActive = true
        baseExperienceLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.70).isActive = true
    }

}
