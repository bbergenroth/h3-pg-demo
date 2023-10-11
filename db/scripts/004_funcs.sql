create or replace function manhattan_trees(z integer, x integer, y integer) returns bytea as 
$$
declare
    result bytea;
begin
    with bounds as (select st_tileenvelope(z, x, y) as geom),
    h3 as (
        select t.h3_index, t.mean_tree_cover_2021, p.name, p.id,
            st_transform(h3_cell_to_boundary_geometry(h3_index)::geometry(polygon, 4326), 3857) as geom
        from tree_cover_h3_2021 t
            join lateral (
                select id, name, h3_polygon_to_cells(geometry, 11) h3_index from places) p
            using (h3_index) 
        where p.name ='Manhattan' and mean_tree_cover_2021 > 0
    ),
    mvtgeom as (
      select st_asmvtgeom(h3.geom, bounds.geom) as geom, h3.name, h3.h3_index, h3.mean_tree_cover_2021
      from h3 join bounds on st_intersects(h3.geom, bounds.geom)
    )
    select st_asmvt(mvtgeom, 'default')
    into result
    from mvtgeom;

    return result;
end;
$$
language 'plpgsql'
stable parallel safe;