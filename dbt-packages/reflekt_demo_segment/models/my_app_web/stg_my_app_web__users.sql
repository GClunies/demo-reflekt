{{
  config(
    materialized = 'view',
  )
}}

with

source as (

    select *

    from {{ source('my_app_web', 'users') }}

),

renamed as (

    select
        id as user_id,
        'my_app_web'::varchar as source_schema,
        'users'::varchar as source_table,
        'my-segment-plan'::varchar as tracking_plan,
        received_at as received_at_tstamp

    from source

)

select * from renamed
