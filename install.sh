echo "Welcome to the installation.."
echo "First of all, to secure your installation, you will be creating a user so you're not using root!"
echo "Enter username - and then follow the prompts to create password etc"
read dausername
echo "You entered: $dausername - setting up user..."
adduser $dausername
