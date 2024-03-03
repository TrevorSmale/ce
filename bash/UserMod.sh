#!/bin/bash
     
     # Add a new user
     USER_NAME="newuser"
     PASSWORD="password123"
     useradd -m -s /bin/bash "$USER_NAME"
     echo "$USER_NAME:$PASSWORD" | chpasswd
     
     # Modify user attributes
     usermod -aG sudo "$USER_NAME"
     
     # Remove a user
     # userdel -r "$USER_NAME"