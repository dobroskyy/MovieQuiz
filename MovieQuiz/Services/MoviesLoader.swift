//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Максим on 22.07.2026.
//

import Foundation

protocol MoviesLoaderProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoaderProtocol {
    // MARK: - NetworkClient
    private let networkClient: NetworkRouting

    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }

    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
        // Учебный ключ IMDb-API (tv-api.com) больше не работает — сервис стал платным.
        // Поэтому список топ-250 берём из снимка данных tv-api.com, размещённого в репозитории проекта,
        // и загружаем его тем же сетевым запросом. Формат JSON полностью совпадает с ответом API.
        guard let url = URL(string: "https://raw.githubusercontent.com/dobroskyy/MovieQuiz/main/Top250Movies.json") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }

    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case .success(let data):
                do {
                    let mostPopularMovies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(mostPopularMovies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
