#!/bin/bash
# Install nginx and deploy a simple registration form
apt-get update -y
apt-get install -y nginx


cat > /var/www/html/index.html <<'EOF'
<!doctype html>
<html>
<head><meta charset="utf-8"><title>Register</title></head>
<body>
<h1>Register</h1>
<form method="post" action="http://APP_PRIVATE_IP/submit.php">
Name: <input type="text" name="name"><br>
Email: <input type="email" name="email"><br>
<input type="submit" value="Submit">
</form>
</body>
</html>
EOF


systemctl restart nginx