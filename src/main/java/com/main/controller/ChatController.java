package com.main.controller;

import com.main.model.Message;
import com.main.model.User;
import com.main.service.ChatService;
import com.main.service.UserService;  // ✅ make sure you have this service
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/chat")
@SessionAttributes("user")
public class ChatController {

    private final ChatService chatService;
    private final UserService userService;  // ✅ add UserService to fetch all registered users

    public ChatController(ChatService chatService, UserService userService) {
        this.chatService = chatService;
        this.userService = userService;
    }

    // ✅ Load chat page and show all registered users
    @GetMapping
    public String openChatPage(@SessionAttribute("user") User currentUser, Model model) {
        List<User> users = userService.findAll(); // get all registered users
        model.addAttribute("user", currentUser);
        model.addAttribute("users", users);       // <-- important
        return "chat"; // JSP page name
    }

    // ✅ Load specific conversation (when clicking a user)
    @GetMapping("/{receiver}")
    public String openConversation(@PathVariable String receiver,
                                   @SessionAttribute("user") User currentUser,
                                   Model model) {
        List<Message> conversation = chatService.getConversation(currentUser.getUsername(), receiver);
        List<User> users = userService.findAll();

        model.addAttribute("user", currentUser);
        model.addAttribute("users", users);
        model.addAttribute("conversation", conversation);
        model.addAttribute("receiver", receiver);

        return "chat";
    }

    // ✅ Handle private message over WebSocket
    @MessageMapping("/chat.private")
    public void sendPrivateMessage(Message message) {
        message.setType("CHAT");
        chatService.sendPrivateMessage(message);
    }
    
}
