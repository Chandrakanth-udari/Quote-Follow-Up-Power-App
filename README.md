# Quote Follow-Up App

A Power Apps Canvas app that surfaces aging, un-converted quotes and lets estimators send targeted follow-up emails in a couple of taps — with an AI-drafted message body and a full send-history audit trail.

> **Client engagement.** Built as a production solution for a client in the commercial door & hardware manufacturing industry. Customer names, estimator names, and email addresses shown in the screenshots have been replaced with fictional equivalents to protect client confidentiality.

## The Problem

A quote goes out, the customer goes quiet, and two weeks later nobody remembers to chase it. That silence is where revenue leaks — a quote that just needed a nudge converts to a competitor or to nothing. Estimators had no single, trustworthy list of *their own* quotes that had gone cold, so following up depended on memory and good intentions. And when someone did follow up, writing the email from scratch each time was friction that made "I'll do it later" the default.

## The Solution

Turn following up from a chore into a one-screen action:

1. A SQL view builds each estimator's **live worklist** — only quotes that are **14+ days old and still open** (a quote number exists but no order yet), joined to customer, sales rep, and estimator detail.
2. The estimator opens the app and filters to **their own quotes**, narrowing by **age** (≤ 60 days / all 14+ days) and **value tier** (High / Medium / Low) so the highest-value cold quotes rise to the top.
3. They **tick the quotes** to chase and open the compose screen, where an **AI-drafted follow-up body** is generated — editable before sending.
4. **Power Automate sends** the emails, and every send (including test sends) is **logged to a history table** — recipient, subject, body, sender, timestamp — so there's a clear audit of who was contacted and when.

The result: cold quotes get worked systematically instead of slipping through the cracks.

## How It Works

```
 Estimator (app)                          Back-office data
 ┌──────────────────────────────┐        ┌──────────────────────────────┐
 │ Quote Follow-Up App           │  read  │ SQL: vw_quote_followup_14days │
 │ (Power Apps Canvas)            ├───────►│  (open quotes 14+ days old)   │
 │                               │        └───────────────────────────────┘
 │  filter by estimator / age /  │
 │  value → select cold quotes   │        ┌──────────────────────────────┐
 │  → AI-drafted email → send    ├───────►│ Power Automate → sends email  │
 └──────────────┬───────────────┘  trigger└───────────────┬──────────────┘
                │ log send                                 │
                ▼                                          ▼
        ┌──────────────────────────────────┐         Customer receives
        │ SQL: quote_followup_send_history  │         follow-up email
        │  (audit: who/what/when)           │
        └──────────────────────────────────┘
```

## Key Features

- **Aging-quote worklist** — only quotes that are 14+ days old and not yet converted to an order.
- **Estimator + priority filters** — filter by estimator, by age (≤ 60 days / all 14+ days), and by value tier (High / Medium / Low).
- **Search** — find a quote by company or quote number.
- **Bulk select & send** — tick multiple quotes and send follow-ups in one action.
- **AI-drafted email body** — generate a follow-up message, then edit before sending.
- **Send-history audit** — every send (including test sends) is logged: recipient, subject, body, sender, and timestamp.

## Tech Stack

- **Power Apps** (Canvas app)
- **SQL Server** (aging-quote view + send-history table)
- **Power Automate** (sends the follow-up emails)
- **AI text generation** for the email body

## Screenshots

| Quote worklist + estimator filter | Bulk selection | Compose & send |
|---|---|---|
| ![Quote list](screenshots/01-quote-list-estimators.png) | ![Selected quotes](screenshots/02-quote-list-selected.png) | ![Email compose](screenshots/03-email-compose.png) |

## Data Model

See [`sql/`](sql/):

- `01-quote-followup-view.sql` — `vw_quote_followup_14days`: joins order, customer, sales rep, and estimator data and flags quotes 14+ days old that haven't converted (the updated version also restricts to live/open order states).
- `02-send-history-table.sql` — `quote_followup_send_history`: append-only log of every follow-up email sent.

---

*Screenshots use anonymized sample data. SQL table definitions are illustrative; column types reflect the production schema.*
