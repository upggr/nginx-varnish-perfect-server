echo "Welcome to the installation.."
echo "Create a new user.."
read -p 'Username: ' uservar
echo "You entered: $uservar - setting up user..."
sudo useradd $uservar
