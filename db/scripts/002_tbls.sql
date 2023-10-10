create table tree_cover_h3_2021 (
    h3_index                h3index, 
    mean_tree_cover_2021    double precision);

alter table tree_cover_h3_2021 add primary key (h3_index, mean_tree_cover_2021);

