# n8n Workflows

This folder contains workflow automation exports for the Enterprise Digital Nervous System (EDNS).

The workflow architecture follows the official roadmap defined in:

```text
docs/EDNS_Master_Roadmap.md
```

---

# Current Development Focus

Current Priority:

Phase 1 – Workflow 1

EDNS Core Pipeline

Status:

🚧 In Development

---

# Workflow 1 – EDNS Core Pipeline

Purpose:

Transform business signals into decisions and actions.

```text
Sense
↓
Ingestion
↓
Remember
↓
Reason
↓
Predict
↓
Decide
↓
Act
↓
Telemetry Logging
```

Capabilities:

* Signal ingestion
* Signal validation
* Enterprise memory retrieval
* AI reasoning
* Risk prediction
* Decision generation
* Automated action execution
* Telemetry collection

---

## Planned n8n Flow

```text
Business Signal
        ↓
Webhook Trigger
        ↓
Signal Validation
        ↓
SQL Server Memory Lookup
        ↓
Retrieve Similar Incidents
        ↓
OpenAI Analysis
        ↓
Risk Assessment
        ↓
Decision Generation
        ↓
Action Execution
        ↓
Telemetry Logging
```

---

# Phase 1 Use Cases

The following business scenarios will utilize the EDNS Core Pipeline.

| Use Case                 | Status  |
| ------------------------ | ------- |
| Supplier Delay           | Planned |
| Facility Failure         | Planned |
| Inventory Shortage       | Planned |
| Logistics Disruption     | Planned |
| Critical Risk Escalation | Planned |

These are business use cases, not separate workflows.

All use cases execute through the EDNS Core Pipeline.

---

# Workflow 2 – EDNS Learning Loop

Purpose:

Continuously improve decision quality through feedback and memory updates.

```text
Feedback
↓
Learn
↓
Enterprise Memory Update
```

Capabilities:

* Outcome tracking
* Decision evaluation
* Knowledge reinforcement
* Enterprise memory updates
* Continuous improvement

---

## Planned Learning Flow

```text
Action Outcome
        ↓
Feedback Collection
        ↓
Decision Evaluation
        ↓
Knowledge Extraction
        ↓
Enterprise Memory Update
        ↓
Learning Log
```

---

# Future Phase 2 Workflows

The following workflows belong to Phase 2 – EDNS Cognitive Extensions.

| Workflow                    | Status  |
| --------------------------- | ------- |
| Multi-Agent Operations      | Planned |
| MCP Tool Integration        | Planned |
| Voice Operations            | Planned |
| Offline LLM / Local AI      | Planned |
| Model Optimization & Tuning | Planned |

Phase 2 development will begin only after Phase 1 is operational.

---

# Technologies

* n8n
* Microsoft SQL Server
* OpenAI GPT-4o
* Email Notifications
* Microsoft Teams
* Power BI

---

# Architecture Governance

Before implementing a workflow:

1. Review EDNS_Master_Roadmap.md
2. Confirm the associated Phase
3. Confirm the associated Workflow
4. Update architecture documentation if scope changes
5. Implement only after architectural alignment

This folder contains workflow implementations that follow the official EDNS architecture.
