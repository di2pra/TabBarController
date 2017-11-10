//
//  PageBarMenuView.swift
//  TabBarController
//
//  Created by Pradheep Rajendirane on 02/11/2017.
//  Copyright © 2017 Pradheep Rajendirane. All rights reserved.
//

import UIKit

class PageBarMenuView: UIScrollView {
    
    var containerView: UIView! = UIView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        
        let label1 = UILabel(frame: .zero)
        label1.text = "Premier"
        label1.backgroundColor = .green
        label1.sizeToFit()
        label1.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label1)
        
        NSLayoutConstraint.activate([
            label1.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            label1.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0)
        ])
        
        let label2 = UILabel(frame: .zero)
        label2.text = "Deuxieme"
        label2.backgroundColor = .yellow
        label2.sizeToFit()
        label2.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label2)
        
        NSLayoutConstraint.activate([
            label2.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 10),
            label2.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0)
            ])
        
        let label3 = UILabel(frame: .zero)
        label3.text = "Troisieme"
        label3.backgroundColor = .brown
        label3.sizeToFit()
        label3.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label3)
        
        NSLayoutConstraint.activate([
            label3.leadingAnchor.constraint(equalTo: label2.trailingAnchor, constant: 10),
            label3.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 0)
            ])
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
