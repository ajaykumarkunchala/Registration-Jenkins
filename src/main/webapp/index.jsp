<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Simple Registration</title>
  <style>
    :root{--bg:#f4f7fb;--card:#fff;--accent:#2563eb;--muted:#6b7280}
    body{font-family:Inter, system-ui, -apple-system,Segoe UI, Roboto, "Helvetica Neue", Arial; background:var(--bg); margin:0; padding:40px; display:flex; align-items:center; justify-content:center; min-height:100vh}
    .card{background:var(--card); width:100%; max-width:520px; border-radius:12px; box-shadow:0 6px 22px rgba(38,43,66,0.08); padding:28px}
    h1{margin:0 0 6px 0; font-size:20px}
    p.lead{margin:0 0 18px 0; color:var(--muted); font-size:14px}
    label{display:block; font-size:13px; margin-bottom:6px}
    input[type=text], input[type=email], input[type=password], select{width:100%; padding:10px 12px; border:1px solid #e6e9ef; border-radius:8px; font-size:14px; box-sizing:border-box}
    .row{display:grid; grid-template-columns:1fr 1fr; gap:12px}
    .actions{display:flex; justify-content:space-between; align-items:center; margin-top:18px}
    button{background:var(--accent); color:#fff; border:0; padding:10px 14px; border-radius:8px; cursor:pointer; font-weight:600}
    button.ghost{background:transparent; color:var(--muted); border:1px solid #e6e9ef}
    .muted{color:var(--muted); font-size:13px}
    .error{color:#b91c1c; font-size:13px; margin-top:6px}
    .success-page{display:none}
    .small{font-size:13px}
    footer{margin-top:16px; text-align:center; color:var(--muted); font-size:13px}
  </style>
</head>
<body>
  <div class="card" id="app">
    <!-- Registration Form -->
    <div id="form-page">
      <h1>Create an account</h1>
      <p class="lead">Quick and simple registration form — client-side validation only.</p>

      <form id="regForm" novalidate>
        <label for="fullname">Full name</label>
        <input id="fullname" name="fullname" type="text" placeholder="e.g. Ajay Kumar" required />

        <div style="height:12px"></div>

        <label for="email">Email</label>
        <input id="email" name="email" type="email" placeholder="you@example.com" required />

        <div style="height:12px"></div>

        <div class="row">
          <div>
            <label for="password">Password</label>
            <input id="password" name="password" type="password" placeholder="At least 6 characters" required />
          </div>

          <div>
            <label for="confirm">Confirm password</label>
            <input id="confirm" name="confirm" type="password" placeholder="Retype password" required />
          </div>
        </div>

        <div style="height:12px"></div>

        <label for="phone">Phone (optional)</label>
        <input id="phone" name="phone" type="text" placeholder="+91 98765 43210" />

        <div style="height:12px"></div>

        <label for="country">Country</label>
        <select id="country" name="country">
          <option value="">Select country</option>
          <option>India</option>
          <option>United States</option>
          <option>United Kingdom</option>
          <option>Canada</option>
          <option>Australia</option>
        </select>

        <div style="height:12px"></div>

        <label style="display:flex; align-items:center; gap:8px"><input id="agree" type="checkbox"/> <span class="small">I agree to the terms and privacy policy</span></label>

        <div id="error" class="error" aria-live="polite" style="display:none"></div>

        <div class="actions">
          <button type="button" class="ghost" id="resetBtn">Reset</button>
          <button type="submit" id="submitBtn">Register</button>
        </div>
      </form>

      <footer>Already have an account? <a href="#" onclick="alert('In a real app this would go to login.')">Login</a></footer>
    </div>

    <!-- Success Page -->
    <div id="success-page" class="success-page">
      <h1>Registration complete</h1>
      <p class="lead" id="successMessage">Thanks for registering — we've sent a confirmation email.</p>

      <div style="margin-top:12px">
        <strong>Account</strong>
        <div id="accountSummary" style="margin-top:8px; font-size:14px; color:var(--muted)"></div>
      </div>

      <div style="margin-top:18px; display:flex; gap:10px">
        <button id="goHome">Go to dashboard</button>
        <button class="ghost" id="registerAnother">Register another</button>
      </div>
    </div>
  </div>

  <script>
    const form = document.getElementById('regForm');
    const errorEl = document.getElementById('error');
    const formPage = document.getElementById('form-page');
    const successPage = document.getElementById('success-page');
    const accountSummary = document.getElementById('accountSummary');

    function showError(msg){ errorEl.textContent = msg; errorEl.style.display = 'block'; }
    function clearError(){ errorEl.textContent = ''; errorEl.style.display = 'none'; }

    function validate(){
      clearError();
      const name = document.getElementById('fullname').value.trim();
      const email = document.getElementById('email').value.trim();
      const pw = document.getElementById('password').value;
      const confirm = document.getElementById('confirm').value;
      const agree = document.getElementById('agree').checked;

      if(!name) { showError('Please enter your full name.'); return false; }
      if(!email || !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)){ showError('Please enter a valid email address.'); return false; }
      if(pw.length < 6){ showError('Password must be at least 6 characters.'); return false; }
      if(pw !== confirm){ showError('Passwords do not match.'); return false; }
      if(!agree){ showError('You must agree to the terms to continue.'); return false; }
      return true;
    }

    form.addEventListener('submit', function(e){
      e.preventDefault();
      if(!validate()) return;

      // collect data
      const data = {
        name: document.getElementById('fullname').value.trim(),
        email: document.getElementById('email').value.trim(),
        phone: document.getElementById('phone').value.trim(),
        country: document.getElementById('country').value
      };

      // In a real app you'd POST this to the server (fetch('/register', {method:'POST', body: JSON.stringify(data)}))
      // For this simple demo we'll just show the success page.

      accountSummary.innerHTML = `Name: ${escapeHtml(data.name)}<br/>Email: ${escapeHtml(data.email)}<br/>Phone: ${escapeHtml(data.phone || '—')}<br/>Country: ${escapeHtml(data.country || '—')}`;
      document.getElementById('successMessage').textContent = `Thanks, ${data.name.split(' ')[0]} — your account has been created.`;

      formPage.style.display = 'none';
      successPage.style.display = 'block';
    });

    document.getElementById('resetBtn').addEventListener('click', ()=>{ form.reset(); clearError(); });
    document.getElementById('registerAnother').addEventListener('click', ()=>{ form.reset(); clearError(); successPage.style.display='none'; formPage.style.display='block'; });
    document.getElementById('goHome').addEventListener('click', ()=>{ alert('This would go to the user dashboard in a real app.'); });

    // small helper to avoid XSS when inserting user values into DOM
    function escapeHtml(s){ return String(s).replace(/[&<>"']/g, function(c){ return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":"&#39;"}[c]; }); }
  </script>
</body>
</html>
