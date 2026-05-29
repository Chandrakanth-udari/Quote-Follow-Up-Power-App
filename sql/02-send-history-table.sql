-- quote_followup_send_history
-- Audit log of every follow-up email sent from the app: who it went to, the
-- subject/body, whether it was a test send, and who/when it was sent.

SELECT TOP (1000)
       [history_id]
      ,[quote_num]
      ,[estimator_email]
      ,[estimator_name]
      ,[recipient_email]
      ,[recipient_name]
      ,[subject]
      ,[body_text]
      ,[is_test_mode]
      ,[sent_by_email]
      ,[sent_by_name]
      ,[sent_utc]
      ,[order_id]
  FROM [ClientDW].[dbo].[quote_followup_send_history];
