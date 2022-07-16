{{
  config(
    materialized = 'view',
  )
}}

with

source as (

    select *

    from {{ source('my_app_web', 'pages') }}

),

renamed as (

    select
        id as page_id,
        'my_app_web'::varchar as source_schema,
        'pages'::varchar as source_table,
        'my-plan'::varchar as tracking_plan,
        name as page_name,
        'page'::varchar as call_type,
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
        context_page_search as page_url_query,
        context_page_referrer as page_referrer,
        context_ip as ip,
        context_user_agent as user_agent,
        path,
        referrer,
        search,
        title,
        url

    from source

)

select * from renamed
