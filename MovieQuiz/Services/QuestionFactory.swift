import UIKit

final class QuestionFactory: QuestionFactoryProtocol {

    private let moviesLoader: MoviesLoaderProtocol
    private weak var delegate: QuestionFactoryDelegate?

    private var movies: [MostPopularMovie] = []

    private enum LoadDataError: Error, LocalizedError {
        case serverError(String)

        var errorDescription: String? {
            switch self {
            case .serverError(let message):
                return message
            }
        }
    }

    init(moviesLoader: MoviesLoaderProtocol, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }

    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let mostPopularMovies):
                guard mostPopularMovies.errorMessage.isEmpty else {
                    DispatchQueue.main.async {
                        self.delegate?.didFailToLoadData(with: LoadDataError.serverError(mostPopularMovies.errorMessage))
                    }
                    return
                }
                self.movies = mostPopularMovies.items
                DispatchQueue.main.async {
                    self.delegate?.didLoadDataFromServer()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }

    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0

            guard let movie = self.movies[safe: index] else { return }

            var imageData = Data()

            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
                imageData = UIImage(named: "placeholder")?.pngData() ?? Data()
            }

            let rating = Float(movie.rating) ?? 0

            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7

            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
