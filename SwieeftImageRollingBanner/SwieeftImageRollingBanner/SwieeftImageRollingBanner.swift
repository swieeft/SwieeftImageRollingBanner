//
//  RollingBanner.swift
//  SwieeftImageRollingBanner
//
//  Created by Park GilNam on 2020/04/08.
//  Copyright © 2020 swieeft. All rights reserved.
//

import UIKit

protocol SwieeftImageRollingBannerDelegate: class {
    func tapImage(index: Int)
}

class SwieeftImageRollingBanner: UIView {
    fileprivate var scrollView: UIScrollView!
    fileprivate var pageLabel: UILabel!
    fileprivate var imageViews: [UIImageView] = []
    fileprivate var timer = Timer()
    
    var imageUrls: [String] = [] {
        didSet {
            addImageView()
            downloadImages()
            setIndexNumber(index: 0)
            startTimer()
        }
    }
    
    var imageContentMode: UIView.ContentMode = .scaleAspectFit
    
    var placeholderImage: UIImage?
    
    let timerInterval: TimeInterval = 3.0
    
    weak var delegate: SwieeftImageRollingBannerDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setScrollView()
        setPageLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setScrollView()
        setPageLabel()
    }
    
    private func setScrollView() {
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(scrollView)
        
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setPageLabel() {
        pageLabel = UILabel()
        pageLabel.textColor = .white
        pageLabel.text = "0/0"
        
        self.addSubview(pageLabel)
        
        pageLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: self.trailingAnchor, multiplier: 20).isActive = true
        pageLabel.bottomAnchor.constraint(equalToSystemSpacingBelow: self.bottomAnchor, multiplier: 20).isActive = true
    }
    
    private func addImageView() {
        guard imageViews.count == 0 else {
            return
        }
        
        let imageViewCount = imageUrls.count + 2 // 한쪽 방향으로 무한 스크롤이 되게 하기 위해 더미 이미지 뷰 2개를 더 생성함
        
        var newFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
        
        let scrollViewSize = scrollView.frame.size
        
        for index in 0..<imageViewCount {
            newFrame.origin.x = scrollViewSize.width * CGFloat(index)
            newFrame.size = scrollViewSize
            
            let imageView = UIImageView(frame: newFrame)
            imageView.contentMode = imageContentMode
            imageView.image = placeholderImage
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapImage))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tapGesture)
        }
    }
    
    private func setIndexNumber(index: Int) {
        pageLabel.text = "\(index + 1)/\(imageUrls.count)"
    }
    
    @objc private func onTapImage(sender: UITapGestureRecognizer) {
        let index = (Int(scrollView.contentOffset.x / scrollView.bounds.width)) - 1
        
        delegate?.tapImage(index: index)
    }
    
    private func downloadImages() {
        for i in 0..<imageViews.count {
            var urlStr = ""
            if i == 0 {
                urlStr = imageUrls.last ?? ""
            } else if i == imageViews.count - 1 {
                urlStr = imageUrls.first ?? ""
            } else {
                urlStr = imageUrls[i - 1]
            }
            
            imageViews[i].imageDownload(link: urlStr)
        }
    }
    
    private func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true, block: { _ in
          
            let index = Int(self.scrollView.contentOffset.x / self.scrollView.bounds.width)
            var nextIndex = index + 1

            if nextIndex == self.imageViews.count {
                nextIndex = 0
            }
            
            let newOffset = CGFloat(nextIndex) * CGFloat(self.scrollView.bounds.width)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.contentOffset.x = newOffset
            }) { (_) in
                self.infiniteScroll()
            }
        })
    }
    
    fileprivate func infiniteScroll() {
        if scrollView.contentOffset.x == 0 {
            scrollView.contentOffset.x = self.scrollView.bounds.width * CGFloat((imageViews.count - 2))
        } else if scrollView.contentOffset.x == (self.scrollView.bounds.width * CGFloat((imageViews.count - 1))) {
            scrollView.contentOffset.x = self.scrollView.bounds.width * CGFloat(1)
        }
        
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        setIndexNumber(index: index)
    }
    
    fileprivate func stopTimer() {
        self.timer.invalidate()
    }
    
}

extension SwieeftImageRollingBanner: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        infiniteScroll()
        startTimer()
    }
}
