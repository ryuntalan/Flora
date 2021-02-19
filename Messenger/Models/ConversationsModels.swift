//
//  ConversationsModels.swift
//  Messenger
//
//  Created by Ryan Untalan on 2/19/21.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
