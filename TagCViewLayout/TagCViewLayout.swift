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
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight :CGFloat = 0.0
    private var tagExtraWidth: CGFloat = 0.0
    private var contentWidth :CGFloat {
        let inset = self.collectionView!.contentInset
        return collectionView!.bounds.width - (inset.left + inset.right) + tagExtraWidth
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
                
                if let width = delegate?.collectionView(collectionView: collectionView!, widthForTagsAtIndexPath: indexPath, withHeight: CGFloat(height))
                {
                
                    if width == self.maxTagWidth() {
                        self.tagExtraWidth = width - (collectionView?.bounds.width)!
                    }
                    else if self.maxTagWidth() < (collectionView?.bounds.width)! {
                        self.tagExtraWidth = 0.0
                    }
                    
                    
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
        
        return CGSize(width: contentWidth , height: contentHeight)
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
    
    private func maxTagWidth() -> CGFloat {
        
        let indexPath1 = IndexPath(item: 0, section: 0)
        
        let height = cellPadding + 30 + cellPadding
        var maxTagWidh = (delegate?.collectionView(collectionView: collectionView!, widthForTagsAtIndexPath: indexPath1, withHeight: CGFloat(height)))!
        
        for item in 0..<collectionView!.numberOfItems(inSection: 0){
            let indexPath = IndexPath(item: item, section: 0)
            
            if let width = delegate?.collectionView(collectionView: collectionView!, widthForTagsAtIndexPath: indexPath, withHeight: CGFloat(height)) {
                
                if width > maxTagWidh {
                    maxTagWidh = width
                }
                
            }
        }
        return maxTagWidh
    }
}
