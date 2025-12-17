# 🚀 Spring Boot CI/CD Deployment on Google Cloud
**Jenkins + Docker + Artifact Registry + Cloud Run**

This document explains **step-by-step** how to deploy a **Spring Boot multi-module project** using a full **CI/CD pipeline** with **Jenkins**, **Docker**, and **Google Cloud Platform (GCP)**.

---

## 🧭 Architecture Overview

```
GitHub
   ↓
Jenkins (Windows)
   ↓
Maven build (JAR)
   ↓
Docker build
   ↓
Artifact Registry (Docker Repository)
   ↓
Cloud Run (Serverless container)
   ↓
Public HTTPS URL
```

---

## 1️⃣ Create Google Cloud Account & Project

### 1.1 Create Google Cloud Account
- Go to https://cloud.google.com/
- Sign in with a Google account
- Activate **Free Trial**
- 💳 **Billing account is mandatory**

> ⚠️ Even during the free trial, **a billing account is required** to use Cloud Run and Artifact Registry.

### 1.2 Create a Project
- Google Cloud Console → Project selector → **New Project**
- Project name: `springbootmicroservicetp`
- Click **Create**

---

## 2️⃣ Billing Account (IMPORTANT ⚠️)

Some Google Cloud services **DO NOT work without an active billing account**, even if usage is minimal.

### Services that REQUIRE Billing:
- ✅ Cloud Run
- ✅ Artifact Registry
- ✅ Cloud Build
- ✅ Container Registry
- ✅ VPC / Networking (if used)

### Services that MAY work without billing (limited):
- IAM
- Service Accounts
- Cloud Console UI

📌 If billing is **not enabled**, deployments will fail with errors such as:
```
Cloud Run API has not been used or billing is disabled
```

👉 Enable billing here:  
https://console.cloud.google.com/billing

---

## 3️⃣ Enable Required APIs

Enable the following APIs **after billing is enabled**:

- Cloud Run Admin API
- Artifact Registry API
- IAM Service Account Credentials API

👉 https://console.cloud.google.com/apis/library

---

## 4️⃣ Create Artifact Registry (Docker Repository)

- Open **Artifact Registry**
- Create Repository
- Name: `springbootmicroserve-repo`
- Format: **Docker**
- Location: `europe-west1`

### Docker Image URL Format
```
europe-west1-docker.pkg.dev/springbootmicroservicetp/springbootmicroserve-repo/runner-ms
```

---

## 5️⃣ Create Service Account for Jenkins

### 5.1 Create Service Account
- IAM & Admin → Service Accounts
- Create service account
- Name: `jenkins-deployer`

### 5.2 Assign Roles
Assign **minimum required permissions**:

- Cloud Run Admin
- Artifact Registry Writer
- Service Account User
- Viewer  
(Optional: Owner for learning/demo environments)

---

## 6️⃣ Create Service Account Key (JSON)

- Service account → **Keys**
- Create new key → **JSON**
- Download the file

⚠️ **Security warning**
- Never commit this file to GitHub
- Never expose it publicly
- Store it securely in Jenkins credentials

---

## 7️⃣ Install Required Tools on Jenkins Machine (Windows)

### Java 17
https://adoptium.net/

### Maven
https://maven.apache.org/download.cgi

### Docker Desktop
https://www.docker.com/products/docker-desktop/

### Google Cloud CLI
https://cloud.google.com/sdk/docs/install

⚠️ **Do NOT run**:
```bat
gcloud init
```

Verify:
```bat
gcloud --version
```

---

## 8️⃣ Manual Authentication Test (Recommended)

```bat
gcloud auth activate-service-account --key-file=jenkins-sa.json
gcloud config set project springbootmicroservicetp
gcloud artifacts repositories list --location=europe-west1
gcloud run services list --region=europe-west1
```

---

## 9️⃣ Dockerfile

```dockerfile
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY runner-ms/target/runner-ms-1.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENV PORT=8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
```

---

## 🔟 Jenkins Credentials

- Jenkins → Manage Jenkins → Credentials
- Scope: Global
- Kind: Secret file
- Upload the JSON service account key
- ID: `gcp-sa-key`

---

## 1️⃣1️⃣ Jenkins Pipeline

- Builds JAR
- Builds Docker image
- Pushes image to Artifact Registry
- Deploys to Cloud Run
- Outputs public HTTPS URL

---

## 1️⃣2️⃣ Access Application

```
https://runner-ms-xxxxx-ew.a.run.app
```

Swagger UI:
```
/swagger-ui/index.html
```

---

## ✅ Done

You now have a **production-ready CI/CD pipeline** for Spring Boot on Google Cloud 🚀
