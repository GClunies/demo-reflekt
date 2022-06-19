{{
  config(
    materialized = 'view',
  )
}}

with

source as (

    select *

    from {{ source('my_app_web', 'cart_viewed') }}

),

renamed as (

    select
        id as event_id,
        'my_app_web'::varchar as source_schema,
        'cart_viewed'::varchar as source_table,
        'my-plan'::varchar as tracking_plan,
        context_library_name as library_name,
        context_library_version as library_version,
        sent_at as sent_at_tstamp,
        received_at as received_at_tstamp,
        timestamp as tstamp,
        anonymous_id,
        user_id,
        context_user_agent as user_agent,
        
            cast(
                case
                    when lower(context_user_agent) like '%android%'
                        then 'Android'
                    else replace(
                        {{ dbt_utils.split_part(dbt_utils.split_part('context_user_agent', "'('", 2), "' '", 1) }},
                    ';',
                    ''
                    )
                end
                as varchar
            ) as device
            ,
        context_ip as ip,
        cart_id,
        products

    from source

)

select * from renamed
