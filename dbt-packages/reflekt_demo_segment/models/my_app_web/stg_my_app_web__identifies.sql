{{
  config(
    materialized = 'view',
  )
}}

with

source as (

    select *

    from {{ source('my_app_web', 'identifies') }}

),

renamed as (

    select
        id as identify_id,
        'my_app_web'::varchar as source_schema,
        'identifies'::varchar as source_table,
        'my-segment-plan'::varchar as tracking_plan,
        'identify'::varchar as call_type,
        received_at as received_at_tstamp,
        sent_at as sent_at_tstamp,
        timestamp as tstamp,
        anonymous_id,
        user_id

    from source

)

select * from renamed
