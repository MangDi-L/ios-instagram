//
//  MainTabController.swift
//  Instagram
//
//  Created by mangdi on 5/25/24.
//

import UIKit

final class MainTabController: UITabBarController {

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }

    // MARK: - Helpers

    private func configureViewControllers() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .black

        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"),
                                                selectedImage: #imageLiteral(resourceName: "home_selected"),
                                                rootViewController: FeedController())
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"),
                                                  selectedImage: #imageLiteral(resourceName: "search_selected"),
                                                  rootViewController: SearchController())
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"),
                                                         selectedImage: #imageLiteral(resourceName: "plus_unselected"),
                                                         rootViewController: ImageSelectorController())
        let notification = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"),
                                                        selectedImage: #imageLiteral(resourceName: "like_selected"),
                                                        rootViewController: NotificationController())
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"),
                                                   selectedImage: #imageLiteral(resourceName: "profile_selected"),
                                                   rootViewController: ProfileController())
        
        viewControllers = [feed, search, imageSelector, notification, profile]
    }
    
    private func templateNavigationController(unselectedImage: UIImage,
                                              selectedImage: UIImage,
                                              rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }

}
