CREATE SCHEMA IF NOT EXISTS "ola_mundo";

CREATE TABLE IF NOT EXISTS "ola_mundo"."greetings" (
  "id" bigserial PRIMARY KEY,
  "created_at" timestamptz,
  "text" text NOT NULL
);
ALTER TABLE "ola_mundo"."greetings" ADD COLUMN IF NOT EXISTS "created_at" timestamptz;
ALTER TABLE "ola_mundo"."greetings" ADD COLUMN IF NOT EXISTS "text" text;
