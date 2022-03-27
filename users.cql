CREATE KEYSPACE demo WITH replication = {
'class': 'SimpleStrategy', 'replication_factor': '1'
};

CREATE TABLE demo.users (
  lastname text PRIMARY KEY,
  firstname text,
  email text
);
