//
//  XNFastReadAnimatorCollectionViewLayout.swift
//  xndm_proj
//
//  Created by helinyu on 2020/11/29.
//  Copyright © 2020 Linfeng Song. All rights reserved.
//

import Foundation

class XNFastReadAnimatorCollectionViewLayout: UICollectionViewLayout {
    
    let itemSize:CGSize = UIScreen.main.bounds.size;
    let showNum:NSInteger = 2;
    var isBackItem:Bool = false;
    var lastLeftLength:CGFloat = 0.0
    var lastProposedContentOffsetX:CGFloat = 0.0
    var otherHidden = false;
    
    override func prepare() {
        super.prepare()
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override var collectionViewContentSize: CGSize {
        let cellCnt = self.collectionView?.numberOfItems(inSection: 0)
        return CGSize.init(width: CGFloat(CGFloat(cellCnt!) * self.itemSize.width), height: CGFloat(self.itemSize.height))
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var index:Int = 0;
        let cellCnt:Int = (self.collectionView?.numberOfItems(inSection: 0))!;
        var curIndex:Int = Int((self.collectionView?.contentOffset.x)! / self.itemSize.width);
        print("lt ---- contentoffsetx: \(String(describing: self.collectionView?.contentOffset.x)), curIndex:\(curIndex)")
        var arr = Array<UICollectionViewLayoutAttributes>()
        while index < self.showNum && curIndex < cellCnt {
            let indexPath = IndexPath.init(item: curIndex, section: 0)
            let attr:UICollectionViewLayoutAttributes? = self.layoutAttributesForItem(at: indexPath)
            if attr != nil {
                arr.append(attr!)
            }
            curIndex += 1
            index += 1
        }
        return arr;
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let cellCnt = self.collectionView?.numberOfItems(inSection: 0)
        let attrs = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        attrs.size = self.itemSize
        attrs.zIndex = -indexPath.item
        if !self.isBackItem && indexPath.item != cellCnt {
            self.isBackItem = true
            let curIndex = indexPath.item
            let leftLength:CGFloat = (self.collectionView?.contentOffset.x)! - self.itemSize.width * CGFloat(curIndex);
            self.lastLeftLength = leftLength;
//            角度
            let totalAngle = Double.pi / 2 / 2 / 2;
            let lastAngle:Float = atan2f(Float(attrs.transform.b), Float(attrs.transform.a))
            let angleRatio = leftLength / self.itemSize.width
            let angle = angleRatio * CGFloat(totalAngle)
            let detaAngle:CGFloat = CGFloat(-Float(angle) - lastAngle)
            attrs.transform = attrs.transform.rotated(by: detaAngle);

//             宽度
            let actualMoveX = leftLength - self.lastLeftLength
            let alphaDetaLength = UIScreen.main.bounds.width - leftLength
            let alphaThreadHold = CGFloat(40.0)~
            if (alphaDetaLength <= alphaThreadHold) {
                let alpha:CGFloat = alphaDetaLength * 1.0 / alphaThreadHold
                attrs.alpha = alpha
            }
            attrs.center = CGPoint.init(x: self.itemSize.width/2.0 + actualMoveX + CGFloat(curIndex) * self.itemSize.width, y: self.itemSize.height/2.0);
            attrs.isHidden = false;
            self.otherHidden = (leftLength > 0.0 ? false : true)
        }
        else {
            attrs.center = CGPoint.init(x: self.collectionView!.contentOffset.x +  self.itemSize.width/2.0, y: self.itemSize.height/2.0)
            self.isBackItem = false
            attrs.isHidden = self.otherHidden;
        }
        return attrs
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let threaHold = UIScreen.main.bounds.width / 2.0 - 17≈
        var offsetX = self.lastProposedContentOffsetX;
        if proposedContentOffset.x > self.lastProposedContentOffsetX {
            let detaX = proposedContentOffset.x - self.lastProposedContentOffsetX
            if detaX > threaHold {
                offsetX += UIScreen.main.bounds.width
            }
        }
        else {
            let detaX = self.lastProposedContentOffsetX - proposedContentOffset.x
            if (detaX > threaHold) {
                offsetX = self.lastProposedContentOffsetX - UIScreen.main.bounds.width
            }
        }
        self.lastProposedContentOffsetX = offsetX
        print("lt -- target content offset:\(proposedContentOffset), offsetx:\(offsetX)")
        return CGPoint.init(x: offsetX, y: proposedContentOffset.y)
    }
}
