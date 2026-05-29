-- =============================================================================
-- vw_quote_followup_14days
-- Surfaces quotes that are >= 14 days old and have NOT yet converted to an
-- order (quote_num present, order_num null). Joins customer, sales rep, and
-- estimator detail so the follow-up app can show and email the right people.
-- =============================================================================
CREATE OR ALTER VIEW dbo.vw_quote_followup_14days
AS
SELECT
    fo.order_key,
    fo.order_id,
    fo.order_num,
    fo.quote_num,

    CAST(dd.date AS DATE) AS quote_date,
    DATEDIFF(DAY, CAST(dd.date AS DATE), CAST(GETDATE() AS DATE)) AS days_since_quote,

    CASE
        WHEN CAST(dd.date AS DATE) <= DATEADD(DAY, -14, CAST(GETDATE() AS DATE))
            THEN 1
        ELSE 0
    END AS IsQuoted14DaysAgo,

    fo.total AS quote_total,

    p.partner_key,
    p.company_name        AS customer_name,
    p.company_name_full   AS customer_name_full,
    p.email               AS customer_email,
    p.phone_number        AS customer_phone,
    p.address_city        AS customer_city,
    p.address_state       AS customer_state,

    pr.partner_representative_key,
    pr.full_name          AS rep_name,
    pr.email              AS rep_email,
    pr.phone              AS rep_phone,
    pr.title              AS rep_title,

    e.employee_key        AS estimator_key,
    e.full_name           AS estimator_name,
    e.email               AS estimator_email,
    e.department          AS estimator_department

FROM dbo.fact_order fo
JOIN dbo.dim_date dd
    ON fo.quote_finalized_key = dd.date_key
JOIN dbo.dim_partner p
    ON fo.partner_key = p.partner_key
JOIN dbo.dim_partner_representative pr
    ON fo.partner_representative_key = pr.partner_representative_key
JOIN dbo.dim_employee e
    ON fo.estimator_key = e.employee_key
WHERE
    fo.quote_num IS NOT NULL
    AND fo.order_num IS NULL;
GO

-- =============================================================================
-- Updated logic: additionally restrict to a specific order state so only
-- live, open quotes are followed up on.
-- =============================================================================
CREATE OR ALTER VIEW dbo.vw_quote_followup_14days
AS
SELECT
    fo.order_key,
    fo.order_id,
    fo.order_num,
    fo.quote_num,

    CAST(dd.date AS DATE) AS quote_date,
    DATEDIFF(DAY, CAST(dd.date AS DATE), CAST(GETDATE() AS DATE)) AS days_since_quote,

    CASE
        WHEN CAST(dd.date AS DATE) <= DATEADD(DAY, -14, CAST(GETDATE() AS DATE))
            THEN 1
        ELSE 0
    END AS IsQuoted14DaysAgo,

    fo.total AS quote_total,

    p.partner_key,
    p.company_name        AS customer_name,
    p.company_name_full   AS customer_name_full,
    p.email               AS customer_email,
    p.phone_number        AS customer_phone,
    p.address_city        AS customer_city,
    p.address_state       AS customer_state,

    pr.partner_representative_key,
    pr.full_name          AS rep_name,
    pr.email              AS rep_email,
    pr.phone              AS rep_phone,
    pr.title              AS rep_title,

    e.employee_key        AS estimator_key,
    e.full_name           AS estimator_name,
    e.email               AS estimator_email,
    e.department          AS estimator_department

FROM dbo.fact_order fo
JOIN dbo.dim_date dd
    ON fo.quote_finalized_key = dd.date_key
JOIN dbo.dim_partner p
    ON fo.partner_key = p.partner_key
JOIN dbo.dim_partner_representative pr
    ON fo.partner_representative_key = pr.partner_representative_key
JOIN dbo.dim_employee e
    ON fo.estimator_key = e.employee_key
JOIN dbo.dim_order_state os
    ON fo.state_key = os.order_state_key
WHERE
    fo.quote_num IS NOT NULL
    AND fo.order_num IS NULL
    AND os.order_state_id = 17;
GO
