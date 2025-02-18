//
//  AppDelegate.swift
//  TransactionsTestTask
//
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        startApp(at: window)
        
        return true
    }
    
    private func startApp(at: UIWindow?) {
        window?.overrideUserInterfaceStyle = .light

        if let window = window {
            window.rootViewController = WalletViewController(
                viewModel: .init(
                    btcCurrencyService: ServicesAssembler.bitcoinRateService(),
                    coreDataManager: ServicesAssembler.coreDataManager(),
                    accountRepo: ServicesAssembler.accountRepo()
                )
            )
            window.makeKeyAndVisible()
        }
    }
}
