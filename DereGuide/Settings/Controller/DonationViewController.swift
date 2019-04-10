//
//  DonationViewController.swift
//  DereGuide
//
//  Created by zzk on 2017/1/3.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import SnapKit
import StoreKit

class DonationViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let scrollView = UIScrollView()
    let questionView1 = DonationQAView()
    let questionView2 = DonationQAView()
    
    private(set) var collectionView: UICollectionView!

    let bannerDescLabel2 = UILabel()
    
    var products = [SKProduct]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        request?.delegate = nil
        request?.cancel()
        SKPaymentQueue.default().remove(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        requestData()
        // Do any additional setup after loading the view.
    }
    
    func prepareUI() {
        
        self.navigationItem.title = NSLocalizedString("支持作者", comment: "")
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: NSLocalizedString("恢复", comment: ""), style: .plain, target: self, action: #selector(restoreAction))
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(questionView1)
        questionView1.snp.makeConstraints { (make) in
            make.left.right.width.equalTo(scrollView.readableContentGuide)
            make.top.equalTo(10)
        }
        
        scrollView.addSubview(questionView2)
        questionView2.snp.makeConstraints { (make) in
            make.left.right.equalTo(questionView1)
            make.top.equalTo(questionView1.snp.bottom).offset(10)
        }
        
        questionView1.setup(question: NSLocalizedString("为什么会有这个页面？", comment: ""), answer: NSLocalizedString("DereGuide是一款免费应用，现在以及未来都不会增加任何需要收费开启的功能，也不会使用广告进行盈利。但是DereGuide的开发和所使用的服务器的维持都需要一定资金的支持，如果您喜欢这款应用，请支持我们。", comment: ""))
        
        questionView2.setup(question: NSLocalizedString("如何支持我们？", comment: ""), answer: NSLocalizedString("您可以通过购买下面的两个虚拟商品来支持本程序。为了更好的App体验，我们决定不在本页添加象征性的广告，因此您的购买不会获得任何虚拟物品或者功能上的扩展。", comment: ""))
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 10
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        scrollView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(questionView2.snp.bottom).offset(20)
            make.left.right.equalTo(scrollView.readableContentGuide)
            make.height.equalTo(80)
            make.bottom.equalToSuperview().offset(-20)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(DonationCell.self, forCellWithReuseIdentifier: "DonationCell")
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.collectionView.performBatchUpdates(nil, completion: nil)
        }, completion: nil)
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    var hud: LoadingImageView?
    private var request: SKProductsRequest?
    func requestData() {
        request = SKProductsRequest(productIdentifiers: Config.iAPRemoveADProductIDs)
        request?.delegate = self
        hud = LoadingImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        hud?.show(to: self.collectionView)
        request?.start()
    }
    
    @objc func restoreAction() {
        CGSSLoadingHUDManager.default.show()
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
//    func removeAd() {
//        if UserDefaults.standard.shouldShowAd {
//            UserDefaults.standard.shouldShowAd = false
//        }
//        gadBanner.isHidden = true
//        bannerDescLabel2.text = NSLocalizedString("感谢您的支持，广告已经被移除。", comment: "")
//    }
    
    // MARK: UICollectionViewDelegate & DataSource
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (scrollView.readableContentGuide.layoutFrame.width - 10) / 2, height: 80)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DonationCell", for: indexPath) as! DonationCell
        
        let product = products[indexPath.item]
        cell.setup(amount: (product.priceLocale.currencySymbol ?? "") + product.price.stringValue, desc: product.localizedTitle)
        
        switch indexPath.item {
        case 0:
            cell.borderColor = UIColor.cool.cgColor
        case 1:
            cell.borderColor = UIColor.cute.cgColor
        default:
            break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.item]
        
        if SKPaymentQueue.canMakePayments() {
            CGSSLoadingHUDManager.default.show()
            SKPaymentQueue.default().add(SKPayment(product: product))
        } else {
            let alert = UIAlertController(title: NSLocalizedString("提示", comment: ""), message: NSLocalizedString("您的设备未开启应用内购买。", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            tabBarController?.present(alert, animated: true, completion: nil)
        }
    }
    
}

// MARK: StoreKitDelegate

extension DonationViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products.sorted(by: { $0.price.decimalValue < $1.price.decimalValue })
        DispatchQueue.main.async { [weak self] in
            self?.hud?.hide()
            self?.reloadData()
        }
    }
}

// MARK: StoreKitTransactionObserver

extension DonationViewController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction)
                finishTransaction(transaction)
            case .failed:
                failedTransaction(transaction)
                finishTransaction(transaction)
            case .restored:
                restoreTransaction(transaction)
                finishTransaction(transaction)
            case .deferred:
                finishTransaction(transaction)
            case .purchasing:
                break
            @unknown default:
                fatalError()
            }
        }
    }
    
    func completeTransaction(_ transaction: SKPaymentTransaction) {
//        removeAd()
    }
    
    func failedTransaction(_ transaction: SKPaymentTransaction) {
        
    }
    
    func restoreTransaction(_ transaction: SKPaymentTransaction) {
//        removeAd()
    }
    
    func finishTransaction(_ transaction: SKPaymentTransaction) {
        CGSSLoadingHUDManager.default.hide()
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        CGSSLoadingHUDManager.default.hide()
        var restored = false
        label: for transaction in queue.transactions {
            for id in Config.iAPRemoveADProductIDs {
                if transaction.payment.productIdentifier == id {
                    restored = true
                    break label
                }
            }
        }
        if !restored {
            let alert = UIAlertController(title: NSLocalizedString("恢复失败", comment: ""), message: NSLocalizedString("您的当前账号未曾购买过去除广告服务。", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("确定", comment: ""), style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            }))
            tabBarController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        CGSSLoadingHUDManager.default.hide()
    }
}
