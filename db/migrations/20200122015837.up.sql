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
