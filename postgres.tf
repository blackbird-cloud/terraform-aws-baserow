resource "postgresql_database" "baserow" {
  name  = "baserow"
  owner = postgresql_role.baserow.name
  lifecycle {
    prevent_destroy = true
  }
}

resource "postgresql_role" "baserow" {
  name            = "baserow"
  login           = true
  create_role     = true
  create_database = true
  password        = random_password.baserow_postgres_role.result
  lifecycle {
    prevent_destroy = true
  }
}

resource "postgresql_grant" "baserow_database" {
  database    = postgresql_database.baserow.name
  role        = postgresql_role.baserow.name
  schema      = "public"
  object_type = "database"
  privileges = [
    "CONNECT",
    "CREATE",
    "TEMPORARY",
  ]
  lifecycle {
    prevent_destroy = true
  }
}

resource "postgresql_grant" "baserow_schema" {
  database    = postgresql_database.baserow.name
  role        = postgresql_role.baserow.name
  schema      = "public"
  object_type = "schema"
  privileges = [
    "CREATE",
    "USAGE"
  ]
  lifecycle {
    prevent_destroy = true
  }
}

resource "postgresql_grant" "baserow_table" {
  database    = postgresql_database.baserow.name
  role        = postgresql_role.baserow.name
  schema      = "public"
  object_type = "table"
  privileges = [
    "DELETE",
    "INSERT",
    "MAINTAIN",
    "REFERENCES",
    "SELECT",
    "TRIGGER",
    "TRUNCATE",
    "UPDATE"
  ]
  lifecycle {
    prevent_destroy = true
  }
}

resource "postgresql_grant" "baserow_sequence" {
  database    = postgresql_database.baserow.name
  role        = postgresql_role.baserow.name
  schema      = "public"
  object_type = "sequence"
  privileges = [
    "ALL"
  ]
  lifecycle {
    prevent_destroy = true
  }
}

resource "postgresql_grant" "baserow_function" {
  database    = postgresql_database.baserow.name
  role        = postgresql_role.baserow.name
  schema      = "public"
  object_type = "function"
  privileges = [
    "ALL"
  ]
  lifecycle {
    prevent_destroy = true
  }
}

resource "random_password" "baserow_postgres_role" {
  length  = 24
  special = true
}
