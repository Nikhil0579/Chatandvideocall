package com.main.repository;

import com.main.model.Message;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.util.List;

public interface MessageRepository extends JpaRepository<Message, Long> {

    // Fetch all messages between two users (both directions)
	@Query("SELECT m FROM Message m WHERE " +
		       "(m.sender = :user1 AND m.receiver = :user2) OR " +
		       "(m.sender = :user2 AND m.receiver = :user1) " +
		       "ORDER BY m.id ASC")
		List<Message> findConversation(@Param("user1") String user1,
		                               @Param("user2") String user2);

}
