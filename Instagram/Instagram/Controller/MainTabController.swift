//
//  MainTabController.swift
//  Instagram
//
//  Created by mangdi on 5/25/24.
//

import UIKit
import Firebase
import YPImagePicker

final class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { 
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    
    // MARK: - API
    
    private func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    private func checkIfUserIsLoggedIn() {
//        do {
//            try Auth.auth().signOut()
//            let controller = LoginController()
//            controller.delegate = self.tabBarController as? MainTabController
//            let nav = UINavigationController(rootViewController: controller)
//            nav.modalPresentationStyle = .fullScreen
//            self.present(nav, animated: true)
//        } catch {
//            print("DEBUG: Failed to sign out!")
//        }
        if Auth.auth().currentUser == nil {
            // background 스레드에서 API 호출을 하고 있기때문에 UI관련 작업은 메인 스레드에 있어야한다. (16_2분20초)
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        }
    }

    // MARK: - Helpers

    private func configureViewControllers(withUser user: User) {
        self.delegate = self
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .black

        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"),
                                                selectedImage: #imageLiteral(resourceName: "home_selected"),
                                                rootViewController: FeedController(collectionViewLayout: layout))
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
                                                   rootViewController: ProfileController(user: user))
        
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
    
    private func didFinishPickingMedia(_ picker: YPImagePicker, currentSelectedIndex: Int) {
        picker.didFinishPicking { items, cancelled in
            if cancelled {
                self.selectedIndex = currentSelectedIndex
                self.dismiss(animated: true)
                return
            }
            
            // 자연스런 화면이동을 위해 animated는 false로 설정
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
                
                let controller = UploadPostController()
                controller.type = .upload
                controller.selectedImage = selectedImage
                controller.uploadPostControllerDelegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                // 자연스런 화면이동을 위해 animated는 false로 설정
                self.present(nav, animated: false)
            }
        }
    }
}

// MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
        print("DEBUG: Auth did complete")
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true)
            
            didFinishPickingMedia(picker, currentSelectedIndex: self.selectedIndex)
        }
        
        return true
    }
}

// MARK: - UploadPostControllerDelegate

extension MainTabController: UploadPostControllerDelegate {
    func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
        selectedIndex = 0
        controller.dismiss(animated: true)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedController else { return }
        feed.handleRefresh()
    }
    
    func controllerDidCanceledUploadingPost() {
        selectedIndex = 0
    }
}
