//
//  ViewController.swift
//  TagCViewLayout
//
//  Created by Saravana on 26/05/17.
//  Copyright © 2017 Tennibs. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
  //MARK: -Outlets
  @IBOutlet weak var collectionView: UICollectionView!
  
  //MARK: -Variables
  var tags = ["Swift","Lorem ipsum dolor sit amet, consectetur adipiscing elit","iOS 10.3","Objective-C","Virtual Reality","Material Design","App Store","iTunes","Sed ut perspiciatis unde omnis iste natus error sit voluptatem","Android","Animations","Sketch"]
  
  //MARK: -View Methods
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    self.collectionView.register(UINib(nibName: "TagCell", bundle: nil), forCellWithReuseIdentifier: "TagCell")
    
    if let layout = collectionView.collectionViewLayout as? TagCViewLayout
    {
      layout.delegate = self
    }
    collectionView.dataSource = self
  }
  
  //MARK: -Selector Actions
  func removeBtnTapped(sender :UIButton)
  {
    if let cell = sender.superview?.superview?.superview as? TagCell,let indexPath = collectionView.indexPath(for: cell)
    {
      self.removeTag(indexPath: indexPath)
    }
  }
  
  
  //MARK: -Helper Methods
  func removeTag(indexPath: IndexPath)
  {
    self.tags.remove(at: indexPath.row)
    self.collectionView.performBatchUpdates({
      self.collectionView.deleteItems(at: [indexPath])
    }, completion: nil)
  }
}

//MARK: -UICollectionViewDataSource
extension ViewController : UICollectionViewDataSource
{
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
  {
    return tags.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
  {
   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath) as! TagCell
   
   cell.tagNameBtn.setTitle(tags[indexPath.row], for: .normal)
   cell.removeTagBtn.addTarget(self, action: #selector(self.removeBtnTapped(sender:)), for: .touchUpInside)
    
   return cell
  }
}

//MARK: -TagCViewLayoutDelegate
extension ViewController : TagCViewLayoutDelegate
{
  func collectionView(collectionView: UICollectionView, widthForTagsAtIndexPath indexPath: IndexPath, withHeight: CGFloat) -> CGFloat
  {
    let lbl = UILabel(frame: view.frame)
    lbl.text = self.tags[indexPath.row]
    lbl.sizeToFit()
    return lbl.frame.size.width + 53
  }
}

