package com.main.service;

import com.main.model.Message;
import com.main.repository.MessageRepository;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class ChatService {
    private final MessageRepository repo;
    private final SimpMessagingTemplate template;

    public ChatService(MessageRepository repo, SimpMessagingTemplate template) {
        this.repo = repo;
        this.template = template;
    }

    public void sendPrivateMessage(Message message) {
        repo.save(message);

        // ✅ Send message to receiver
        template.convertAndSend("/topic/chat/" + message.getReceiver(), message);

        // ✅ Also send to sender (so they update instantly)
        template.convertAndSend("/topic/chat/" + message.getSender(), message);
    }

 // ✅ Return full chat history between two users
    public List<Message> getConversation(String username, String receiver) {
        return repo.findConversation(username, receiver);
	}
}

