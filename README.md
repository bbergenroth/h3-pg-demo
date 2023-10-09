## [H3 PG extension demo](https://github.com/zachasme/h3-pg/)
### Supported on [RDS](https://aws.amazon.com/about-aws/whats-new/2023/09/amazon-rds-postgresql-h3-pg-geospatial-indexing/)

#### Build and run:

`docker-compose up`

`docker exec -it h3-pg-demo-db-1 psql -U postgres -d h3`

#### Available functions

```
h3=# \sf h3
h3_are_neighbor_cells                  h3_grid_path_cells_recursive
h3_cell_area                           h3_grid_ring_unsafe
h3_cells_to_directed_edge              h3index_cmp
h3_cells_to_multi_polygon              h3index_contained_by
h3_cells_to_multi_polygon_geography    h3index_contains
h3_cells_to_multi_polygon_geometry     h3index_distance
h3_cells_to_multi_polygon_wkb          h3index_eq
h3_cell_to_boundary                    h3index_ge
h3_cell_to_boundary_geography          h3index_gt
h3_cell_to_boundary_geometry           h3index_hash
h3_cell_to_boundary_wkb                h3index_hash_extended
h3_cell_to_center_child                h3index_in
h3_cell_to_child_pos                   h3index_le
h3_cell_to_children                    h3index_lt
h3_cell_to_children_slow               h3index_ne
h3_cell_to_geography                   h3index_out
h3_cell_to_geometry                    h3index_overlaps
h3_cell_to_lat_lng                     h3index_sortsupport
h3_cell_to_local_ij                    h3index_to_bigint
h3_cell_to_parent                      h3_is_pentagon
h3_cell_to_vertex                      h3_is_res_class_iii
h3_cell_to_vertexes                    h3_is_valid_cell
h3_child_pos_to_cell                   h3_is_valid_directed_edge
h3_compact_cells                       h3_is_valid_vertex
h3_directed_edge_to_boundary           h3_lat_lng_to_cell
h3_directed_edge_to_cells              h3_local_ij_to_cell
h3_edge_length                         h3_origin_to_directed_edges
h3_get_base_cell_number                h3_pg_migrate_pass_by_reference
h3_get_directed_edge_destination       h3_polygon_to_cells
h3_get_directed_edge_origin            h3_raster_class_summary
h3_get_extension_version               h3_raster_class_summary_centroids
h3_get_hexagon_area_avg                h3_raster_class_summary_clip
h3_get_hexagon_edge_length_avg         h3_raster_class_summary_item_agg
h3_get_icosahedron_faces               h3_raster_class_summary_item_to_jsonb
h3_get_num_cells                       h3_raster_class_summary_subpixel
h3_get_pentagons                       h3_raster_summary
h3_get_res_0_cells                     h3_raster_summary_centroids
h3_get_resolution                      h3_raster_summary_clip
h3_great_circle_distance               h3_raster_summary_stats_agg
h3_grid_disk                           h3_raster_summary_subpixel
h3_grid_disk_distances                 h3_uncompact_cells
h3_grid_distance                       h3_vertex_to_lat_lng
h3_grid_path_cells                     
```

#### How many hexagons at each zoom level?
```
h3=# select n, h3_get_num_cells(n) from generate_series(0, 15, 1) n;
+----+------------------+
| n  | h3_get_num_cells |
+----+------------------+
|  0 |              122 |
|  1 |              842 |
|  2 |             5882 |
|  3 |            41162 |
|  4 |           288122 |
|  5 |          2016842 |
|  6 |         14117882 |
|  7 |         98825162 |
|  8 |        691776122 |
|  9 |       4842432842 |
| 10 |      33897029882 |
| 11 |     237279209162 |
| 12 |    1660954464122 |
| 13 |   11626681248842 |
| 14 |   81386768741882 |
| 15 |  569707381193162 |
+----+------------------+
(16 rows)
```
---

### Useful links/references
https://pgxn.org/dist/h3/docs/api.html

https://blog.rustprooflabs.com/2022/04/postgis-h3-intro
