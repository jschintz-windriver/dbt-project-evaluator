-- this model finds cases where a model references more than one source
with direct_source_relationships as (
    select  
        *
    from {{ ref('int_all_dag_relationships') }}
    where distance = 1
    and parent_type = 'source'
),

multiple_sources_joined as (
    select
        child,
        count(*)
    from direct_source_relationships
    group by 1
    having count(*) > 1
),

final as (
    select 
        direct_source_relationships.*
    from direct_source_relationships
    inner join multiple_sources_joined
    on direct_source_relationships.child = multiple_sources_joined.child
    order by direct_source_relationships.child
)

select * from final