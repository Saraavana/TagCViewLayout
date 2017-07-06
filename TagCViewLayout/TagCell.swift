//
//  TagCell.swift
//  TagCViewLayout
//
//  Created by Saravana on 26/05/17.
//  Copyright © 2017 Tennibs. All rights reserved.
//

import UIKit

class TagCell: UICollectionViewCell
{
  @IBOutlet weak var tagView: UIView!
  @IBOutlet weak var removeTagBtn: UIButton!
  @IBOutlet weak var tagNameLbl: UILabel!
  

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        self.tagView.layer.cornerRadius = 15
    }

}
