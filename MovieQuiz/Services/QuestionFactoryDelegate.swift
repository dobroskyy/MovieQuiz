//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Максим on 22.07.2026.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()          // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error)  // сообщение об ошибке загрузки
}
