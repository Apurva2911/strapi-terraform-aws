# Strapi Deployment on AWS EC2 using Terraform

A real-world, production-style deployment of **Strapi v4** on an **AWS EC2 (Ubuntu 22.04)** instance provisioned entirely using **Terraform**, with **PostgreSQL installed directly on EC2**. This project demonstrates Infrastructure as Code (IaC), backend deployment, and secure configuration practices.

---

## 🚀 Features

* Infrastructure provisioned using **Terraform (IaC)**
* Custom VPC with public subnets
* EC2 instance running Ubuntu 22.04
* Strapi v4 headless CMS deployment
* PostgreSQL database installed on EC2
* Secure environment variable configuration
* Production-style AWS networking & security

---

## 🛠️ Tech Stack

* **Infrastructure as Code:** Terraform
* **Cloud Provider:** AWS
* **Compute:** EC2 
* **Networking:** VPC, Subnets, Internet Gateway, Route Tables
* **Security:** Security Groups, SSH Key Pair
* **Backend:** Strapi v4 (Node.js)
* **Database:** PostgreSQL (on EC2)
* **OS:** Ubuntu 22.04
* **Version Control:** Git & GitHub

---

## 📂 Project Structure

```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf

Strapi-app/
├── config/
│   ├── database.js
│   └── server.js
├── src/
├── Dockerfile
├── package.json
├── package-lock.json
├── .env.example
└── README.md
```

---

## ⚙️ Environment Configuration

The application uses environment variables for configuration. Sensitive files are **not committed** to GitHub.

Create a `.env` file using the example below:

```env
DATABASE_CLIENT=postgres
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_NAME=strapidb
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=your_password

ADMIN_JWT_SECRET=your_admin_jwt_secret
APP_KEYS=key1,key2,key3,key4
API_TOKEN_SALT=your_api_token_salt
JWT_SECRET=your_jwt_secret
```

---

## 🗄️ Database Setup (PostgreSQL)

### 1️⃣ Install PostgreSQL on EC2

```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib
```

### 2️⃣ Switch to postgres user

```bash
sudo -i -u postgres
```

### 3️⃣ Create Database & User

```sql
psql
CREATE DATABASE strapidb;
CREATE USER postgres WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON DATABASE strapidb TO postgres;
\q
exit
```

### 4️⃣ Verify Connection

```bash
psql -U postgres -d strapidb
```

This ensures that Strapi can connect using the `.env` credentials.

Example startup output from Strapi:

```
✔ Database Connected
✔ Strapi started successfully
```

---

## ▶️ Application Deployment on EC2

After Terraform provisions the EC2 instance:

### 1️⃣ SSH into EC2

```bash
ssh -i strapi-key.pem ubuntu@<EC2_PUBLIC_IP>
```

### 2️⃣ Install Dependencies

```bash
sudo apt update
sudo apt install -y nodejs npm
```

### 3️⃣ Configure Environment Variables

See `.env` file section above.

### 4️⃣ Start Strapi

```bash
npm install
npm run develop
```

Access Admin Panel:

```
http://<EC2-PUBLIC-IP>:1337/admin
```

---

## 📸 Screenshots

Recommended screenshots to include:

1. **Terminal output** showing:

   * `Database Connected`
   * `Strapi started successfully`

2. **Strapi Admin Dashboard** after successful login

> Note: Database credentials are not exposed in the admin UI for security reasons.

---

## 🔐 Security Best Practices

* `.env` file is excluded using `.gitignore`
* Secrets and credentials are never committed
* Environment-based configuration is used

---

## 🌍 Infrastructure Provisioning (Terraform)

All AWS infrastructure for this project is provisioned using **Terraform**, ensuring repeatable and version-controlled deployments.

### AWS Resources Created

* Custom **VPC** (`10.0.0.0/16`)
* **2 Public Subnets** across different Availability Zones
* **Internet Gateway** and **Public Route Table**
* **Security Group** allowing:

  * SSH (22)
  * Strapi (1337)
* **EC2 Instance** (Ubuntu 22.04)
* **TLS-generated SSH Key Pair** (Terraform-managed)

### Terraform Workflow Used

```bash
terraform init
terraform plan
terraform apply
```

After apply, Terraform outputs a public EC2 instance accessible via SSH.

---

## 📌 Deployment Notes

* PostgreSQL uses peer authentication on Ubuntu
* Strapi connects using password authentication from `.env`
* This setup follows production-style deployment practices

---

## 🧠 Key Learnings

* Designing AWS networking using Terraform
* Provisioning EC2 and security resources via IaC
* Installing and configuring PostgreSQL on EC2
* Deploying Strapi on a Linux server
* Managing secrets using environment variables
* Understanding PostgreSQL peer authentication on Ubuntu
* Clean Git workflows for infrastructure + application code

---

## 👤 Author

**Apurva**
GitHub: (https://github.com/Apurva2911)


