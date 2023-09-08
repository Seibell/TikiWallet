# TikiWallet
E-wallet with offline transaction support for Tiktok hackathon 2023

## 𝌞 Table of Contents
- [About](#about)
    - [Problem Statement](#problem-statement)
    - [Motivation](#motivation)
    - [Target Audience](#target-audience)
    - [Value Proposition](#value-proposition)
    - [Tech Stack](#tech-stack)
    - [Architecture](#architecture)
- [Features](#features)
    - [Authentication](#authentication)
    - [Topups and Withdrawls](#topup-and-withdrawal)
    - [Online Wallet](#online-wallet)
    - [Offline Wallet](#offline-wallet)
- [Roadmap for Scalability and Availability](#roadmap-for-scalability-and-availability)

## About
### <a name="problem-statement"></a>❓ Problem Statement
Problem statement 4: 
How can new technologies in digital wallets enable new and trustworthy user experiences?

### <a name="motivation"></a>💡 Motivation
With the advancement of technology, underserved regions or areas have trouble keeping up with the latest trends such as the lack of a stable WiFi connection. For financial inclusivity, TikiWallet enables transactions between users with no WiFi connections at all.

### <a name="target-audience"></a>🧑 Target Audience
- The general public
- People with no access to a stable WiFi or mobile data connection on the go

### <a name="value-proposition"></a>❗ Value Proposition
TikiWallet partitions your wallet into 2 wallets - online and offline.
In addition to your typical online transactions between users, users are able to send and receive transactions offline by being in contact with the receiver.

### <a name="tech-stack"></a>💻 Tech Stack
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Express.js](https://img.shields.io/badge/express.js-%23404d59.svg?style=for-the-badge&logo=express&logoColor=%2361DAFB)
![NodeJS](https://img.shields.io/badge/node.js-6DA55F?style=for-the-badge&logo=node.js&logoColor=white)
![Postgres](https://img.shields.io/badge/postgres-%23316192.svg?style=for-the-badge&logo=postgresql&logoColor=white)
![Prisma](https://img.shields.io/badge/Prisma-3982CE?style=for-the-badge&logo=Prisma&logoColor=white)
![Google Cloud](https://img.shields.io/badge/GoogleCloud-%234285F4.svg?style=for-the-badge&logo=google-cloud&logoColor=white)
![Render](https://img.shields.io/badge/Render-%46E3B7.svg?style=for-the-badge&logo=render&logoColor=white)
![Stripe](https://img.shields.io/badge/Stripe-008CDD.svg?style=for-the-badge&logo=Stripe&logoColor=white)
![Twilio](https://img.shields.io/badge/Twilio-F22F46.svg?style=for-the-badge&logo=Twilio&logoColor=white)

**Client**:
- Flutter

**Backend**:
- Express/ NodeJS hosted on Render
- PostgreSQL hosted on Google CloudSQL
- Prisma ORM

**APIs Used**:
- Stripe
- Twilio

### <a name="architecture"></a>🔨 Architecture
Adopted a client-server monolithic architecture

Considerations:
- Small prototype project
- Fast development

![Basic Architecture](/lib/tikiwallet%20msa.jpg)
*Architecture Diagram*

## Features
### <a name="authentication"></a>🔒 Authentication
Aim:
- To reduce fraud and phishing using 2FA method through OTP SMS verification
- Encrypted access to restrict access to the app by sessions through JWT

Authentication and session management is carried out using JSON Web Tokens.

*Register:*
- Users are to create an account with phone number, username and password
- They will then be sent an OTP through SMS to be verified with a 6 digit PIN code.

*Login:*
- Users login with phone number and password

*Session management:*
- JWT is set to expire after 6hours to ensure user authorization
- Limits access to in-app routes to signed in users
- Prevents security threats like Cross-Site Request Forgery and Cross-site Scripting



### <a name="topup-and-withdraw"></a>💳 Topups and Withdrawals
Aim:
- Utilize Stripe API to add funds from the user's bank to the wallet
- Utilize Stripe API to retract funds from the user's wallet to the bank

###  <a name="online-wallet"></a>📶 Online Wallet
Aim:
- Transfer of funds between users over the internet

###  <a name="offline-wallet"></a>📂 Offline Wallet
Aim:
- Transfer of funds between users without internet access
- Physical contact between users to ensure authentication and security


## Roadmap for Scalability and Availability
**Phase 1️⃣: Assessment and Planning**
1. Define Objectives and Metrics
    - What level of traffic can your app handle? What is the acceptable downtime?
2. Understand Current State
    - Assess your current infrastructure, technology stack, and application architecture. Identify bottlenecks and potential points of failure.
3. User and Traffic Analysis
    - Analyze user patterns, peak usage times, and geographic distribution. Understand your user base and how it may grow over time.
4. Cost Analysis
    - Estimate the budget required for implementing scalability and availability improvements. Consider cloud services, additional hardware, and software costs.

**Phase 2️⃣: Architecture and Design**
1. Microservices Architecture
    - Auth Service
    - Transactions Service
    - Accounts DB NoSQL, Transactions DB PostgreSQL
2. Containerization and Orchestration
    - Kubernetes
3. Load Balancing
    - Distribute incoming traffic across multiple servers to ensure high availability and even load distribution.
4. Database Scaling
    - Partition data into 2 databases for each service: PostgreSQL for transactions and MongoDB for authentication/accounts. 
    - Database sharding based on geographical locations of users hosted on separate servers.
    - Autoscaling with AWS to automatically adjust number of database instances
5. Caching Strategies
    - Redis to reduce database load and improve response times for information frequently accessed. Like user account balance and transaction history.
    - Store API request and response data to allow rate limiting and throttling strategies.

**Phase 3️⃣: Infrastructure and Deployment**
1. Cloud Adoption
    - Deploy onto AWS EKS
2. Auto-scaling
    - Configure auto-scaling policies to automatically adjust resources based on traffic and demand. Utilize serverless computing where possible.
3. Data Replication and Backup
    - Implement data replication across multiple regions for disaster recovery and backup.

**Phase 4️⃣: Monitoring and Optimization**
1. Real-time Monitoring
    - AWS cloudwatch to track the health and performance of your application and infrastructure. Configure alarms to trigger notifications when CPU utilization, memory usage, network traffic and storage thresholds exceed. Automatically adjust number of instances based on predefined scaling policies based on cloudwatch triggers.
2. Performance Testing
    - Regularly conduct load testing to identify performance bottlenecks
3. Disaster Recovery Plan
    - Data Replication for databases
    - Automate cluster provisioning with IaC or AWS Cloudformation to quickly recreate the cluster.
    - Third party disaster recovery services or AWS Disaster Recovery Service

**Phase 5️⃣: Scaling and Growth**
1. Scalability Testing
    - Conduct scalability tests to ensure increased loads can be handled especially during peak times.
2. User Feedback
    - Continuously gather user feedback and adjust scalability and availability strategies based on user needs and expectations.
3. Global Expansion
    - Expand the app to new geographic regions to demonstrate financial inclusion. Main purpose of our wallet is to allow transactions even without WiFi access which are more applicable to regions with lesser developed technology and reach.

![Scale MSA](/lib/Tikiwallet%20Scale%20MSA.jpg)
*A brief overview of the scalability and availability plan*

## ✍🏻 Contributors
* Benjamin Toh [@bentohset](https://github.com/bentohset)
* Muhammad Jabir [@muhdjabir](https://github.com/muhdjabir)
* Ryan Ong [@ryanongwx](https://github.com/ryanongwx)
* Ryan Lim [@Seibell](https://github.com/Seibell)
* Wang Yu Teng [@WangYuTengg](https://github.com/WangYuTengg)
