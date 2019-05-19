//
//  ViewController.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit
import CoreData

// Логика: Если есть доступ к Интернету, то грузятся новости из сети, иначе грузятся из Core Data.
class NewsViewController: UIViewController {
    
    
    // MARK: Public Properties
    
    let service: ServiceAssembly
    
    
    // MARK: Private Properties
    
    private var news: [News] = []
    private var views: [[String: Any]] = []
    private let requestSender = RequestSender()
    private let privateContextToSaveData = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    private let mainContextToDisplayData = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    private let privateContextToLoadData = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    private var refreshControl: UIRefreshControl!
    private let transition = PopAnimator()
    private var isLoading: Bool = false
    private var isFirstLoading = true
    private var allNewsCount: Int = 0
    private var currentNewsCount: Int = 0
    
    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingStackView: UIStackView!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupTableView()
        setupContext()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isFirstLoading {
            views = []
            loadNewsViews(isInternetAccess: true, alert: nil)
        }
    }
    
    init(service: ServiceAssembly) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = TitleConstants.news
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: Images.settings), style: .plain, target: self, action: #selector(didTapSettings))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
    }
    
    @objc private func didTapSettings() {
        let navSettingController = UINavigationController(rootViewController: service.settingController)
        navSettingController.transitioningDelegate = self // Используется кастомная анимация из PopAnimator().
        present(navSettingController, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NewsTableViewCell.nib, forCellReuseIdentifier: NewsTableViewCell.name)
        tableView.register(LoadingTableViewCell.nib, forCellReuseIdentifier: LoadingTableViewCell.name)
        
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView(frame: .zero)
        
        setupRefreshControl()
        tableView.refreshControl = refreshControl
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Strings.refresh, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
    }
    
    @objc private func refreshTableView() {
        isLoading = true
        updateView(isLoading: isLoading, refresh: true)
        loadData()
        refreshControl.endRefreshing()
    }
    
    private func setupContext() {
        privateContextToSaveData.persistentStoreCoordinator = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.persistentStoreCoordinator
        mainContextToDisplayData.parent = privateContextToSaveData
        privateContextToLoadData.parent = mainContextToDisplayData
    }
    
    private func fetchData() {
        isLoading = true
        updateView(isLoading: isLoading, refresh: false)
        loadData()
    }
    
    private func loadData() {
        privateContextToLoadData.perform { [weak self] in
            guard let self = self else { return }
            
            let requestConfig = RequestConfigFactory.NewsRequestConfig.newsRequestConfig()
            self.requestSender.send(config: requestConfig) { [weak self] (result) in
                guard let self = self else { return }
                
                let fetchRequest: NSFetchRequest<NewsCoreData> = NewsCoreData.fetchRequest()
                self.deleteData()
                
                switch result {
                case .success(let array):
                    self.deleteDataFromContext(self.privateContextToSaveData, fetchRequest: fetchRequest) // Удаление новостей из Store (Запрос выполняется по контексту, но если в нем нет данных, то запрос идет вниз до БД, где Persistant Coordinator выдает объекты в контекст). Удаляя объекты из родителя, они удаляются и из детей.
                    
//                    let qwerty = try? self.privateContextToLoadData.fetch(fetchRequest)
//                    print(qwerty?.count)
//                    let qwerty1 = try? self.mainContextToDisplayData.fetch(fetchRequest)
//                    print(qwerty1?.count)
//                    let qwerty2 = try? self.privateContextToSaveData.fetch(fetchRequest)
//                    print(qwerty2?.count)
                    
                    self.createManagedObjectsFrom(array: array) // Создание экземпляров NewsCoreData для отображения и сохранения. Передача их в главный контекст.
                    self.displayNews() // Отображение новостей и их дальнейшее сохранение в CoreData.
                    
//                    let qwerty3 = try? self.privateContextToLoadData.fetch(fetchRequest)
//                    print(qwerty3?.count)
//                    let qwerty4 = try? self.mainContextToDisplayData.fetch(fetchRequest)
//                    print(qwerty4?.count)
//                    let qwerty5 = try? self.privateContextToSaveData.fetch(fetchRequest)
//                    print(qwerty5?.count)
                    
                case .error(let error):
                    print(error)
                    
//                    let qwerty = try? self.privateContextToLoadData.fetch(fetchRequest)
//                    print(qwerty?.count)
//                    let qwerty1 = try? self.mainContextToDisplayData.fetch(fetchRequest)
//                    print(qwerty1?.count)
//                    let qwerty2 = try? self.privateContextToSaveData.fetch(fetchRequest)
//                    print(qwerty2?.count)
                    
                    let alertController = AlertController.makeOKAlertController(title: Strings.alertNotConnectionTitle, message: Strings.alertNotConnectionMessage)
                    
                    self.fetchDataFromCoreData(alert: alertController) // Загрузка экземпляров из main context.
                }
            }
        }
    }
    
    private func deleteData() {
        news = []
        views = []
        allNewsCount = 0
        currentNewsCount = 0
        isFirstLoading = true
    }
    
    private func deleteDataFromContext(_ context: NSManagedObjectContext, fetchRequest: NSFetchRequest<NewsCoreData>) {
        let newsCoreData = try? context.fetch(fetchRequest)
        guard let news = newsCoreData else { return }
        for newsOne in news {
            context.delete(newsOne)
        }
//        print(context)
        if context == privateContextToSaveData {
//            print(context)
//            print(privateContextToSaveData)
            saveContext(context: privateContextToSaveData, completionBlock: nil)
        }
    }
    
    private func createManagedObjectsFrom(array: [News]) {
        allNewsCount = array.count
        
        for item in array {
            let newsCoreData = NewsCoreData(context: privateContextToLoadData)
            newsCoreData.id = item.id
            newsCoreData.title = item.title
            saveContext(context: privateContextToLoadData, completionBlock: nil)
        }
        
        let fetchRequest: NSFetchRequest<NewsCoreData> = NewsCoreData.fetchRequest()
        fetchRequest.fetchLimit = 20
        fetchRequest.fetchOffset = currentNewsCount
        
        do {
            let newsCoreData = try mainContextToDisplayData.fetch(fetchRequest)
            currentNewsCount += 20
            
            for item in newsCoreData {
                let newsOne = News(id: item.id!, title: item.title!)
                news.append(newsOne)
            }
        } catch {
            print(error.localizedDescription)
        }
        
        loadNewsViews(isInternetAccess: true, alert: nil)
    }
    
    private func displayNews() { 
        mainContextToDisplayData.perform { [weak self] in
            guard let self = self else { return }
            
            self.saveContext(context: self.mainContextToDisplayData, completionBlock: {
                print("Кол-во новостей при первой загрузке или рефреше: \(self.news.count)")
                self.isLoading = false
                self.updateView(isLoading: self.isLoading, refresh: false)
            })
            
            self.saveData() // Сохранение данных, пришедших от ребенка (от mainContextToDisplayData) в CoreData.
        }
    }
    
    private func saveData() {
        privateContextToSaveData.perform { [weak self] in
            guard let self = self else { return }
            
            self.saveContext(context: self.privateContextToSaveData, completionBlock: nil)
        }
    }
    
    private func saveContext(context: NSManagedObjectContext, completionBlock: (()->())?) {
        if context.hasChanges {
            do {
                completionBlock?()
                
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchDataFromCoreData(alert: UIAlertController) {
        let fetchRequest: NSFetchRequest<NewsCoreData> = NewsCoreData.fetchRequest()
        
        let newsCoreDataFromMainContext = try? self.mainContextToDisplayData.fetch(fetchRequest) // Если нет интернета, всегда лучше обращаться к main контексту.
        
        guard let newsCoreData = newsCoreDataFromMainContext else { return }
        
        allNewsCount = newsCoreData.count
        
        loop: for newsCoreDataOne in newsCoreData {
            guard
                let id = newsCoreDataOne.id,
                let title = newsCoreDataOne.title
                else {
                    assertionFailure("Managed Object has not fields")
                    return
            }
            
            let newsOne = News(id: id, title: title)
            
            if currentNewsCount < 20 {
                news.append(newsOne)
                currentNewsCount += 1
            } else {
                break loop
            }
        }
        
        loadNewsViews(isInternetAccess: false, alert: alert)
    }
    
    private func updateView(isLoading: Bool, refresh: Bool) {
        if !refresh {
            loadingStackView.isHidden = !isLoading
            _ = isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
        navigationItem.rightBarButtonItem?.isEnabled = !isLoading
        tableView.reloadData()
    }
    
    private func loadNextBatch() {
        DispatchQueue.global().async {
            let fetchRequest: NSFetchRequest<NewsCoreData> = NewsCoreData.fetchRequest()
            fetchRequest.fetchLimit = 20
            fetchRequest.fetchOffset = self.currentNewsCount
            
            do {
                let newsCoreData = try self.mainContextToDisplayData.fetch(fetchRequest)
                self.currentNewsCount += 20
                
                for item in newsCoreData {
                    let newsOne = News(id: item.id!, title: item.title!)
                    self.news.append(newsOne)
                }
                
                print("Кол-во записей при дозагрузке: \(self.news.count)")
                
                self.setNewsCount(isInternetOnline: true, alert: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func loadNewsViews(isInternetAccess: Bool, alert: UIAlertController?) {
        guard let viewsFromUserDefaults = UserDefaults.standard.object(forKey: KeysConstants.views) as? [[String: Any]] else {
            if isInternetAccess {
                tableView.reloadData()
            } else {
                guard let alert = alert else { return }
                displayFirstNewsFromCoreData(alert: alert)
            }
            return
        }
        views = viewsFromUserDefaults
        setNewsCount(isInternetOnline: isInternetAccess, alert: alert)
    }
    
    private func setNewsCount(isInternetOnline: Bool, alert: UIAlertController?) {
        for view in views {
            guard
                let id = view[KeysConstants.id] as? String,
                let count = view[KeysConstants.count] as? Int
                else { return }
            
            for newsOne in news {
                if newsOne.id == id {
                    newsOne.count = count
                    break
                }
            }
        }
        
        DispatchQueue.main.async {
            if isInternetOnline {
                self.tableView.reloadData()
            } else {
                guard let alert = alert else { return }
                self.displayFirstNewsFromCoreData(alert: alert)
            }
        }
    }
    
    private func displayFirstNewsFromCoreData(alert: UIAlertController) {
        DispatchQueue.main.async {
            print("Кол-во новостей при первой загрузке, когда нет соединения с Интернетом: \(self.news.count)")
            self.isLoading = false
            self.updateView(isLoading: self.isLoading, refresh: false)
            self.present(alert, animated: true, completion: nil)
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // +1 to show the loading cell at the last row
        if isLoading {
            return 0
        } else if news.count != allNewsCount {
            return news.count + 1
        } else {
            return news.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let time = CACurrentMediaTime()
//        print(indexPath.row)
        
        if indexPath.row == news.count && news.count != allNewsCount {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.name, for: indexPath) as! LoadingTableViewCell
            
//            print(CACurrentMediaTime() - time)
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.name, for: indexPath) as! NewsTableViewCell
        
        let newsOne = news[indexPath.item]
        cell.titleLabel.text = newsOne.title
        displayCountLabel(cell: cell, newsOne: newsOne)
        
//        print(CACurrentMediaTime() - time)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == news.count && news.count != allNewsCount {
            let cell = cell as! LoadingTableViewCell
            if !cell.activityIndicator.isAnimating {
                cell.startLoading()
                loadNextBatch()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailController = service.detailController
        let newsOne = news[indexPath.item]
        detailController.newsOne = newsOne
        detailController.views = views
        isFirstLoading = false
        navigationController?.pushViewController(detailController, animated: true)   
    }
    
    
    // MARK: Private
    
    private func displayCountLabel(cell: NewsTableViewCell, newsOne: News) {
        if let count = newsOne.count {
            cell.viewsCountLabel.text = Strings.viewsCountText + "\(count)"
        } else {
            cell.viewsCountLabel.text = Strings.viewsCountText + "\(0)"
        }
    }
}


// MARK: - UIViewControllerTransitioningDelegate

extension NewsViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
