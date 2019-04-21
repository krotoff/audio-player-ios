//
//  ResponseError.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 16/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import Foundation

public struct ResponseError: Codable, LocalizedError {
    var code: Int
    var message: String?
    
    public enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}

public typealias ServerErrorType = Decodable & LocalizedError

public enum NetworkingError<SE: ServerErrorType>: Error {
    case incorrectRoute
    case offline
    case unreachable
    case parsing(Error)
    case timeout
    case server(SE)
    case system(Error)
}

extension NetworkingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .incorrectRoute:
            return "Некорректный путь запроса"
        case .offline:
            return "Отсутствует подключение к интернету"
        case .unreachable:
            return "Сервер недоступен. Повторите попытку позже"
        case let .parsing(error):
            return "Ошибка кодирования.\n\(error.localizedDescription)"
        case .timeout:
            return "Превышено время ожидания ответа от сервера"
        case let .server(serverError):
            return serverError.errorDescription
        case let .system(error):
            return error.localizedDescription
        }
    }
}
