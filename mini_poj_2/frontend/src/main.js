
document.getElementById('app').innerText = 'Frontend is working!';

const form = document.getElementById('login-form');
if (form) {
	form.addEventListener('submit', async function(e) {
		e.preventDefault();
		const username = document.getElementById('username').value;
		const password = document.getElementById('password').value;
		try {
			const res = await fetch('http://127.0.0.1:5000/login', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({ username, password })
			});
			const data = await res.json();
			if (res.status === 200) {
				window.location.href = 'success.html';
			} else {
				document.getElementById('app').innerText = data.message || JSON.stringify(data);
			}
		} catch (err) {
			document.getElementById('app').innerText = 'Error connecting to backend.';
		}
	});
}
