//
//  DetailNewsViewController.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import UIKit
import Alamofire

class DetailNewsViewController: UIViewController {
    
    
    // MARK: Private Structures
    
    private enum ContantsStrings {
        static let concurrentQueue = "concurrentQueue"
    }
    
    
    // MARK: Public Properties
    
    var newsOne: News?
    var views: [[String: Any]]?
    
    
    // MARK: Private Properties
    
    private let requestConfig = RequestConfigFactory.NewsRequestConfig.newsRequestConfig()
    private let parser = ParserFactory.NewsTextParserFactory.newsTextParser()

    
    // MARK: Outlets
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var textOfNews: UILabel!
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let newsOne = newsOne else { return }
        
        setupNavBar()
        increaseViews(newsOne: newsOne)
        if let text = newsOne.text {
            updateView(text: text)
        } else {
            loadData(newsOne: newsOne)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        progressView.isHidden = false
        progressView.progress = 0.0
        textOfNews.text = .empty
    }
    
    deinit {
        print("DetailNewsViewController \(#function)")
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func increaseViews(newsOne: News) {
        guard let views = views else { return }
        var newViews = views
        
        var newsViewsOne: [String: Any] = [:]
        for i in 0..<views.count {
            guard
                let id = views[i][KeysConstants.id] as? String,
                let count = views[i][KeysConstants.count] as? Int
                else { return }
            
            if id == newsOne.id {
                newViews.remove(at: i)
                newsViewsOne[KeysConstants.count] = count + 1
                saveNewViews(newsOne: newsOne, newViews: &newViews, newsViewsOne: &newsViewsOne)
                return
            }
        }
        
        newsViewsOne[KeysConstants.count] = 1
        saveNewViews(newsOne: newsOne, newViews: &newViews, newsViewsOne: &newsViewsOne)
    }
    
    private func saveNewViews(newsOne: News, newViews: inout [[String: Any]], newsViewsOne: inout [String: Any]) {
        newsViewsOne[KeysConstants.id] = newsOne.id
        newViews.append(newsViewsOne)
        
        UserDefaults.standard.set(newViews, forKey: KeysConstants.views)
        UserDefaults.standard.synchronize()
    }
    
    private func loadData(newsOne: News) {
        guard let urlRequest = requestConfig.request.urlRequest else { return }
        let concurrentQueue = DispatchQueue(label: ContantsStrings.concurrentQueue, attributes: .concurrent)
        
        request(urlRequest)
            .downloadProgress(queue: concurrentQueue, closure: { [weak self] progress in
                let progressPercent = Float(pow(Double(Float(745255) / Float(progress.completedUnitCount)), -1))
                DispatchQueue.main.async {
                    self?.progressView.setProgress(progressPercent, animated: true)
                }
            })
            .response(queue: concurrentQueue, completionHandler: { [weak self] response in
                guard
                    let self = self,
                    let data = response.data
                    else { return }
                print(data)
                
                let newsTextArray = self.parser.parse(data: data)
                
                newsTextArray?.forEach({ newsTextOne in
                    if newsTextOne[KeysConstants.id] == newsOne.id {
                        let text = newsTextOne[KeysConstants.text]
                        newsOne.text = text
                        
                        self.updateView(text: text)
                        return
                    }
                })
            })
    }
    
    private func updateView(text: String?) {
        DispatchQueue.main.async {
            self.progressView.isHidden = true
            if let text = text {
                self.textOfNews.text = text
            } else {
                self.displayPopUp()
            }
        }
    }
    
    private func displayPopUp() {
        
    }
}
