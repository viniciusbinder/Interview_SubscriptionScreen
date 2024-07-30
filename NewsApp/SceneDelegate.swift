//
//  SceneDelegate.swift
//  NewsApp
//
//  Created by Vinícius on 29/07/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let homeViewController = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        Task {
            await fetchPayload { config in
                if let navigationViewController = self.window?.rootViewController as? UINavigationController,
                   let homeViewController = navigationViewController.topViewController as? HomeViewController
                {
                    homeViewController.config = HomeViewConfiguration(offersConfiguration: config)
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

extension SceneDelegate {
    func fetchPayload(completion: @escaping (OffersViewConfiguration) -> Void) async {
        let offersProvider = OffersNetworkProvider()
        let offersManager = OffersManager(provider: offersProvider)

        // Use mock provider for UI tests
        let isUITesting = ProcessInfo.processInfo.arguments.contains("Testing")
        if isUITesting {
            await fetchMock(offersManager: offersManager, completion: completion)
            return
        }

        do {
            // Fetch payload from network
            if let config = try await offersManager.loadViewConfiguration() {
                await MainActor.run {
                    completion(config)
                }
            }
        } catch {
            // Use mock provider if network fails
            await fetchMock(offersManager: offersManager, completion: completion)
        }
    }

    func fetchMock(offersManager: OffersManager,
                   completion: @escaping (OffersViewConfiguration) -> Void) async
    {
        let mockProvider = OffersMockProvider()
        offersManager.setProvider(mockProvider)
        do {
            if let config = try await offersManager.loadViewConfiguration() {
                await MainActor.run {
                    completion(config)
                }
            }
        } catch {
            print("Could not mock view configuration: ", error)
        }
    }
}
