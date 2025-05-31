# 🏎️ Slip Stream ƪ( ` ▿▿▿▿ ´ ƪ)

*A curated social media experience for Formula 1 fans — where racing news meets community.*



## 📌 Overview

**Slip Stream** will be an iOS-first social media application focused entirely on the world of Formula 1. The MVP will combine curated F1 news and race updates with interactive social features inspired by Twitter/X — such as user posts, comments, likes, and shares.

This project is designed as a 6-week solo sprint to showcase full-stack mobile app development with real-world content integration. It is intended for portfolio use and will evolve iteratively.



## ⚙️ Planned Tech Stack

| Layer        | Technology                               |
| ------------ | ---------------------------------------- |
| **Frontend** | Flutter (iOS-first)                      |
| **Backend**  | Node.js + Express + PostgreSQL           |
| **Auth**     | Clerk                                    |
| **News**     | Lambda + API Gateway (F1 News API)       |
| **Storage**  | AWS S3 for media (image uploads)         |
| **Infra**    | Local development, optionally Dockerized |



## 🗺️ 6-Week Roadmap

### 🗓️ Week 1 – Setup & Research

* [x] Initialize Flutter project (targeting iPhone)
* [x] Set up Node.js backend with Express and PostgreSQL
* [x] build authentication screens from scratch Signup/Signin  
* [ ] Research and test F1 news APIs (e.g. NewsData.io, scraping Formula1.com)

### 🗓️ Week 2 – Backend Models & News Integration

* [ ] Create DB models: User, Post, Like, Comment, News
* [ ] Build REST API: `/posts`, `/feed`, `/news`, `/comments`
* [ ] Implement cron-based Lambda to ingest news every 1–2 hours
* [ ] Store articles in a dedicated news table

### 🗓️ Week 3 – Frontend Auth & Feed UI

* [ ] Develop Home Feed UI (mix of news + user posts)
* [ ] Add create-post screen with text/media support
* [ ] Implement comment view for each post

### 🗓️ Week 4 – Profiles & User Interaction

* [ ] Profile screen with user bio, posts, likes
* [ ] Favorite driver selection (dropdown UI)
* [ ] Enable likes, comments, and reposts (“Regrid”)
* [ ] Scaffold notification system (log-based for now)

### 🗓️ Week 5 – UI Polish & QA

* [ ] Improve UI: transitions, shadows, rounded cards
* [ ] Integrate image upload via AWS S3
* [ ] Validate data: post creation, empty feed states
* [ ] Test edge cases: auth errors, invalid inputs

### 🗓️ Week 6 – Launch Prep & Expansion Planning

* [ ] Seed app with demo posts, F1 news, and test users (e.g., @VerstappenFan21)
* [ ] Conduct real device testing (iPhone 15 Pro Max)
* [ ] Document setup and usage
* [ ] Brainstorm and log future features for Cycle 2

---

## 🔁 Key Features (Planned)

* Home Feed: F1 news + user-generated posts
* User Profiles: View posts, likes, and favorite drivers
* Social Interactions: Likes, comments, reposts (“Regrid”)
* Messaging (Basic DM planned for future)
* Heritage Hub: F1 trivia, records, past champions (static content in MVP)

---

## 🌱 Potential Features (Cycle 2)

* Real-time race chatroom (via WebSockets)
* Race weekend trending tags
* Live standings and race data integration
* User polls and race predictions

---

## 📂 Project Status

> This project is currently **in development**. Weekly updates will be added as each milestone is completed.

---

## ✍️ Author

**Developer:** Timothy Itayhi
**Based in:** Australia 
**Tech Focus:** Mobile-first full-stack apps with real-world APIs and serverless integrations


