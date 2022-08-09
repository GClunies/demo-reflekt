{{
  config(
    materialized = 'view',
  )
}}

with

source as (

    select *

    from {{ source('my_app_web', 'order_completed') }}

),

renamed as (

    select
        id as event_id,
        'my_app_web'::varchar as source_schema,
        'order_completed'::varchar as source_table,
        'my-segment-plan'::varchar as tracking_plan,
        event_text as event_name,
        'track'::varchar as call_type,
        context_library_name as library_name,
        context_library_version as library_version,
        sent_at as sent_at_tstamp,
        received_at as received_at_tstamp,
        timestamp as tstamp,
        anonymous_id,
        user_id,
        checkout_id,
        currency,
        order_id,
        products,
        revenue,
        shipping,
        tax

    from source

)

select * from renamed
