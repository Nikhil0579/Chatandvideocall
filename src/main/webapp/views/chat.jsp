<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
<title>Chat</title>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>
<style>
#userList {
    border: 1px solid #ccc;
    width: 200px;
    padding: 5px;
}
#userList li {
    cursor: pointer;
    padding: 6px;
    border-bottom: 1px solid #eee;
}
#userList li:hover {
    background: #f5f5f5;
}
#chatBox {
    border: 1px solid gray;
    height: 300px;
    width: 400px;
    overflow: auto;
    padding: 5px;
    background: #fafafa;
}
</style>
</head>
<body>
<h2>Welcome ${user.username}</h2>

<h3>Registered Users</h3>
<ul id="userList">
    <c:forEach var="u" items="${users}">
        <c:if test="${u.username ne user.username}">
            <li onclick="selectUser('${u.username}')">${u.username}</li>
        </c:if>
    </c:forEach>
</ul>

<h3>Chat Box (<span id="chatWith">Select user</span>)</h3>
<div id="chatBox"></div>
<input id="msg" placeholder="Type message" style="width:320px;">
<button onclick="sendMsg()">Send</button>

<script>
let receiver = null;
let stomp = Stomp.over(new SockJS('/ws'));

stomp.connect({}, function() {
    console.log("✅ Connected to WebSocket");

    stomp.subscribe('/topic/chat/${user.username}', function(res) {
        let m = JSON.parse(res.body);
        if ((m.sender === receiver && m.receiver === '${user.username}') ||
            (m.sender === '${user.username}' && m.receiver === receiver)) {
            appendMessage(m.sender, m.content);
        }
    });
});

function selectUser(name) {
    receiver = name;
    document.getElementById('chatWith').innerText = name;
    document.getElementById('chatBox').innerHTML = "";
    // Optional: Load history if you implement API
}

function sendMsg() {
    if (!receiver) { alert("Select a user first"); return; }
    let msg = document.getElementById('msg').value.trim();
    if (msg === "") return;

    stomp.send("/app/chat.private", {}, JSON.stringify({
        sender: '${user.username}',
        receiver: receiver,
        content: msg
    }));
    appendMessage('You', msg);
    document.getElementById('msg').value = "";
}

function appendMessage(sender, content) {
    let chatBox = document.getElementById('chatBox');
    chatBox.innerHTML += `<p><b>${sender}:</b> ${content}</p>`;
    chatBox.scrollTop = chatBox.scrollHeight;
}
</script>
</body>
</html>
