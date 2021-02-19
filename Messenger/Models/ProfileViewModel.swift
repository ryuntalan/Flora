//
//  ProfileViewModel.swift
//  Messenger
//
//  Created by Ryan Untalan on 2/19/21.
//

import Foundation

enum ProfileViewModelType {
    case info, logout
}

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}

