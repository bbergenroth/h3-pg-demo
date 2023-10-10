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
#### Example data

```
h3=# \d tree_cover_h3_2021
                     Table "public.tree_cover_h3_2021"
+----------------------+------------------+-----------+----------+---------+
|        Column        |       Type       | Collation | Nullable | Default |
+----------------------+------------------+-----------+----------+---------+
| h3_index             | h3index          |           | not null |         |
| mean_tree_cover_2021 | double precision |           | not null |         |
+----------------------+------------------+-----------+----------+---------+
Indexes:
    "tree_cover_h3_2021_pkey" PRIMARY KEY, btree (h3_index, mean_tree_cover_2021)

h3=# select count(*) from tree_cover_h3_2021;
+--------+
| count  |
+--------+
| 968288 |
+--------+
```
```
h3=# select * from tree_cover_h3_2021 limit 3;
+-----------------+----------------------+
|    h3_index     | mean_tree_cover_2021 |
+-----------------+----------------------+
| 8b2a1008562afff |                 0.34 |
| 8b2a10745d0afff |                 1.29 |
| 8b2a100d5a24fff |                  2.1 |
+-----------------+----------------------+
```

#### The tree cover area

```
select st_asgeojson(
    st_convexhull(
        h3_cells_to_multi_polygon_geometry(h3_index))) 
from tree_cover_h3_2021;
```

```geojson
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "properties": {},
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              -74.008478952,
              40.529915816
            ],
            [
              -74.05214856,
              40.533609308
            ],
            [
              -74.054291999,
              40.533926518
            ],
            [
              -74.05889831,
              40.534928644
            ],
            [
              -74.07303799,
              40.538301822
            ],
            [
              -74.092715569,
              40.543025093
            ],
            [
              -74.098251629,
              40.544376495
            ],
            [
              -74.098560935,
              40.544493379
            ],
            [
              -74.135752947,
              40.560020478
            ],
            [
              -74.138858755,
              40.561439487
            ],
            [
              -74.142605163,
              40.563593917
            ],
            [
              -74.173615848,
              40.583436543
            ],
            [
              -74.17518637,
              40.584522289
            ],
            [
              -74.182175841,
              40.591106878
            ],
            [
              -74.196481685,
              40.604644325
            ],
            [
              -74.203798266,
              40.611597209
            ],
            [
              -74.204119297,
              40.611965015
            ],
            [
              -74.224654557,
              40.641920374
            ],
            [
              -74.225652149,
              40.643777638
            ],
            [
              -74.22874564,
              40.651610577
            ],
            [
              -74.23564614,
              40.669522185
            ],
            [
              -74.238065924,
              40.675867512
            ],
            [
              -74.238421257,
              40.676989424
            ],
            [
              -74.238877395,
              40.680373099
            ],
            [
              -74.242307887,
              40.709342064
            ],
            [
              -74.242487493,
              40.713364572
            ],
            [
              -74.242266484,
              40.715259126
            ],
            [
              -74.241569681,
              40.720188746
            ],
            [
              -74.240872733,
              40.725118665
            ],
            [
              -74.240175639,
              40.730048881
            ],
            [
              -74.239478398,
              40.734979395
            ],
            [
              -74.238781012,
              40.739910207
            ],
            [
              -74.238083479,
              40.744841316
            ],
            [
              -74.237607168,
              40.747877365
            ],
            [
              -74.233284025,
              40.774452041
            ],
            [
              -74.232739969,
              40.775979507
            ],
            [
              -74.2313629,
              40.779420854
            ],
            [
              -74.225563634,
              40.793573908
            ],
            [
              -74.223351884,
              40.798930158
            ],
            [
              -74.221139633,
              40.804286716
            ],
            [
              -74.21892688,
              40.809643581
            ],
            [
              -74.216713626,
              40.815000753
            ],
            [
              -74.21449987,
              40.820358232
            ],
            [
              -74.212285613,
              40.825716018
            ],
            [
              -74.210070853,
              40.83107411
            ],
            [
              -74.207855591,
              40.836432509
            ],
            [
              -74.207020588,
              40.83834756
            ],
            [
              -74.206185518,
              40.84026265
            ],
            [
              -74.163368757,
              40.913379128
            ],
            [
              -74.150917059,
              40.930768231
            ],
            [
              -74.150626624,
              40.931155067
            ],
            [
              -74.150336183,
              40.931541904
            ],
            [
              -74.150045739,
              40.931928743
            ],
            [
              -74.149755289,
              40.932315582
            ],
            [
              -74.149464835,
              40.932702423
            ],
            [
              -74.149174376,
              40.933089264
            ],
            [
              -74.148883912,
              40.933476107
            ],
            [
              -74.148593444,
              40.93386295
            ],
            [
              -74.148302971,
              40.934249795
            ],
            [
              -74.148012493,
              40.93463664
            ],
            [
              -74.14772201,
              40.935023487
            ],
            [
              -74.147431523,
              40.935410335
            ],
            [
              -74.147141031,
              40.935797184
            ],
            [
              -74.146850534,
              40.936184034
            ],
            [
              -74.146560033,
              40.936570884
            ],
            [
              -74.146269526,
              40.936957736
            ],
            [
              -74.145979015,
              40.937344589
            ],
            [
              -74.1456885,
              40.937731443
            ],
            [
              -74.145397979,
              40.938118298
            ],
            [
              -74.145107454,
              40.938505154
            ],
            [
              -74.144816924,
              40.938892011
            ],
            [
              -74.14452639,
              40.93927887
            ],
            [
              -74.14423585,
              40.939665729
            ],
            [
              -74.143945306,
              40.940052589
            ],
            [
              -74.143654757,
              40.94043945
            ],
            [
              -74.143364204,
              40.940826313
            ],
            [
              -74.143073645,
              40.941213176
            ],
            [
              -74.142783082,
              40.94160004
            ],
            [
              -74.142492514,
              40.941986906
            ],
            [
              -74.142201942,
              40.942373772
            ],
            [
              -74.141911365,
              40.94276064
            ],
            [
              -74.141620783,
              40.943147508
            ],
            [
              -74.141330196,
              40.943534378
            ],
            [
              -74.141039605,
              40.943921248
            ],
            [
              -74.140749008,
              40.94430812
            ],
            [
              -74.140458408,
              40.944694993
            ],
            [
              -74.140167802,
              40.945081867
            ],
            [
              -74.139877191,
              40.945468741
            ],
            [
              -74.108019566,
              40.976662569
            ],
            [
              -74.105950351,
              40.97861441
            ],
            [
              -74.085217551,
              40.997376287
            ],
            [
              -74.083437907,
              40.998941211
            ],
            [
              -74.081658146,
              41.000506135
            ],
            [
              -74.079878269,
              41.002071061
            ],
            [
              -74.078681208,
              41.002862023
            ],
            [
              -74.077484106,
              41.00365298
            ],
            [
              -74.07298684,
              41.006429771
            ],
            [
              -74.061887238,
              41.013177867
            ],
            [
              -74.050784532,
              41.019925402
            ],
            [
              -74.047482298,
              41.021910855
            ],
            [
              -74.044179792,
              41.023896257
            ],
            [
              -74.043877691,
              41.024030857
            ],
            [
              -74.043273484,
              41.024300055
            ],
            [
              -74.042971378,
              41.024434653
            ],
            [
              -74.04236716,
              41.024703848
            ],
            [
              -74.042065049,
              41.024838444
            ],
            [
              -74.041460822,
              41.025107635
            ],
            [
              -74.041158706,
              41.02524223
            ],
            [
              -74.040554468,
              41.025511418
            ],
            [
              -74.040252347,
              41.025646011
            ],
            [
              -74.0396481,
              41.025915195
            ],
            [
              -74.039345974,
              41.026049786
            ],
            [
              -74.034199396,
              41.028085343
            ],
            [
              -74.029052392,
              41.030120714
            ],
            [
              -74.02390496,
              41.0321559
            ],
            [
              -74.004217898,
              41.039891227
            ],
            [
              -74.000882397,
              41.041118455
            ],
            [
              -73.995088055,
              41.042411838
            ],
            [
              -73.959701065,
              41.050182719
            ],
            [
              -73.957564035,
              41.050618675
            ],
            [
              -73.952353082,
              41.051136259
            ],
            [
              -73.942838543,
              41.051767609
            ],
            [
              -73.933323818,
              41.052398176
            ],
            [
              -73.91367901,
              41.053673085
            ],
            [
              -73.913064204,
              41.053689202
            ],
            [
              -73.912449398,
              41.053705316
            ],
            [
              -73.911834592,
              41.053721427
            ],
            [
              -73.911219785,
              41.053737534
            ],
            [
              -73.910604979,
              41.053753639
            ],
            [
              -73.909990172,
              41.05376974
            ],
            [
              -73.909375365,
              41.053785837
            ],
            [
              -73.905364887,
              41.053511677
            ],
            [
              -73.901969266,
              41.053221324
            ],
            [
              -73.898573697,
              41.052930873
            ],
            [
              -73.895178179,
              41.052640324
            ],
            [
              -73.891782712,
              41.052349678
            ],
            [
              -73.888387297,
              41.052058933
            ],
            [
              -73.884991933,
              41.051768091
            ],
            [
              -73.88159662,
              41.051477151
            ],
            [
              -73.878201359,
              41.051186113
            ],
            [
              -73.874806149,
              41.050894978
            ],
            [
              -73.871410991,
              41.050603744
            ],
            [
              -73.868015884,
              41.050312413
            ],
            [
              -73.864620829,
              41.050020984
            ],
            [
              -73.863070063,
              41.049681922
            ],
            [
              -73.861519322,
              41.049342841
            ],
            [
              -73.859968606,
              41.049003741
            ],
            [
              -73.858417913,
              41.048664623
            ],
            [
              -73.856867246,
              41.048325485
            ],
            [
              -73.849728976,
              41.046613735
            ],
            [
              -73.84259127,
              41.04490159
            ],
            [
              -73.835454126,
              41.043189052
            ],
            [
              -73.828317546,
              41.041476118
            ],
            [
              -73.82273161,
              41.040102361
            ],
            [
              -73.820246077,
              41.039407581
            ],
            [
              -73.819934263,
              41.039289177
            ],
            [
              -73.81931064,
              41.039052366
            ],
            [
              -73.81899883,
              41.038933959
            ],
            [
              -73.818375217,
              41.038697145
            ],
            [
              -73.818063413,
              41.038578736
            ],
            [
              -73.81743981,
              41.038341918
            ],
            [
              -73.81712801,
              41.038223507
            ],
            [
              -73.816504417,
              41.037986685
            ],
            [
              -73.816192623,
              41.037868273
            ],
            [
              -73.815569039,
              41.037631446
            ],
            [
              -73.81525725,
              41.037513032
            ],
            [
              -73.814633676,
              41.037276202
            ],
            [
              -73.814321892,
              41.037157786
            ],
            [
              -73.813698328,
              41.036920952
            ],
            [
              -73.813386549,
              41.036802534
            ],
            [
              -73.812762995,
              41.036565696
            ],
            [
              -73.812451221,
              41.036447276
            ],
            [
              -73.805583658,
              41.033589465
            ],
            [
              -73.785921099,
              41.025369709
            ],
            [
              -73.7799917,
              41.022866232
            ],
            [
              -73.777801797,
              41.02178445
            ],
            [
              -73.776546706,
              41.021058117
            ],
            [
              -73.775291655,
              41.020331779
            ],
            [
              -73.762717227,
              41.012311001
            ],
            [
              -73.744490895,
              41.00064216
            ],
            [
              -73.742916983,
              40.999544827
            ],
            [
              -73.740703327,
              40.997705791
            ],
            [
              -73.737210395,
              40.994383389
            ],
            [
              -73.733717968,
              40.991061027
            ],
            [
              -73.730226046,
              40.987738706
            ],
            [
              -73.72673463,
              40.984416425
            ],
            [
              -73.723243719,
              40.981094185
            ],
            [
              -73.719753313,
              40.977771986
            ],
            [
              -73.716263412,
              40.974449828
            ],
            [
              -73.715943869,
              40.974079027
            ],
            [
              -73.71562433,
              40.973708227
            ],
            [
              -73.715304797,
              40.973337428
            ],
            [
              -73.714985269,
              40.97296663
            ],
            [
              -73.714665746,
              40.972595833
            ],
            [
              -73.714346228,
              40.972225036
            ],
            [
              -73.714026716,
              40.971854241
            ],
            [
              -73.713707208,
              40.971483447
            ],
            [
              -73.713387706,
              40.971112653
            ],
            [
              -73.713068209,
              40.970741861
            ],
            [
              -73.712748717,
              40.970371069
            ],
            [
              -73.71242923,
              40.970000278
            ],
            [
              -73.712109748,
              40.969629488
            ],
            [
              -73.711790272,
              40.969258699
            ],
            [
              -73.7114708,
              40.968887911
            ],
            [
              -73.711151334,
              40.968517124
            ],
            [
              -73.706309573,
              40.961442305
            ],
            [
              -73.699209333,
              40.95101628
            ],
            [
              -73.696949699,
              40.94766473
            ],
            [
              -73.694690393,
              40.944313281
            ],
            [
              -73.692431414,
              40.940961933
            ],
            [
              -73.691449129,
              40.939093475
            ],
            [
              -73.684057907,
              40.919595134
            ],
            [
              -73.679689905,
              40.907972341
            ],
            [
              -73.679346387,
              40.906845716
            ],
            [
              -73.679002886,
              40.905719107
            ],
            [
              -73.678585265,
              40.902324491
            ],
            [
              -73.67684136,
              40.886479882
            ],
            [
              -73.676399402,
              40.882330264
            ],
            [
              -73.675957523,
              40.87818086
            ],
            [
              -73.675515721,
              40.87403167
            ],
            [
              -73.675507506,
              40.87377976
            ],
            [
              -73.675491075,
              40.873275943
            ],
            [
              -73.67548286,
              40.873024036
            ],
            [
              -73.67546643,
              40.872520224
            ],
            [
              -73.675458215,
              40.872268319
            ],
            [
              -73.675441785,
              40.871764511
            ],
            [
              -73.675433571,
              40.871512609
            ],
            [
              -73.675417142,
              40.871008806
            ],
            [
              -73.675408927,
              40.870756906
            ],
            [
              -73.675392499,
              40.870253108
            ],
            [
              -73.675384285,
              40.87000121
            ],
            [
              -73.675367857,
              40.869497417
            ],
            [
              -73.675359643,
              40.869245521
            ],
            [
              -73.676362424,
              40.862414908
            ],
            [
              -73.679882214,
              40.838889916
            ],
            [
              -73.680395342,
              40.835853481
            ],
            [
              -73.696643295,
              40.753097315
            ],
            [
              -73.696911325,
              40.751957941
            ],
            [
              -73.698326116,
              40.74852492
            ],
            [
              -73.709369517,
              40.722204261
            ],
            [
              -73.711075147,
              40.718387665
            ],
            [
              -73.723870196,
              40.699201111
            ],
            [
              -73.734076049,
              40.684986465
            ],
            [
              -73.748098002,
              40.666528308
            ],
            [
              -73.782650831,
              40.633601064
            ],
            [
              -73.784717714,
              40.631663333
            ],
            [
              -73.811280875,
              40.606857891
            ],
            [
              -73.830173925,
              40.58978813
            ],
            [
              -73.835781061,
              40.584744141
            ],
            [
              -73.839324659,
              40.581637738
            ],
            [
              -73.842894974,
              40.579284292
            ],
            [
              -73.873878496,
              40.560391346
            ],
            [
              -73.875966255,
              40.559206411
            ],
            [
              -73.877164493,
              40.558672679
            ],
            [
              -73.882265979,
              40.556655125
            ],
            [
              -73.917066665,
              40.54292773
            ],
            [
              -73.918572862,
              40.542511019
            ],
            [
              -73.937890135,
              40.538229126
            ],
            [
              -73.951471116,
              40.535228352
            ],
            [
              -73.959317826,
              40.533510608
            ],
            [
              -73.96143143,
              40.533076995
            ],
            [
              -73.967801177,
              40.532528449
            ],
            [
              -74.006654962,
              40.529965717
            ],
            [
              -74.008478952,
              40.529915816
            ]
          ]
        ]
      }
    }
  ]
}
```
#### A random H3 index

```
select json_build_object(
    'type', 'FeatureCollection',
    'features', json_agg(ST_AsGeoJSON(a.*)::json))
from (
    select h3_index::bigint as id, h3_cell_to_boundary_geometry(h3_index), mean_tree_cover_2021 
    from tree_cover_h3_2021 limit 1) a;

```

```geojson
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [
              -73.969360627,
              40.848119896
            ],
            [
              -73.969661793,
              40.847985766
            ],
            [
              -73.969652001,
              40.847733931
            ],
            [
              -73.969341046,
              40.847616225
            ],
            [
              -73.969039882,
              40.847750353
            ],
            [
              -73.969049671,
              40.848002189
            ],
            [
              -73.969360627,
              40.848119896
            ]
          ]
        ]
      },
      "properties": {
        "id": 626740321767829503,
        "mean_tree_cover_2021": 0.34
      }
    }
  ]
}
```
---

### Useful links/references
https://pgxn.org/dist/h3/docs/api.html

https://blog.rustprooflabs.com/2022/04/postgis-h3-intro
