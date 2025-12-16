# 🍽️ AI Recipe Maker with Weather Awareness (n8n + LLM)
### 📌 Project Overview

This project is an **AI-powered recipe recommendation agent built with n8n**, integrating a local LLM (via Ollama) and a weather API.

The agent:
- Receives ingredients from a user (chat-based)
- Retrieves current weather conditions
- Generates a **recipe adapted to weather, time, and constraints**
- Includes **calorie estimation**
- Handles errors gracefully with **fallback responses**

This project was focusing on **automation, LLM agents, and production-ready workflows.**

---

### 🧠 Use Case

##### Problem: Users often don’t know what to cook with available ingredients, limited time, and external conditions (e.g. cold or hot weather).

##### Solution 
An AI agent that:
- Adapts recipes based on ingredients
- Adjusts recommendations based on weather
- Provides clear, structured output
- Works through a chat interface

---

### 🏗️ Technical Architecture

**Stack**
- n8n – workflow orchestration
- Ollama – local LLM inference
- LLM model: qwen2.5:1.5b
- OpenWeather API – real-time weather
- Docker & Docker Compose
- PostgreSQL – n8n internal persistence

---

### High-level flow

```
Chat Trigger
   ↓
AI Agent (LLM + Weather Tool)
   ↓
IF (error detection)
   ├── Error → Respond to Chat (fallback)
   └── Success → Respond to Chat (recipe)
```

--- 

### 🐳 Setup Instructions (from scratch)
##### 1️⃣ Prerequisites
- Docker & Docker Compose installed
- Git
- Node.js (optional, only for local tests)
- Minimum 8 GB RAM recommended (LLM inference)

--- 
### 2️⃣ Project Setup
##### Clone the repository:
```
git clone https://github.com/<your-username>/<repo-name>.git
cd Agent_AI_N8N_LLM_Receipt_Maker
```
---

### 3️⃣ Environment Variables
###### Create a .env file (never commit it):
```
# PostgreSQL
POSTGRES_DB=n8n
POSTGRES_USER=n8n
POSTGRES_PASSWORD=strongpassword

# n8n
N8N_BASIC_AUTH_ACTIVE=false
N8N_HOST=localhost
N8N_PORT=5678
N8N_PROTOCOL=http

# OpenWeather
OPENWEATHER_API_KEY=your_api_key_here
```

---

### 4️⃣ Docker Stack Launch
##### Run:
```./setup-bash.sh```
This will:
1. Pull Docker images
2. Create volumes

Start:
1. PostgreSQL
2. n8n
3. Ollama
   
---
### 🤖 LLM Setup (Ollama)
* Pull a lightweight model (important)
* Initial attempt with llama3 failed due to memory limits.
#### Solution: use a smaller model.

```docker exec -it ollama ollama pull qwen2.5:1.5b```


Test:
```
curl http://localhost:11434/api/generate \
-d '{"model":"qwen2.5:1.5b","prompt":"Say hello"}'
```

### 🔄 n8n Workflow Creation
#### Nodes used

##### 1. Chat Trigger*
* Response Mode: Using Response Nodes
##### 2. AI Agent
* Model: Gemini / Ollama (final choice: Gemini)
* System prompt = long structured prompt
##### Tools:
* Weather API (OpenWeather)
##### IF Node
* Condition: output is empty
* Respond to Chat (Success)
##### Response:
* {{ $json.output }}
##### Respond to Chat (Error)
* Fallback message

---
### 🧠 Prompt Engineering
1. System Prompt (long prompt) is placed inside the AI Agent node.
2. User Prompt (short prompt)
Provided dynamically via chat, for example:
```
tomato, cheese, basil, rice, baguette, garlic – 30 minutes
```
n8n automatically treats chat input as the user message.

---
### 📚 Key Learnings
a) How to deploy n8n with Docker

b) How to integrate local and cloud LLMs

c) Prompt engineering (system vs user prompts)

d) Error handling in automation workflows

e) Security best practices (secrets & Git)

---
### 👩‍💻 Author

Developed by *Arailym PERNEBAY*

2025
