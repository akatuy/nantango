CREATE TABLE "quiz" (
    "id" BIGSERIAL NOT NULL PRIMARY KEY,
    "level" INTEGER,
    "english" TEXT,
    "sound" TEXT,
    "ja" TEXT,
    "ja2" TEXT,
    "created_at" TIMESTAMPTZ,
    "updated_at" TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS "schema_migrations" (
    "version" VARCHAR(255) PRIMARY KEY,
    "applied_at" TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);
