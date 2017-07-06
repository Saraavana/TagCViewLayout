//
//  TagCViewLayout.swift
//  TagCViewLayout
//
//  Created by Saravana on 26/05/17.
//  Copyright © 2017 Tennibs. All rights reserved.
//

import Foundation

import UIKit

//MARK: -Tags Custom Delegate
protocol TagCViewLayoutDelegate
{
  func collectionView(collectionView:UICollectionView, widthForTagsAtIndexPath indexPath:IndexPath,
                      withHeight:CGFloat) -> CGFloat
}

class TagCViewLayout: UICollectionViewLayout
{
  //MARK: -Variables
  var delegate :TagCViewLayoutDelegate?
  
  var cellPadding = 7
  var exceededWidth = CGFloat()
  
  var widenRow = Int()
  
  private var cache = [UICollectionViewLayoutAttributes]()
  private var contentHeight :CGFloat = 0.0
  private var contentWidth :CGFloat {
    let inset = self.collectionView!.contentInset
    return collectionView!.bounds.width - (inset.left + inset.right)
  }
  
  
  override func prepare()
  {
    if cache.isEmpty
    {
      var xOffset = [CGFloat]()
      var prevTagWidth = CGFloat()
      var column = 0
      var row = 0
      
      var yOffset  = [CGFloat]()
      for item in 0..<collectionView!.numberOfItems(inSection: 0)
      {
        let indexPath = IndexPath(item: item, section: 0)
        
        let height = cellPadding + 30 + cellPadding
        
        if let cView = self.collectionView,let width = delegate?.collectionView(collectionView: cView, widthForTagsAtIndexPath: indexPath, withHeight: CGFloat(height))
        {
          
          var xOff = CGFloat()
          var yOff = CGFloat()
          
          if column == 0
          {
            xOff = 0
            prevTagWidth = width
          }
          else
          {
            let reversedOffset = Array(xOffset.reversed())
            
            if let prevOffset = reversedOffset.first
            {
              xOff = prevOffset + CGFloat(cellPadding) + prevTagWidth
              prevTagWidth = width
            }
            
            if xOff+width >= contentWidth
            {
              prevTagWidth = width
              xOff = 0
              row += 1
            }
          }
          
          xOffset.append(xOff)
          yOff = CGFloat(row) * CGFloat(height)
          yOffset.append(yOff)

          
          if let cViewWidth = collectionView?.bounds.width, width > cViewWidth {
            exceededWidth = width - cViewWidth > exceededWidth ? width - cViewWidth : exceededWidth
          }

          let cViewWidth = cView.bounds.width
          if width > cViewWidth {
            exceededWidth = width - cViewWidth > exceededWidth ? width - cViewWidth : exceededWidth
          }
          
          let frame = CGRect(x: xOffset[column], y: yOffset[column], width: width, height: CGFloat(height))
          let insetFrame = frame.insetBy(dx: CGFloat(cellPadding), dy: CGFloat(cellPadding))
          
          let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
          attributes.frame = insetFrame
          
          cache.append(attributes)
          contentHeight = max(contentHeight, frame.maxY)
          column = xOffset[column] >= contentWidth ? 0 : column+1
        }
        
      }
    }
  }
  
  override var collectionViewContentSize: CGSize
  {
    return CGSize(width: contentWidth+exceededWidth, height: contentHeight)
  }
  
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
  {
    var layoutAttributes = [UICollectionViewLayoutAttributes]()
    
    cache.removeAll()
    self.prepare()
    
    for eachAttr in cache
    {
      if eachAttr.frame.intersects(rect)
      {
        layoutAttributes.append(eachAttr)
      }
    }
    return layoutAttributes
  }
}
