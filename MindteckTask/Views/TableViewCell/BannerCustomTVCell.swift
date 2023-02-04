//
//  BannerCustomTVCell.swift
//  MindteckTask
//
//  Created by Anil Pahadiya on 04/02/23.
//

import UIKit

protocol CollectionViewBannerSwipeCellDelegate: AnyObject {
    func swipeLRCollectionView(Index: Int )
}

class BannerCustomTVCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bgView: UIView!
    
    var bannerData : [String] = ["Car","Bike","Auto"]
    
    private let spacing:CGFloat = 30
    weak var cellDelegate: CollectionViewBannerSwipeCellDelegate?
    
    @IBOutlet open weak var pageControl: UIPageControl? {
        didSet {
            pageControl?.addTarget(self, action: #selector(self.pageChanged(_:)), for: .valueChanged)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Page Control
        pageControl?.numberOfPages = bannerData.count
        pageControl?.currentPage = 0
        pageControl?.transform = CGAffineTransform(scaleX: 2, y: 2)
        
        //CollectionView Cell Frame
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: collectionView.frame.width/2 + 150 , height: collectionView.frame.height  )
        flowLayout.sectionInset = UIEdgeInsets(top: spacing, left: 0  , bottom: spacing , right: 0 )
        flowLayout.minimumLineSpacing = spacing
        flowLayout.minimumInteritemSpacing = spacing
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
}

extension BannerCustomTVCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bannerData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "banner_cvcell", for: indexPath) as? BannerCollectionViewCell
        return cell!
    }
    @IBAction open func pageChanged(_ sender: UIPageControl) {
        self.cellDelegate?.swipeLRCollectionView(Index: sender.currentPage)
        self.pageControl!.currentPage = sender.currentPage
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
        print(indexPath[1])
        self.cellDelegate?.swipeLRCollectionView(Index: indexPath[1])
        self.pageControl!.currentPage = indexPath[1]
        
    }
    
    
}
