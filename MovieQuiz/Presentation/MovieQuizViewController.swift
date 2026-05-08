import UIKit

struct QuizQuestion {
    let imageName: String
    let text: String
    let correctAnswer: Bool
}

final class MovieQuizViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var yesButton: UIButton!
    
    // MARK: - Private Properties

    private let questions: [QuizQuestion] = [
        QuizQuestion(
            imageName: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            imageName: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            imageName: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            imageName: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            imageName: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    private var currentQuestionIndex = 0
    private var correctAnswers = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        show(quiz: convert(model: questions[currentQuestionIndex]))
    }

    // MARK: - IBActions

    @IBAction private func yesButtonClicked() {
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer)
    }

    @IBAction private func noButtonClicked() {
        showAnswerResult(isCorrect: !questions[currentQuestionIndex].correctAnswer)
    }

    // MARK: - Private Methods

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.imageName) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }

    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { [self] _ in
            currentQuestionIndex = 0
            correctAnswers = 0
            show(quiz: convert(model: questions[currentQuestionIndex]))
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    private func showAnswerResult(isCorrect: Bool) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        correctAnswers += isCorrect ? 1 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            yesButton.isEnabled = true
            noButton.isEnabled = true
            imageView.layer.borderWidth = 0
            showNextQuestionOrResults()
        }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/\(questions.count)"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
        } else {
            currentQuestionIndex += 1
            show(quiz: convert(model: questions[currentQuestionIndex]))
        }
    }
}
