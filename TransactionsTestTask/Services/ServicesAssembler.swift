//
//  ServicesAssembler.swift
//  TransactionsTestTask
//
//

/// Services Assembler is used for Dependency Injection
enum ServicesAssembler {
    
    // MARK: - BitcoinRateService
    
    static let bitcoinRateService: PerformOnce<BitcoinRateService> = {
        let service = BitcoinRateServiceImpl(apiEndpoint: APIEndpoints.btcCurrencyEndpoint, networkService: networkService())
        
        return { service }
    }()
    
    static let networkService: PerformOnce<NetworkService> = {
        let service = NetworkServiceImpl()
        
        return { service }
    }()
    
    static let coreDataManager: PerformOnce<CoreDataManager> = {
        let manager = CoreDataManagerImpl()
        
        return { manager }
    }()
    
    static let accountRepo: PerformOnce<AccountRepo> = {
        let repo = AccountRepo(coreDataManager: coreDataManager())
        
        return { repo }
    }()
}
