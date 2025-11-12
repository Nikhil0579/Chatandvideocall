package com.main.service;

import com.main.model.User;
import com.main.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    private final UserRepository repo;

    public UserService(UserRepository repo) {
        this.repo = repo;
    }

    // ✅ Register new user (if username not taken)
    public String register(User user) {
        Optional<User> existing = Optional.ofNullable(repo.findByUsername(user.getUsername()));
        if (existing.isPresent()) {
            return "Username already exists. Please choose another.";
        }

        user.setOnline(false);
        repo.save(user);
        return "Registration successful. You can now log in.";
    }

    // ✅ Login with username and password
    public User login(String username, String password) {
        User user = repo.findByUsername(username);
        if (user != null && user.getPassword().equals(password)) {
            user.setOnline(true);
            repo.save(user);
            return user;
        }
        return null; // invalid credentials
    }

    // ✅ Logout (mark user offline)
    public void logout(String username) {
        User user = repo.findByUsername(username);
        if (user != null) {
            user.setOnline(false);
            repo.save(user);
        }
    }

    // ✅ Get all users except the current one (used for chat list)
    public List<User> findAllExcept(String username) {
        return repo.findAll().stream()
                .filter(u -> !u.getUsername().equals(username))
                .toList();
    }

    // ✅ Get all registered users (admin or debug use)
    public List<User> findAll() {
        return repo.findAll();
    }

    // ✅ Find single user by username
    public User findByUsername(String username) {
        return repo.findByUsername(username);
    }

    public List<User> getAllUsersExcept(String username) {
        return repo.findAll().stream()
                .filter(u -> !u.getUsername().equals(username))
                .toList();
    }

	public User validateUser(String username, String password) {
		// TODO Auto-generated method stub
		return repo.findByUsername(username);
	}
	}

