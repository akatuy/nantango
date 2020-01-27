# Settting up the DB environment: PostgreSQL

create the user:

```sql
$ psql -U teacher nantango
postgres=# CREATE USER teacher WITH PASSWORD 'teacher2020';
```

create the database for the app in the name of "nantango":

```sql
$ psql -U adminuser postgres
postgres=# CREATE DATABASE nantango WITH OWNER teacher;
postgres=# \l
                          List of databases
   Name    |  Owner  | Encoding | Collate | Ctype | Access privileges 
-----------+---------+----------+---------+-------+-------------------
 nantango  | teacher | UTF8     | C       | C     | 
```

give all privilages to the user teacher:

```sql
nantango=# GRANT ALL PRIVILEGES ON quiz To teacher;
```


make a migration script and do migration:

```bash
$ utopian generate migration
$ utopian db migrate
Applying 'db/schema.sql'...
-> CREATE TABLE "quiz" (
    "id" BIGSERIAL NOT NULL PRIMARY KEY,
    "level" INTEGER,
    "english" TEXT,
    "sound" TEXT,
    "ja" TEXT,
    "ja2" TEXT,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ
);
-> CREATE TABLE IF NOT EXISTS "schema_migrations" (
    "version" VARCHAR(255) PRIMARY KEY,
    "applied_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
WARNING:
   PostgreSQL warning: relation "schema_migrations" already exists, skipping
Successfully updated to the version "20200122015837".
```
inject quiz data to the database:

```sql
$ psql -U teacher nantango
nantango=# COPY quiz(id,level,english,sound,ja,ja2) FROM '/Users/tcool/.roswell/local-projects/t-cool/nantango/db/data.csv' WITH csv;
COPY 11891
nantango=# 
```

check the data injection:

```sql
nantango=# select * from quiz;
 id  | level | english  |   sound      |      ja       |      ja2        | created_at | updated_at 
 1   |  1    | something| サムスィング   |  何か，あるもの |  なにか，あるもの  |            | 
 2   |  1    | also     | オールソウ     |  もまた，さらに |  もまた          |            |
 3   |  1    | all      | オール        | すべての，全部の |  すべての，ぜんぶの|            |
:q
```

