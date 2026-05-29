-- quote_followup_send_history
-- Audit log of every follow-up email sent from the app: who it went to, the
-- subject/body, whether it was a test send, and who/when it was sent.

CREATE TABLE dbo.quote_followup_send_history (

    history_id       INT IDENTITY(1,1) PRIMARY KEY,

    quote_num        VARCHAR(100),

    estimator_email  VARCHAR(255),

    estimator_name   VARCHAR(255),

    recipient_email  VARCHAR(255),

    recipient_name   VARCHAR(255),

    subject          NVARCHAR(500),

    body_text        NVARCHAR(MAX),

    is_test_mode     BIT DEFAULT 0,

    sent_by_email    VARCHAR(255),

    sent_by_name     VARCHAR(255),

    sent_utc         DATETIME DEFAULT GETUTCDATE(),

    order_id         INT

);
