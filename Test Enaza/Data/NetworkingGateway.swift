//
//  NetworkingGateway.swift
//  Test Enaza
//
//  Created by Andrew Krotov on 16/04/2019.
//  Copyright © 2019 Andrew Krotov. All rights reserved.
//

import NetworkExtension

public protocol NetworkingGatewayDelegate {
    func gotAlbum(_ result: Result<TrackListResponse, NetworkingError<ResponseError>>)
    func gotCover(_ result: Result<Data, NetworkingError<ResponseError>>)
}

public class NetworkingGateway {
    public static let sharedInstance = NetworkingGateway()
    
    private let decoder = JSONDecoder()
    
    private var delegate: NetworkingGatewayDelegate?
    
    private init() { }
    
    public func setDelegate(_ delegate: NetworkingGatewayDelegate) {
        self.delegate = delegate
    }
    
    public func requestAlbum(id: Int) {
        var components = URLComponents(string: "https://api.mobimusic.kz/")
        components?.queryItems = [
            URLQueryItem(name: "productId", value: String(id)),
            URLQueryItem(name: "method", value: "product.getCard")
        ]

        guard let forcedComponents = components, let url = forcedComponents.url else {
            delegate?.gotAlbum(.failure(.incorrectRoute))
            return
        }

        var getRequest = URLRequest(url: url)
        getRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: getRequest, completionHandler: { [decoder, delegate] (data, response, error) -> Void in
            
            if let error = error {
                delegate?.gotAlbum(.failure(.system(error)))
            } else if let data = data {
                guard let httpURLResponse = response as? HTTPURLResponse else {
                    delegate?.gotAlbum(.failure(.timeout))
                    return
                }
                
                switch httpURLResponse.statusCode {
                case 200...300:
                    do {
                        let decodedData = try decoder.decode(TrackListResponse.self, from: data)
                        
                        DispatchQueue.main.async(execute: {
                            delegate?.gotAlbum(.success(decodedData))
                        })
                    } catch {
                        DispatchQueue.main.async(execute: {
                            delegate?.gotAlbum(.failure(.parsing(error)))
                        })
                    }
                default:
                    delegate?.gotAlbum(.failure(.unreachable))
                }
            }
        }).resume()
    }
    
    func getCover(from link: String) {
        guard let url = URL(string: "https://static-cdn.enazadev.ru/" + link) else {
            delegate?.gotAlbum(.failure(.incorrectRoute))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [delegate] data, response, error in
            guard let httpURLResponse = response as? HTTPURLResponse else {
                delegate?.gotAlbum(.failure(.timeout))
                return
            }
            
            if let error = error {
                delegate?.gotAlbum(.failure(.system(error)))
            } else {
                switch httpURLResponse.statusCode {
                case 200...300:
                    guard let mimeType = response?.mimeType,
                        mimeType.hasPrefix("image"),
                        let data = data
                    else {
                        delegate?.gotAlbum(.failure(.parsing(NSError())))
                        return
                    }
                    
                    delegate?.gotCover(.success(data))
                default:
                    delegate?.gotAlbum(.failure(.unreachable))
                }
            }
        }.resume()
    }
}
