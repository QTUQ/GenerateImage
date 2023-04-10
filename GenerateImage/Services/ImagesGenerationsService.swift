//
//  APIService.swift
//  SmartSketch
//
//  Created by Tuqa on 3/18/23.
//

import Foundation
import UIKit

//MARK: - API request to get the response
class ImagesGenerationsService {
    // getting the image
    let apiKey = "Enter your api key here"
    func fetchImageForPrompt(_ prompt: String) async throws -> UIImage {
        let fetchImageUrl = "https://api.openai.com/v1/images/generations"
        let urlRequest = try createUrlRequestFor(httpMethod: "POST", url: fetchImageUrl, prompt: prompt)
        let (data, response) = try  await URLSession.shared.data(for: urlRequest)
        print(String(data: data, encoding: .utf8) as Any)
        let decoder = JSONDecoder()
        let result = try decoder.decode(Response.self, from: data)
        print(result)
        print(response)
        let imageUrl = result.data[0].url
        guard let imageUrl = URL(string: imageUrl) else {
            throw APIError.unableToCreateImageUrl
        }
        let (imageData, imageResponse) = try  await URLSession.shared.data(from: imageUrl)
        guard let image = UIImage(data: imageData) else {
            throw APIError.unableToConvertImageDataToImage
        }
        return image
    }
    // create the url request
    func createUrlRequestFor(httpMethod: String, url: String, prompt: String) throws -> URLRequest {
        guard let url = URL(string: url) else {
            throw APIError.unableToCreateUrlForUrlRequest
        }
        // url request
        var urlRequest = URLRequest(url: url)
        // method
        urlRequest.httpMethod = httpMethod
        // headers
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //body
        let jsonBody: [String: Any] = [
            "prompt": "\(prompt)",
              "n": 1,
              "size": "1024x1024"
        ]
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        return urlRequest
    }
}

//MARK: - Create an api error to handel them
enum APIError: Error {
    case unableToCreateImageUrl
    case unableToConvertImageDataToImage
    case unableToCreateUrlForUrlRequest
}

//MARK: - decode the response
struct Response: Decodable {
    let data: [ImageUrl]
}
struct ImageUrl: Decodable {
    let url: String
}

