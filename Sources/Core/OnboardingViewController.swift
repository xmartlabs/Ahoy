//
//  OnboardingViewController.swift
//  Ahoy ( https://github.com/xmartlabs/Ahoy)
//
//  Copyright (c) 2017 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import UIKit

open class OnboardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    public var presenter: OnboardingPresenter = BasePresenter()
    public var pageControlBottomConstant: CGFloat = 15.0

    public var currentPage = 0 {
        didSet {
            if isViewLoaded {
                pageChanged(to: currentPage)
            }
        }
    }

    @IBOutlet public weak var collectionView: UICollectionView?
    @IBOutlet public weak var pageControl: UIPageControl?
    @IBOutlet public weak var skipButton: UIButton?

    override open var prefersStatusBarHidden: Bool {
        return true
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        setupPageControl()
        setupSkipButton()
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = collectionView?.bounds.size ?? UIScreen.main.bounds.size
        layout?.minimumInteritemSpacing = 0
        layout?.minimumLineSpacing = 0
    }

    open func setupCollectionView() {
        if collectionView == nil {
            createCollectionView()
        }

        collectionView?.dataSource = self
        collectionView?.delegate = self

        presenter.cellProviders.values.forEach(register(with:))
        
        register(with: presenter.defaultProvider)

        presenter.style(collection: collectionView)
    }

    open func setupPageControl() {
        if pageControl == nil {
            createPageControl()
        }

        presenter.style(pageControl: pageControl)
    }

    open func setupSkipButton() {
        presenter.style(skip: skipButton)
        skipButton?.addTarget(self, action: #selector(skipPressed), for: .touchUpInside)
    }

    func skipPressed() {
        guard let skipAction = presenter.onOnboardingSkipped else {
            return
        }

        skipAction()
    }

    open func skipOnboarding() {
        presenter.onOnboardingSkipped?()
    }

    open func pageChanged(to page: Int) {
        pageControl?.currentPage = min(page, presenter.pageCount - 1)
    }

    open func createCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection: UICollectionView = {
            let collection = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
            collection.backgroundColor = .clear
            collection.isPagingEnabled = true
            collection.bounces = false
            collection.translatesAutoresizingMaskIntoConstraints = false
            collection.showsHorizontalScrollIndicator = false
            return collection
        }()
        let views: [String: Any?] = ["collectionView": collection]
        view.addSubview(collection)
        view.sendSubview(toBack: collection)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[collectionView]|", options: [], metrics: nil, views: views))
        collectionView = collection
    }

    open func createPageControl() {
        let pageControl: UIPageControl = {
            let frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            let control = UIPageControl(frame: frame)
            control.translatesAutoresizingMaskIntoConstraints = false
            return control
        }()
        view.addSubview(pageControl)
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: pageControl, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: pageControl, attribute: .bottom, multiplier: 1.0, constant: pageControlBottomConstant))
        view.bringSubview(toFront: pageControl)
        self.pageControl = pageControl
    }

    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collection = collectionView else { return }
        let page = Int(collection.contentOffset.x / collection.bounds.width)
        currentPage = page
    }

    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collection = collectionView else { return }
        collection.visibleCells.forEach {
            let width = self.view.convert($0.frame, from: self.collectionView).intersection(collection.frame).width
            let amountVisible = width / collection.bounds.width
            guard let index = collection.indexPath(for: $0)?.row else { return }
            presenter.visibilityChanged(for: $0, at: index, amount: amountVisible)
        }
    }

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.pageCount
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = presenter.reuseIdentifier(for: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  reuseIdentifier, for: indexPath)
        presenter.style(cell: cell, for: indexPath.row)
        return cell
    }

    private func register(with provider: CellProvider?) {
        guard let provider = provider else { return }
        switch provider {
        case .nib(let name, let identifier, let bundle):
            collectionView?.register(UINib(nibName: name, bundle: bundle), forCellWithReuseIdentifier: identifier)
        case .cellClass(let className, let identifier):
            collectionView?.register(className, forCellWithReuseIdentifier: identifier)
        }
    }

}
