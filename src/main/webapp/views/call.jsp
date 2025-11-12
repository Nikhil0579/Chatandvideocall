<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
<title>Video Call with ${receiver}</title>
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<style>
body {
  font-family: Arial;
  background: #f5f5f5;
  text-align: center;
  padding: 20px;
}
video {
  width: 40%;
  margin: 10px;
  border: 2px solid #ccc;
  border-radius: 10px;
  background: black;
}
button {
  margin: 10px;
  padding: 10px 20px;
  font-size: 16px;
  border-radius: 6px;
  border: none;
  cursor: pointer;
}
#startBtn { background: #007bff; color: white; }
#endBtn { background: #dc3545; color: white; }
</style>
</head>
<body>

<h2>${sender} calling ${receiver}</h2>
<video id="localVideo" autoplay playsinline muted></video>
<video id="remoteVideo" autoplay playsinline></video><br>

<button id="startBtn" onclick="startCall()">Start Call</button>
<button id="endBtn" onclick="endCall()" disabled>End Call</button>

<script>
let sender = '${sender}';
let receiver = '${receiver}';
let stomp = Stomp.over(new SockJS('/ws'));
let pc = new RTCPeerConnection({ iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] });
let remoteDescSet = false, pendingCandidates = [];
let localStream = null;

navigator.mediaDevices.getUserMedia({ video: true, audio: true })
.then(stream => {
  localStream = stream;
  document.getElementById('localVideo').srcObject = stream;
  stream.getTracks().forEach(t => pc.addTrack(t, stream));
});

pc.ontrack = e => { document.getElementById('remoteVideo').srcObject = e.streams[0]; };
pc.onicecandidate = e => { if (e.candidate) sendSignal("CANDIDATE", JSON.stringify(e.candidate)); };

stomp.connect({}, () => {
  stomp.subscribe("/topic/call/" + sender, msg => {
    const data = JSON.parse(msg.body);
    if (data.type === "OFFER") handleOffer(data);
    if (data.type === "ANSWER") handleAnswer(data);
    if (data.type === "CANDIDATE") handleCandidate(data);
  });
});

function sendSignal(type, content) {
  stomp.send("/app/call.signal", {}, JSON.stringify({ sender, receiver, type, content }));
}

async function startCall() {
  document.getElementById('startBtn').disabled = true;
  document.getElementById('endBtn').disabled = false;
  const offer = await pc.createOffer();
  await pc.setLocalDescription(offer);
  sendSignal("OFFER", JSON.stringify(offer));
}

async function handleOffer(data) {
  const offer = JSON.parse(data.content);
  if (pc.signalingState !== "stable") return;
  await pc.setRemoteDescription(new RTCSessionDescription(offer));
  remoteDescSet = true;
  const answer = await pc.createAnswer();
  await pc.setLocalDescription(answer);
  sendSignal("ANSWER", JSON.stringify(answer));
}

async function handleAnswer(data) {
  const answer = JSON.parse(data.content);
  if (pc.signalingState !== "have-local-offer") return;
  await pc.setRemoteDescription(new RTCSessionDescription(answer));
  remoteDescSet = true;
  for (const c of pendingCandidates)
    await pc.addIceCandidate(new RTCIceCandidate(c));
  pendingCandidates = [];
}

async function handleCandidate(data) {
  const candidate = JSON.parse(data.content);
  if (remoteDescSet) await pc.addIceCandidate(new RTCIceCandidate(candidate));
  else pendingCandidates.push(candidate);
}

function endCall() {
  document.getElementById('endBtn').disabled = true;
  if (localStream) localStream.getTracks().forEach(track => track.stop());
  pc.close();
  stomp.disconnect();
  alert("Call ended");
  window.location.href = '/dashboard';
}
</script>
</body>
</html>
