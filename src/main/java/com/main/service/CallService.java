package com.main.service;

import com.main.model.Message;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

@Service
public class CallService {

    private final SimpMessagingTemplate template;
    public CallService(SimpMessagingTemplate template) { this.template = template; }

    public void sendSignal(Message message) {
        template.convertAndSend("/topic/call/" + message.getReceiver(), message);
    }
}
