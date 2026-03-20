--
-- PostgreSQL database dump
--

\restrict ZnCEebbwFsl2u8pAik2dT2c9MAzQ1mTey0O7YVm2Fw0Hycizk1hxjDNWhv5u3wz

-- Dumped from database version 17.8 (a284a84)
-- Dumped by pg_dump version 17.9 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY neon_auth.session DROP CONSTRAINT IF EXISTS "session_userId_fkey";
ALTER TABLE IF EXISTS ONLY neon_auth.member DROP CONSTRAINT IF EXISTS "member_userId_fkey";
ALTER TABLE IF EXISTS ONLY neon_auth.member DROP CONSTRAINT IF EXISTS "member_organizationId_fkey";
ALTER TABLE IF EXISTS ONLY neon_auth.invitation DROP CONSTRAINT IF EXISTS "invitation_organizationId_fkey";
ALTER TABLE IF EXISTS ONLY neon_auth.invitation DROP CONSTRAINT IF EXISTS "invitation_inviterId_fkey";
ALTER TABLE IF EXISTS ONLY neon_auth.account DROP CONSTRAINT IF EXISTS "account_userId_fkey";
DROP INDEX IF EXISTS neon_auth.verification_identifier_idx;
DROP INDEX IF EXISTS neon_auth."session_userId_idx";
DROP INDEX IF EXISTS neon_auth.organization_slug_uidx;
DROP INDEX IF EXISTS neon_auth."member_userId_idx";
DROP INDEX IF EXISTS neon_auth."member_organizationId_idx";
DROP INDEX IF EXISTS neon_auth."invitation_organizationId_idx";
DROP INDEX IF EXISTS neon_auth.invitation_email_idx;
DROP INDEX IF EXISTS neon_auth."account_userId_idx";
ALTER TABLE IF EXISTS ONLY neon_auth.verification DROP CONSTRAINT IF EXISTS verification_pkey;
ALTER TABLE IF EXISTS ONLY neon_auth."user" DROP CONSTRAINT IF EXISTS user_pkey;
ALTER TABLE IF EXISTS ONLY neon_auth."user" DROP CONSTRAINT IF EXISTS user_email_key;
ALTER TABLE IF EXISTS ONLY neon_auth.session DROP CONSTRAINT IF EXISTS session_token_key;
ALTER TABLE IF EXISTS ONLY neon_auth.session DROP CONSTRAINT IF EXISTS session_pkey;
ALTER TABLE IF EXISTS ONLY neon_auth.project_config DROP CONSTRAINT IF EXISTS project_config_pkey;
ALTER TABLE IF EXISTS ONLY neon_auth.project_config DROP CONSTRAINT IF EXISTS project_config_endpoint_id_key;
ALTER TABLE IF EXISTS ONLY neon_auth.organization DROP CONSTRAINT IF EXISTS organization_slug_key;
ALTER TABLE IF EXISTS ONLY neon_auth.organization DROP CONSTRAINT IF EXISTS organization_pkey;
ALTER TABLE IF EXISTS ONLY neon_auth.member DROP CONSTRAINT IF EXISTS member_pkey;
ALTER TABLE IF EXISTS ONLY neon_auth.jwks DROP CONSTRAINT IF EXISTS jwks_pkey;
ALTER TABLE IF EXISTS ONLY neon_auth.invitation DROP CONSTRAINT IF EXISTS invitation_pkey;
ALTER TABLE IF EXISTS ONLY neon_auth.account DROP CONSTRAINT IF EXISTS account_pkey;
DROP TABLE IF EXISTS public."T_USER_INFO";
DROP TABLE IF EXISTS public."T_ONAIR_KANRI";
DROP TABLE IF EXISTS public."M_TALENT";
DROP TABLE IF EXISTS public."M_PROGRAM";
DROP TABLE IF EXISTS public."M_NENTSUKI_SHU_KANRI";
DROP TABLE IF EXISTS public."M_KBN_GENRE";
DROP TABLE IF EXISTS public."M_CHANNEL_KYOKU";
DROP TABLE IF EXISTS neon_auth.verification;
DROP TABLE IF EXISTS neon_auth."user";
DROP TABLE IF EXISTS neon_auth.session;
DROP TABLE IF EXISTS neon_auth.project_config;
DROP TABLE IF EXISTS neon_auth.organization;
DROP TABLE IF EXISTS neon_auth.member;
DROP TABLE IF EXISTS neon_auth.jwks;
DROP TABLE IF EXISTS neon_auth.invitation;
DROP TABLE IF EXISTS neon_auth.account;
DROP SCHEMA IF EXISTS neon_auth;
--
-- Name: neon_auth; Type: SCHEMA; Schema: -; Owner: neon_auth
--

CREATE SCHEMA neon_auth;


ALTER SCHEMA neon_auth OWNER TO neon_auth;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.account (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "accountId" text NOT NULL,
    "providerId" text NOT NULL,
    "userId" uuid NOT NULL,
    "accessToken" text,
    "refreshToken" text,
    "idToken" text,
    "accessTokenExpiresAt" timestamp with time zone,
    "refreshTokenExpiresAt" timestamp with time zone,
    scope text,
    password text,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE neon_auth.account OWNER TO neon_auth;

--
-- Name: invitation; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.invitation (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "organizationId" uuid NOT NULL,
    email text NOT NULL,
    role text,
    status text NOT NULL,
    "expiresAt" timestamp with time zone NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "inviterId" uuid NOT NULL
);


ALTER TABLE neon_auth.invitation OWNER TO neon_auth;

--
-- Name: jwks; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.jwks (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "publicKey" text NOT NULL,
    "privateKey" text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL,
    "expiresAt" timestamp with time zone
);


ALTER TABLE neon_auth.jwks OWNER TO neon_auth;

--
-- Name: member; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.member (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "organizationId" uuid NOT NULL,
    "userId" uuid NOT NULL,
    role text NOT NULL,
    "createdAt" timestamp with time zone NOT NULL
);


ALTER TABLE neon_auth.member OWNER TO neon_auth;

--
-- Name: organization; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.organization (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    logo text,
    "createdAt" timestamp with time zone NOT NULL,
    metadata text
);


ALTER TABLE neon_auth.organization OWNER TO neon_auth;

--
-- Name: project_config; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.project_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    endpoint_id text NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    trusted_origins jsonb NOT NULL,
    social_providers jsonb NOT NULL,
    email_provider jsonb,
    email_and_password jsonb,
    allow_localhost boolean NOT NULL,
    plugin_configs jsonb,
    webhook_config jsonb
);


ALTER TABLE neon_auth.project_config OWNER TO neon_auth;

--
-- Name: session; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.session (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    "expiresAt" timestamp with time zone NOT NULL,
    token text NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL,
    "ipAddress" text,
    "userAgent" text,
    "userId" uuid NOT NULL,
    "impersonatedBy" text,
    "activeOrganizationId" text
);


ALTER TABLE neon_auth.session OWNER TO neon_auth;

--
-- Name: user; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth."user" (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    "emailVerified" boolean NOT NULL,
    image text,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    role text,
    banned boolean,
    "banReason" text,
    "banExpires" timestamp with time zone
);


ALTER TABLE neon_auth."user" OWNER TO neon_auth;

--
-- Name: verification; Type: TABLE; Schema: neon_auth; Owner: neon_auth
--

CREATE TABLE neon_auth.verification (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    identifier text NOT NULL,
    value text NOT NULL,
    "expiresAt" timestamp with time zone NOT NULL,
    "createdAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE neon_auth.verification OWNER TO neon_auth;

--
-- Name: M_CHANNEL_KYOKU; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."M_CHANNEL_KYOKU" (
    "CHANNEL_ID" integer NOT NULL,
    "CHANNEL_KYOKU_ID" integer,
    "AREA_ID" integer,
    "DELETE_FLG" integer,
    "TOROKU_DAY" timestamp without time zone,
    "KOUSHIN_DAY" timestamp without time zone
);


ALTER TABLE public."M_CHANNEL_KYOKU" OWNER TO neondb_owner;

--
-- Name: M_KBN_GENRE; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."M_KBN_GENRE" (
    "GENRE_ID" integer NOT NULL,
    "JYUNJYO" integer NOT NULL,
    "GENRE" character varying(30) DEFAULT NULL::character varying,
    "DELETE_FLG" integer,
    "TOROKU_DAY" timestamp without time zone,
    "KOUSHIN_DAY" timestamp without time zone
);


ALTER TABLE public."M_KBN_GENRE" OWNER TO neondb_owner;

--
-- Name: M_NENTSUKI_SHU_KANRI; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."M_NENTSUKI_SHU_KANRI" (
    "NENTSUKI" integer NOT NULL,
    "SHU" integer NOT NULL,
    "SHU_FROM" date,
    "SHU_TO" date,
    "TOROKU_DAY" timestamp without time zone,
    "KOUSHIN_DAY" timestamp without time zone
);


ALTER TABLE public."M_NENTSUKI_SHU_KANRI" OWNER TO neondb_owner;

--
-- Name: M_PROGRAM; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."M_PROGRAM" (
    "PROGRAM_ID" character varying(8) NOT NULL,
    "PROGRAM_NAME" character varying(30) DEFAULT NULL::character varying,
    "CHANNEL_ID" integer,
    "GENRE_ID" integer,
    "DELETE_FLG" integer,
    "TOROKU_DAY" timestamp without time zone,
    "KOUSHIN_DAY" timestamp without time zone
);


ALTER TABLE public."M_PROGRAM" OWNER TO neondb_owner;

--
-- Name: M_TALENT; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."M_TALENT" (
    "TALENT_ID" character varying(8) NOT NULL,
    "TALENT_NAME" character varying(30) DEFAULT NULL::character varying,
    "GENRE_ID" integer,
    "DELETE_FLG" integer,
    "TOROKU_DAY" timestamp without time zone,
    "KOUSHIN_DAY" timestamp without time zone
);


ALTER TABLE public."M_TALENT" OWNER TO neondb_owner;

--
-- Name: T_ONAIR_KANRI; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."T_ONAIR_KANRI" (
    "ID" character varying(8) NOT NULL,
    "ONAIR_DAY" timestamp without time zone,
    "PROGRAM_ID" character varying(8) DEFAULT NULL::character varying,
    "TALENT_ID" character varying(8) DEFAULT NULL::character varying,
    "NENTSUKI" integer,
    "SHU" integer,
    "DELETE_FLG" integer,
    "TOROKU_DAY" timestamp without time zone,
    "KOUSHIN_DAY" timestamp without time zone
);


ALTER TABLE public."T_ONAIR_KANRI" OWNER TO neondb_owner;

--
-- Name: T_USER_INFO; Type: TABLE; Schema: public; Owner: neondb_owner
--

CREATE TABLE public."T_USER_INFO" (
    "ID" integer NOT NULL,
    "NAME" character varying(255) NOT NULL,
    "SEX" integer,
    "POSTNO" character varying(8),
    "ADDRESS1" character varying(255),
    "ADDRESS2" character varying(255),
    "BIKO" text
);


ALTER TABLE public."T_USER_INFO" OWNER TO neondb_owner;

--
-- Data for Name: account; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--



--
-- Data for Name: invitation; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--



--
-- Data for Name: jwks; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--



--
-- Data for Name: member; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--



--
-- Data for Name: organization; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--



--
-- Data for Name: project_config; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--

INSERT INTO neon_auth.project_config (id, name, endpoint_id, created_at, updated_at, trusted_origins, social_providers, email_provider, email_and_password, allow_localhost, plugin_configs, webhook_config) VALUES ('0a34654a-e3a4-4c42-ad6c-9666b152956f', 'kadaiDB_202305', 'ep-divine-truth-a1eqa5uj', '2026-03-17 05:46:17.807+00', '2026-03-17 05:46:17.807+00', '[]', '[{"id": "google", "isShared": true}]', '{"type": "shared"}', '{"enabled": true, "disableSignUp": false, "emailVerificationMethod": "otp", "requireEmailVerification": false, "autoSignInAfterVerification": true, "sendVerificationEmailOnSignIn": false, "sendVerificationEmailOnSignUp": false}', true, '{"organization": {"config": {"creatorRole": "owner", "membershipLimit": 100, "organizationLimit": 10, "sendInvitationEmail": false}, "enabled": true}}', '{"enabled": false, "enabledEvents": [], "timeoutSeconds": 5}');


--
-- Data for Name: session; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--



--
-- Data for Name: user; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--



--
-- Data for Name: verification; Type: TABLE DATA; Schema: neon_auth; Owner: neon_auth
--



--
-- Data for Name: M_CHANNEL_KYOKU; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public."M_CHANNEL_KYOKU" ("CHANNEL_ID", "CHANNEL_KYOKU_ID", "AREA_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (1, 1, 1, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_CHANNEL_KYOKU" ("CHANNEL_ID", "CHANNEL_KYOKU_ID", "AREA_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (2, 4, 1, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_CHANNEL_KYOKU" ("CHANNEL_ID", "CHANNEL_KYOKU_ID", "AREA_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (3, 5, 1, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_CHANNEL_KYOKU" ("CHANNEL_ID", "CHANNEL_KYOKU_ID", "AREA_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (4, 6, 1, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_CHANNEL_KYOKU" ("CHANNEL_ID", "CHANNEL_KYOKU_ID", "AREA_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (5, 7, 1, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_CHANNEL_KYOKU" ("CHANNEL_ID", "CHANNEL_KYOKU_ID", "AREA_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (6, 8, 1, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_CHANNEL_KYOKU" ("CHANNEL_ID", "CHANNEL_KYOKU_ID", "AREA_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (7, 1, 2, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_CHANNEL_KYOKU" ("CHANNEL_ID", "CHANNEL_KYOKU_ID", "AREA_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (8, 4, 2, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_CHANNEL_KYOKU" ("CHANNEL_ID", "CHANNEL_KYOKU_ID", "AREA_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (9, 6, 2, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_CHANNEL_KYOKU" ("CHANNEL_ID", "CHANNEL_KYOKU_ID", "AREA_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (10, 7, 2, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_CHANNEL_KYOKU" ("CHANNEL_ID", "CHANNEL_KYOKU_ID", "AREA_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (11, 10, 2, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');


--
-- Data for Name: M_KBN_GENRE; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (1, 1, 'ドラマ', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (1, 2, '報道', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (1, 3, 'バラエティ', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (1, 4, 'ドキュメント', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (1, 5, '教養', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (2, 1, 'お笑い', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (2, 2, '俳優', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (2, 3, 'タレント', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (2, 4, '先生', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (2, 5, 'その他', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (3, 1, 'NHK', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (3, 2, '日本テレビ', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (3, 3, 'テレビ朝日', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (3, 4, 'TBS', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (3, 5, 'テレビ東京', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (3, 6, 'フジテレビ', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (4, 1, '関東', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_KBN_GENRE" ("GENRE_ID", "JYUNJYO", "GENRE", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (4, 2, '関西', 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');


--
-- Data for Name: M_NENTSUKI_SHU_KANRI; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202303, 5, '2024-01-04', '2024-01-27', '2023-05-01 12:00:00', '2024-01-25 17:08:23');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202304, 1, '2023-04-02', '2023-04-08', '2023-05-01 12:00:00', '2024-01-29 22:03:56');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202304, 2, '2023-04-08', '2023-04-14', '2023-05-01 12:00:00', '2024-02-03 18:32:21');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202304, 4, '2024-01-01', '2024-01-01', '2023-05-01 12:00:00', '2024-01-31 11:23:16');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202311, 1, '2023-11-01', '2023-11-30', '2023-11-05 13:46:24', '2023-11-05 13:53:09');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202311, 2, '2023-11-01', '2023-11-30', '2023-11-05 13:53:27', '2024-01-23 15:42:56');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202401, 1, '2024-01-01', '2024-01-07', '2023-11-05 13:53:27', '2024-02-11 23:20:25');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202404, 5, '2024-01-04', '2024-01-31', '2024-01-23 15:57:42', '2024-01-26 18:39:37');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (200004, 4, '2024-01-06', '2024-01-14', '2024-01-23 16:22:29', '2024-01-23 16:22:29');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202303, 3, '2024-01-04', '2024-01-31', '2024-01-23 17:41:32', '2024-01-23 17:41:32');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202402, 4, '2024-01-01', '2024-01-01', '2024-01-23 17:44:37', '2024-01-31 00:42:31');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (199210, 1, '1992-10-01', '1992-10-07', '2024-01-29 10:56:14', '2024-02-04 16:41:09');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (199612, 2, '1996-12-10', '1996-12-16', '2024-01-29 16:10:41', '2024-02-04 18:19:00');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202309, 3, '2024-01-05', '2024-01-13', '2024-01-29 17:33:33', '2024-01-29 17:33:33');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202312, 3, '2024-01-01', '2024-01-01', '2024-01-31 00:42:53', '2024-01-31 12:14:50');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (200512, 1, '2024-01-03', '2024-01-19', '2024-01-31 11:23:39', '2024-01-31 11:23:39');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202311, 3, '2024-01-01', '2024-01-01', '2024-01-31 12:14:31', '2024-01-31 12:14:31');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202301, 3, '2024-01-01', '2024-01-01', '2024-01-31 12:15:19', '2024-01-31 12:15:19');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202308, 3, '2024-01-01', '2024-01-01', '2024-01-31 12:15:58', '2024-01-31 12:15:58');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202312, 4, '2024-01-04', '2024-01-31', '2024-01-31 14:22:22', '2024-01-31 14:22:22');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202312, 5, '2023-12-01', '2023-12-07', '2024-01-31 15:23:00', '2024-01-31 16:59:11');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202312, 1, '2023-12-24', '2023-12-30', '2024-01-31 15:23:21', '2024-01-31 20:13:41');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202401, 3, '2024-01-04', '2024-01-10', '2024-01-31 16:03:44', '2024-02-12 00:25:03');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202410, 2, '2024-10-06', '2024-10-12', '2024-10-11 00:02:07', '2024-10-11 00:02:07');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202507, 1, '2025-07-06', '2025-07-12', '2025-06-30 15:36:06.954', '2025-06-30 15:36:06.954');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202507, 2, '2025-07-20', '2025-07-26', '2025-06-30 16:01:21.983', '2025-06-30 16:01:21.983');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202304, 3, '2023-04-16', '2023-04-22', '2023-05-01 12:00:00', '2025-07-01 05:40:19.325');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202506, 1, '2025-06-01', '2025-06-07', '2025-07-01 06:21:50.553', '2025-07-01 06:21:50.553');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202603, 3, '2026-03-16', '2026-03-22', '2026-03-19 09:48:58.621', '2026-03-19 09:48:58.621');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202304, 5, '2023-04-24', '2023-04-30', '2023-05-01 12:00:00', '2026-03-19 12:06:19.335');
INSERT INTO public."M_NENTSUKI_SHU_KANRI" ("NENTSUKI", "SHU", "SHU_FROM", "SHU_TO", "TOROKU_DAY", "KOUSHIN_DAY") VALUES (202401, 4, '2024-01-22', '2024-01-28', '2024-01-23 15:59:05', '2026-03-19 12:11:41.927');


--
-- Data for Name: M_PROGRAM; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000003', 'ロンドンハーツ', 3, 1, 0, '2023-05-01 12:00:00', '2024-01-29 10:39:25');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000011', 'R-1グランプリ', 6, 5, 0, '2023-11-04 16:19:17', '2023-11-04 16:19:17');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000012', 'R-1グランプリ', 6, 5, 0, '2023-11-04 17:04:40', '2023-11-04 17:04:40');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000013', 'R-1グランプリ', 6, 5, 0, '2023-11-04 18:11:59', '2023-11-04 18:11:59');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000014', 'R-1グランプリ', 6, 5, 0, '2023-11-04 18:52:41', '2023-11-04 18:52:41');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000015', 'R-1グランプリ', 6, 5, 0, '2023-11-04 22:27:24', '2023-11-04 22:27:24');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000016', '酒のつまみ', 6, 5, 0, '2023-11-04 22:33:41', '2023-11-04 22:33:41');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000017', 'リンカーン', 6, 5, 0, '2023-11-04 22:36:55', '2023-11-19 13:46:28');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000018', 'R-1グランプリ', 6, 5, 0, '2023-11-09 23:20:16', '2023-11-09 23:20:16');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000019', 'R-1グランプリ', 6, 5, 0, '2023-11-11 21:56:06', '2023-11-11 21:56:06');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000020', 'R-1グランプリ', 6, 5, 0, '2023-11-13 23:35:34', '2023-11-13 23:35:34');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000021', 'R-1グランプリ', 6, 5, 0, '2023-11-17 12:21:55', '2023-11-17 12:21:55');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000022', 'R-1グランプリ', 6, 5, 0, '2023-11-17 12:22:09', '2023-11-17 12:22:09');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000023', 'R-1グランプリ', 6, 5, 0, '2023-11-19 13:46:24', '2023-11-19 13:46:24');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000024', 'b', 6, 2, 0, '2024-01-22 17:02:42', '2024-01-22 17:02:42');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000025', 'c', 6, 2, 0, '2024-01-22 17:02:46', '2024-01-22 17:02:46');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000026', 'd', 6, 2, 0, '2024-01-22 17:03:33', '2024-01-22 17:03:33');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000027', 'e', 6, 2, 0, '2024-01-22 17:05:45', '2024-01-22 17:05:45');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000028', 'g', 6, 1, 0, '2024-01-22 17:06:04', '2024-01-22 17:06:04');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000029', '乃木坂', 5, 3, 0, '2024-01-22 17:08:02', '2024-01-22 17:08:02');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000030', 'aa', 7, 5, 0, '2024-01-22 18:43:17', '2024-01-22 18:43:17');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000031', 'aa', 7, 4, 0, '2024-01-22 18:47:53', '2024-01-22 18:47:53');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000032', 'h', 3, 5, 0, '2024-01-22 18:51:21', '2024-01-22 18:51:21');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000033', 'i', 3, 5, 0, '2024-01-22 18:51:24', '2024-01-22 18:51:24');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000034', 'j', 3, 5, 0, '2024-01-22 18:52:34', '2024-01-22 18:52:34');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000035', 'aaa', 4, 5, 0, '2024-01-22 18:53:09', '2024-01-22 18:53:09');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000036', 'いいとも', 8, 3, 0, '2024-01-22 22:17:10', '2024-01-22 22:17:10');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000037', 'いいとも', 3, 3, 0, '2024-01-22 22:36:21', '2024-01-22 22:36:21');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000038', 'いいとも', 4, 5, 0, '2024-01-22 22:37:42', '2024-01-22 22:37:42');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000039', 'いいとも', 4, 2, 0, '2024-01-22 22:38:39', '2024-01-22 22:38:39');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000040', 'いいとも', 4, 3, 0, '2024-01-22 22:41:40', '2024-01-22 22:41:40');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000041', 'いいとも', 6, 3, 0, '2024-01-22 22:54:01', '2024-01-22 22:54:01');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000042', 'いいとも', 6, 4, 0, '2024-01-22 22:55:41', '2024-01-22 22:55:41');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000043', 'いいとも', 8, 4, 0, '2024-01-22 23:04:48', '2024-01-22 23:04:48');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000044', 'いいとも', 6, 5, 0, '2024-01-22 23:10:50', '2024-01-22 23:10:50');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000045', 'いいとも', 6, 4, 0, '2024-01-22 23:12:17', '2024-01-22 23:12:17');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000046', 'プラチナロンハー', 3, 5, 0, '2024-01-22 23:13:01', '2025-03-15 13:20:43');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000047', 'いいとも', 6, 4, 0, '2024-01-23 10:31:33', '2024-01-23 10:31:33');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000048', 'k', 3, 3, 0, '2024-01-23 11:40:30', '2024-01-23 11:40:30');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000049', '金スマ', 4, 4, 0, '2024-01-23 11:40:59', '2024-02-04 17:53:49');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000050', 'l', 5, 5, 0, '2024-01-23 11:41:34', '2024-01-23 11:41:34');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000051', 'm', 4, 3, 0, '2024-01-23 11:42:05', '2024-01-23 11:42:05');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000052', 'n', 5, 3, 0, '2024-01-23 11:42:38', '2024-01-23 11:42:38');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000053', 'o', 4, 3, 0, '2024-01-23 11:43:17', '2024-01-23 11:43:17');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000055', 'aaa５５', 4, 4, 0, '2024-01-25 16:09:30', '2024-01-25 16:10:50');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000056', 'プラチナロンハー', 2, 4, 0, '2024-01-25 19:05:08', '2024-01-25 19:05:08');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000057', 'いいとも３', 6, 3, 0, '2024-01-29 16:09:14', '2024-01-29 16:09:29');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000058', 'いいとも', 4, 3, 0, '2024-01-30 19:19:04', '2024-01-30 19:19:04');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000059', 'いいとも', 5, 5, 0, '2024-01-31 11:02:17', '2024-01-31 11:02:26');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000060', 'aaaa', 2, 4, 0, '2024-02-03 18:31:14', '2024-02-03 18:31:14');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000061', '夫よ死んでくれ', 5, 1, 0, '2025-06-30 15:34:46.457', '2025-06-30 15:34:46.457');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000007', 'いいともマリエ', 6, 3, 0, '2023-05-01 00:00:00', '2025-07-01 05:40:03.426');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000005', 'ひるおび', 4, 5, 0, '2023-05-01 12:00:00', '2025-07-02 01:40:16.758');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000054', 'ポップアップ', 2, 4, 0, '2024-01-23 11:46:03', '2025-07-02 08:31:15.255');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000004', 'いいとも１２３', 3, 3, 0, '2023-05-01 12:00:00', '2026-03-19 05:23:37.439');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000062', '夫と結婚して（日本版）', 2, 5, 0, '2025-07-01 06:21:01.747', '2026-03-19 05:38:18.796');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000001', 'バイキング', 6, 3, 0, '2023-05-01 12:00:00', '2026-03-19 09:32:35.734');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000002', 'NEWニューヨーク', 3, 5, 0, '2023-05-01 12:00:00', '2026-03-19 09:32:54.556');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000008', '霜降りバラエティ', 3, 4, 0, '2023-11-01 00:00:00', '2026-03-19 09:34:19.447');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000009', 'アメトーク', 3, 3, 0, '2023-11-04 15:50:39', '2026-03-19 09:52:59.72');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000006', 'やりすぎ都市伝説', 5, 2, 0, '2023-05-01 12:00:00', '2026-03-19 09:54:22.766');
INSERT INTO public."M_PROGRAM" ("PROGRAM_ID", "PROGRAM_NAME", "CHANNEL_ID", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000010', 'M-1グランプリ年末', 6, 5, 0, '2023-11-04 16:17:13', '2026-03-19 14:30:52.692');


--
-- Data for Name: M_TALENT; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000001', '森田哲矢（さらば青春の光）', 4, 0, '2023-05-01 12:00:00', '2024-01-29 16:25:21');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000002', 'せいや（霜降り明星）', 1, 0, '2023-05-01 12:00:00', '2024-01-31 16:58:30');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000003', '香取慎吾', 5, 0, '2023-05-01 12:00:00', '2024-01-30 19:48:27');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000004', '岡村隆史（ナインティナイン）', 1, 0, '2023-05-01 12:00:00', '2024-02-11 22:06:35');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000006', '岡村隆史（ナインティナイン）', 2, 0, '2023-05-01 12:00:00', '2024-01-30 19:48:49');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000007', 'みちょぱ（池田美優）', 5, 0, '2023-05-01 12:00:00', '2024-01-28 15:30:41');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000008', 'かまいたち', 1, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000010', '松本人志', 1, 0, '2023-11-04 23:54:23', '2024-01-31 18:50:15');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000015', 'G', 2, 0, '2023-11-11 22:04:09', '2023-11-11 22:04:09');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000016', 'H', 2, 0, '2023-11-11 22:04:12', '2023-11-11 22:04:12');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000017', 'I', 2, 0, '2023-11-13 23:35:44', '2023-11-13 23:35:44');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000018', 'J', 2, 0, '2023-11-13 23:35:47', '2023-11-13 23:35:47');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000019', 'K', 2, 0, '2023-11-17 11:53:25', '2023-11-17 11:53:25');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000020', 'L', 2, 0, '2023-11-17 11:53:29', '2023-11-17 11:53:29');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000021', 'M', 2, 0, '2023-11-19 13:46:34', '2023-11-19 13:46:34');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000022', 'N', 2, 0, '2023-11-19 13:46:36', '2023-11-19 13:46:36');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000023', 'M', 2, 0, '2024-01-23 10:53:06', '2024-01-23 10:53:06');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000024', 'O', 3, 0, '2024-01-23 11:03:27', '2024-01-23 11:03:27');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000025', 'P', 1, 0, '2024-01-23 11:29:08', '2024-01-23 11:29:08');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000026', 'L', 4, 0, '2024-01-23 11:33:25', '2024-01-23 11:33:25');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000027', 'M', 3, 0, '2024-01-23 11:46:10', '2024-01-28 21:48:04');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000028', 'N', 4, 0, '2024-01-23 11:46:46', '2024-01-23 11:46:46');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000029', '佐久間宣行', 3, 0, '2024-01-23 11:49:00', '2024-01-29 20:39:49');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000030', 'aaa', 2, 0, '2024-01-26 10:01:24', '2024-01-26 10:01:24');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000031', 'モグライダー', 5, 0, '2024-01-29 13:03:35', '2024-01-29 13:03:35');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000032', '東ブクロ１１１１', 1, 0, '2024-01-29 16:09:56', '2024-01-29 16:10:06');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000033', 'EE', 3, 0, '2024-01-29 17:16:41', '2024-01-29 17:16:41');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000034', 'GG', 5, 0, '2024-01-29 17:16:52', '2024-01-29 17:16:52');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000035', '岡村隆史（ナインティナイン）', 4, 0, '2024-01-31 11:15:05', '2024-01-31 11:15:05');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000036', 'ジャンポケ斉藤', 1, 0, '2024-10-11 00:00:51', '2024-10-11 00:00:51');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000038', '小芝おにゃり', 2, 0, '2025-07-01 06:21:19.054', '2025-07-01 06:21:19.054');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000011', '佐藤秀臣', 2, 0, '2023-11-05 00:05:43', '2025-07-03 02:31:45.06');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000012', '松田ボクジ', 2, 0, '2023-11-05 00:05:48', '2025-07-03 02:32:01.98');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000013', '髙橋パワハラ', 2, 0, '2023-11-09 23:20:24', '2025-07-03 02:33:26.242');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000009', '国分太一', 4, 0, '2023-11-04 23:24:30', '2025-07-03 02:41:18.858');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000014', '小竹兼治', 2, 0, '2023-11-09 23:20:28', '2025-07-03 02:46:18.697');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000037', '畑めい可愛いヤツ', 4, 0, '2025-06-30 16:00:57.785', '2026-03-19 05:38:55.377');
INSERT INTO public."M_TALENT" ("TALENT_ID", "TALENT_NAME", "GENRE_ID", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000005', 'はまやねん（8.6秒バズーカ）', 1, 0, '2023-05-01 12:00:00', '2026-03-19 12:03:09.228');


--
-- Data for Name: T_ONAIR_KANRI; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000001', '2023-05-11 11:50:00', '00000005', '00000010', 202304, 3, 0, '2023-05-01 12:00:00', '2024-01-31 18:51:17');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000002', '2023-04-18 11:50:00', '00000004', '00000010', 202304, 3, 0, '2023-05-01 12:00:00', '2024-01-31 16:10:59');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000003', '2023-04-19 11:50:00', '00000008', '00000009', 202402, 4, 0, '2023-05-01 12:00:00', '2024-02-11 13:18:39');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000005', '2024-01-04 17:25:00', '00000005', '00000005', 202304, 3, 0, '2023-05-01 12:00:00', '2024-01-31 20:13:46');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000006', '2023-04-18 23:45:00', '00000005', '00000003', 202304, 3, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000007', '2023-04-18 23:45:00', '00000002', '00000002', 202303, 5, 0, '2023-05-01 12:00:00', '2024-02-11 15:33:15');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000008', '2023-11-12 00:00:00', '00000003', '00000005', 202305, 4, 0, '2023-11-01 00:00:00', '2023-11-19 13:47:00');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000009', '2023-11-12 00:00:00', '00000003', '00000005', 202305, 4, 1, '2023-11-01 00:00:00', '2023-11-05 21:37:19');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000010', '2023-11-12 00:00:00', '00000003', '00000005', 202305, 4, 1, '2023-11-05 21:39:37', '2023-11-05 21:39:37');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000011', '2024-01-25 11:22:00', '00000002', '00000003', 202404, 5, 0, '2024-01-24 11:26:11', '2024-01-24 11:26:11');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000012', '2024-01-25 19:02:00', '00000004', '00000001', 202402, 4, 0, '2024-01-25 19:03:07', '2024-02-11 22:06:29');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000013', '2024-01-26 10:09:00', '00000006', '00000009', 202402, 4, 0, '2024-01-26 10:09:19', '2024-01-26 10:09:19');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000015', '2024-01-04 18:24:00', '00000005', '00000012', 202304, 3, 0, '2024-01-26 18:24:30', '2024-01-26 18:24:30');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000016', '2023-04-18 11:50:00', '00000005', '00000013', 202304, 3, 0, '2023-05-01 12:00:00', '2024-01-25 16:07:13');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000017', '2023-04-18 11:50:00', '00000005', '00000014', 202304, 3, 0, '2023-05-01 12:00:00', '2024-01-25 17:49:55');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000018', '2023-04-19 11:50:00', '00000008', '00000015', 202402, 4, 0, '2023-05-01 12:00:00', '2024-01-25 16:08:52');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000019', '2023-04-18 11:50:00', '00000005', '00000002', 202304, 3, 0, '2023-05-01 12:00:00', '2024-01-29 16:25:36');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000020', '2023-04-18 11:50:00', '00000005', '00000017', 202304, 3, 0, '2023-05-01 12:00:00', '2023-05-01 12:00:00');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000021', '2023-04-18 23:45:00', '00000005', '00000018', 202304, 3, 0, '2023-05-01 12:00:00', '2024-01-29 17:33:16');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000022', '2023-04-18 23:45:00', '00000002', '00000008', 202303, 5, 0, '2023-05-01 12:00:00', '2024-01-29 16:21:28');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000023', '2023-11-12 00:00:00', '00000003', '00000020', 202305, 4, 0, '2023-11-01 00:00:00', '2023-11-19 13:47:00');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000024', '2023-11-12 00:00:00', '00000003', '00000021', 202305, 4, 1, '2023-11-01 00:00:00', '2023-11-05 21:37:19');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000025', '2023-11-12 00:00:00', '00000003', '00000022', 202305, 4, 1, '2023-11-05 21:39:37', '2023-11-05 21:39:37');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000026', '2024-01-25 11:22:00', '00000002', '00000023', 202404, 5, 0, '2024-01-24 11:26:11', '2024-01-24 11:26:11');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000027', '2024-01-25 19:02:00', '00000004', '00000024', 202402, 4, 0, '2024-01-25 19:03:07', '2024-01-25 19:03:07');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000028', '2024-01-26 10:09:00', '00000006', '00000025', 202402, 4, 0, '2024-01-26 10:09:19', '2024-01-26 10:09:19');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000030', '2024-01-04 18:24:00', '00000008', '00000027', 202304, 3, 0, '2024-01-26 18:24:30', '2024-01-26 18:24:30');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000032', '2024-01-26 16:11:00', '00000005', '00000003', 202401, 1, 0, '2024-01-29 16:11:45', '2024-01-29 16:11:45');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000033', '2024-01-26 16:11:00', '00000005', '00000005', 202401, 1, 0, '2024-01-29 16:12:12', '2024-01-29 16:12:12');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000034', '2024-01-05 16:11:00', '00000005', '00000005', 202401, 1, 0, '2024-01-29 16:13:00', '2024-01-29 16:13:00');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000035', '2024-01-04 16:22:00', '00000003', '00000003', 202311, 2, 0, '2024-01-29 16:23:06', '2024-01-29 16:23:06');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000036', '2024-01-20 22:03:00', '00000056', '00000002', 202404, 3, 0, '2024-01-29 22:03:17', '2024-01-29 22:03:17');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000037', '2024-01-30 23:45:00', '00000003', '00000003', 202304, 3, 0, '2024-01-30 23:46:08', '2024-01-30 23:46:08');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000038', '2024-02-22 18:19:00', '00000005', '00000007', 199612, 2, 0, '2024-02-04 18:19:39', '2024-02-04 18:19:39');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000039', '2024-02-16 13:15:00', '00000004', '00000008', 202303, 3, 0, '2024-02-11 13:15:21', '2024-02-11 13:15:21');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000040', '2024-02-01 13:15:00', '00000004', '00000005', 202303, 5, 0, '2024-02-11 13:15:50', '2024-02-11 13:15:50');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000041', '2024-10-12 20:02:00', '00000059', '00000036', 202410, 2, 0, '2024-10-11 00:03:02', '2024-10-11 00:04:10');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000042', '2025-07-10 00:45:00', '00000061', '00000007', 202507, 1, 0, '2025-06-30 15:45:24.165', '2025-06-30 15:45:24.165');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000043', '2025-07-17 01:01:00', '00000056', '00000037', 202507, 2, 0, '2025-06-30 16:01:49.68', '2025-06-30 16:01:49.68');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000004', '2023-04-18 11:50:00', '00000005', '00000004', 202304, 3, 0, '2023-05-01 12:00:00', '2025-06-30 16:50:49.316');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000044', '2025-06-06 15:21:00', '00000062', '00000038', 202506, 1, 0, '2025-07-01 06:22:21.255', '2025-07-01 06:22:21.255');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000046', '2025-01-24 15:23:00', '00000005', '00000007', 199612, 2, 0, '2025-07-01 06:23:54.68', '2025-07-01 06:23:54.68');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000029', '2024-01-26 15:10:00', '00000008', '00000026', 202507, 1, 0, '2024-01-26 15:10:38', '2025-07-01 12:48:44.095');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000045', '2025-06-07 15:00:00', '00000057', '00000038', 202506, 1, 0, '2025-07-01 06:23:05.582', '2025-07-01 12:59:37.588');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000047', '2025-06-07 15:00:00', '00000057', '00000005', 202506, 1, 0, '2025-07-01 12:54:29.16', '2025-07-01 13:01:17.201');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000048', '2026-03-22 18:30:00', '00000022', '00000009', 202603, 3, 0, '2026-03-19 09:50:43.194', '2026-03-19 09:50:43.194');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000049', '2026-03-18 18:51:00', '00000009', '00000009', 202603, 3, 0, '2026-03-19 09:52:09.076', '2026-03-19 09:52:09.076');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000050', '2026-03-17 18:53:00', '00000006', '00000010', 202603, 3, 0, '2026-03-19 09:53:30.092', '2026-03-19 09:53:30.092');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000014', '2023-04-28 15:10:00', '00000008', '00000011', 202304, 5, 0, '2024-01-26 15:10:38', '2026-03-19 12:08:14.021');
INSERT INTO public."T_ONAIR_KANRI" ("ID", "ONAIR_DAY", "PROGRAM_ID", "TALENT_ID", "NENTSUKI", "SHU", "DELETE_FLG", "TOROKU_DAY", "KOUSHIN_DAY") VALUES ('00000031', '2024-01-29 16:08:00', '00000003', '00000001', 202401, 4, 0, '2024-01-29 16:08:14', '2026-03-19 12:10:19.033');


--
-- Data for Name: T_USER_INFO; Type: TABLE DATA; Schema: public; Owner: neondb_owner
--

INSERT INTO public."T_USER_INFO" ("ID", "NAME", "SEX", "POSTNO", "ADDRESS1", "ADDRESS2", "BIKO") VALUES (5, 'いいとも', 1, '3222323', '323', '', '');
INSERT INTO public."T_USER_INFO" ("ID", "NAME", "SEX", "POSTNO", "ADDRESS1", "ADDRESS2", "BIKO") VALUES (8, '佐藤秀臣', 1, '1233322', 'a', 'b', 'c');
INSERT INTO public."T_USER_INFO" ("ID", "NAME", "SEX", "POSTNO", "ADDRESS1", "ADDRESS2", "BIKO") VALUES (9, '井出けいすけ', 1, '3234343', 'a', 'bc', 'dfdf');
INSERT INTO public."T_USER_INFO" ("ID", "NAME", "SEX", "POSTNO", "ADDRESS1", "ADDRESS2", "BIKO") VALUES (2, 'ぱお!!!!１２３４', 1, '2131231', 'せんとらる', '都会', 'ゾウ');
INSERT INTO public."T_USER_INFO" ("ID", "NAME", "SEX", "POSTNO", "ADDRESS1", "ADDRESS2", "BIKO") VALUES (1, 'ゆうき！', 2, '3232323', 'あ１', 'い２', 'う３');
INSERT INTO public."T_USER_INFO" ("ID", "NAME", "SEX", "POSTNO", "ADDRESS1", "ADDRESS2", "BIKO") VALUES (4, 'てすと121', 1, '1234566', 'たかや12', 'なやら2323', 'にり3434');
INSERT INTO public."T_USER_INFO" ("ID", "NAME", "SEX", "POSTNO", "ADDRESS1", "ADDRESS2", "BIKO") VALUES (7, 'ヒルナンデス', 1, '1211231', '', '', '');
INSERT INTO public."T_USER_INFO" ("ID", "NAME", "SEX", "POSTNO", "ADDRESS1", "ADDRESS2", "BIKO") VALUES (12, 'Five', 1, '5601112', 'A123', 'B456', 'C789');


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: invitation invitation_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.invitation
    ADD CONSTRAINT invitation_pkey PRIMARY KEY (id);


--
-- Name: jwks jwks_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.jwks
    ADD CONSTRAINT jwks_pkey PRIMARY KEY (id);


--
-- Name: member member_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: organization organization_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: organization organization_slug_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.organization
    ADD CONSTRAINT organization_slug_key UNIQUE (slug);


--
-- Name: project_config project_config_endpoint_id_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.project_config
    ADD CONSTRAINT project_config_endpoint_id_key UNIQUE (endpoint_id);


--
-- Name: project_config project_config_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.project_config
    ADD CONSTRAINT project_config_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: session session_token_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.session
    ADD CONSTRAINT session_token_key UNIQUE (token);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: verification verification_pkey; Type: CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.verification
    ADD CONSTRAINT verification_pkey PRIMARY KEY (id);


--
-- Name: account_userId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "account_userId_idx" ON neon_auth.account USING btree ("userId");


--
-- Name: invitation_email_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX invitation_email_idx ON neon_auth.invitation USING btree (email);


--
-- Name: invitation_organizationId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "invitation_organizationId_idx" ON neon_auth.invitation USING btree ("organizationId");


--
-- Name: member_organizationId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "member_organizationId_idx" ON neon_auth.member USING btree ("organizationId");


--
-- Name: member_userId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "member_userId_idx" ON neon_auth.member USING btree ("userId");


--
-- Name: organization_slug_uidx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE UNIQUE INDEX organization_slug_uidx ON neon_auth.organization USING btree (slug);


--
-- Name: session_userId_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX "session_userId_idx" ON neon_auth.session USING btree ("userId");


--
-- Name: verification_identifier_idx; Type: INDEX; Schema: neon_auth; Owner: neon_auth
--

CREATE INDEX verification_identifier_idx ON neon_auth.verification USING btree (identifier);


--
-- Name: account account_userId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.account
    ADD CONSTRAINT "account_userId_fkey" FOREIGN KEY ("userId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: invitation invitation_inviterId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.invitation
    ADD CONSTRAINT "invitation_inviterId_fkey" FOREIGN KEY ("inviterId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: invitation invitation_organizationId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.invitation
    ADD CONSTRAINT "invitation_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES neon_auth.organization(id) ON DELETE CASCADE;


--
-- Name: member member_organizationId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.member
    ADD CONSTRAINT "member_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES neon_auth.organization(id) ON DELETE CASCADE;


--
-- Name: member member_userId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.member
    ADD CONSTRAINT "member_userId_fkey" FOREIGN KEY ("userId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: session session_userId_fkey; Type: FK CONSTRAINT; Schema: neon_auth; Owner: neon_auth
--

ALTER TABLE ONLY neon_auth.session
    ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES neon_auth."user"(id) ON DELETE CASCADE;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO neon_superuser WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: cloud_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE cloud_admin IN SCHEMA public GRANT ALL ON TABLES TO neon_superuser WITH GRANT OPTION;


--
-- PostgreSQL database dump complete
--

\unrestrict ZnCEebbwFsl2u8pAik2dT2c9MAzQ1mTey0O7YVm2Fw0Hycizk1hxjDNWhv5u3wz

