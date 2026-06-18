# Enterprise Digital Nervous System (EDNS)

## Enterprise Decision Intelligence Platform

### Overview

Enterprise Digital Nervous System (EDNS) is an AI-powered closed-loop decision intelligence platform designed to help organizations detect signals, understand operational risk, make decisions, execute actions, and continuously improve through feedback-driven learning.

Core Flow:

```text
Sense → Remember → Reason → Predict → Decide → Act → Learn
```

Unlike traditional dashboards or chatbots, EDNS combines:

- SQL Server Enterprise Memory
- AI Decision Intelligence
- Workflow Automation
- Governance & Audit Controls
- Operational Telemetry
- Continuous Learning Loops

---

# Current Build Status

## Phase 1 – Database Foundation ✅ Complete

Implemented and validated in Microsoft SQL Server Express.

### Completed

- EDNS_V1 Database
- 8 Core Tables
- Foreign Key Relationships
- Logical Delete Framework
- Audit & Governance Fields
- Memory Versioning Design
- Seed Data Validation

### Core Tables

1. signal_events
2. enterprise_entities
3. enterprise_memory
4. ai_decisions
5. action_history
6. ai_telemetry
7. decision_feedback
8. learning_execution_log

---

# Architecture

```text
Business Signals
        ↓
Signal Events
        ↓
Enterprise Memory
        ↓
AI Operations Brain
        ↓
AI Decisions
        ↓
Enterprise Actions
        ↓
Telemetry & Feedback
        ↓
Learning Loop
        ↓
Enterprise Memory Update
```

---

# Entity Relationship Overview

```text
signal_events
      │
      ▼
ai_decisions
      │
      ├── action_history
      ├── ai_telemetry
      └── decision_feedback

enterprise_entities
      │
      ▼
enterprise_memory
```

---

# Technology Stack

## Data Layer

- Microsoft SQL Server Express

## Workflow Layer

- n8n (Planned)

## Intelligence Layer

- OpenAI GPT-4o (Planned)

## Analytics Layer

- Power BI (Planned)

## Communication Layer

- Email Notifications
- Microsoft Teams (Planned)

---

# Database Validation

Successfully validated:

- enterprise_entities seed data
- enterprise_memory seed data
- Foreign key relationships
- Core governance architecture

Current Database:

```text
EDNS_V1
```

---

# Roadmap

## Phase 1
✅ SQL Server Database Foundation

## Phase 2
🚧 n8n Signal Processing Pipeline

## Phase 3
🚧 OpenAI Decision Engine Integration

## Phase 4
🚧 Power BI Decision Intelligence Dashboard

## Phase 5
🚧 Closed-Loop Learning Automation

---

# Skills Demonstrated

- Business Systems Analysis
- Technical Business Analysis
- SQL Server Data Modeling
- Enterprise Architecture
- Workflow Automation Design
- AI Enablement
- Decision Intelligence Design
- Governance & Audit Frameworks

---

# Repository Structure

```text
enterprise-digital-nervous-system/

├── README.md
├── sql/
├── docs/
├── images/
├── n8n/
└── powerbi/
```

---

# Author

Kaori Kashiwagi

Enterprise Digital Nervous System (EDNS)
AI-Powered Closed-Loop Decision Intelligence Platform
