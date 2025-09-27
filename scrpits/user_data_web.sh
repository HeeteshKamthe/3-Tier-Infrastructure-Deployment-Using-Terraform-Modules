#!/bin/bash
# Install Apache + PHP and create submit.php
apt-get update -y
apt-get install -y apache2 php php-mysql curl


cat > /var/www/html/submit.php <<'EOF'
<?php
$dbHost = 'DB_ENDPOINT_PLACEHOLDER';
$dbUser = 'DBUSER_PLACEHOLDER';
$dbPass = 'DBPASS_PLACEHOLDER';
$dbName = 'DBNAME_PLACEHOLDER';


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
$name = $_POST['name'];
$email = $_POST['email'];


$conn = new mysqli($dbHost, $dbUser, $dbPass, $dbName);
if ($conn->connect_error) {
die('Connection failed: ' . $conn->connect_error);
}


$stmt = $conn->prepare("INSERT INTO registrations (name, email) VALUES (?, ?)");
$stmt->bind_param('ss', $name, $email);
$stmt->execute();
echo "Thanks, registered!";
$stmt->close();
$conn->close();
}
?>
EOF


php -r "\$mysqli = new mysqli('DB_ENDPOINT_PLACEHOLDER','DBUSER_PLACEHOLDER','DBPASS_PLACEHOLDER','DBNAME_PLACEHOLDER'); if (!\$mysqli->connect_error) { \$mysqli->query('CREATE TABLE IF NOT EXISTS registrations (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255), email VARCHAR(255))'); }"


systemctl restart apache2