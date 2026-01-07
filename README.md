# 3-Tier Infrastructure Deployment Using Terraform & Ansible

This project provisions and configures a **3-tier web application architecture on AWS** using **Terraform** (for infra) and **Ansible** (for configuration management).

---

## 📂 Project Structure

```
3-Tier-Infrastructure-Deployment-Using-Terraform-Modules/
|
├──modules/
│  ├── vpc/
│  ├── web/
│  ├── app/
│  └── rds/
├── provider.tf
├── main.tf
├── variable.tf
├── terraform.tfvars
└── output.tf
|
├── ansible/
|   ├── hosts.ini
│   ├── playbook.yml
│   ├── vars.yml
│   └── templates/
│   |   ├── form.html.j2
│   |   └── submit.php.j2
|   └── files
│       └── init.sql
|
├── README.md → Project documentation
```

---

## 📌 Architecture Overview

The architecture is divided into three tiers:

1. **Networking (VPC)**
   - Custom VPC with public and private subnets across 2 AZs
   - Internet Gateway for public subnets
   - NAT Gateway for private subnets
   - Route Tables and associations
   - Security Groups and NACLs for isolation

2. **Web Tier (Public Subnet)**
   - EC2 instance in public subnet
   - NGINX installed
   - Hosts a basic HTML registration form (`form.html`)
   - Acts as a **reverse proxy** to forward requests to the App tier

3. **Application Tier (Private Subnet)**
   - EC2 instance in private subnet
   - Runs PHP-FPM and NGINX
   - Hosts `submit.php` which processes form submissions
   - Connects to the database tier (RDS)

4. **Database Tier (Private Subnet)**
   - Amazon RDS (MySQL/PostgreSQL)
   - Accessible only from the App tier
   - Stores registration form data

---

## 📖 Prerequisites

* AWS Account with programmatic access (IAM user with EC2, VPC, RDS permissions)
* Installed locally:
  * [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5
  * [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/) >= 2.18
* SSH key pair created (`my-key.pem`) and uploaded in AWS
* Linux/Mac/WSL environment recommended
* Python 3 (for Ansible execution)
* Git installed


---

## 🚀 Deployment Steps

### 1. Clone Repository

```bash
git clone https://github.com/HeeteshKamthe/3-Tier-Infrastructure-Deployment-Using-Terraform-Modules.git
cd 3-Tier-Infrastructure-Deployment-Using-Terraform-Modules
```

### 2. Provision Infrastructure with Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

👉 Terraform will create:

* VPC, subnets, IGW, NAT, route tables
* EC2 instances (web + app)
* Security groups for each tier
* RDS MySQL instance

Outputs:

* **Web Public IP**
* **App Private IP**
* **RDS Endpoint**

### 3. Configure with Ansible

Update `ansible/hosts.ini` with Terraform outputs:

```ini
[web]
<web-ip> ansible_user=ubuntu ansible_ssh_private_key_file=~/3-Tier-Infrastructure-Deployment-Using-Terraform-Modules/my-key.pem

[app]
<app-ip> ansible_user=ubuntu ansible_ssh_private_key_file=~/3-Tier-Infrastructure-Deployment-Using-Terraform-Modules/my-key.pem \
 ansible_ssh_common_args='-o ProxyCommand="ssh -W %h:%p -i ~/3-Tier-Infrastructure-Deployment-Using-Terraform-Modules/my-key.pem ubuntu@<web-ip>"'
```

Update `ansible/vars.yml` with RDS endpoint and DB credentials:

```yaml
db_endpoint: "terraform-xxxx.rds.amazonaws.com"
db_port: 3306
db_username: "dbadmin"
db_password: "your-password"
db_name: "appdb"
app_private_ip: "<APP_PRIVATE_IP>"
php_fpm_version: "8.3"
```

Run Ansible playbook:

```bash
cd ../ansible
ansible-playbook -i hosts.ini playbook.yml
```

---

## 🔎 Verification

1. Open in browser:

   ```
   http://<WEB_PUBLIC_IP>/form.html
   ```

   Fill the form and submit.

2. Workflow:

   * Request → Web EC2 (NGINX reverse proxy)
   * Forwarded → App EC2 (NGINX + PHP-FPM)
   * `submit.php` → Inserts into RDS

3. Ansible verification tasks:

   * Ensure `users` table exists
   * Insert a test row
   * Fetch last row to confirm DB connection

4. Check Ansible output:

   ```
   last_row.stdout: "id name email website comment gender created_at ..."
   ```

---

## 🖼️ Architecture Diagram

<p align="center"> <img src="img/3tierarchitecture.png" alt="3 tier architecture" width="800"/> </p>


---

## 📷 Screenshots

* `terraform apply` output
 <p align="center"> <img src="img/terraform output.jpg" alt="terraform output" width="800"/> </p>
 
* Ansible playbook run (`ok=... changed=...`)
  <p align="center"> <img src="img/ansible playbook apply.jpg" alt="ansible output" width="800"/> </p>
  
* Browser view of `form.html`
 <p align="center"> <img src="img/forms.html page.jpg" alt="browser forms.html" width="800"/> </p>
 
* Submission success message from `submit.php`
  <p align="center"> <img src="img/submit.php page.jpg" alt="browser submit.php" width="800"/> </p>
  
* RDS table query result
  <p align="center"> <img src="img/database table entry.jpg" alt="RDS table" width="800"/> </p>

---

## 🛑 Cleanup

To avoid AWS charges:

```bash
cd terraform
terraform destroy -auto-approve
```

---


## ⚡ How the System Works

1. **User** accesses Web Tier (NGINX, public subnet).
2. **Web Tier** serves `form.html` and proxies `/submit.php` requests to App Tier.
3. **App Tier** (NGINX + PHP-FPM) runs `submit.php` which processes form data.
4. **App Tier** connects securely to **RDS** in a private subnet.
5. **RDS** stores submitted records in the `users` table.
6. **Security groups** ensure isolation:

   * Web only exposed to internet on 80/22
   * App only accessible from Web SG
   * RDS only accessible from App SG

---
