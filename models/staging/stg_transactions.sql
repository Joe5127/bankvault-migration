-- ==========================================
-- Model   : stg_transactions
-- Schema  : staging
-- Purpose : Clean and Standardise raw 
--           transaction data from source
-- ===========================================

With Source as(
    
    select * from {{ source('raw', 'transactions') }}
),

cleaned as (
  
     select
          transaction_id,
          Account_id,
          Transaction_date,
          UPPER(Transaction_type)               as transaction_type,
          Amount,
          Case
              when amount >= 10000 Then 'Large'
              when Amount >= 1000  Then 'Medium'
              Else 'SMALL'

          END                                    as amount_category,
              
          UPPER(Channel)                         as channel,
          upper(Merchant_category)               as Merchant_category,
          Upper(status)                          as status,
          Upper(Remarks)                         as Remarks,
          CURRENT_TIMESTAMP                      as dbt_loaded_at

    From Source

    where Transaction_id is not null
      And account_id is not null
      And Amount > 0

)

select * from Cleaned