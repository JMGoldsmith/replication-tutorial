listener "tcp" {
  address = "127.0.0.1:8200"
  tls_disable = 1
}

storage "raft" {
  path = "/raft/data"
  node_id = "raft_node_1"
}

cluster_addr = "http://127.0.0.1:8201"
