-- =========================================================================
-- Enterprise Digital Nervous System (EDNS) - Production Schema v1.5.1 - 8 Tables
--
-- Author:
-- Kaori Kashiwagi
--
-- Last Updated:
-- 2026-06-17
--
-- Environment:
-- Portfolio Development Environment
--
-- Target Database:
-- Microsoft SQL Server Express Edition
--
-- Development Tool:
-- SQL Server Management Studio (SSMS) 22.4.1
--
-- Project:
-- Enterprise Digital Nervous System (EDNS)
--
-- Purpose:
-- AI-Powered Closed-Loop Decision Intelligence Platform
--
-- Portfolio Focus:
-- Business Systems Analysis
-- Technical Business Analysis
-- Workflow Automation
-- AI Enablement
-- Enterprise Architecture
--
-- Architecture Upgrades Applied:
--   1. Idempotent Database Creation Guard (IF DB_ID Check)
--   2. Fix Seed Data Column Mismatch (version_tracker -> record_version)
--   3. Fix Transaction Safe Rollback in CATCH Block using @@TRANCOUNT
--   4. Fix Stagnant Version Number Bug in Learning Loop Execution
--   5. Enforce Unique Index on Active Memory to Protect Power BI 1:N Joins
--
-- 8 tables
--  signal_events
--  enterprise_entities
--  enterprise_memory
--  ai_decisions
--  action_history
--  ai_telemetry
--  decision_feedback
--  learning_execution_log    
-- =========================================================================

-- Idempotent Database Creation Guard
IF DB_ID('EDNS_V1') IS NULL
BEGIN
    CREATE DATABASE EDNS_V1;
END
GO

USE EDNS_V1;
GO

-- -------------------------------------------------------------------------
-- STEP 1: CLEAN RESET FOR PORTFOLIO / LOCAL DEVELOPMENT
-- -------------------------------------------------------------------------
-- This reset section is intended for a local portfolio/demo environment.
-- Remove or disable this section for a production deployment with live data.

DROP VIEW IF EXISTS v_decision_intelligence_summary;
GO

-- Drop dependent tables first to handle foreign key constraints cleanly during re-runs.
-- supplier_master is included only to clean up earlier EDNS_V1 prototype versions.
DROP TABLE IF EXISTS decision_feedback;
DROP TABLE IF EXISTS ai_telemetry;
DROP TABLE IF EXISTS action_history;
DROP TABLE IF EXISTS ai_decisions;
DROP TABLE IF EXISTS enterprise_memory;
DROP TABLE IF EXISTS learning_execution_log;
DROP TABLE IF EXISTS supplier_master;
DROP TABLE IF EXISTS enterprise_entities;
DROP TABLE IF EXISTS signal_events;
GO

-- -------------------------------------------------------------------------
-- STEP 2: TABLE DEFINITIONS - EDNS CORE 8 TABLE MODEL
-- -------------------------------------------------------------------------

-- 1. SIGNAL LAYER: Raw Telemetry Ingestion
CREATE TABLE signal_events (
    signal_id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    source_channel VARCHAR(50) NOT NULL,      -- 'RSS', 'Webhook', 'API_Alert'
    raw_payload NVARCHAR(MAX) NOT NULL,       -- Ingested JSON string
    status VARCHAR(30) DEFAULT 'INGESTED',    -- 'INGESTED', 'HYDRATED', 'PROCESSED', 'FAILED'
    
    -- Unified Audit & Governance Fields
    created_at DATETIME2 DEFAULT SYSUTCDATETIME() NOT NULL,
    created_by VARCHAR(100) DEFAULT 'SYSTEM' NOT NULL,
    updated_at DATETIME2 NULL,
    updated_by VARCHAR(100) NULL,
    delete_flag CHAR(1) DEFAULT 'N' NOT NULL, -- 'N' = Active, 'Y' = Logically Deleted
    deleted_at DATETIME2 NULL,
    deleted_by VARCHAR(100) NULL,
    record_version INT DEFAULT 1 NOT NULL
);

-- 2. MASTER DATA LAYER: Extended Corporate Assets
CREATE TABLE enterprise_entities (
    entity_id VARCHAR(50) NOT NULL,
    entity_code VARCHAR(50) NOT NULL,         -- ERP/CRM Integration Key (e.g., SAP-VND-1002)
    entity_type VARCHAR(30) NOT NULL,         -- Physical System Type: 'Supplier', 'Facility', etc.
    entity_name NVARCHAR(255) NOT NULL,
    entity_category VARCHAR(50) NULL,         -- Strategic Category: 'Critical Supplier', etc.
    risk_tier VARCHAR(10) NOT NULL,           -- 'Tier-1' (Critical), 'Tier-2', 'Tier-3'
    sla_threshold_hours INT NOT NULL,         -- Maximum allowable latency before auto-escalation
    is_active BIT DEFAULT 1 NOT NULL,         -- Operational state control flag
    
    -- Profile Metadata
    tax_id VARCHAR(50) NULL,                  
    country VARCHAR(100) NULL,                
    city VARCHAR(100) NULL,                   
    address_summary NVARCHAR(500) NULL,       
    phone_number VARCHAR(50) NULL,            
    contact_person NVARCHAR(255) NULL,        
    contact_email VARCHAR(255) NULL,          
    
    -- Unified Audit & Governance Fields
    created_at DATETIME2 DEFAULT SYSUTCDATETIME() NOT NULL,
    created_by VARCHAR(100) DEFAULT 'SYSTEM' NOT NULL,
    updated_at DATETIME2 NULL,
    updated_by VARCHAR(100) NULL,
    delete_flag CHAR(1) DEFAULT 'N' NOT NULL,
    deleted_at DATETIME2 NULL,
    deleted_by VARCHAR(100) NULL,
    record_version INT DEFAULT 1 NOT NULL,

    CONSTRAINT PK_enterprise_entities PRIMARY KEY (entity_id),
    CONSTRAINT UQ_enterprise_entities_entity_code UNIQUE (entity_code)
);

-- 3. KNOWLEDGE LAYER: RAG Core Anchors
CREATE TABLE enterprise_memory (
    memory_id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    entity_id VARCHAR(50) NOT NULL,
    incident_type VARCHAR(100) NOT NULL,      -- 'Logistics_Delay', 'Facility_Failure' (2-Key Anchor Part 1)
    resolution_pattern NVARCHAR(MAX) NOT NULL, -- Past validated solutions
    policy_constraints NVARCHAR(MAX) NOT NULL, -- Business logic constraints
    business_rule_applied NVARCHAR(MAX) NOT NULL, -- XAI Audit (e.g., 'Tier-1 + SLA > 48h')
    effectiveness_score DECIMAL(5,2) DEFAULT 100.00 NOT NULL, -- Standardized 0-100 Learning Scale
    last_learned_at DATETIME2 NULL,
    
    -- Unified Audit & Governance Fields
    created_at DATETIME2 DEFAULT SYSUTCDATETIME() NOT NULL,
    created_by VARCHAR(100) DEFAULT 'SYSTEM' NOT NULL,
    updated_at DATETIME2 NULL,
    updated_by VARCHAR(100) NULL,
    delete_flag CHAR(1) DEFAULT 'N' NOT NULL, -- 'N' = Active Version, 'Y' = Archived Old Version
    deleted_at DATETIME2 NULL,
    deleted_by VARCHAR(100) NULL,
    record_version INT DEFAULT 1 NOT NULL,

    CONSTRAINT FK_enterprise_memory_entities FOREIGN KEY (entity_id) REFERENCES enterprise_entities(entity_id)
);

-- 4. COGNITION LAYER: Structured AI Decisions
CREATE TABLE ai_decisions (
    decision_id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    signal_id UNIQUEIDENTIFIER NOT NULL,
    entity_id VARCHAR(50) NOT NULL,
    incident_type VARCHAR(100) NULL,           -- Enforced to strictly resolve Power BI Duplication bug
    reasoning_summary NVARCHAR(MAX) NOT NULL,  
    prediction_summary NVARCHAR(MAX) NOT NULL, 
    recommended_action NVARCHAR(MAX) NOT NULL, 
    severity_score DECIMAL(5,2) NOT NULL,      
    confidence_score DECIMAL(5,2) NOT NULL,    
    decision_status VARCHAR(30) DEFAULT 'OPEN' NOT NULL, -- 'OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED'
    structured_json_output NVARCHAR(MAX) NOT NULL, -- Enforced deterministic JSON schema
    
    -- Unified Audit & Governance Fields
    created_at DATETIME2 DEFAULT SYSUTCDATETIME() NOT NULL,
    created_by VARCHAR(100) DEFAULT 'SYSTEM' NOT NULL,
    updated_at DATETIME2 NULL,
    updated_by VARCHAR(100) NULL,
    delete_flag CHAR(1) DEFAULT 'N' NOT NULL,
    deleted_at DATETIME2 NULL,
    deleted_by VARCHAR(100) NULL,
    record_version INT DEFAULT 1 NOT NULL,

    CONSTRAINT FK_ai_decisions_signals FOREIGN KEY (signal_id) REFERENCES signal_events(signal_id),
    CONSTRAINT FK_ai_decisions_entities FOREIGN KEY (entity_id) REFERENCES enterprise_entities(entity_id)
);

-- 5. EXECUTION LAYER: Downstream Infrastructure Tracking
CREATE TABLE action_history (
    action_id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    decision_id UNIQUEIDENTIFIER NOT NULL,
    target_system VARCHAR(50) NOT NULL,        -- 'ServiceNow', 'Teams', 'Email_API'
    action_type VARCHAR(50) NOT NULL,          -- 'Escalation', 'Ticket_Creation', etc.
    execution_status VARCHAR(30) NOT NULL,     -- 'PENDING', 'SUCCESS', 'FAILED'
    retry_count INT DEFAULT 0 NOT NULL,        -- Tracks n8n automated error recovery loops
    response_payload NVARCHAR(MAX),
    
    -- Unified Audit & Governance Fields
    executed_at DATETIME2 DEFAULT SYSUTCDATETIME() NOT NULL,
    created_by VARCHAR(100) DEFAULT 'SYSTEM' NOT NULL,
    updated_at DATETIME2 NULL,
    updated_by VARCHAR(100) NULL,
    delete_flag CHAR(1) DEFAULT 'N' NOT NULL,
    deleted_at DATETIME2 NULL,
    deleted_by VARCHAR(100) NULL,
    record_version INT DEFAULT 1 NOT NULL,

    CONSTRAINT FK_action_history_decisions FOREIGN KEY (decision_id) REFERENCES ai_decisions(decision_id)
);

-- 6. TELEMETRY LAYER: Brain Performance Analytics
CREATE TABLE ai_telemetry (
    telemetry_id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    decision_id UNIQUEIDENTIFIER NOT NULL,
    model_name VARCHAR(50) NOT NULL,             -- 'gpt-4o'
    prompt_tokens INT NOT NULL,
    completion_tokens INT NOT NULL,
    execution_latency_ms INT NOT NULL,
    estimated_cost_usd DECIMAL(8,6) NOT NULL,
    
    -- Unified Audit & Governance Fields
    logged_at DATETIME2 DEFAULT SYSUTCDATETIME() NOT NULL,
    created_by VARCHAR(100) DEFAULT 'SYSTEM' NOT NULL,
    updated_at DATETIME2 NULL,
    updated_by VARCHAR(100) NULL,
    delete_flag CHAR(1) DEFAULT 'N' NOT NULL,
    deleted_at DATETIME2 NULL,
    deleted_by VARCHAR(100) NULL,
    record_version INT DEFAULT 1 NOT NULL,

    CONSTRAINT FK_ai_telemetry_decisions FOREIGN KEY (decision_id) REFERENCES ai_decisions(decision_id)
);

-- 7. LEARNING LAYER: Feedback Engine
CREATE TABLE decision_feedback (
    feedback_id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    decision_id UNIQUEIDENTIFIER NOT NULL,
    feedback_source VARCHAR(50) NOT NULL,        -- 'User_UI', 'Teams_Intervention'
    feedback_score DECIMAL(5,2) NOT NULL,        
    feedback_comment NVARCHAR(MAX),              
    
    -- Unified Audit & Governance Fields
    created_at DATETIME2 DEFAULT SYSUTCDATETIME() NOT NULL,
    created_by VARCHAR(100) DEFAULT 'SYSTEM' NOT NULL,
    updated_at DATETIME2 NULL,
    updated_by VARCHAR(100) NULL,
    delete_flag CHAR(1) DEFAULT 'N' NOT NULL,
    deleted_at DATETIME2 NULL,
    deleted_by VARCHAR(100) NULL,
    record_version INT DEFAULT 1 NOT NULL,

    CONSTRAINT FK_decision_feedback_decisions FOREIGN KEY (decision_id) REFERENCES ai_decisions(decision_id)
);
GO

-- 8. AUDIT LAYER: Job-Level Learning Cycle Ledger (Pure Immutable Ledger Design)
CREATE TABLE learning_execution_log (
    execution_id UNIQUEIDENTIFIER DEFAULT NEWID() PRIMARY KEY,
    started_at DATETIME2 NOT NULL,
    completed_at DATETIME2 NULL,
    processed_learnings_count INT DEFAULT 0 NOT NULL, 
    status VARCHAR(30) DEFAULT 'RUNNING' NOT NULL,    -- 'RUNNING', 'SUCCESS', 'FAILED'
    executed_by VARCHAR(100) DEFAULT 'LEARNING_LOOP_SERVICE' NOT NULL,
    response_payload NVARCHAR(MAX) NULL,             
    
    -- Clean Audit Markers
    created_at DATETIME2 DEFAULT SYSUTCDATETIME() NOT NULL,
    updated_at DATETIME2 NULL
);
GO


-- -------------------------------------------------------------------------
-- STEP 2: GOVERNANCE & INTEGRATION VIEWS (FOR POWER BI)
-- -------------------------------------------------------------------------

CREATE VIEW v_decision_intelligence_summary AS
SELECT
    d.decision_id,
    d.signal_id,
    d.entity_id,
    d.incident_type,
    d.decision_status,
    d.severity_score,
    d.confidence_score,
    d.reasoning_summary,
    d.prediction_summary,
    d.recommended_action,
    d.created_at AS decision_created_at,
    
    -- Hydrated Master Entity Metadata
    e.entity_code,
    e.entity_type,
    e.entity_category,
    e.entity_name,
    e.country AS entity_country,
    e.risk_tier,
    e.sla_threshold_hours,
    
    -- Hydrated Explainable RAG Governance Rules (Bound safely by 2 keys)
    m.business_rule_applied,
    m.resolution_pattern AS past_known_pattern,
    m.effectiveness_score AS memory_current_score
FROM ai_decisions d
LEFT JOIN enterprise_entities e
    ON d.entity_id = e.entity_id
LEFT JOIN enterprise_memory m
    ON d.entity_id = m.entity_id 
   AND d.incident_type = m.incident_type -- 2-Key Join Guard Enforced
   AND m.delete_flag = 'N'               -- Fetches only the active updated version
WHERE
    d.delete_flag = 'N'
    AND e.delete_flag = 'N';
GO


-- -------------------------------------------------------------------------
-- STEP 3: HIGH-PERFORMANCE OPERATIONAL INDEXES & PROTECTIONS
-- -------------------------------------------------------------------------

-- Prevent duplicate entries in Active Memory (Filtered Unique Index)
CREATE UNIQUE INDEX UQ_Active_Memory_Keys
ON enterprise_memory(entity_id, incident_type)
WHERE delete_flag = 'N';

-- Covering Index optimized for Power BI Joins
CREATE INDEX IX_enterprise_memory_join_perf
ON enterprise_memory(entity_id, incident_type, delete_flag)
INCLUDE (business_rule_applied, resolution_pattern, effectiveness_score);

-- Foundational Optimization Indexes
CREATE INDEX IX_signal_lookup ON signal_events(status, delete_flag);
CREATE INDEX IX_entities_lookup ON enterprise_entities(entity_type, entity_category, delete_flag) WHERE delete_flag = 'N';
CREATE INDEX IX_decision_governance ON ai_decisions(decision_status, severity_score, confidence_score, delete_flag);
CREATE INDEX IX_feedback_learning ON decision_feedback(decision_id, feedback_score, delete_flag);
GO


-- -------------------------------------------------------------------------
-- STEP 4: SEED DATA MOCKING
-- -------------------------------------------------------------------------

INSERT INTO enterprise_entities (entity_id, entity_code, entity_type, entity_name, entity_category, risk_tier, sla_threshold_hours, tax_id, country, city, address_summary, phone_number, contact_person, contact_email)
VALUES 
('ENT_001', 'SAP-VND-8801', 'Supplier', 'Global ChipCore Foundry', 'Critical Supplier', 'Tier-1', 24, 'TX-999-01', 'Taiwan', 'Hsinchu', 'No. 12, Innovation Road, Hsinchu Science Park', '+886-3-555-0192', 'Alex Chen', 'a.chen@chipcore-fictional.com'),
('ENT_003', 'SAP-FAC-1101', 'Facility', 'Kyoto Nano Assembly Plant', 'Manufacturing Plant', 'Tier-1', 12, 'TX-999-03', 'Japan', 'Kyoto', '1-1 Science-cho, Kansai Science City, Kyoto', '+81-75-555-0345', 'Kenji Sato', 'k.sato@kyotonano-fictional.com');

-- Seed Enterprise Memory.
-- memory_id is intentionally omitted because it is a UNIQUEIDENTIFIER with DEFAULT NEWID().
INSERT INTO enterprise_memory (
    entity_id,
    incident_type,
    resolution_pattern,
    policy_constraints,
    business_rule_applied,
    effectiveness_score,
    delete_flag,
    record_version
)
VALUES
(
    'ENT_001',
    'Logistics_Delay',
    'Initiate instant fallback to standby inventory at Tokyo Hub. Reprioritize assembly schedules based on critical customer impact models.',
    'Alternative air freight routing must not exceed $15,000 budget constraint per event tier baseline.',
    'Rule Enforced: [Tier-1 Supplier] + [Predicted SLA Overrun > 24h]',
    100.00,
    'N',
    1
),
(
    'ENT_003',
    'Facility_Failure',
    'Trigger backup generator systems and automatically re-route in-transit raw material payloads to Yokohama sub-facility nodes.',
    'Downstream assembly lines must be padded with existing buffer stock to avoid terminal downtime exceeding 6 hours.',
    'Rule Enforced: [Manufacturing Plant] + [Severity Score > 80]',
    100.00,
    'N',
    1
);
GO


-- -------------------------------------------------------------------------
-- STEP 5: BATCH LEARNING ENGINE (ADVANCED VERSIONING LOGIC)
-- -------------------------------------------------------------------------

CREATE OR ALTER PROCEDURE sp_EDNS_Execute_Learning_Loop
    @MinFeedbackScore DECIMAL(5,2) = 80.00,
    @ExecutedBy VARCHAR(100) = 'n8n_Learning_Loop_v1.0'
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @JobId UNIQUEIDENTIFIER = NEWID();
    DECLARE @StartTime DATETIME2 = SYSUTCDATETIME();
    DECLARE @TotalProcessed INT = 0;

    -- Open Job Tracker entry
    INSERT INTO learning_execution_log (execution_id, started_at, status, executed_by)
    VALUES (@JobId, @StartTime, 'RUNNING', @ExecutedBy);
    
    BEGIN TRY
        -- Transaction safe placement inside the TRY block
        BEGIN TRANSACTION;
        
        -- Pipeline table variable
        DECLARE @LearningQueue TABLE (
            decision_id UNIQUEIDENTIFIER,
            memory_id UNIQUEIDENTIFIER,
            entity_id VARCHAR(50),
            incident_type VARCHAR(100),
            old_constraints NVARCHAR(MAX),
            new_pattern NVARCHAR(MAX),
            new_rule NVARCHAR(MAX),
            feedback_score DECIMAL(5,2),
            old_version INT -- Tracks current knowledge version hierarchy
        );

        -- Ingest targets for knowledge refinement matching constraints
        INSERT INTO @LearningQueue (decision_id, memory_id, entity_id, incident_type, old_constraints, new_pattern, new_rule, feedback_score, old_version)
        SELECT 
            d.decision_id,
            m.memory_id,
            d.entity_id,
            m.incident_type,
            m.policy_constraints,
            d.recommended_action,  
            d.reasoning_summary,   
            f.feedback_score,
            m.record_version
        FROM ai_decisions d
        INNER JOIN decision_feedback f ON d.decision_id = f.decision_id
        INNER JOIN enterprise_memory m ON d.entity_id = m.entity_id AND d.incident_type = m.incident_type AND m.delete_flag = 'N'
        WHERE f.feedback_score >= @MinFeedbackScore
          AND d.decision_status IN ('RESOLVED', 'CLOSED', 'OPEN')
          AND d.delete_flag = 'N'
          AND f.delete_flag = 'N';

        SELECT @TotalProcessed = COUNT(*) FROM @LearningQueue;

        -- Run autonomous refinement cycles via Explicit Record Versioning
        IF (@TotalProcessed > 0)
        BEGIN
            -- 1. Soft-Delete/Archive old active versions
            UPDATE m
            SET 
                m.delete_flag = 'Y',
                m.deleted_at = SYSUTCDATETIME(),
                m.deleted_by = @ExecutedBy
            FROM enterprise_memory m
            INNER JOIN @LearningQueue q ON m.memory_id = q.memory_id;

            -- 2. Insert fresh reinforced knowledge incrementing the historical version trace
            -- Replaced static '1' boundary with 'q.old_version + 1' dynamic incrementing loop
            INSERT INTO enterprise_memory (
                memory_id, entity_id, incident_type, resolution_pattern, policy_constraints, 
                business_rule_applied, effectiveness_score, last_learned_at, created_by, delete_flag, record_version
            )
            SELECT 
                NEWID(),
                q.entity_id,
                q.incident_type,
                q.new_pattern,          
                q.old_constraints,      
                q.new_rule,             
                q.feedback_score,       
                SYSUTCDATETIME(),
                @ExecutedBy,
                'N',                    -- Active state indicator
                q.old_version + 1       -- Evolved version level assignment
            FROM @LearningQueue q;

            -- 3. Graduate processed decisions into CLOSED status paths
            UPDATE d
            SET 
                d.decision_status = 'CLOSED',
                d.updated_at = SYSUTCDATETIME(),
                d.updated_by = @ExecutedBy,
                d.record_version = d.record_version + 1
            FROM ai_decisions d
            INNER JOIN @LearningQueue q ON d.decision_id = q.decision_id;
        END

        -- Finalize Job Log state metrics
        UPDATE learning_execution_log
        SET 
            completed_at = SYSUTCDATETIME(),
            processed_learnings_count = @TotalProcessed,
            status = 'SUCCESS',
            response_payload = 'EDNS batch learning loop completed. Memory upgraded via row versioning tracking matrices.',
            updated_at = SYSUTCDATETIME()
        WHERE execution_id = @JobId;

        COMMIT TRANSACTION;
        
        -- Return context execution details back to downstream orchestration frameworks (n8n, etc.)
        SELECT @JobId AS job_execution_id, @TotalProcessed AS processed_learnings_count;
        
    END TRY
    BEGIN CATCH
        -- Structured Safety Transaction Rollback Guard Logic
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        
        -- Trace exception structures inside the append-only ledger layout
        UPDATE learning_execution_log
        SET 
            completed_at = SYSUTCDATETIME(),
            processed_learnings_count = 0,
            status = 'FAILED',
            response_payload = ERROR_MESSAGE(),
            updated_at = SYSUTCDATETIME()
        WHERE execution_id = @JobId;
        
        THROW 50004, 'EDNS Learning Loop terminal failure. Relational rollback executed successfully.', 1;
    END CATCH
END;
GO