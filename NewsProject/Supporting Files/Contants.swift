//
//  Contants.swift
//  NewsProject
//
//  Created by Aleksandr Avdukich on 17/05/2019.
//  Copyright © 2019 Sanel Avdukich. All rights reserved.
//

import Foundation

enum KeysConstants {
    static let response = "response"
    static let news = "news"
    static let id = "id"
    static let title = "title"
    static let views = "Views"
    static let count = "count"
    static let textshort = "textshort"
    static let text = "text"
}

enum TitleConstants {
    static let news = "Новости"
    static let settings = "Настройки"
    static let profile = "Учетная запись"
}

enum Strings {
    static let refresh = "Обновление новостей..."
    static let alertNotConnectionTitle = "Невозможно получить данные"
    static let alertNotConnectionMessage = "Проверьте соединение с Интернетом. На данный момент отображаются ранее сохраненные новости"
    static let viewsCountText = "Количество просмотров: "
}

enum Images {
    static let settings = "settings"
    static let back = "back"
}
