{{
  config(
    materialized = 'view',
  )
}}

with

source as (

    select *

    from {{ source('my_app_web', 'tracks') }}

),

renamed as (

    select
        id as event_id,
        'my_app_web'::varchar as source_schema,
        'tracks'::varchar as source_table,
        'my-plan'::varchar as tracking_plan,
        event_text as event_name,
        'track'::varchar as call_type,
        context_library_name as library_name,
        context_library_version as library_version,
        sent_at as sent_at_tstamp,
        received_at as received_at_tstamp,
        timestamp as tstamp,
        anonymous_id,
        user_id,
        context_page_url as page_url,
        context_page_path as page_url_path,
        context_page_title as page_title,
        context_page_referrer as page_referrer,
        context_user_agent as user_agent,
        context_ip as ip

    from source

)

select * from renamed
