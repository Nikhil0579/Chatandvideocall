package com.main.controller;

import com.main.model.Message;
import com.main.model.User;
import com.main.service.CallService;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/call")
@SessionAttributes("user")
public class CallController {

    private final CallService callService;
    public CallController(CallService callService) { this.callService = callService; }

    @GetMapping("/{receiver}")
    public String openCallPage(@PathVariable String receiver,
                               @SessionAttribute("user") User currentUser,
                               Model model) {
        model.addAttribute("sender", currentUser.getUsername());
        model.addAttribute("receiver", receiver);
        return "call";
    }

    @MessageMapping("/call.signal")
    public void signaling(Message message) {
        callService.sendSignal(message);
    }
}
