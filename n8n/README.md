# n8n Workflows

This folder contains workflow automation exports for the Enterprise Digital Nervous System (EDNS).

---

## Phase 2 – Signal Processing Pipeline

The objective of this phase is to transform raw business signals into structured decisions and automated actions.

### Planned Workflow

```text
Business Signal
        ↓
n8n Workflow
        ↓
Signal Validation
        ↓
Enterprise Memory Lookup
        ↓
OpenAI Analysis
        ↓
Risk Assessment
        ↓
Decision Generation
        ↓
Action Execution
        ↓
Feedback Collection
        ↓
Enterprise Memory Update
```

---

## Initial Workflow

### EDNS – Supplier Delay Workflow v1

Business Scenario:

A critical supplier reports a shipment delay.

Workflow:

```text
Webhook Trigger
        ↓
Validate Signal
        ↓
Query SQL Server Memory
        ↓
Retrieve Similar Incidents
        ↓
OpenAI Analysis
        ↓
Generate Recommendation
        ↓
Send Alert
        ↓
Log Decision
```

---

## Planned Workflow Exports

| Workflow                          | Status  |
| --------------------------------- | ------- |
| Supplier Delay Workflow           | Planned |
| Facility Failure Workflow         | Planned |
| Inventory Shortage Workflow       | Planned |
| Logistics Disruption Workflow     | Planned |
| Critical Risk Escalation Workflow | Planned |
| Memory Update Workflow            | Planned |

---

## Technologies

* n8n
* SQL Server
* OpenAI GPT-4o
* Email Notifications
* Microsoft Teams
* Power BI

---

## Future Enhancements

* Multi-agent decision orchestration
* Automated risk prediction
* Closed-loop memory updates
* Enterprise learning automation
* Human approval workflows
