package com.main.controller;

import com.main.model.User;
import com.main.service.UserService;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@SessionAttributes("user")
public class UserController {
    private final UserService userService;
    public UserController(UserService userService) { this.userService = userService; }

    @GetMapping("/register")
    public String registerPage() { return "register"; }

    @PostMapping("/register")
    public String register(@ModelAttribute User user) {
        userService.register(user);
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String loginPage() { return "login"; }

    @PostMapping("/login")
    public String login(@RequestParam String username, @RequestParam String password, Model model) {
        User u = userService.login(username, password);
        if (u != null) {
            model.addAttribute("user", u);
            return "redirect:/dashboard";
        } else {
            model.addAttribute("error", "Invalid credentials");
            return "login";
        }
    }


    @GetMapping("/dashboard")
    public String dashboard(@SessionAttribute("user") User currentUser, Model model) {
        List<User> allUsers = userService.getAllUsersExcept(currentUser.getUsername());
        model.addAttribute("user", currentUser);
        model.addAttribute("contacts", allUsers);
        return "dashboard";
    }
}
