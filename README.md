Strapi App on AWS EC2 using Terraform

This repository contains a Strapi CMS application deployed on an AWS EC2 instance with PostgreSQL as the database.

Features

Strapi v5.x CMS

PostgreSQL database

Admin panel accessible via public IP

Configured .env for database and app secrets

Ready for production deployment

Prerequisites

AWS EC2 instance (Ubuntu 22.04 recommended)

Node.js 20.x

NPM >=6

PostgreSQL database

Security group allowing HTTP/HTTPS (port 1337 for Strapi)

Setup & Deployment

SSH into EC2

ssh -i "strapi-key.pem" ubuntu@<EC2_PUBLIC_IP>


Install Node.js

sudo apt update
sudo apt install -y nodejs npm


Install project dependencies

cd strapi-app/Strapi-app
npm install


Set up PostgreSQL

sudo -i -u postgres
psql
CREATE DATABASE strapidb;
ALTER USER postgres WITH PASSWORD 'YourNewStrongPassword';
\q
exit


Configure .env

DATABASE_CLIENT=postgres
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=strapidb
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=YourNewStrongPassword
ADMIN_JWT_SECRET=yourgeneratedsecret
APP_KEYS=key1,key2,key3,key4
API_TOKEN_SALT=xKcCzQF6/Zmy3StYXRHSiQ==


Build Strapi Admin Panel

npm run build


Run Strapi in development mode

npm run develop


Access Strapi Admin Panel
Open in browser:

http://13.233.20.96:1337/admin
