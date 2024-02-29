{{ config(materialized='view') }}

select 
-- identifiers
    {{dbt_utils.surrogate_key(['vendor_id', 'pickup_datetime'])}} as tripid,
    cast(vendor_id as integer ) as vendorid,
    cast(rate_code as integer ) as ratecodeid,
    cast(pickup_location_id as integer ) as pickup_locationid,
    cast(dropoff_location_id as integer ) as dropoff_locationid,
    
    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,
    
    -- trip info
    store_and_fwd_flag,
    cast(passenger_count as integer) as passenger_count,
    cast(trip_distance as numeric) as trip_distance,

    -- payment info
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra,
    cast(mta_tax as numeric) as mta_tax,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(imp_surcharge as numeric) as improvement_surcharge,
    cast(total_amount as numeric) as total_amount,
    coalesce({{ dbt.safe_cast("payment_type", api.Column.translate_type("integer")) }},0) as payment_type,
    {{ get_payment_type_description("payment_type") }} as payment_type_description
from {{ source('staging', 'green_tripdata') }}
where vendor_id is not null
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
