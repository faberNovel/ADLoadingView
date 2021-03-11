//
//  LoadingViewPageViewController.swift
//  ADLoadingViewSample
//
//  Created by Samuel Gallet on 15/06/16.
//
//

import UIKit
import ADLoadingView

class LoadingViewPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var loadingViewControllers : [UIViewController] = []
    private var pageControl : UIPageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource  = self
        delegate = self
        #if os(tvOS)
            let styles: [ADLoadingViewStyle] = [.alert, .black, .blackOpaque, .transparent, .noStyle]
        #else
            let styles: [ADLoadingViewStyle] = [.alert, .white, .black, .blackOpaque, .transparent, .noStyle]
        #endif
        loadingViewControllers = styles.map {
            let loadingViewController = LoadingViewTestController()
            loadingViewController.loadingViewStyle = $0
            return loadingViewController
        }
        guard let firstViewController = loadingViewControllers.first else {
            return;
        }
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = loadingViewControllers.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.black
        view.addSubview(pageControl)
        let views = ["pageControl" : pageControl]
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[pageControl]-(20)-|", options: .alignAllLeft, metrics: nil, views: views))
        view.addConstraint(NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: pageControl, attribute: .centerX, multiplier: 1.0, constant: 1.0))
    }

    // MARK: UIPageViewController
    override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]?) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = loadingViewControllers.index(of: viewController), index < loadingViewControllers.count - 1 else {
            return nil
        }
        return loadingViewControllers[index + 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = loadingViewControllers.index(of: viewController), index > 0 else {
            return nil
        }
        return loadingViewControllers[index - 1]
    }

    // MARK: UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewController = viewControllers?.first else {
            return;
        }
        pageControl.currentPage = loadingViewControllers.index(of: viewController)!
    }
}
