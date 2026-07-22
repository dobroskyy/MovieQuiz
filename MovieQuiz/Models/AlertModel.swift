//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Максим on 22.07.2026.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
