//
//  RequestConfigFactory.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

// Request.
class NewsURLRequest: RequestProtocol {
    var urlRequest: URLRequest? = URLRequest(url: makeURL()!)
    
    static func makeURL() -> URL? {
        guard let url = URL(string: "https://cfg.tinkoff.ru/news/public/api/platform/v1/getArticles") else {
            assertionFailure("URL not found")
            return nil
        }
        return url
    }
}


typealias RecievedDataType = [String: [String: Any]]
typealias NewsType = [[String: Any]]


// Парсер.
class NewsParser: ParserProtocol {
    typealias Model = [News]
    
    func parse(data: Data) -> [News]? {
        var news: [News] = []
        
        do {
            guard
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? RecievedDataType,
                let response = json[KeysConstants.response],
                let newsArray = response[KeysConstants.news] as? NewsType
                else { return nil }
            
            newsArray.forEach { (newsDict) in
                guard
                    let id = newsDict[KeysConstants.id] as? String,
                    let title = newsDict[KeysConstants.title] as? String
                    else { return }
                
                let oneNews = News(id: id, title: title)
                news.append(oneNews)
            }
        } catch {
            print("Error serializing JSON \(error)")
        }
        
        return news
    }
}

class NewsTextParser: ParserProtocol {
    typealias Model = [[String: String]]
    
    func parse(data: Data) -> [[String: String]]? {
        var newsTextArray: [[String: String]] = []
        
        do {
            guard
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? RecievedDataType,
                let response = json[KeysConstants.response],
                let newsArray = response[KeysConstants.news] as? NewsType
                else { return nil }
            
            newsArray.forEach { newsOne in
                guard
                    let newsOneID = newsOne[KeysConstants.id] as? String,
                    let newsOneText = newsOne[KeysConstants.textshort] as? String
                    else { return }
                
                var newsText: [String: String] = [:]
                newsText[KeysConstants.id] = newsOneID
                newsText[KeysConstants.text] = newsOneText
                
                newsTextArray.append(newsText)
            }
        } catch {
            print("Error serializing JSON \(error)")
        }
        
        return newsTextArray
    }
}

// Фабрика парсеров.
struct ParserFactory {
    struct NewsParserFactory {
        static func newsParser() -> NewsParser {
            return NewsParser()
        }
    }
    
    struct NewsTextParserFactory {
        static func newsTextParser() -> NewsTextParser {
            return NewsTextParser()
        }
    }
}


// Фабрика конфигурации.
struct RequestConfigFactory {
    struct NewsRequestConfig {
        static func newsRequestConfig() -> RequestConfig<NewsParser> {
            return RequestConfig<NewsParser>(request: NewsURLRequest(), parser: ParserFactory.NewsParserFactory.newsParser())
        }
    }
    
//    struct NewsTextRequestConfig {
//        static func newsTextRequestConfig() -> RequestConfig<NewsTextParser> {
//            return RequestConfig<NewsTextParser>(request: NewsURLRequest(), parser: NewsTextParser())
//        }
//    }
}
