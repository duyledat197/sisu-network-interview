DROP TABLE IF EXISTS nodes;

CREATE TABLE IF NOT EXISTS nodes (node_id INT PRIMARY KEY, port INT);

DROP TABLE IF EXISTS neighbour_nodes;

CREATE TABLE IF NOT EXISTS neighbour_nodes (
  node_id INT REFERENCES nodes(node_id),
  neighbour_id INT,
  neighbour_port INT,
  position INT,
  UNIQUE (node_id, neighbour_id)
);

CREATE INDEX IF NOT EXISTS neighbour_nodes_node_id_idx ON neighbour_nodes (node_id);

CREATE INDEX IF NOT EXISTS neighbour_nodes_node_id_neighbour_id_idx ON neighbour_nodes (node_id, neighbour_id);

-- CREATE INDEX IF NOT EXISTS neighbour_nodes_node_id_idx ON neighbour_nodes (node_id);