
#!/bin/bash

# Define the repository path
REPO_PATH="/home/haroon/Documents/Obsidian Vault"


# Define the log file
LOG_FILE="/home/haroon/mydata/mydata1/auto_push.log"


# Navigate to the repository directory
cd "$REPO_PATH" || { echo "Failed to navigate to repository directory" >> "$LOG_FILE"; exit 1; }

# Log the current date and time
echo "Running pushgit.sh at $(date)" >> "$LOG_FILE"

# Add all changes to git
git add . >> "$LOG_FILE" 2>&1

# Commit the changes with a message including the current date
git commit -m "Automated commit on $(date)" >> "$LOG_FILE" 2>&1

# Push the changes to the remote repository
git push origin obsidian >> "$LOG_FILE" 2>&1

# Output a message indicating the script ran
echo "Changes pushed to GitHub on $(date)" >> "$LOG_FILE"

