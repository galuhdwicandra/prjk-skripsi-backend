--
-- PostgreSQL database dump
--

\restrict 0HrWxNNaG3Ni4SVAHM21dIcvi0ojMseA1YtvxvGNndtno5d4aFM7c0d9VZXapVX

-- Dumped from database version 18.1 (Ubuntu 18.1-1.pgdg24.04+2)
-- Dumped by pg_dump version 18.1 (Ubuntu 18.1-1.pgdg24.04+2)

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

--
-- Name: SCHEMA "public"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA "public" IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."accounts" (
    "id" bigint NOT NULL,
    "cabang_id" bigint,
    "code" character varying(32) NOT NULL,
    "name" character varying(160) NOT NULL,
    "type" character varying(20) NOT NULL,
    "normal_balance" character varying(6) NOT NULL,
    "parent_id" bigint,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."accounts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."accounts_id_seq" OWNED BY "public"."accounts"."id";


--
-- Name: audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."audit_logs" (
    "id" bigint NOT NULL,
    "actor_type" character varying(50) NOT NULL,
    "actor_id" bigint,
    "action" character varying(120) NOT NULL,
    "model" character varying(120) NOT NULL,
    "model_id" bigint NOT NULL,
    "diff_json" json NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    "occurred_at" timestamp(0) without time zone
);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."audit_logs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."audit_logs_id_seq" OWNED BY "public"."audit_logs"."id";


--
-- Name: backups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."backups" (
    "id" bigint NOT NULL,
    "storage_path" character varying(512) NOT NULL,
    "kind" character varying(255) NOT NULL,
    "size_bytes" bigint NOT NULL,
    "created_at" timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT "backups_kind_check" CHECK ((("kind")::"text" = ANY ((ARRAY['DB'::character varying, 'FILES'::character varying])::"text"[])))
);


--
-- Name: backups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."backups_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: backups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."backups_id_seq" OWNED BY "public"."backups"."id";


--
-- Name: cabangs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cabangs" (
    "id" bigint NOT NULL,
    "nama" character varying(120) NOT NULL,
    "kota" character varying(120),
    "alamat" character varying(255),
    "telepon" character varying(30),
    "jam_operasional" character varying(120),
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: cabangs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cabangs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cabangs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cabangs_id_seq" OWNED BY "public"."cabangs"."id";


--
-- Name: cache; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cache" (
    "key" character varying(255) NOT NULL,
    "value" "text" NOT NULL,
    "expiration" integer NOT NULL
);


--
-- Name: cache_locks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cache_locks" (
    "key" character varying(255) NOT NULL,
    "owner" character varying(255) NOT NULL,
    "expiration" integer NOT NULL
);


--
-- Name: cash_holders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cash_holders" (
    "id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "name" character varying(120) NOT NULL,
    "balance" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: cash_holders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cash_holders_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cash_holders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cash_holders_id_seq" OWNED BY "public"."cash_holders"."id";


--
-- Name: cash_moves; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cash_moves" (
    "id" bigint NOT NULL,
    "from_holder_id" bigint NOT NULL,
    "to_holder_id" bigint NOT NULL,
    "amount" numeric(18,2) NOT NULL,
    "note" "text",
    "moved_at" timestamp(0) without time zone NOT NULL,
    "status" character varying(255) DEFAULT 'DRAFT'::character varying NOT NULL,
    "submitted_by" bigint,
    "approved_by" bigint,
    "approved_at" timestamp(0) without time zone,
    "rejected_at" timestamp(0) without time zone,
    "reject_reason" "text",
    "idempotency_key" character varying(64),
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    CONSTRAINT "cash_moves_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['DRAFT'::character varying, 'SUBMITTED'::character varying, 'APPROVED'::character varying, 'REJECTED'::character varying])::"text"[])))
);


--
-- Name: cash_moves_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cash_moves_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cash_moves_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cash_moves_id_seq" OWNED BY "public"."cash_moves"."id";


--
-- Name: cash_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cash_sessions" (
    "id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "cashier_id" bigint NOT NULL,
    "opening_amount" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "closing_amount" numeric(18,2),
    "status" character varying(255) DEFAULT 'OPEN'::character varying NOT NULL,
    "opened_at" timestamp(0) without time zone NOT NULL,
    "closed_at" timestamp(0) without time zone,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    CONSTRAINT "cash_sessions_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['OPEN'::character varying, 'CLOSED'::character varying])::"text"[])))
);


--
-- Name: cash_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cash_sessions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cash_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cash_sessions_id_seq" OWNED BY "public"."cash_sessions"."id";


--
-- Name: cash_transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cash_transactions" (
    "id" bigint NOT NULL,
    "session_id" bigint NOT NULL,
    "type" character varying(255) NOT NULL,
    "amount" numeric(18,2) NOT NULL,
    "source" character varying(255) NOT NULL,
    "ref_type" character varying(50),
    "ref_id" bigint,
    "note" "text",
    "occurred_at" timestamp(0) without time zone NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    CONSTRAINT "cash_transactions_source_check" CHECK ((("source")::"text" = ANY ((ARRAY['ORDER'::character varying, 'MANUAL'::character varying, 'REFUND'::character varying])::"text"[]))),
    CONSTRAINT "cash_transactions_type_check" CHECK ((("type")::"text" = ANY ((ARRAY['IN'::character varying, 'OUT'::character varying])::"text"[])))
);


--
-- Name: cash_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."cash_transactions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cash_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."cash_transactions_id_seq" OWNED BY "public"."cash_transactions"."id";


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."categories" (
    "id" bigint NOT NULL,
    "nama" character varying(120) NOT NULL,
    "slug" character varying(140) NOT NULL,
    "deskripsi" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."categories_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."categories_id_seq" OWNED BY "public"."categories"."id";


--
-- Name: customer_timelines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."customer_timelines" (
    "id" bigint NOT NULL,
    "customer_id" bigint NOT NULL,
    "event_type" character varying(40) NOT NULL,
    "title" character varying(190),
    "note" "text",
    "meta" "jsonb",
    "happened_at" timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: customer_timelines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."customer_timelines_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_timelines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."customer_timelines_id_seq" OWNED BY "public"."customer_timelines"."id";


--
-- Name: customers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."customers" (
    "id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "nama" character varying(120) NOT NULL,
    "phone" character varying(30) NOT NULL,
    "email" character varying(190),
    "alamat" character varying(255),
    "catatan" character varying(255),
    "stage" character varying(30) DEFAULT 'ACTIVE'::character varying NOT NULL,
    "last_order_at" timestamp(0) without time zone,
    "total_spent" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "total_orders" bigint DEFAULT '0'::bigint NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."customers_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."customers_id_seq" OWNED BY "public"."customers"."id";


--
-- Name: deliveries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."deliveries" (
    "id" bigint NOT NULL,
    "order_id" bigint NOT NULL,
    "assigned_to" bigint,
    "type" character varying(255) DEFAULT 'DELIVERY'::character varying NOT NULL,
    "status" character varying(255) DEFAULT 'REQUESTED'::character varying NOT NULL,
    "pickup_address" character varying(255),
    "delivery_address" character varying(255),
    "pickup_lat" numeric(10,7),
    "pickup_lng" numeric(10,7),
    "delivery_lat" numeric(10,7),
    "delivery_lng" numeric(10,7),
    "requested_at" timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "completed_at" timestamp(0) without time zone,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    "sj_number" character varying(255),
    "sj_issued_at" timestamp(0) without time zone,
    CONSTRAINT "deliveries_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['REQUESTED'::character varying, 'ASSIGNED'::character varying, 'PICKED_UP'::character varying, 'ON_ROUTE'::character varying, 'DELIVERED'::character varying, 'FAILED'::character varying, 'CANCELLED'::character varying])::"text"[]))),
    CONSTRAINT "deliveries_type_check" CHECK ((("type")::"text" = ANY ((ARRAY['PICKUP'::character varying, 'DELIVERY'::character varying, 'BOTH'::character varying])::"text"[])))
);


--
-- Name: deliveries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."deliveries_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: deliveries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."deliveries_id_seq" OWNED BY "public"."deliveries"."id";


--
-- Name: delivery_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."delivery_events" (
    "id" bigint NOT NULL,
    "delivery_id" bigint NOT NULL,
    "status" character varying(50) NOT NULL,
    "note" "text",
    "photo_url" "text",
    "occurred_at" timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: delivery_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."delivery_events_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delivery_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."delivery_events_id_seq" OWNED BY "public"."delivery_events"."id";


--
-- Name: failed_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."failed_jobs" (
    "id" bigint NOT NULL,
    "uuid" character varying(255) NOT NULL,
    "connection" "text" NOT NULL,
    "queue" "text" NOT NULL,
    "payload" "text" NOT NULL,
    "exception" "text" NOT NULL,
    "failed_at" timestamp(0) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."failed_jobs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."failed_jobs_id_seq" OWNED BY "public"."failed_jobs"."id";


--
-- Name: fee_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."fee_entries" (
    "id" bigint NOT NULL,
    "fee_id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "period_date" "date" NOT NULL,
    "ref_type" character varying(255) NOT NULL,
    "ref_id" bigint NOT NULL,
    "owner_user_id" bigint,
    "base_amount" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "fee_amount" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "pay_status" character varying(255) DEFAULT 'UNPAID'::character varying NOT NULL,
    "paid_amount" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "paid_at" timestamp(0) without time zone,
    "notes" character varying(255),
    "created_by" bigint,
    "updated_by" bigint,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    CONSTRAINT "fee_entries_pay_status_check" CHECK ((("pay_status")::"text" = ANY ((ARRAY['UNPAID'::character varying, 'PAID'::character varying, 'PARTIAL'::character varying])::"text"[]))),
    CONSTRAINT "fee_entries_ref_type_check" CHECK ((("ref_type")::"text" = ANY ((ARRAY['ORDER'::character varying, 'DELIVERY'::character varying])::"text"[])))
);


--
-- Name: fee_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."fee_entries_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fee_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."fee_entries_id_seq" OWNED BY "public"."fee_entries"."id";


--
-- Name: fees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."fees" (
    "id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "name" character varying(100) NOT NULL,
    "kind" character varying(255) NOT NULL,
    "calc_type" character varying(255) NOT NULL,
    "rate" numeric(10,2) NOT NULL,
    "base" character varying(255) NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_by" bigint,
    "updated_by" bigint,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    CONSTRAINT "fees_base_check" CHECK ((("base")::"text" = ANY ((ARRAY['GRAND_TOTAL'::character varying, 'DELIVERY'::character varying])::"text"[]))),
    CONSTRAINT "fees_calc_type_check" CHECK ((("calc_type")::"text" = ANY ((ARRAY['PERCENT'::character varying, 'FIXED'::character varying])::"text"[]))),
    CONSTRAINT "fees_kind_check" CHECK ((("kind")::"text" = ANY ((ARRAY['SALES'::character varying, 'CASHIER'::character varying, 'COURIER'::character varying])::"text"[])))
);


--
-- Name: fees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."fees_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."fees_id_seq" OWNED BY "public"."fees"."id";


--
-- Name: fiscal_periods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."fiscal_periods" (
    "id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "year" smallint NOT NULL,
    "month" smallint NOT NULL,
    "status" character varying(6) DEFAULT 'OPEN'::character varying NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: fiscal_periods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."fiscal_periods_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fiscal_periods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."fiscal_periods_id_seq" OWNED BY "public"."fiscal_periods"."id";


--
-- Name: gudangs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."gudangs" (
    "id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "nama" character varying(120) NOT NULL,
    "is_default" boolean DEFAULT false NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: gudangs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."gudangs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gudangs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."gudangs_id_seq" OWNED BY "public"."gudangs"."id";


--
-- Name: job_batches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."job_batches" (
    "id" character varying(255) NOT NULL,
    "name" character varying(255) NOT NULL,
    "total_jobs" integer NOT NULL,
    "pending_jobs" integer NOT NULL,
    "failed_jobs" integer NOT NULL,
    "failed_job_ids" "text" NOT NULL,
    "options" "text",
    "cancelled_at" integer,
    "created_at" integer NOT NULL,
    "finished_at" integer
);


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."jobs" (
    "id" bigint NOT NULL,
    "queue" character varying(255) NOT NULL,
    "payload" "text" NOT NULL,
    "attempts" smallint NOT NULL,
    "reserved_at" integer,
    "available_at" integer NOT NULL,
    "created_at" integer NOT NULL
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."jobs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."jobs_id_seq" OWNED BY "public"."jobs"."id";


--
-- Name: journal_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."journal_entries" (
    "id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "journal_date" "date" NOT NULL,
    "number" character varying(40) NOT NULL,
    "description" character varying(255),
    "status" character varying(6) DEFAULT 'DRAFT'::character varying NOT NULL,
    "period_year" smallint NOT NULL,
    "period_month" smallint NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: journal_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."journal_entries_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: journal_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."journal_entries_id_seq" OWNED BY "public"."journal_entries"."id";


--
-- Name: journal_lines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."journal_lines" (
    "id" bigint NOT NULL,
    "journal_id" bigint NOT NULL,
    "account_id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "debit" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "credit" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "ref_type" character varying(50),
    "ref_id" bigint,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: journal_lines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."journal_lines_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: journal_lines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."journal_lines_id_seq" OWNED BY "public"."journal_lines"."id";


--
-- Name: migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."migrations" (
    "id" integer NOT NULL,
    "migration" character varying(255) NOT NULL,
    "batch" integer NOT NULL
);


--
-- Name: migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."migrations_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."migrations_id_seq" OWNED BY "public"."migrations"."id";


--
-- Name: model_has_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."model_has_permissions" (
    "permission_id" bigint NOT NULL,
    "model_type" character varying(255) NOT NULL,
    "model_id" bigint NOT NULL
);


--
-- Name: model_has_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."model_has_roles" (
    "role_id" bigint NOT NULL,
    "model_type" character varying(255) NOT NULL,
    "model_id" bigint NOT NULL
);


--
-- Name: order_change_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."order_change_logs" (
    "id" bigint NOT NULL,
    "order_id" bigint NOT NULL,
    "actor_id" bigint,
    "action" character varying(50) NOT NULL,
    "diff_json" json,
    "note" "text",
    "occurred_at" timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "created_at" timestamp(0) with time zone,
    "updated_at" timestamp(0) with time zone
);


--
-- Name: order_change_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."order_change_logs_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_change_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."order_change_logs_id_seq" OWNED BY "public"."order_change_logs"."id";


--
-- Name: order_item_lot_allocations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."order_item_lot_allocations" (
    "id" bigint NOT NULL,
    "order_item_id" bigint NOT NULL,
    "stock_lot_id" bigint NOT NULL,
    "qty_allocated" integer NOT NULL,
    "unit_cost" numeric(18,2),
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: order_item_lot_allocations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."order_item_lot_allocations_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_item_lot_allocations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."order_item_lot_allocations_id_seq" OWNED BY "public"."order_item_lot_allocations"."id";


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."order_items" (
    "id" bigint NOT NULL,
    "order_id" bigint NOT NULL,
    "variant_id" bigint NOT NULL,
    "name_snapshot" character varying(200) NOT NULL,
    "price" numeric(18,2) NOT NULL,
    "discount" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "qty" numeric(18,2) NOT NULL,
    "line_total" numeric(18,2) NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."order_items_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: order_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."order_items_id_seq" OWNED BY "public"."order_items"."id";


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."orders" (
    "id" bigint NOT NULL,
    "kode" character varying(50) NOT NULL,
    "cabang_id" bigint NOT NULL,
    "gudang_id" bigint NOT NULL,
    "cashier_id" bigint NOT NULL,
    "customer_id" bigint,
    "status" character varying(255) DEFAULT 'DRAFT'::character varying NOT NULL,
    "subtotal" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "discount" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "tax" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "service_fee" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "grand_total" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "paid_total" numeric(18,2) DEFAULT '0'::numeric NOT NULL,
    "channel" character varying(255) DEFAULT 'POS'::character varying NOT NULL,
    "note" "text",
    "ordered_at" timestamp(0) without time zone NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    "paid_at" timestamp(0) with time zone,
    "customer_name" character varying(191),
    "customer_phone" character varying(30),
    "customer_address" "text",
    "cash_position" character varying(16),
    CONSTRAINT "orders_cash_position_check" CHECK ((("cash_position" IS NULL) OR (("cash_position")::"text" = ANY ((ARRAY['CUSTOMER'::character varying, 'CASHIER'::character varying, 'SALES'::character varying, 'ADMIN'::character varying])::"text"[])))),
    CONSTRAINT "orders_channel_check" CHECK ((("channel")::"text" = ANY ((ARRAY['POS'::character varying, 'ONLINE'::character varying])::"text"[]))),
    CONSTRAINT "orders_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['DRAFT'::character varying, 'UNPAID'::character varying, 'PAID'::character varying, 'VOID'::character varying, 'REFUND'::character varying])::"text"[])))
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."orders_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."orders_id_seq" OWNED BY "public"."orders"."id";


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."payments" (
    "id" bigint NOT NULL,
    "order_id" bigint NOT NULL,
    "method" character varying(255) NOT NULL,
    "amount" numeric(18,2) NOT NULL,
    "status" character varying(255) DEFAULT 'PENDING'::character varying NOT NULL,
    "ref_no" character varying(191),
    "payload_json" json,
    "paid_at" timestamp(0) without time zone,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    CONSTRAINT "payments_method_check" CHECK ((("method")::"text" = ANY ((ARRAY['CASH'::character varying, 'TRANSFER'::character varying, 'QRIS'::character varying, 'XENDIT'::character varying])::"text"[]))),
    CONSTRAINT "payments_status_check" CHECK ((("status")::"text" = ANY ((ARRAY['PENDING'::character varying, 'SUCCESS'::character varying, 'FAILED'::character varying, 'REFUND'::character varying])::"text"[])))
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."payments_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."payments_id_seq" OWNED BY "public"."payments"."id";


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."permissions" (
    "id" bigint NOT NULL,
    "name" character varying(255) NOT NULL,
    "guard_name" character varying(255) NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."permissions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."permissions_id_seq" OWNED BY "public"."permissions"."id";


--
-- Name: personal_access_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."personal_access_tokens" (
    "id" bigint NOT NULL,
    "tokenable_type" character varying(255) NOT NULL,
    "tokenable_id" bigint NOT NULL,
    "name" "text" NOT NULL,
    "token" character varying(64) NOT NULL,
    "abilities" "text",
    "last_used_at" timestamp(0) without time zone,
    "expires_at" timestamp(0) without time zone,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."personal_access_tokens_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."personal_access_tokens_id_seq" OWNED BY "public"."personal_access_tokens"."id";


--
-- Name: product_media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."product_media" (
    "id" bigint NOT NULL,
    "product_id" bigint NOT NULL,
    "disk" character varying(40) DEFAULT 'public'::character varying NOT NULL,
    "path" character varying(255) NOT NULL,
    "mime" character varying(100),
    "size_kb" integer,
    "is_primary" boolean DEFAULT false NOT NULL,
    "sort_order" smallint DEFAULT '0'::smallint NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: product_media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."product_media_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."product_media_id_seq" OWNED BY "public"."product_media"."id";


--
-- Name: product_variants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."product_variants" (
    "id" bigint NOT NULL,
    "product_id" bigint NOT NULL,
    "size" character varying(40),
    "type" character varying(60),
    "tester" character varying(40),
    "sku" character varying(80) NOT NULL,
    "harga" numeric(14,2) NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: product_variants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."product_variants_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_variants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."product_variants_id_seq" OWNED BY "public"."product_variants"."id";


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."products" (
    "id" bigint NOT NULL,
    "category_id" bigint NOT NULL,
    "nama" character varying(160) NOT NULL,
    "slug" character varying(180) NOT NULL,
    "deskripsi" "text",
    "is_active" boolean DEFAULT true NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."products_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."products_id_seq" OWNED BY "public"."products"."id";


--
-- Name: receipts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."receipts" (
    "id" bigint NOT NULL,
    "order_id" bigint NOT NULL,
    "print_format" smallint DEFAULT '58'::smallint NOT NULL,
    "html_snapshot" "text" NOT NULL,
    "wa_url" character varying(255),
    "printed_by" bigint,
    "printed_at" timestamp(0) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "reprint_of_id" bigint,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."receipts_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."receipts_id_seq" OWNED BY "public"."receipts"."id";


--
-- Name: role_has_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."role_has_permissions" (
    "permission_id" bigint NOT NULL,
    "role_id" bigint NOT NULL
);


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."roles" (
    "id" bigint NOT NULL,
    "name" character varying(255) NOT NULL,
    "guard_name" character varying(255) NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."roles_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."roles_id_seq" OWNED BY "public"."roles"."id";


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."settings" (
    "id" bigint NOT NULL,
    "scope" character varying(255) NOT NULL,
    "scope_id" bigint,
    "key" character varying(150) NOT NULL,
    "value_json" json NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    CONSTRAINT "settings_scope_check" CHECK ((("scope")::"text" = ANY ((ARRAY['GLOBAL'::character varying, 'BRANCH'::character varying, 'USER'::character varying])::"text"[])))
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."settings_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."settings_id_seq" OWNED BY "public"."settings"."id";


--
-- Name: stock_lots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."stock_lots" (
    "id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "gudang_id" bigint NOT NULL,
    "product_variant_id" bigint NOT NULL,
    "lot_no" character varying(100),
    "received_at" timestamp(0) without time zone,
    "expires_at" "date",
    "qty_received" integer NOT NULL,
    "qty_remaining" integer NOT NULL,
    "unit_cost" numeric(18,2),
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone
);


--
-- Name: stock_lots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."stock_lots_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stock_lots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."stock_lots_id_seq" OWNED BY "public"."stock_lots"."id";


--
-- Name: stock_movements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."stock_movements" (
    "id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "gudang_id" bigint NOT NULL,
    "product_variant_id" bigint NOT NULL,
    "stock_lot_id" bigint,
    "type" character varying(255) NOT NULL,
    "qty" integer NOT NULL,
    "unit_cost" numeric(18,2),
    "ref_type" character varying(100),
    "ref_id" character varying(100),
    "note" character varying(255),
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    CONSTRAINT "stock_movements_type_check" CHECK ((("type")::"text" = ANY ((ARRAY['IN'::character varying, 'OUT'::character varying, 'ADJ'::character varying])::"text"[])))
);


--
-- Name: stock_movements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."stock_movements_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stock_movements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."stock_movements_id_seq" OWNED BY "public"."stock_movements"."id";


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."users" (
    "id" bigint NOT NULL,
    "name" character varying(120) NOT NULL,
    "email" character varying(190) NOT NULL,
    "phone" character varying(30),
    "password" character varying(255) NOT NULL,
    "cabang_id" bigint,
    "role" character varying(255) NOT NULL,
    "is_active" boolean DEFAULT true NOT NULL,
    "remember_token" character varying(100),
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    "email_verified_at" timestamp(0) without time zone,
    CONSTRAINT "users_role_check" CHECK ((("role")::"text" = ANY ((ARRAY['superadmin'::character varying, 'admin_cabang'::character varying, 'gudang'::character varying, 'kasir'::character varying, 'sales'::character varying, 'kurir'::character varying])::"text"[])))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."users_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."users_id_seq" OWNED BY "public"."users"."id";


--
-- Name: v_stock_onhand_variant; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "public"."v_stock_onhand_variant" AS
 SELECT "cabang_id",
    "gudang_id",
    "product_variant_id",
    "sum"(COALESCE("qty_remaining", 0)) AS "qty_onhand"
   FROM "public"."stock_lots" "sl"
  GROUP BY "cabang_id", "gudang_id", "product_variant_id";


--
-- Name: variant_stocks; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."variant_stocks" (
    "id" bigint NOT NULL,
    "cabang_id" bigint NOT NULL,
    "gudang_id" bigint NOT NULL,
    "product_variant_id" bigint NOT NULL,
    "qty" integer DEFAULT 0 NOT NULL,
    "min_stok" integer DEFAULT 10 NOT NULL,
    "created_at" timestamp(0) without time zone,
    "updated_at" timestamp(0) without time zone,
    "safety_stock" integer,
    "lead_time_days" integer,
    "reorder_point" integer
);


--
-- Name: variant_stocks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE "public"."variant_stocks_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: variant_stocks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE "public"."variant_stocks_id_seq" OWNED BY "public"."variant_stocks"."id";


--
-- Name: accounts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."accounts" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."accounts_id_seq"'::"regclass");


--
-- Name: audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."audit_logs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."audit_logs_id_seq"'::"regclass");


--
-- Name: backups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."backups" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."backups_id_seq"'::"regclass");


--
-- Name: cabangs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cabangs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."cabangs_id_seq"'::"regclass");


--
-- Name: cash_holders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_holders" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."cash_holders_id_seq"'::"regclass");


--
-- Name: cash_moves id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_moves" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."cash_moves_id_seq"'::"regclass");


--
-- Name: cash_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_sessions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."cash_sessions_id_seq"'::"regclass");


--
-- Name: cash_transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_transactions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."cash_transactions_id_seq"'::"regclass");


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categories" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."categories_id_seq"'::"regclass");


--
-- Name: customer_timelines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."customer_timelines" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."customer_timelines_id_seq"'::"regclass");


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."customers" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."customers_id_seq"'::"regclass");


--
-- Name: deliveries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."deliveries" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."deliveries_id_seq"'::"regclass");


--
-- Name: delivery_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."delivery_events" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."delivery_events_id_seq"'::"regclass");


--
-- Name: failed_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."failed_jobs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."failed_jobs_id_seq"'::"regclass");


--
-- Name: fee_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fee_entries" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."fee_entries_id_seq"'::"regclass");


--
-- Name: fees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fees" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."fees_id_seq"'::"regclass");


--
-- Name: fiscal_periods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fiscal_periods" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."fiscal_periods_id_seq"'::"regclass");


--
-- Name: gudangs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."gudangs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."gudangs_id_seq"'::"regclass");


--
-- Name: jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."jobs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."jobs_id_seq"'::"regclass");


--
-- Name: journal_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."journal_entries" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."journal_entries_id_seq"'::"regclass");


--
-- Name: journal_lines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."journal_lines" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."journal_lines_id_seq"'::"regclass");


--
-- Name: migrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."migrations" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."migrations_id_seq"'::"regclass");


--
-- Name: order_change_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."order_change_logs" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."order_change_logs_id_seq"'::"regclass");


--
-- Name: order_item_lot_allocations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."order_item_lot_allocations" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."order_item_lot_allocations_id_seq"'::"regclass");


--
-- Name: order_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."order_items" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."order_items_id_seq"'::"regclass");


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."orders" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."orders_id_seq"'::"regclass");


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."payments" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."payments_id_seq"'::"regclass");


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."permissions" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."permissions_id_seq"'::"regclass");


--
-- Name: personal_access_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."personal_access_tokens" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."personal_access_tokens_id_seq"'::"regclass");


--
-- Name: product_media id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."product_media" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."product_media_id_seq"'::"regclass");


--
-- Name: product_variants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."product_variants" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."product_variants_id_seq"'::"regclass");


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."products" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."products_id_seq"'::"regclass");


--
-- Name: receipts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."receipts" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."receipts_id_seq"'::"regclass");


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."roles_id_seq"'::"regclass");


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."settings" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."settings_id_seq"'::"regclass");


--
-- Name: stock_lots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."stock_lots" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stock_lots_id_seq"'::"regclass");


--
-- Name: stock_movements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."stock_movements" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."stock_movements_id_seq"'::"regclass");


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."users_id_seq"'::"regclass");


--
-- Name: variant_stocks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."variant_stocks" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."variant_stocks_id_seq"'::"regclass");


--
-- Data for Name: accounts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."accounts" ("id", "cabang_id", "code", "name", "type", "normal_balance", "parent_id", "is_active", "created_at", "updated_at") FROM stdin;
1	\N	1000	ASET	ASSET	DEBIT	\N	t	2025-11-10 13:02:12	2025-12-24 00:41:00
2	\N	1100	Kas & Bank	ASSET	DEBIT	1	t	2025-11-10 13:02:12	2025-12-24 00:41:00
3	\N	1110	Kas (Cash on Hand)	ASSET	DEBIT	2	t	2025-11-10 13:02:12	2025-12-24 00:41:00
4	\N	1120	Bank	ASSET	DEBIT	2	t	2025-11-10 13:02:12	2025-12-24 00:41:00
5	\N	1200	Piutang Usaha	ASSET	DEBIT	1	t	2025-11-10 13:02:12	2025-12-24 00:41:00
6	\N	1400	Persediaan Barang	ASSET	DEBIT	1	t	2025-11-10 13:02:12	2025-12-24 00:41:00
7	\N	2000	KEWAJIBAN	LIABILITY	CREDIT	\N	t	2025-11-10 13:02:12	2025-12-24 00:41:00
8	\N	2100	Hutang Usaha	LIABILITY	CREDIT	7	t	2025-11-10 13:02:12	2025-12-24 00:41:00
9	\N	3000	EKUITAS	EQUITY	CREDIT	\N	t	2025-11-10 13:02:12	2025-12-24 00:41:00
10	\N	3100	Modal Pemilik	EQUITY	CREDIT	9	t	2025-11-10 13:02:12	2025-12-24 00:41:00
11	\N	3200	Laba Ditahan	EQUITY	CREDIT	9	t	2025-11-10 13:02:12	2025-12-24 00:41:00
12	\N	4000	PENDAPATAN	REVENUE	CREDIT	\N	t	2025-11-10 13:02:12	2025-12-24 00:41:00
13	\N	4100	Penjualan	REVENUE	CREDIT	12	t	2025-11-10 13:02:12	2025-12-24 00:41:00
14	\N	4200	Diskon Penjualan (-)	REVENUE	CREDIT	12	t	2025-11-10 13:02:12	2025-12-24 00:41:00
15	\N	5000	HARGA POKOK PENJUALAN	EXPENSE	DEBIT	\N	t	2025-11-10 13:02:12	2025-12-24 00:41:00
16	\N	5100	HPP	EXPENSE	DEBIT	15	t	2025-11-10 13:02:12	2025-12-24 00:41:00
17	\N	6000	BEBAN OPERASIONAL	EXPENSE	DEBIT	\N	t	2025-11-10 13:02:12	2025-12-24 00:41:00
18	\N	6100	Beban Listrik & Air	EXPENSE	DEBIT	17	t	2025-11-10 13:02:12	2025-12-24 00:41:00
19	\N	6200	Beban Sewa	EXPENSE	DEBIT	17	t	2025-11-10 13:02:12	2025-12-24 00:41:00
20	\N	6300	Beban Gaji	EXPENSE	DEBIT	17	t	2025-11-10 13:02:12	2025-12-24 00:41:00
\.


--
-- Data for Name: audit_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."audit_logs" ("id", "actor_type", "actor_id", "action", "model", "model_id", "diff_json", "created_at", "updated_at", "occurred_at") FROM stdin;
1	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 13:06:10	2025-11-10 13:06:10	\N
2	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-11-10 13:06:10	2025-11-10 13:06:10	\N
3	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-11-10 13:06:10	2025-11-10 13:06:10	\N
4	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-11-10 13:06:10	2025-11-10 13:06:10	\N
5	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 13:06:10	2025-11-10 13:06:10	\N
6	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-11-10 13:06:11	2025-11-10 13:06:11	\N
7	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-11-10 13:06:11	2025-11-10 13:06:11	\N
8	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-11-10 13:06:11	2025-11-10 13:06:11	\N
9	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-11-10 13:06:11	2025-11-10 13:06:11	\N
10	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-11-10 13:06:11	2025-11-10 13:06:11	\N
11	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 14:18:41	2025-11-10 14:18:41	\N
12	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 14:18:41	2025-11-10 14:18:41	\N
13	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 14:18:42	2025-11-10 14:18:42	\N
14	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 14:18:42	2025-11-10 14:18:42	\N
15	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 14:18:42	2025-11-10 14:18:42	\N
16	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 14:18:42	2025-11-10 14:18:42	\N
17	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 14:18:42	2025-11-10 14:18:42	\N
18	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 14:18:42	2025-11-10 14:18:42	\N
19	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 14:18:42	2025-11-10 14:18:42	\N
20	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 14:18:42	2025-11-10 14:18:42	\N
21	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 14:19:09	2025-11-10 14:19:09	\N
22	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 14:19:09	2025-11-10 14:19:09	\N
23	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 14:19:09	2025-11-10 14:19:09	\N
24	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 14:19:09	2025-11-10 14:19:09	\N
25	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 14:19:09	2025-11-10 14:19:09	\N
26	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 14:19:09	2025-11-10 14:19:09	\N
27	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 14:19:09	2025-11-10 14:19:09	\N
28	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 14:19:09	2025-11-10 14:19:09	\N
29	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 14:19:09	2025-11-10 14:19:09	\N
30	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 14:19:09	2025-11-10 14:19:09	\N
31	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 14:22:50	2025-11-10 14:22:50	\N
32	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 14:22:50	2025-11-10 14:22:50	\N
33	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 14:22:51	2025-11-10 14:22:51	\N
34	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 14:22:51	2025-11-10 14:22:51	\N
35	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 14:22:51	2025-11-10 14:22:51	\N
36	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 14:22:51	2025-11-10 14:22:51	\N
37	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 14:22:51	2025-11-10 14:22:51	\N
38	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 14:22:51	2025-11-10 14:22:51	\N
39	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 14:22:51	2025-11-10 14:22:51	\N
40	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 14:22:51	2025-11-10 14:22:51	\N
41	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 14:24:02	2025-11-10 14:24:02	\N
42	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 14:24:02	2025-11-10 14:24:02	\N
43	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 14:24:02	2025-11-10 14:24:02	\N
44	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 14:24:02	2025-11-10 14:24:02	\N
45	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 14:24:02	2025-11-10 14:24:02	\N
46	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 14:24:02	2025-11-10 14:24:02	\N
47	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 14:24:03	2025-11-10 14:24:03	\N
48	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 14:24:03	2025-11-10 14:24:03	\N
49	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 14:24:03	2025-11-10 14:24:03	\N
50	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 14:24:03	2025-11-10 14:24:03	\N
51	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 14:33:27	2025-11-10 14:33:27	\N
52	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 14:33:27	2025-11-10 14:33:27	\N
53	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 14:33:27	2025-11-10 14:33:27	\N
54	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 14:33:27	2025-11-10 14:33:27	\N
55	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 14:33:27	2025-11-10 14:33:27	\N
56	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 14:33:27	2025-11-10 14:33:27	\N
57	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 14:33:27	2025-11-10 14:33:27	\N
58	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 14:33:27	2025-11-10 14:33:27	\N
59	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 14:33:27	2025-11-10 14:33:27	\N
60	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 14:33:27	2025-11-10 14:33:27	\N
61	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 15:20:31	2025-11-10 15:20:31	\N
62	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 15:20:31	2025-11-10 15:20:31	\N
63	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 15:20:31	2025-11-10 15:20:31	\N
64	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-03T00:00:00.000000Z","to":"2025-11-10T23:59:59.999999Z"}	2025-11-10 15:20:31	2025-11-10 15:20:31	\N
65	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 15:20:31	2025-11-10 15:20:31	\N
66	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-10 15:20:31	2025-11-10 15:20:31	\N
67	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 15:20:31	2025-11-10 15:20:31	\N
68	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-10 15:20:31	2025-11-10 15:20:31	\N
69	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-10 15:20:32	2025-11-10 15:20:32	\N
70	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-10 15:20:32	2025-11-10 15:20:32	\N
71	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-11-13T00:00:00.000000Z","to":"2025-11-20T23:59:59.999999Z"}	2025-11-20 16:05:08	2025-11-20 16:05:08	\N
72	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-11-20 16:05:08	2025-11-20 16:05:08	\N
73	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-11-20 16:05:08	2025-11-20 16:05:08	\N
74	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-11-20 16:05:09	2025-11-20 16:05:09	\N
75	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-11-20 16:05:09	2025-11-20 16:05:09	\N
76	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-11-13T00:00:00.000000Z","to":"2025-11-20T23:59:59.999999Z"}	2025-11-20 16:05:09	2025-11-20 16:05:09	\N
77	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-11-20 16:05:09	2025-11-20 16:05:09	\N
78	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-11-20 16:05:09	2025-11-20 16:05:09	\N
79	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-11-20 16:05:09	2025-11-20 16:05:09	\N
80	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-11-20 16:05:09	2025-11-20 16:05:09	\N
81	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-13T00:00:00.000000Z","to":"2025-11-20T23:59:59.999999Z"}	2025-11-20 16:10:28	2025-11-20 16:10:28	\N
82	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-20 16:10:28	2025-11-20 16:10:28	\N
83	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-20 16:10:28	2025-11-20 16:10:28	\N
84	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-20 16:10:28	2025-11-20 16:10:28	\N
85	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-20 16:10:28	2025-11-20 16:10:28	\N
86	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-13T00:00:00.000000Z","to":"2025-11-20T23:59:59.999999Z"}	2025-11-20 16:10:28	2025-11-20 16:10:28	\N
87	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-20 16:10:28	2025-11-20 16:10:28	\N
88	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-20 16:10:28	2025-11-20 16:10:28	\N
89	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-20 16:10:28	2025-11-20 16:10:28	\N
90	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-20 16:10:29	2025-11-20 16:10:29	\N
91	USER	2	ORDER_WA_RESEND	Order	8	{"phone":"628586554548788","message":"Terima kasih telah berbelanja.\\nKode: PRM-1763629970-C1\\nTotal: Rp 1.100.000\\nTanggal: 2025-11-20 16:12:50"}	2025-11-20 16:14:08	2025-11-20 16:14:08	\N
92	USER	2	JOURNAL_POSTED	JournalEntry	2	{"number":"PAY-PRM-1763629970-C1-7","posted_at":"2025-11-20 16:20:17"}	2025-11-20 16:20:17	2025-11-20 16:20:17	2025-11-20 16:20:17
93	USER	2	JOURNAL_POSTED	JournalEntry	1	{"number":"PAY-PRM-1762759501-C1-1","posted_at":"2025-11-20 16:20:21"}	2025-11-20 16:20:21	2025-11-20 16:20:21	2025-11-20 16:20:21
94	USER	2	UPSERT	Setting	6	{"before":null,"after":{"darkMode":true}}	2025-11-20 16:24:29	2025-11-20 16:24:29	2025-11-20 16:24:29
95	USER	2	UPSERT	Setting	6	{"before":{"darkMode":true},"after":{"compactTables":true}}	2025-11-20 16:24:29	2025-11-20 16:24:29	2025-11-20 16:24:29
96	USER	2	UPSERT	Setting	6	{"before":{"compactTables":true},"after":{"darkMode":false}}	2025-11-20 16:24:30	2025-11-20 16:24:30	2025-11-20 16:24:30
97	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-13T00:00:00.000000Z","to":"2025-11-20T23:59:59.999999Z"}	2025-11-20 16:27:22	2025-11-20 16:27:22	\N
98	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-20 16:27:22	2025-11-20 16:27:22	\N
99	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-20 16:27:23	2025-11-20 16:27:23	\N
100	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-20 16:27:23	2025-11-20 16:27:23	\N
101	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-20 16:27:23	2025-11-20 16:27:23	\N
153	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-12-24 00:29:14	2025-12-24 00:29:14	\N
102	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-13T00:00:00.000000Z","to":"2025-11-20T23:59:59.999999Z"}	2025-11-20 16:27:23	2025-11-20 16:27:23	\N
103	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-20 16:27:23	2025-11-20 16:27:23	\N
104	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-20 16:27:23	2025-11-20 16:27:23	\N
105	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-20 16:27:23	2025-11-20 16:27:23	\N
106	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-20 16:27:23	2025-11-20 16:27:23	\N
107	USER	2	ORDER_RECEIPT_REPRINTED	Order	8	{"format":"58","printed_at":"2025-11-20 16:29:56"}	2025-11-20 16:29:56	2025-11-20 16:29:56	\N
108	USER	2	ORDER_RECEIPT_REPRINTED	Order	8	{"format":"80","printed_at":"2025-11-20 16:29:58"}	2025-11-20 16:29:58	2025-11-20 16:29:58	\N
109	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-13T00:00:00.000000Z","to":"2025-11-20T23:59:59.999999Z"}	2025-11-20 16:30:42	2025-11-20 16:30:42	\N
110	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-20 16:30:42	2025-11-20 16:30:42	\N
111	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-20 16:30:42	2025-11-20 16:30:42	\N
112	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-20 16:30:42	2025-11-20 16:30:42	\N
113	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-20 16:30:42	2025-11-20 16:30:42	\N
114	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-11-13T00:00:00.000000Z","to":"2025-11-20T23:59:59.999999Z"}	2025-11-20 16:30:42	2025-11-20 16:30:42	\N
115	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-11-20 16:30:43	2025-11-20 16:30:43	\N
116	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-11-20 16:30:43	2025-11-20 16:30:43	\N
117	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-11-20 16:30:43	2025-11-20 16:30:43	\N
118	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-11-20 16:30:43	2025-11-20 16:30:43	\N
119	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:26:29	2025-12-24 00:26:29	\N
120	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-12-24 00:26:29	2025-12-24 00:26:29	\N
121	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-12-24 00:26:29	2025-12-24 00:26:29	\N
122	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-12-24 00:26:29	2025-12-24 00:26:29	\N
123	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-12-24 00:26:29	2025-12-24 00:26:29	\N
124	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:26:29	2025-12-24 00:26:29	\N
125	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-12-24 00:26:29	2025-12-24 00:26:29	\N
126	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-12-24 00:26:29	2025-12-24 00:26:29	\N
127	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-12-24 00:26:29	2025-12-24 00:26:29	\N
128	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-12-24 00:26:29	2025-12-24 00:26:29	\N
129	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:27:22	2025-12-24 00:27:22	\N
130	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-12-24 00:27:22	2025-12-24 00:27:22	\N
131	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-12-24 00:27:22	2025-12-24 00:27:22	\N
132	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-12-24 00:27:23	2025-12-24 00:27:23	\N
133	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-12-24 00:27:23	2025-12-24 00:27:23	\N
134	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:27:23	2025-12-24 00:27:23	\N
135	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-12-24 00:27:23	2025-12-24 00:27:23	\N
136	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-12-24 00:27:23	2025-12-24 00:27:23	\N
137	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-12-24 00:27:23	2025-12-24 00:27:23	\N
138	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-12-24 00:27:23	2025-12-24 00:27:23	\N
139	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:27:44	2025-12-24 00:27:44	\N
140	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 00:27:45	2025-12-24 00:27:45	\N
141	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 00:27:45	2025-12-24 00:27:45	\N
142	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 00:27:45	2025-12-24 00:27:45	\N
143	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 00:27:45	2025-12-24 00:27:45	\N
144	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:27:45	2025-12-24 00:27:45	\N
145	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 00:27:45	2025-12-24 00:27:45	\N
146	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 00:27:45	2025-12-24 00:27:45	\N
147	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 00:27:45	2025-12-24 00:27:45	\N
148	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 00:27:45	2025-12-24 00:27:45	\N
149	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:29:14	2025-12-24 00:29:14	\N
150	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-12-24 00:29:14	2025-12-24 00:29:14	\N
151	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-12-24 00:29:14	2025-12-24 00:29:14	\N
152	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-12-24 00:29:14	2025-12-24 00:29:14	\N
154	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:29:14	2025-12-24 00:29:14	\N
155	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-12-24 00:29:14	2025-12-24 00:29:14	\N
156	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-12-24 00:29:14	2025-12-24 00:29:14	\N
157	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-12-24 00:29:14	2025-12-24 00:29:14	\N
158	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-12-24 00:29:14	2025-12-24 00:29:14	\N
159	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:44:29	2025-12-24 00:44:29	\N
160	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 00:44:29	2025-12-24 00:44:29	\N
161	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 00:44:29	2025-12-24 00:44:29	\N
162	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 00:44:29	2025-12-24 00:44:29	\N
163	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 00:44:29	2025-12-24 00:44:29	\N
164	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:44:29	2025-12-24 00:44:29	\N
165	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 00:44:29	2025-12-24 00:44:29	\N
166	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 00:44:29	2025-12-24 00:44:29	\N
167	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 00:44:29	2025-12-24 00:44:29	\N
168	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 00:44:29	2025-12-24 00:44:29	\N
169	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:44:57	2025-12-24 00:44:57	\N
170	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 00:44:57	2025-12-24 00:44:57	\N
171	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 00:44:57	2025-12-24 00:44:57	\N
172	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 00:44:57	2025-12-24 00:44:57	\N
173	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 00:44:57	2025-12-24 00:44:57	\N
174	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:44:57	2025-12-24 00:44:57	\N
175	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 00:44:57	2025-12-24 00:44:57	\N
176	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 00:44:57	2025-12-24 00:44:57	\N
177	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 00:44:58	2025-12-24 00:44:58	\N
178	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 00:44:58	2025-12-24 00:44:58	\N
179	USER	3	CASH_MIRROR	payments	8	{"holder_id":2,"amount":1050000,"note":"ORDER#PRM-1763629970-C1","before":"0.00","after":"1050000.00"}	2025-12-24 00:46:12	2025-12-24 00:46:12	\N
180	USER	3	CASH_MIRROR	payments	9	{"holder_id":2,"amount":250000,"note":"ORDER#PRM-1762763802-C1","before":"1050000.00","after":"1300000.00"}	2025-12-24 00:46:25	2025-12-24 00:46:25	\N
181	USER	3	CASH_MIRROR	payments	10	{"holder_id":2,"amount":250000,"note":"ORDER#PRM-1762762854-C1","before":"1300000.00","after":"1550000.00"}	2025-12-24 00:46:36	2025-12-24 00:46:36	\N
182	USER	3	SUBMIT	cash_moves	1	{"after":{"from_holder_id":2,"to_holder_id":3,"amount":"1550000.00","note":null,"moved_at":"2025-12-23T17:00:00.000000Z","status":"SUBMITTED","submitted_by":3,"idempotency_key":"l37lpzwz5fn.mjivngf1","updated_at":"2025-12-23T17:47:15.000000Z","created_at":"2025-12-23T17:47:15.000000Z","id":1}}	2025-12-24 00:47:15	2025-12-24 00:47:15	\N
183	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:47:31	2025-12-24 00:47:31	\N
184	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 00:47:31	2025-12-24 00:47:31	\N
185	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 00:47:31	2025-12-24 00:47:31	\N
186	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 00:47:31	2025-12-24 00:47:31	\N
187	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 00:47:31	2025-12-24 00:47:31	\N
188	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:47:31	2025-12-24 00:47:31	\N
189	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 00:47:31	2025-12-24 00:47:31	\N
190	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 00:47:31	2025-12-24 00:47:31	\N
191	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 00:47:31	2025-12-24 00:47:31	\N
192	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 00:47:32	2025-12-24 00:47:32	\N
193	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:48:12	2025-12-24 00:48:12	\N
194	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-12-24 00:48:12	2025-12-24 00:48:12	\N
195	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-12-24 00:48:12	2025-12-24 00:48:12	\N
196	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-12-24 00:48:12	2025-12-24 00:48:12	\N
197	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-12-24 00:48:12	2025-12-24 00:48:12	\N
198	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:48:12	2025-12-24 00:48:12	\N
199	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-12-24 00:48:12	2025-12-24 00:48:12	\N
200	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-12-24 00:48:12	2025-12-24 00:48:12	\N
201	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-12-24 00:48:12	2025-12-24 00:48:12	\N
202	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-12-24 00:48:12	2025-12-24 00:48:12	\N
203	USER	1	SUBMIT	cash_moves	2	{"after":{"from_holder_id":2,"to_holder_id":3,"amount":"1550000.00","note":null,"moved_at":"2025-12-23T17:00:00.000000Z","status":"SUBMITTED","submitted_by":1,"idempotency_key":"8mscmkcxsqt.mjivoxt4","updated_at":"2025-12-23T17:48:28.000000Z","created_at":"2025-12-23T17:48:28.000000Z","id":2}}	2025-12-24 00:48:28	2025-12-24 00:48:28	\N
204	USER	1	REJECT	cash_moves	1	{"after":{"status":"REJECTED","reject_reason":"double"}}	2025-12-24 00:48:56	2025-12-24 00:48:56	\N
205	USER	1	APPROVE	cash_moves	2	{"before":{"from.balance":"1550000.00","to.balance":"0.00","status":"SUBMITTED"},"after":{"from.balance":"0","to.balance":"1550000","status":"APPROVED"}}	2025-12-24 00:48:58	2025-12-24 00:48:58	\N
206	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:49:18	2025-12-24 00:49:18	\N
207	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 00:49:18	2025-12-24 00:49:18	\N
208	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 00:49:18	2025-12-24 00:49:18	\N
209	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 00:49:18	2025-12-24 00:49:18	\N
210	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 00:49:18	2025-12-24 00:49:18	\N
211	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 00:49:18	2025-12-24 00:49:18	\N
212	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 00:49:18	2025-12-24 00:49:18	\N
213	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 00:49:18	2025-12-24 00:49:18	\N
214	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 00:49:18	2025-12-24 00:49:18	\N
215	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 00:49:18	2025-12-24 00:49:18	\N
216	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 02:57:24	2025-12-24 02:57:24	\N
217	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 02:57:24	2025-12-24 02:57:24	\N
218	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 02:57:24	2025-12-24 02:57:24	\N
219	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 02:57:24	2025-12-24 02:57:24	\N
220	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 02:57:24	2025-12-24 02:57:24	\N
221	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 02:57:24	2025-12-24 02:57:24	\N
222	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 02:57:24	2025-12-24 02:57:24	\N
223	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 02:57:24	2025-12-24 02:57:24	\N
224	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 02:57:25	2025-12-24 02:57:25	\N
225	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 02:57:25	2025-12-24 02:57:25	\N
226	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 02:58:03	2025-12-24 02:58:03	\N
227	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 02:58:03	2025-12-24 02:58:03	\N
228	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 02:58:03	2025-12-24 02:58:03	\N
229	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 02:58:03	2025-12-24 02:58:03	\N
230	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 02:58:03	2025-12-24 02:58:03	\N
231	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 02:58:03	2025-12-24 02:58:03	\N
232	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 02:58:03	2025-12-24 02:58:03	\N
233	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 02:58:03	2025-12-24 02:58:03	\N
234	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 02:58:03	2025-12-24 02:58:03	\N
235	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 02:58:03	2025-12-24 02:58:03	\N
236	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 03:00:49	2025-12-24 03:00:49	\N
237	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 03:00:49	2025-12-24 03:00:49	\N
238	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 03:00:49	2025-12-24 03:00:49	\N
239	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 03:00:49	2025-12-24 03:00:49	\N
240	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 03:00:49	2025-12-24 03:00:49	\N
241	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 03:00:49	2025-12-24 03:00:49	\N
242	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 03:00:49	2025-12-24 03:00:49	\N
243	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 03:00:49	2025-12-24 03:00:49	\N
244	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 03:00:49	2025-12-24 03:00:49	\N
245	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 03:00:49	2025-12-24 03:00:49	\N
246	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 03:05:50	2025-12-24 03:05:50	\N
247	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 03:05:50	2025-12-24 03:05:50	\N
248	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 03:05:50	2025-12-24 03:05:50	\N
249	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 03:05:50	2025-12-24 03:05:50	\N
250	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 03:05:50	2025-12-24 03:05:50	\N
251	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 03:05:50	2025-12-24 03:05:50	\N
252	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 03:05:51	2025-12-24 03:05:51	\N
253	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 03:05:51	2025-12-24 03:05:51	\N
254	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 03:05:51	2025-12-24 03:05:51	\N
255	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 03:05:51	2025-12-24 03:05:51	\N
256	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 03:23:19	2025-12-24 03:23:19	\N
257	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-12-24 03:23:19	2025-12-24 03:23:19	\N
258	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 03:23:19	2025-12-24 03:23:19	\N
259	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-12-24 03:23:19	2025-12-24 03:23:19	\N
260	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2025-12-24 03:23:19	2025-12-24 03:23:19	\N
261	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2025-12-24 03:23:19	2025-12-24 03:23:19	\N
262	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-12-24 03:23:19	2025-12-24 03:23:19	\N
263	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2025-12-24 03:23:19	2025-12-24 03:23:19	\N
264	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-12-24 03:23:20	2025-12-24 03:23:20	\N
265	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2025-12-24 03:23:20	2025-12-24 03:23:20	\N
266	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 03:23:42	2025-12-24 03:23:42	\N
267	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 03:23:42	2025-12-24 03:23:42	\N
268	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 03:23:42	2025-12-24 03:23:42	\N
269	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 03:23:43	2025-12-24 03:23:43	\N
270	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 03:23:43	2025-12-24 03:23:43	\N
271	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 03:23:43	2025-12-24 03:23:43	\N
272	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 03:23:43	2025-12-24 03:23:43	\N
273	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 03:23:43	2025-12-24 03:23:43	\N
274	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 03:23:43	2025-12-24 03:23:43	\N
275	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 03:23:43	2025-12-24 03:23:43	\N
276	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 04:27:48	2025-12-24 04:27:48	\N
277	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 04:27:49	2025-12-24 04:27:49	\N
278	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 04:27:49	2025-12-24 04:27:49	\N
279	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 04:27:49	2025-12-24 04:27:49	\N
280	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 04:27:49	2025-12-24 04:27:49	\N
281	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 04:27:49	2025-12-24 04:27:49	\N
282	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 04:27:49	2025-12-24 04:27:49	\N
283	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 04:27:49	2025-12-24 04:27:49	\N
284	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 04:27:49	2025-12-24 04:27:49	\N
285	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 04:27:49	2025-12-24 04:27:49	\N
286	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 04:31:58	2025-12-24 04:31:58	\N
287	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 04:31:58	2025-12-24 04:31:58	\N
288	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 04:31:58	2025-12-24 04:31:58	\N
289	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 04:31:58	2025-12-24 04:31:58	\N
290	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 04:31:58	2025-12-24 04:31:58	\N
291	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 04:31:58	2025-12-24 04:31:58	\N
292	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 04:31:58	2025-12-24 04:31:58	\N
293	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 04:31:58	2025-12-24 04:31:58	\N
294	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 04:31:58	2025-12-24 04:31:58	\N
295	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 04:31:59	2025-12-24 04:31:59	\N
296	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 04:33:16	2025-12-24 04:33:16	\N
297	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 04:33:16	2025-12-24 04:33:16	\N
298	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 04:33:16	2025-12-24 04:33:16	\N
299	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 04:33:16	2025-12-24 04:33:16	\N
300	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 04:33:16	2025-12-24 04:33:16	\N
301	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 04:33:16	2025-12-24 04:33:16	\N
302	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 04:33:16	2025-12-24 04:33:16	\N
303	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 04:33:16	2025-12-24 04:33:16	\N
304	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 04:33:16	2025-12-24 04:33:16	\N
305	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 04:33:17	2025-12-24 04:33:17	\N
306	USER	3	CASH_MIRROR	payments	13	{"holder_id":2,"amount":100000,"note":"ORDER#PRM-1766525547-C1","before":"0.00","after":"100000.00"}	2025-12-24 04:33:28	2025-12-24 04:33:28	\N
307	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 04:33:40	2025-12-24 04:33:40	\N
308	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 04:33:40	2025-12-24 04:33:40	\N
309	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 04:33:40	2025-12-24 04:33:40	\N
310	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 04:33:40	2025-12-24 04:33:40	\N
311	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 04:33:40	2025-12-24 04:33:40	\N
312	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2025-12-17T00:00:00.000000Z","to":"2025-12-24T23:59:59.999999Z"}	2025-12-24 04:33:40	2025-12-24 04:33:40	\N
313	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2025-12-24 04:33:40	2025-12-24 04:33:40	\N
314	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2025-12-24 04:33:40	2025-12-24 04:33:40	\N
315	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2025-12-24 04:33:40	2025-12-24 04:33:40	\N
316	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2025-12-24 04:33:40	2025-12-24 04:33:40	\N
317	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 21:50:27	2026-01-12 21:50:27	\N
318	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-12 21:50:27	2026-01-12 21:50:27	\N
319	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-12 21:50:27	2026-01-12 21:50:27	\N
320	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 21:50:27	2026-01-12 21:50:27	\N
321	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-12 21:50:27	2026-01-12 21:50:27	\N
322	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-12 21:50:27	2026-01-12 21:50:27	\N
323	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-12 21:50:27	2026-01-12 21:50:27	\N
324	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-12 21:50:27	2026-01-12 21:50:27	\N
325	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-12 21:50:27	2026-01-12 21:50:27	\N
326	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-12 21:50:27	2026-01-12 21:50:27	\N
327	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 21:50:51	2026-01-12 21:50:51	\N
328	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 21:50:51	2026-01-12 21:50:51	\N
329	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 21:50:51	2026-01-12 21:50:51	\N
330	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 21:50:51	2026-01-12 21:50:51	\N
331	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 21:50:51	2026-01-12 21:50:51	\N
332	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 21:50:51	2026-01-12 21:50:51	\N
333	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 21:50:51	2026-01-12 21:50:51	\N
334	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 21:50:51	2026-01-12 21:50:51	\N
335	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 21:50:51	2026-01-12 21:50:51	\N
336	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 21:50:51	2026-01-12 21:50:51	\N
337	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 22:22:26	2026-01-12 22:22:26	\N
338	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 22:22:26	2026-01-12 22:22:26	\N
339	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 22:22:26	2026-01-12 22:22:26	\N
340	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 22:22:26	2026-01-12 22:22:26	\N
341	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 22:22:26	2026-01-12 22:22:26	\N
342	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 22:22:26	2026-01-12 22:22:26	\N
343	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 22:22:26	2026-01-12 22:22:26	\N
344	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 22:22:26	2026-01-12 22:22:26	\N
345	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 22:22:26	2026-01-12 22:22:26	\N
346	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 22:22:26	2026-01-12 22:22:26	\N
347	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 22:22:42	2026-01-12 22:22:42	\N
348	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 22:22:42	2026-01-12 22:22:42	\N
349	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 22:22:43	2026-01-12 22:22:43	\N
350	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 22:22:43	2026-01-12 22:22:43	\N
351	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 22:22:43	2026-01-12 22:22:43	\N
352	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 22:22:43	2026-01-12 22:22:43	\N
353	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 22:22:43	2026-01-12 22:22:43	\N
354	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 22:22:43	2026-01-12 22:22:43	\N
355	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 22:22:43	2026-01-12 22:22:43	\N
356	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 22:22:43	2026-01-12 22:22:43	\N
357	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 22:23:05	2026-01-12 22:23:05	\N
358	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 22:23:05	2026-01-12 22:23:05	\N
359	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 22:23:05	2026-01-12 22:23:05	\N
360	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 22:23:05	2026-01-12 22:23:05	\N
361	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 22:23:05	2026-01-12 22:23:05	\N
362	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 22:23:06	2026-01-12 22:23:06	\N
363	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 22:23:06	2026-01-12 22:23:06	\N
364	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 22:23:06	2026-01-12 22:23:06	\N
365	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 22:23:06	2026-01-12 22:23:06	\N
366	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 22:23:06	2026-01-12 22:23:06	\N
367	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 22:41:37	2026-01-12 22:41:37	\N
368	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 22:41:37	2026-01-12 22:41:37	\N
369	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 22:41:37	2026-01-12 22:41:37	\N
370	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 22:41:37	2026-01-12 22:41:37	\N
371	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 22:41:38	2026-01-12 22:41:38	\N
372	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 22:41:38	2026-01-12 22:41:38	\N
373	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 22:41:38	2026-01-12 22:41:38	\N
374	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 22:41:38	2026-01-12 22:41:38	\N
375	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 22:41:38	2026-01-12 22:41:38	\N
376	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 22:41:38	2026-01-12 22:41:38	\N
377	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 23:09:32	2026-01-12 23:09:32	\N
378	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 23:09:32	2026-01-12 23:09:32	\N
379	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 23:09:32	2026-01-12 23:09:32	\N
380	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 23:09:32	2026-01-12 23:09:32	\N
381	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 23:09:32	2026-01-12 23:09:32	\N
382	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-05T00:00:00.000000Z","to":"2026-01-12T23:59:59.999999Z"}	2026-01-12 23:09:32	2026-01-12 23:09:32	\N
383	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-12 23:09:32	2026-01-12 23:09:32	\N
384	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-12 23:09:32	2026-01-12 23:09:32	\N
385	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-12 23:09:32	2026-01-12 23:09:32	\N
386	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-12 23:09:32	2026-01-12 23:09:32	\N
387	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:20:09	2026-01-14 23:20:09	\N
388	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-14 23:20:10	2026-01-14 23:20:10	\N
389	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:20:10	2026-01-14 23:20:10	\N
390	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-14 23:20:10	2026-01-14 23:20:10	\N
391	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-14 23:20:10	2026-01-14 23:20:10	\N
392	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-14 23:20:10	2026-01-14 23:20:10	\N
393	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-14 23:20:10	2026-01-14 23:20:10	\N
394	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-14 23:20:10	2026-01-14 23:20:10	\N
395	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-14 23:20:10	2026-01-14 23:20:10	\N
396	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-14 23:20:10	2026-01-14 23:20:10	\N
397	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:24:21	2026-01-14 23:24:21	\N
398	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:24:21	2026-01-14 23:24:21	\N
399	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:24:22	2026-01-14 23:24:22	\N
400	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:24:22	2026-01-14 23:24:22	\N
401	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:24:22	2026-01-14 23:24:22	\N
402	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:24:22	2026-01-14 23:24:22	\N
403	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:24:22	2026-01-14 23:24:22	\N
404	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:24:22	2026-01-14 23:24:22	\N
405	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:24:22	2026-01-14 23:24:22	\N
406	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:24:22	2026-01-14 23:24:22	\N
407	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:24:36	2026-01-14 23:24:36	\N
408	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:24:37	2026-01-14 23:24:37	\N
409	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:24:37	2026-01-14 23:24:37	\N
410	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:24:37	2026-01-14 23:24:37	\N
411	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:24:37	2026-01-14 23:24:37	\N
412	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:24:37	2026-01-14 23:24:37	\N
413	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:24:37	2026-01-14 23:24:37	\N
414	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:24:37	2026-01-14 23:24:37	\N
415	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:24:37	2026-01-14 23:24:37	\N
416	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:24:37	2026-01-14 23:24:37	\N
417	USER	2	CASH_MIRROR	payments	16	{"holder_id":1,"amount":250000,"note":"ORDER#PRM-1768407932-C1","before":"0.00","after":"250000.00"}	2026-01-14 23:26:31	2026-01-14 23:26:31	\N
418	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:28:20	2026-01-14 23:28:20	\N
419	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:28:20	2026-01-14 23:28:20	\N
420	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:28:20	2026-01-14 23:28:20	\N
421	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:28:20	2026-01-14 23:28:20	\N
422	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:28:20	2026-01-14 23:28:20	\N
423	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:28:20	2026-01-14 23:28:20	\N
424	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:28:20	2026-01-14 23:28:20	\N
425	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:28:20	2026-01-14 23:28:20	\N
426	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:28:20	2026-01-14 23:28:20	\N
427	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:28:20	2026-01-14 23:28:20	\N
428	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:28:46	2026-01-14 23:28:46	\N
429	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:28:46	2026-01-14 23:28:46	\N
430	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:28:46	2026-01-14 23:28:46	\N
431	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:28:46	2026-01-14 23:28:46	\N
432	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:28:46	2026-01-14 23:28:46	\N
433	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:28:46	2026-01-14 23:28:46	\N
434	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:28:46	2026-01-14 23:28:46	\N
435	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:28:47	2026-01-14 23:28:47	\N
436	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:28:47	2026-01-14 23:28:47	\N
437	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:28:47	2026-01-14 23:28:47	\N
438	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:29:30	2026-01-14 23:29:30	\N
439	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:29:30	2026-01-14 23:29:30	\N
440	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:29:30	2026-01-14 23:29:30	\N
441	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:29:30	2026-01-14 23:29:30	\N
442	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:29:30	2026-01-14 23:29:30	\N
443	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:29:30	2026-01-14 23:29:30	\N
444	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:29:30	2026-01-14 23:29:30	\N
445	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:29:30	2026-01-14 23:29:30	\N
446	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:29:30	2026-01-14 23:29:30	\N
447	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:29:30	2026-01-14 23:29:30	\N
448	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:35:45	2026-01-14 23:35:45	\N
449	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:35:45	2026-01-14 23:35:45	\N
450	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:35:45	2026-01-14 23:35:45	\N
451	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:35:45	2026-01-14 23:35:45	\N
452	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:35:45	2026-01-14 23:35:45	\N
453	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-07T00:00:00.000000Z","to":"2026-01-14T23:59:59.999999Z"}	2026-01-14 23:35:45	2026-01-14 23:35:45	\N
454	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-14 23:35:45	2026-01-14 23:35:45	\N
455	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-14 23:35:46	2026-01-14 23:35:46	\N
456	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-14 23:35:46	2026-01-14 23:35:46	\N
457	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-14 23:35:46	2026-01-14 23:35:46	\N
458	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 00:56:10	2026-01-15 00:56:10	\N
459	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 00:56:10	2026-01-15 00:56:10	\N
460	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 00:56:11	2026-01-15 00:56:11	\N
461	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 00:56:11	2026-01-15 00:56:11	\N
462	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 00:56:11	2026-01-15 00:56:11	\N
463	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 00:56:11	2026-01-15 00:56:11	\N
464	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 00:56:11	2026-01-15 00:56:11	\N
465	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 00:56:11	2026-01-15 00:56:11	\N
466	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 00:56:11	2026-01-15 00:56:11	\N
467	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 00:56:11	2026-01-15 00:56:11	\N
468	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 00:56:54	2026-01-15 00:56:54	\N
469	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 00:56:54	2026-01-15 00:56:54	\N
470	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 00:56:54	2026-01-15 00:56:54	\N
471	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 00:56:54	2026-01-15 00:56:54	\N
472	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 00:56:54	2026-01-15 00:56:54	\N
473	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 00:56:54	2026-01-15 00:56:54	\N
474	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 00:56:54	2026-01-15 00:56:54	\N
475	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 00:56:54	2026-01-15 00:56:54	\N
476	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 00:56:54	2026-01-15 00:56:54	\N
477	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 00:56:55	2026-01-15 00:56:55	\N
478	USER	2	JOURNAL_POSTED	JournalEntry	21	{"number":"FEE-ACCR-8","posted_at":"2026-01-15 01:01:27"}	2026-01-15 01:01:27	2026-01-15 01:01:27	2026-01-15 01:01:27
479	USER	2	JOURNAL_POSTED	JournalEntry	20	{"number":"PAY-PRM-1768412961-C1-19","posted_at":"2026-01-15 01:01:32"}	2026-01-15 01:01:32	2026-01-15 01:01:32	2026-01-15 01:01:32
480	USER	2	JOURNAL_POSTED	JournalEntry	16	{"number":"FEE-ACCR-6","posted_at":"2026-01-15 01:01:34"}	2026-01-15 01:01:34	2026-01-15 01:01:34	2026-01-15 01:01:34
481	USER	2	JOURNAL_POSTED	JournalEntry	9	{"number":"CASH-MOVE-2","posted_at":"2026-01-15 01:01:37"}	2026-01-15 01:01:37	2026-01-15 01:01:37	2026-01-15 01:01:37
482	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 01:05:49	2026-01-15 01:05:49	\N
483	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 01:05:49	2026-01-15 01:05:49	\N
484	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 01:05:49	2026-01-15 01:05:49	\N
485	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 01:05:49	2026-01-15 01:05:49	\N
486	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 01:05:49	2026-01-15 01:05:49	\N
487	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 01:05:50	2026-01-15 01:05:50	\N
488	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 01:05:50	2026-01-15 01:05:50	\N
489	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 01:05:50	2026-01-15 01:05:50	\N
490	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 01:05:50	2026-01-15 01:05:50	\N
491	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 01:05:50	2026-01-15 01:05:50	\N
492	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 02:25:05	2026-01-15 02:25:05	\N
493	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 02:25:06	2026-01-15 02:25:06	\N
494	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 02:25:06	2026-01-15 02:25:06	\N
495	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 02:25:06	2026-01-15 02:25:06	\N
496	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 02:25:06	2026-01-15 02:25:06	\N
497	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 02:25:06	2026-01-15 02:25:06	\N
498	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 02:25:06	2026-01-15 02:25:06	\N
499	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 02:25:06	2026-01-15 02:25:06	\N
500	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 02:25:06	2026-01-15 02:25:06	\N
501	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 02:25:06	2026-01-15 02:25:06	\N
502	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 02:40:30	2026-01-15 02:40:30	\N
503	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 02:40:30	2026-01-15 02:40:30	\N
504	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 02:40:31	2026-01-15 02:40:31	\N
505	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 02:40:31	2026-01-15 02:40:31	\N
506	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 02:40:31	2026-01-15 02:40:31	\N
507	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 02:40:31	2026-01-15 02:40:31	\N
508	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 02:40:31	2026-01-15 02:40:31	\N
509	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 02:40:31	2026-01-15 02:40:31	\N
510	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 02:40:31	2026-01-15 02:40:31	\N
511	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 02:40:31	2026-01-15 02:40:31	\N
512	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 18:49:24	2026-01-15 18:49:24	\N
513	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 18:49:24	2026-01-15 18:49:24	\N
514	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 18:49:24	2026-01-15 18:49:24	\N
515	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 18:49:24	2026-01-15 18:49:24	\N
516	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 18:49:24	2026-01-15 18:49:24	\N
517	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 18:49:24	2026-01-15 18:49:24	\N
518	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 18:49:24	2026-01-15 18:49:24	\N
519	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 18:49:24	2026-01-15 18:49:24	\N
520	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 18:49:24	2026-01-15 18:49:24	\N
521	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 18:49:25	2026-01-15 18:49:25	\N
522	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 18:49:59	2026-01-15 18:49:59	\N
523	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 18:49:59	2026-01-15 18:49:59	\N
524	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 18:49:59	2026-01-15 18:49:59	\N
525	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 18:49:59	2026-01-15 18:49:59	\N
526	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 18:49:59	2026-01-15 18:49:59	\N
527	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 18:49:59	2026-01-15 18:49:59	\N
528	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 18:49:59	2026-01-15 18:49:59	\N
529	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 18:49:59	2026-01-15 18:49:59	\N
530	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 18:49:59	2026-01-15 18:49:59	\N
531	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 18:49:59	2026-01-15 18:49:59	\N
532	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 18:56:47	2026-01-15 18:56:47	\N
533	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 18:56:47	2026-01-15 18:56:47	\N
534	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 18:56:47	2026-01-15 18:56:47	\N
535	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 18:56:47	2026-01-15 18:56:47	\N
536	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 18:56:47	2026-01-15 18:56:47	\N
537	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 18:56:47	2026-01-15 18:56:47	\N
538	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 18:56:47	2026-01-15 18:56:47	\N
539	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 18:56:47	2026-01-15 18:56:47	\N
540	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 18:56:47	2026-01-15 18:56:47	\N
541	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 18:56:47	2026-01-15 18:56:47	\N
542	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 18:57:48	2026-01-15 18:57:48	\N
543	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 18:57:48	2026-01-15 18:57:48	\N
544	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 18:57:48	2026-01-15 18:57:48	\N
545	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 18:57:48	2026-01-15 18:57:48	\N
546	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 18:57:48	2026-01-15 18:57:48	\N
547	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 18:57:48	2026-01-15 18:57:48	\N
548	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 18:57:48	2026-01-15 18:57:48	\N
549	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 18:57:48	2026-01-15 18:57:48	\N
550	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 18:57:48	2026-01-15 18:57:48	\N
551	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 18:57:48	2026-01-15 18:57:48	\N
552	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 18:59:25	2026-01-15 18:59:25	\N
553	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 18:59:25	2026-01-15 18:59:25	\N
554	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 18:59:25	2026-01-15 18:59:25	\N
555	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 18:59:26	2026-01-15 18:59:26	\N
556	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 18:59:26	2026-01-15 18:59:26	\N
557	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 18:59:26	2026-01-15 18:59:26	\N
558	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 18:59:26	2026-01-15 18:59:26	\N
559	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 18:59:26	2026-01-15 18:59:26	\N
560	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 18:59:26	2026-01-15 18:59:26	\N
561	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 18:59:26	2026-01-15 18:59:26	\N
562	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 19:01:00	2026-01-15 19:01:00	\N
563	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 19:01:01	2026-01-15 19:01:01	\N
564	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 19:01:01	2026-01-15 19:01:01	\N
565	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 19:01:01	2026-01-15 19:01:01	\N
566	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 19:01:01	2026-01-15 19:01:01	\N
567	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 19:01:01	2026-01-15 19:01:01	\N
568	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 19:01:01	2026-01-15 19:01:01	\N
569	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 19:01:01	2026-01-15 19:01:01	\N
570	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 19:01:01	2026-01-15 19:01:01	\N
571	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 19:01:01	2026-01-15 19:01:01	\N
572	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 19:01:19	2026-01-15 19:01:19	\N
573	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-15 19:01:19	2026-01-15 19:01:19	\N
574	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 19:01:20	2026-01-15 19:01:20	\N
575	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-15 19:01:20	2026-01-15 19:01:20	\N
576	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-15 19:01:20	2026-01-15 19:01:20	\N
577	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-15 19:01:20	2026-01-15 19:01:20	\N
578	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-15 19:01:20	2026-01-15 19:01:20	\N
579	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-15 19:01:20	2026-01-15 19:01:20	\N
580	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-15 19:01:20	2026-01-15 19:01:20	\N
581	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-15 19:01:20	2026-01-15 19:01:20	\N
582	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 19:03:45	2026-01-15 19:03:45	\N
583	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 19:03:45	2026-01-15 19:03:45	\N
584	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 19:03:45	2026-01-15 19:03:45	\N
585	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 19:03:45	2026-01-15 19:03:45	\N
586	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 19:03:45	2026-01-15 19:03:45	\N
587	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 19:03:45	2026-01-15 19:03:45	\N
588	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 19:03:45	2026-01-15 19:03:45	\N
589	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 19:03:45	2026-01-15 19:03:45	\N
590	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 19:03:46	2026-01-15 19:03:46	\N
591	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 19:03:46	2026-01-15 19:03:46	\N
592	USER	3	SUBMIT	cash_moves	3	{"after":{"from_holder_id":1,"to_holder_id":2,"amount":"250000.00","note":null,"moved_at":"2026-01-14T17:00:00.000000Z","status":"SUBMITTED","submitted_by":3,"idempotency_key":"42lq8dmu3h9.mkfelxs7","updated_at":"2026-01-15T12:06:30.000000Z","created_at":"2026-01-15T12:06:30.000000Z","id":3}}	2026-01-15 19:06:30	2026-01-15 19:06:30	\N
593	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 19:19:57	2026-01-15 19:19:57	\N
594	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 19:19:57	2026-01-15 19:19:57	\N
595	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 19:19:57	2026-01-15 19:19:57	\N
596	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 19:19:57	2026-01-15 19:19:57	\N
597	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 19:19:57	2026-01-15 19:19:57	\N
598	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 19:19:57	2026-01-15 19:19:57	\N
599	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 19:19:58	2026-01-15 19:19:58	\N
600	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 19:19:58	2026-01-15 19:19:58	\N
601	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 19:19:58	2026-01-15 19:19:58	\N
602	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 19:19:58	2026-01-15 19:19:58	\N
603	USER	3	SUBMIT	cash_moves	4	{"after":{"from_holder_id":1,"to_holder_id":2,"amount":"250000.00","note":null,"moved_at":"2026-01-14T17:00:00.000000Z","status":"SUBMITTED","submitted_by":3,"idempotency_key":"04v71ytvh1xs.mkff6xk6","updated_at":"2026-01-15T12:22:51.000000Z","created_at":"2026-01-15T12:22:51.000000Z","id":4}}	2026-01-15 19:22:51	2026-01-15 19:22:51	\N
604	USER	3	SUBMIT	cash_moves	5	{"after":{"from_holder_id":1,"to_holder_id":2,"amount":"250000.00","note":null,"moved_at":"2026-01-14T17:00:00.000000Z","status":"SUBMITTED","submitted_by":3,"idempotency_key":"0tvl3v6hybuj.mkffi3o1","updated_at":"2026-01-15T12:31:33.000000Z","created_at":"2026-01-15T12:31:33.000000Z","id":5}}	2026-01-15 19:31:33	2026-01-15 19:31:33	\N
605	USER	3	SUBMIT	cash_moves	6	{"after":{"from_holder_id":1,"to_holder_id":3,"amount":"250000.00","note":null,"moved_at":"2026-01-14T17:00:00.000000Z","status":"SUBMITTED","submitted_by":3,"idempotency_key":"18dggyaaqpy.mkffkcs9","updated_at":"2026-01-15T12:33:15.000000Z","created_at":"2026-01-15T12:33:15.000000Z","id":6}}	2026-01-15 19:33:15	2026-01-15 19:33:15	\N
606	USER	3	SUBMIT	cash_moves	7	{"after":{"from_holder_id":1,"to_holder_id":3,"amount":"250000.00","note":null,"moved_at":"2026-01-14T17:00:00.000000Z","status":"SUBMITTED","submitted_by":3,"idempotency_key":"teinvdsei3.mkffmcho","updated_at":"2026-01-15T12:34:46.000000Z","created_at":"2026-01-15T12:34:46.000000Z","id":7}}	2026-01-15 19:34:46	2026-01-15 19:34:46	\N
607	USER	3	SUBMIT	cash_moves	8	{"after":{"from_holder_id":1,"to_holder_id":2,"amount":"250000.00","note":null,"moved_at":"2026-01-14T17:00:00.000000Z","status":"SUBMITTED","submitted_by":3,"idempotency_key":"f72p2sxa3qm.mkffo0qa","updated_at":"2026-01-15T12:36:07.000000Z","created_at":"2026-01-15T12:36:07.000000Z","id":8}}	2026-01-15 19:36:07	2026-01-15 19:36:07	\N
608	USER	3	SUBMIT	cash_moves	9	{"after":{"from_holder_id":1,"to_holder_id":3,"amount":"250000.00","note":null,"moved_at":"2026-01-14T17:00:00.000000Z","status":"SUBMITTED","submitted_by":3,"idempotency_key":"7d5c6lyadbb.mkffq9jf","updated_at":"2026-01-15T12:37:51.000000Z","created_at":"2026-01-15T12:37:51.000000Z","id":9}}	2026-01-15 19:37:51	2026-01-15 19:37:51	\N
609	USER	3	SUBMIT	cash_moves	10	{"after":{"from_holder_id":1,"to_holder_id":3,"amount":"250000.00","note":null,"moved_at":"2026-01-14T17:00:00.000000Z","status":"SUBMITTED","submitted_by":3,"idempotency_key":"vyvrx4axcws.mkffssue","updated_at":"2026-01-15T12:39:51.000000Z","created_at":"2026-01-15T12:39:51.000000Z","id":10}}	2026-01-15 19:39:51	2026-01-15 19:39:51	\N
610	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 22:46:49	2026-01-15 22:46:49	\N
611	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 22:46:49	2026-01-15 22:46:49	\N
612	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 22:46:49	2026-01-15 22:46:49	\N
613	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-08T00:00:00.000000Z","to":"2026-01-15T23:59:59.999999Z"}	2026-01-15 22:46:49	2026-01-15 22:46:49	\N
614	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 22:46:49	2026-01-15 22:46:49	\N
615	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 22:46:49	2026-01-15 22:46:49	\N
616	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-15 22:46:50	2026-01-15 22:46:50	\N
617	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-15 22:46:50	2026-01-15 22:46:50	\N
618	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-15 22:46:50	2026-01-15 22:46:50	\N
619	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-15 22:46:50	2026-01-15 22:46:50	\N
622	USER	3	OPEN_SESSION	cash_sessions	2	{"after":{"cabang_id":1,"cashier_id":3,"opening_amount":"0.00","status":"OPEN","opened_at":"2026-01-15T15:53:36.000000Z","updated_at":"2026-01-15T15:53:36.000000Z","created_at":"2026-01-15T15:53:36.000000Z","id":2}}	2026-01-15 22:53:36	2026-01-15 22:53:36	\N
623	USER	3	LOG_CASH	cash_transactions	2	{"after":{"session_id":2,"type":"IN","amount":"85000.00","source":"ORDER","ref_type":"ORDER","ref_id":31,"note":"ORDER#PRM-1768492416-C1","occurred_at":"2026-01-15T15:53:36.000000Z","updated_at":"2026-01-15T15:53:36.000000Z","created_at":"2026-01-15T15:53:36.000000Z","id":2}}	2026-01-15 22:53:36	2026-01-15 22:53:36	\N
624	USER	3	LOG_CASH	cash_transactions	3	{"after":{"session_id":2,"type":"IN","amount":"85000.00","source":"ORDER","ref_type":"ORDER","ref_id":32,"note":"ORDER#PRM-1768492455-C1","occurred_at":"2026-01-15T15:54:15.000000Z","updated_at":"2026-01-15T15:54:15.000000Z","created_at":"2026-01-15T15:54:15.000000Z","id":3}}	2026-01-15 22:54:15	2026-01-15 22:54:15	\N
625	USER	3	LOG_CASH	cash_transactions	4	{"after":{"session_id":2,"type":"IN","amount":"250000.00","source":"ORDER","ref_type":"ORDER","ref_id":33,"note":"ORDER#PRM-1768492470-C1","occurred_at":"2026-01-15T15:54:30.000000Z","updated_at":"2026-01-15T15:54:30.000000Z","created_at":"2026-01-15T15:54:30.000000Z","id":4}}	2026-01-15 22:54:30	2026-01-15 22:54:30	\N
626	USER	3	LOG_CASH	cash_transactions	5	{"after":{"session_id":2,"type":"IN","amount":"250000.00","source":"ORDER","ref_type":"ORDER","ref_id":34,"note":"ORDER#PRM-1768492516-C1","occurred_at":"2026-01-15T15:55:16.000000Z","updated_at":"2026-01-15T15:55:16.000000Z","created_at":"2026-01-15T15:55:16.000000Z","id":5}}	2026-01-15 22:55:16	2026-01-15 22:55:16	\N
627	USER	3	LOG_CASH	cash_transactions	6	{"after":{"session_id":2,"type":"IN","amount":"85000.00","source":"ORDER","ref_type":"ORDER","ref_id":35,"note":"ORDER#PRM-1768492527-C1","occurred_at":"2026-01-15T15:55:27.000000Z","updated_at":"2026-01-15T15:55:27.000000Z","created_at":"2026-01-15T15:55:27.000000Z","id":6}}	2026-01-15 22:55:27	2026-01-15 22:55:27	\N
628	USER	3	LOG_CASH	cash_transactions	7	{"after":{"session_id":2,"type":"IN","amount":"85000.00","source":"ORDER","ref_type":"ORDER","ref_id":36,"note":"ORDER#PRM-1768492536-C1","occurred_at":"2026-01-15T15:55:36.000000Z","updated_at":"2026-01-15T15:55:36.000000Z","created_at":"2026-01-15T15:55:36.000000Z","id":7}}	2026-01-15 22:55:36	2026-01-15 22:55:36	\N
629	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 00:10:12	2026-01-16 00:10:12	\N
630	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 00:10:12	2026-01-16 00:10:12	\N
631	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 00:10:12	2026-01-16 00:10:12	\N
632	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 00:10:12	2026-01-16 00:10:12	\N
633	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 00:10:13	2026-01-16 00:10:13	\N
634	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 00:10:13	2026-01-16 00:10:13	\N
635	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 00:10:13	2026-01-16 00:10:13	\N
636	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 00:10:13	2026-01-16 00:10:13	\N
637	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 00:10:13	2026-01-16 00:10:13	\N
638	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 00:10:13	2026-01-16 00:10:13	\N
639	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 00:13:54	2026-01-16 00:13:54	\N
640	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 00:13:55	2026-01-16 00:13:55	\N
641	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 00:13:55	2026-01-16 00:13:55	\N
642	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 00:13:55	2026-01-16 00:13:55	\N
643	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 00:13:55	2026-01-16 00:13:55	\N
644	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 00:13:55	2026-01-16 00:13:55	\N
645	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 00:13:55	2026-01-16 00:13:55	\N
646	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 00:13:55	2026-01-16 00:13:55	\N
647	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 00:13:55	2026-01-16 00:13:55	\N
648	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 00:13:55	2026-01-16 00:13:55	\N
649	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 00:39:33	2026-01-16 00:39:33	\N
650	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-16 00:39:33	2026-01-16 00:39:33	\N
651	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-16 00:39:33	2026-01-16 00:39:33	\N
652	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-16 00:39:33	2026-01-16 00:39:33	\N
653	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-16 00:39:33	2026-01-16 00:39:33	\N
654	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 00:39:33	2026-01-16 00:39:33	\N
655	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-16 00:39:33	2026-01-16 00:39:33	\N
656	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-16 00:39:33	2026-01-16 00:39:33	\N
657	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-16 00:39:33	2026-01-16 00:39:33	\N
658	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-16 00:39:33	2026-01-16 00:39:33	\N
659	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:15:12	2026-01-16 21:15:12	\N
660	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:12	2026-01-16 21:15:12	\N
661	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 21:15:12	2026-01-16 21:15:12	\N
662	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:15:12	2026-01-16 21:15:12	\N
663	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 21:15:12	2026-01-16 21:15:12	\N
664	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:12	2026-01-16 21:15:12	\N
665	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:12	2026-01-16 21:15:12	\N
666	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 21:15:12	2026-01-16 21:15:12	\N
667	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 21:15:12	2026-01-16 21:15:12	\N
668	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:13	2026-01-16 21:15:13	\N
669	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:15:20	2026-01-16 21:15:20	\N
670	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:20	2026-01-16 21:15:20	\N
671	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 21:15:20	2026-01-16 21:15:20	\N
672	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 21:15:20	2026-01-16 21:15:20	\N
673	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:20	2026-01-16 21:15:20	\N
674	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:15:20	2026-01-16 21:15:20	\N
675	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:20	2026-01-16 21:15:20	\N
676	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 21:15:20	2026-01-16 21:15:20	\N
677	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 21:15:20	2026-01-16 21:15:20	\N
678	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:20	2026-01-16 21:15:20	\N
679	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:15:32	2026-01-16 21:15:32	\N
680	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:32	2026-01-16 21:15:32	\N
681	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 21:15:32	2026-01-16 21:15:32	\N
682	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 21:15:32	2026-01-16 21:15:32	\N
683	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:32	2026-01-16 21:15:32	\N
684	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:15:32	2026-01-16 21:15:32	\N
685	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:32	2026-01-16 21:15:32	\N
686	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 21:15:32	2026-01-16 21:15:32	\N
687	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 21:15:32	2026-01-16 21:15:32	\N
688	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:32	2026-01-16 21:15:32	\N
689	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:15:55	2026-01-16 21:15:55	\N
690	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:56	2026-01-16 21:15:56	\N
691	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 21:15:56	2026-01-16 21:15:56	\N
692	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 21:15:56	2026-01-16 21:15:56	\N
693	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:56	2026-01-16 21:15:56	\N
694	USER	3	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:15:56	2026-01-16 21:15:56	\N
695	USER	3	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:56	2026-01-16 21:15:56	\N
696	USER	3	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-16 21:15:56	2026-01-16 21:15:56	\N
697	USER	3	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-16 21:15:56	2026-01-16 21:15:56	\N
698	USER	3	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-16 21:15:56	2026-01-16 21:15:56	\N
699	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:16:11	2026-01-16 21:16:11	\N
700	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-16 21:16:11	2026-01-16 21:16:11	\N
701	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-16 21:16:11	2026-01-16 21:16:11	\N
702	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:16:11	2026-01-16 21:16:11	\N
703	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-16 21:16:11	2026-01-16 21:16:11	\N
704	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-16 21:16:11	2026-01-16 21:16:11	\N
705	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-16 21:16:11	2026-01-16 21:16:11	\N
706	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-16 21:16:11	2026-01-16 21:16:11	\N
707	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-16 21:16:11	2026-01-16 21:16:11	\N
708	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-16 21:16:11	2026-01-16 21:16:11	\N
709	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:18:44	2026-01-16 21:18:44	\N
710	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-16 21:18:45	2026-01-16 21:18:45	\N
711	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-16 21:18:45	2026-01-16 21:18:45	\N
712	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-16 21:18:45	2026-01-16 21:18:45	\N
713	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-16 21:18:45	2026-01-16 21:18:45	\N
714	USER	1	DASHBOARD.KPIS	dashboard	0	{"cabang_id":null,"from":"2026-01-09T00:00:00.000000Z","to":"2026-01-16T23:59:59.999999Z"}	2026-01-16 21:18:45	2026-01-16 21:18:45	\N
715	USER	1	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":null}	2026-01-16 21:18:45	2026-01-16 21:18:45	\N
716	USER	1	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":null,"limit":5}	2026-01-16 21:18:45	2026-01-16 21:18:45	\N
717	USER	1	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":null,"threshold":null}	2026-01-16 21:18:45	2026-01-16 21:18:45	\N
718	USER	1	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":null}	2026-01-16 21:18:45	2026-01-16 21:18:45	\N
719	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-23T00:00:00.000000Z","to":"2026-01-30T23:59:59.999999Z"}	2026-01-30 13:23:05	2026-01-30 13:23:05	\N
720	USER	2	DASHBOARD.KPIS	dashboard	0	{"cabang_id":1,"from":"2026-01-23T00:00:00.000000Z","to":"2026-01-30T23:59:59.999999Z"}	2026-01-30 13:23:05	2026-01-30 13:23:05	\N
721	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-30 13:23:05	2026-01-30 13:23:05	\N
722	USER	2	DASHBOARD.CHART7D	dashboard	0	{"cabang_id":1}	2026-01-30 13:23:06	2026-01-30 13:23:06	\N
723	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-30 13:23:06	2026-01-30 13:23:06	\N
724	USER	2	DASHBOARD.TOPPRODUCTS	dashboard	0	{"cabang_id":1,"limit":5}	2026-01-30 13:23:06	2026-01-30 13:23:06	\N
725	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-30 13:23:06	2026-01-30 13:23:06	\N
726	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-30 13:23:06	2026-01-30 13:23:06	\N
727	USER	2	DASHBOARD.LOWSTOCK	dashboard	0	{"cabang_id":1,"threshold":null}	2026-01-30 13:23:06	2026-01-30 13:23:06	\N
728	USER	2	DASHBOARD.QUICKACTIONS	dashboard	0	{"cabang_id":1}	2026-01-30 13:23:06	2026-01-30 13:23:06	\N
\.


--
-- Data for Name: backups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."backups" ("id", "storage_path", "kind", "size_bytes", "created_at") FROM stdin;
\.


--
-- Data for Name: cabangs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."cabangs" ("id", "nama", "kota", "alamat", "telepon", "jam_operasional", "is_active", "created_at", "updated_at") FROM stdin;
1	Cabang Pusat	Bandung	Jl. Contoh No. 1	081234567890	Senin-Minggu 08:00-21:00	t	2025-11-10 13:02:11	2025-11-10 13:02:11
\.


--
-- Data for Name: cache; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."cache" ("key", "value", "expiration") FROM stdin;
ordering-cache-dash:kpi:c1:2026-01-09-2026-01-16	a:6:{s:12:"orders_total";i:15;s:11:"orders_paid";i:14;s:7:"revenue";d:4075000;s:10:"avg_ticket";d:291071.4285714286;s:13:"paid_rate_pct";d:93.33;s:10:"validation";a:3:{s:15:"paid_amount_sum";d:4075000;s:23:"orders_vs_payments_diff";d:0;s:13:"is_consistent";b:1;}}	1768572972
ordering-cache-dash:chart7d:c1:2026-01-10	a:7:{i:0;a:3:{s:4:"date";s:10:"2026-01-10";s:6:"orders";i:0;s:7:"revenue";d:0;}i:1;a:3:{s:4:"date";s:10:"2026-01-11";s:6:"orders";i:0;s:7:"revenue";d:0;}i:2;a:3:{s:4:"date";s:10:"2026-01-12";s:6:"orders";i:1;s:7:"revenue";d:0;}i:3;a:3:{s:4:"date";s:10:"2026-01-13";s:6:"orders";i:0;s:7:"revenue";d:0;}i:4;a:3:{s:4:"date";s:10:"2026-01-14";s:6:"orders";i:2;s:7:"revenue";d:335000;}i:5;a:3:{s:4:"date";s:10:"2026-01-15";s:6:"orders";i:12;s:7:"revenue";d:3740000;}i:6;a:3:{s:4:"date";s:10:"2026-01-16";s:6:"orders";i:0;s:7:"revenue";d:0;}}	1768572972
ordering-cache-dash:kpi:c:2026-01-09-2026-01-16	a:6:{s:12:"orders_total";i:15;s:11:"orders_paid";i:14;s:7:"revenue";d:4075000;s:10:"avg_ticket";d:291071.4285714286;s:13:"paid_rate_pct";d:93.33;s:10:"validation";a:3:{s:15:"paid_amount_sum";d:4075000;s:23:"orders_vs_payments_diff";d:0;s:13:"is_consistent";b:1;}}	1768573184
ordering-cache-dash:chart7d:c:2026-01-10	a:7:{i:0;a:3:{s:4:"date";s:10:"2026-01-10";s:6:"orders";i:0;s:7:"revenue";d:0;}i:1;a:3:{s:4:"date";s:10:"2026-01-11";s:6:"orders";i:0;s:7:"revenue";d:0;}i:2;a:3:{s:4:"date";s:10:"2026-01-12";s:6:"orders";i:1;s:7:"revenue";d:0;}i:3;a:3:{s:4:"date";s:10:"2026-01-13";s:6:"orders";i:0;s:7:"revenue";d:0;}i:4;a:3:{s:4:"date";s:10:"2026-01-14";s:6:"orders";i:2;s:7:"revenue";d:335000;}i:5;a:3:{s:4:"date";s:10:"2026-01-15";s:6:"orders";i:12;s:7:"revenue";d:3740000;}i:6;a:3:{s:4:"date";s:10:"2026-01-16";s:6:"orders";i:0;s:7:"revenue";d:0;}}	1768573185
ordering-cache-dash:top:c:l5	a:4:{i:0;a:4:{s:10:"variant_id";i:2;s:4:"name";s:16:"choco flavour - ";s:3:"qty";d:12;s:7:"revenue";d:1800000;}i:1;a:4:{s:10:"variant_id";i:1;s:4:"name";s:16:"choco flavour - ";s:3:"qty";d:10;s:7:"revenue";d:2500000;}i:2;a:4:{s:10:"variant_id";i:3;s:4:"name";s:14:"Choco lover - ";s:3:"qty";d:7;s:7:"revenue";d:1750000;}i:3;a:4:{s:10:"variant_id";i:4;s:4:"name";s:13:"Tube Class - ";s:3:"qty";d:5;s:7:"revenue";d:425000;}}	1768573185
ordering-cache-dash:low:c:tmin	a:2:{i:0;a:6:{s:9:"gudang_id";i:1;s:10:"variant_id";i:4;s:3:"sku";s:4:"F-02";s:4:"name";s:10:"Tube Class";s:11:"qty_on_hand";d:7;s:9:"min_stock";d:10;}i:1;a:6:{s:9:"gudang_id";i:1;s:10:"variant_id";i:5;s:3:"sku";s:4:"P-01";s:4:"name";s:13:"Pudding Extra";s:11:"qty_on_hand";d:11;s:9:"min_stock";d:11;}}	1768573185
ordering-cache-spatie.permission.cache	a:3:{s:5:"alias";a:0:{}s:11:"permissions";a:0:{}s:5:"roles";a:0:{}}	1769840585
ordering-cache-dash:kpi:c1:2026-01-23-2026-01-30	a:6:{s:12:"orders_total";i:0;s:11:"orders_paid";i:0;s:7:"revenue";d:0;s:10:"avg_ticket";d:0;s:13:"paid_rate_pct";d:0;s:10:"validation";a:3:{s:15:"paid_amount_sum";d:0;s:23:"orders_vs_payments_diff";d:0;s:13:"is_consistent";b:1;}}	1769754245
ordering-cache-dash:chart7d:c1:2026-01-24	a:7:{i:0;a:3:{s:4:"date";s:10:"2026-01-24";s:6:"orders";i:0;s:7:"revenue";d:0;}i:1;a:3:{s:4:"date";s:10:"2026-01-25";s:6:"orders";i:0;s:7:"revenue";d:0;}i:2;a:3:{s:4:"date";s:10:"2026-01-26";s:6:"orders";i:0;s:7:"revenue";d:0;}i:3;a:3:{s:4:"date";s:10:"2026-01-27";s:6:"orders";i:0;s:7:"revenue";d:0;}i:4;a:3:{s:4:"date";s:10:"2026-01-28";s:6:"orders";i:0;s:7:"revenue";d:0;}i:5;a:3:{s:4:"date";s:10:"2026-01-29";s:6:"orders";i:0;s:7:"revenue";d:0;}i:6;a:3:{s:4:"date";s:10:"2026-01-30";s:6:"orders";i:0;s:7:"revenue";d:0;}}	1769754245
ordering-cache-dash:top:c1:l5	a:4:{i:0;a:4:{s:10:"variant_id";i:2;s:4:"name";s:16:"choco flavour - ";s:3:"qty";d:12;s:7:"revenue";d:1800000;}i:1;a:4:{s:10:"variant_id";i:1;s:4:"name";s:16:"choco flavour - ";s:3:"qty";d:10;s:7:"revenue";d:2500000;}i:2;a:4:{s:10:"variant_id";i:3;s:4:"name";s:14:"Choco lover - ";s:3:"qty";d:7;s:7:"revenue";d:1750000;}i:3;a:4:{s:10:"variant_id";i:4;s:4:"name";s:13:"Tube Class - ";s:3:"qty";d:5;s:7:"revenue";d:425000;}}	1769754246
ordering-cache-dash:low:c1:tmin	a:2:{i:0;a:6:{s:9:"gudang_id";i:1;s:10:"variant_id";i:4;s:3:"sku";s:4:"F-02";s:4:"name";s:10:"Tube Class";s:11:"qty_on_hand";d:7;s:9:"min_stock";d:10;}i:1;a:6:{s:9:"gudang_id";i:1;s:10:"variant_id";i:5;s:3:"sku";s:4:"P-01";s:4:"name";s:13:"Pudding Extra";s:11:"qty_on_hand";d:11;s:9:"min_stock";d:11;}}	1769754246
\.


--
-- Data for Name: cache_locks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."cache_locks" ("key", "owner", "expiration") FROM stdin;
\.


--
-- Data for Name: cash_holders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."cash_holders" ("id", "cabang_id", "name", "balance", "created_at", "updated_at") FROM stdin;
3	1	Bank	1550000.00	2025-12-24 00:46:00	2025-12-24 00:48:58
2	1	Brankas	100000.00	2025-12-24 00:46:00	2025-12-24 04:33:28
1	1	Kasir	250000.00	2025-12-24 00:43:48	2026-01-14 23:26:31
\.


--
-- Data for Name: cash_moves; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."cash_moves" ("id", "from_holder_id", "to_holder_id", "amount", "note", "moved_at", "status", "submitted_by", "approved_by", "approved_at", "rejected_at", "reject_reason", "idempotency_key", "created_at", "updated_at") FROM stdin;
1	2	3	1550000.00	\N	2025-12-24 00:00:00	REJECTED	3	1	\N	2025-12-24 00:48:56	double	l37lpzwz5fn.mjivngf1	2025-12-24 00:47:15	2025-12-24 00:48:56
2	2	3	1550000.00	\N	2025-12-24 00:00:00	APPROVED	1	1	2025-12-24 00:48:58	\N	\N	8mscmkcxsqt.mjivoxt4	2025-12-24 00:48:28	2025-12-24 00:48:58
3	1	2	250000.00	\N	2026-01-15 00:00:00	SUBMITTED	3	\N	\N	\N	\N	42lq8dmu3h9.mkfelxs7	2026-01-15 19:06:30	2026-01-15 19:06:30
4	1	2	250000.00	\N	2026-01-15 00:00:00	SUBMITTED	3	\N	\N	\N	\N	04v71ytvh1xs.mkff6xk6	2026-01-15 19:22:51	2026-01-15 19:22:51
5	1	2	250000.00	\N	2026-01-15 00:00:00	SUBMITTED	3	\N	\N	\N	\N	0tvl3v6hybuj.mkffi3o1	2026-01-15 19:31:33	2026-01-15 19:31:33
6	1	3	250000.00	\N	2026-01-15 00:00:00	SUBMITTED	3	\N	\N	\N	\N	18dggyaaqpy.mkffkcs9	2026-01-15 19:33:15	2026-01-15 19:33:15
7	1	3	250000.00	\N	2026-01-15 00:00:00	SUBMITTED	3	\N	\N	\N	\N	teinvdsei3.mkffmcho	2026-01-15 19:34:46	2026-01-15 19:34:46
8	1	2	250000.00	\N	2026-01-15 00:00:00	SUBMITTED	3	\N	\N	\N	\N	f72p2sxa3qm.mkffo0qa	2026-01-15 19:36:07	2026-01-15 19:36:07
9	1	3	250000.00	\N	2026-01-15 00:00:00	SUBMITTED	3	\N	\N	\N	\N	7d5c6lyadbb.mkffq9jf	2026-01-15 19:37:51	2026-01-15 19:37:51
10	1	3	250000.00	\N	2026-01-15 00:00:00	SUBMITTED	3	\N	\N	\N	\N	vyvrx4axcws.mkffssue	2026-01-15 19:39:51	2026-01-15 19:39:51
\.


--
-- Data for Name: cash_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."cash_sessions" ("id", "cabang_id", "cashier_id", "opening_amount", "closing_amount", "status", "opened_at", "closed_at", "created_at", "updated_at") FROM stdin;
2	1	3	0.00	\N	OPEN	2026-01-15 22:53:36	\N	2026-01-15 22:53:36	2026-01-15 22:53:36
\.


--
-- Data for Name: cash_transactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."cash_transactions" ("id", "session_id", "type", "amount", "source", "ref_type", "ref_id", "note", "occurred_at", "created_at", "updated_at") FROM stdin;
2	2	IN	85000.00	ORDER	ORDER	31	ORDER#PRM-1768492416-C1	2026-01-15 22:53:36	2026-01-15 22:53:36	2026-01-15 22:53:36
3	2	IN	85000.00	ORDER	ORDER	32	ORDER#PRM-1768492455-C1	2026-01-15 22:54:15	2026-01-15 22:54:15	2026-01-15 22:54:15
4	2	IN	250000.00	ORDER	ORDER	33	ORDER#PRM-1768492470-C1	2026-01-15 22:54:30	2026-01-15 22:54:30	2026-01-15 22:54:30
5	2	IN	250000.00	ORDER	ORDER	34	ORDER#PRM-1768492516-C1	2026-01-15 22:55:16	2026-01-15 22:55:16	2026-01-15 22:55:16
6	2	IN	85000.00	ORDER	ORDER	35	ORDER#PRM-1768492527-C1	2026-01-15 22:55:27	2026-01-15 22:55:27	2026-01-15 22:55:27
7	2	IN	85000.00	ORDER	ORDER	36	ORDER#PRM-1768492536-C1	2026-01-15 22:55:36	2026-01-15 22:55:36	2026-01-15 22:55:36
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."categories" ("id", "nama", "slug", "deskripsi", "is_active", "created_at", "updated_at") FROM stdin;
1	Cake	cake	\N	t	2025-11-10 13:02:12	2025-11-10 13:02:12
2	Cookies	cookies	\N	t	2025-11-10 13:02:12	2025-11-10 13:02:12
3	Brownies	brownies	\N	t	2025-11-10 13:02:12	2025-11-10 13:02:12
4	Pudding	pudding	\N	t	2025-11-10 13:02:12	2025-11-10 13:02:12
5	Snack Box	snack-box	\N	t	2025-11-10 13:02:12	2025-11-10 13:02:12
6	Sepatu	sepatu	\N	f	2025-11-20 16:05:36	2025-11-20 16:05:48
\.


--
-- Data for Name: customer_timelines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."customer_timelines" ("id", "customer_id", "event_type", "title", "note", "meta", "happened_at", "created_at", "updated_at") FROM stdin;
1	1	NOTE	Customer created	\N	{"source": "POS"}	2025-11-10 14:18:54	2025-11-10 14:18:54	2025-11-10 14:18:54
2	2	NOTE	Customer created	\N	{"source": "POS"}	2025-11-20 16:10:48	2025-11-20 16:10:48	2025-11-20 16:10:48
3	3	NOTE	Customer created	\N	{"source": "POS"}	2026-01-15 18:50:19	2026-01-15 18:50:19	2026-01-15 18:50:19
4	4	NOTE	Customer created	\N	{"source": "POS"}	2026-01-15 18:50:55	2026-01-15 18:50:55	2026-01-15 18:50:55
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."customers" ("id", "cabang_id", "nama", "phone", "email", "alamat", "catatan", "stage", "last_order_at", "total_spent", "total_orders", "created_at", "updated_at") FROM stdin;
1	1	galuh	081214695222	\N	\N	\N	ACTIVE	\N	0.00	0	2025-11-10 14:18:54	2025-11-10 14:18:54
2	1	Mang Aden	08586554548788	\N	\N	\N	ACTIVE	\N	0.00	0	2025-11-20 16:10:48	2025-11-20 16:10:48
3	1	irfan	085865809424	\N	\N	\N	ACTIVE	\N	0.00	0	2026-01-15 18:50:19	2026-01-15 18:50:19
4	1	jajang	081452565585	\N	\N	\N	ACTIVE	\N	0.00	0	2026-01-15 18:50:55	2026-01-15 18:50:55
\.


--
-- Data for Name: deliveries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."deliveries" ("id", "order_id", "assigned_to", "type", "status", "pickup_address", "delivery_address", "pickup_lat", "pickup_lng", "delivery_lat", "delivery_lng", "requested_at", "completed_at", "created_at", "updated_at", "sj_number", "sj_issued_at") FROM stdin;
1	8	4	DELIVERY	DELIVERED	\N	\N	\N	\N	\N	\N	2025-11-20 16:17:02	2025-11-20 16:17:45	2025-11-20 16:17:02	2025-11-20 16:17:45	\N	\N
4	12	4	DELIVERY	ASSIGNED	\N	\N	\N	\N	\N	\N	2026-01-15 01:04:05	\N	2026-01-15 01:04:05	2026-01-15 01:04:14	\N	\N
3	13	4	DELIVERY	ASSIGNED	\N	\N	\N	\N	\N	\N	2026-01-15 01:04:01	\N	2026-01-15 01:04:01	2026-01-15 01:04:16	\N	\N
2	15	4	DELIVERY	ASSIGNED	\N	\N	\N	\N	\N	\N	2026-01-15 01:03:56	\N	2026-01-15 01:03:56	2026-01-15 01:04:15	\N	\N
\.


--
-- Data for Name: delivery_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."delivery_events" ("id", "delivery_id", "status", "note", "photo_url", "occurred_at", "created_at", "updated_at") FROM stdin;
1	1	REQUESTED	Delivery requested	\N	2025-11-20 16:17:02	2025-11-20 16:17:02	2025-11-20 16:17:02
2	1	ASSIGNED	Assigned to user #4	\N	2025-11-20 16:17:18	2025-11-20 16:17:18	2025-11-20 16:17:18
3	1	PICKED_UP	\N	\N	2025-11-20 16:17:32	2025-11-20 16:17:32	2025-11-20 16:17:32
4	1	ON_ROUTE	\N	\N	2025-11-20 16:17:41	2025-11-20 16:17:41	2025-11-20 16:17:41
5	1	DELIVERED	\N	\N	2025-11-20 16:17:45	2025-11-20 16:17:45	2025-11-20 16:17:45
6	2	REQUESTED	Delivery requested	\N	2026-01-15 01:03:56	2026-01-15 01:03:56	2026-01-15 01:03:56
7	3	REQUESTED	Delivery requested	\N	2026-01-15 01:04:01	2026-01-15 01:04:01	2026-01-15 01:04:01
8	4	REQUESTED	Delivery requested	\N	2026-01-15 01:04:05	2026-01-15 01:04:05	2026-01-15 01:04:05
9	4	ASSIGNED	Assigned to user #4	\N	2026-01-15 01:04:14	2026-01-15 01:04:14	2026-01-15 01:04:14
10	3	ASSIGNED	Assigned to user #4	\N	2026-01-15 01:04:16	2026-01-15 01:04:16	2026-01-15 01:04:16
11	2	ASSIGNED	Assigned to user #4	\N	2026-01-15 01:04:15	2026-01-15 01:04:15	2026-01-15 01:04:15
\.


--
-- Data for Name: failed_jobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."failed_jobs" ("id", "uuid", "connection", "queue", "payload", "exception", "failed_at") FROM stdin;
\.


--
-- Data for Name: fee_entries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."fee_entries" ("id", "fee_id", "cabang_id", "period_date", "ref_type", "ref_id", "owner_user_id", "base_amount", "fee_amount", "pay_status", "paid_amount", "paid_at", "notes", "created_by", "updated_by", "created_at", "updated_at") FROM stdin;
1	1	1	2025-12-24	ORDER	8	2	1100000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2025-12-24 00:46:12	2025-12-24 00:46:12
2	1	1	2025-12-24	ORDER	7	3	250000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2025-12-24 00:46:25	2025-12-24 00:46:25
3	1	1	2025-12-24	ORDER	6	3	250000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2025-12-24 00:46:36	2025-12-24 00:46:36
4	1	1	2025-12-24	ORDER	10	3	400000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2025-12-24 04:33:00	2025-12-24 04:33:00
5	1	1	2025-12-24	ORDER	9	3	150000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2025-12-24 04:33:28	2025-12-24 04:33:28
6	1	1	2026-01-14	ORDER	12	2	250000.00	5000.00	UNPAID	0.00	\N	\N	2	2	2026-01-14 23:26:31	2026-01-14 23:26:31
7	1	1	2026-01-14	ORDER	13	2	85000.00	5000.00	UNPAID	0.00	\N	\N	2	2	2026-01-14 23:28:39	2026-01-14 23:28:39
8	1	1	2026-01-15	ORDER	15	2	650000.00	5000.00	UNPAID	0.00	\N	\N	2	2	2026-01-15 00:49:21	2026-01-15 00:49:21
9	1	1	2026-01-15	ORDER	17	3	650000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2026-01-15 19:04:03	2026-01-15 19:04:03
10	1	1	2026-01-15	ORDER	18	3	400000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2026-01-15 19:21:51	2026-01-15 19:21:51
11	1	1	2026-01-15	ORDER	19	3	400000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2026-01-15 19:30:49	2026-01-15 19:30:49
12	1	1	2026-01-15	ORDER	21	3	650000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2026-01-15 19:34:12	2026-01-15 19:34:12
13	1	1	2026-01-15	ORDER	24	3	150000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2026-01-15 19:39:15	2026-01-15 19:39:15
14	1	1	2026-01-15	ORDER	27	3	85000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2026-01-15 22:53:36	2026-01-15 22:53:36
15	1	1	2026-01-15	ORDER	28	3	85000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2026-01-15 22:54:15	2026-01-15 22:54:15
16	1	1	2026-01-15	ORDER	29	3	250000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2026-01-15 22:54:30	2026-01-15 22:54:30
17	1	1	2026-01-15	ORDER	30	3	250000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2026-01-15 22:55:16	2026-01-15 22:55:16
18	1	1	2026-01-15	ORDER	31	3	85000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2026-01-15 22:55:27	2026-01-15 22:55:27
19	1	1	2026-01-15	ORDER	32	3	85000.00	5000.00	UNPAID	0.00	\N	\N	3	3	2026-01-15 22:55:36	2026-01-15 22:55:36
\.


--
-- Data for Name: fees; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."fees" ("id", "cabang_id", "name", "kind", "calc_type", "rate", "base", "is_active", "created_by", "updated_by", "created_at", "updated_at") FROM stdin;
1	1	Fee Kasir	CASHIER	FIXED	5000.00	GRAND_TOTAL	t	2	2	2025-11-20 16:18:44	2025-11-20 16:18:44
\.


--
-- Data for Name: fiscal_periods; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."fiscal_periods" ("id", "cabang_id", "year", "month", "status", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: gudangs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."gudangs" ("id", "cabang_id", "nama", "is_default", "is_active", "created_at", "updated_at") FROM stdin;
1	1	Gudang Utama	t	t	2025-11-10 13:02:11	2025-11-10 13:02:11
\.


--
-- Data for Name: job_batches; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."job_batches" ("id", "name", "total_jobs", "pending_jobs", "failed_jobs", "failed_job_ids", "options", "cancelled_at", "created_at", "finished_at") FROM stdin;
\.


--
-- Data for Name: jobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."jobs" ("id", "queue", "payload", "attempts", "reserved_at", "available_at", "created_at") FROM stdin;
\.


--
-- Data for Name: journal_entries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."journal_entries" ("id", "cabang_id", "journal_date", "number", "description", "status", "period_year", "period_month", "created_at", "updated_at") FROM stdin;
2	1	2025-11-20	PAY-PRM-1763629970-C1-7	Pembayaran Order PRM-1763629970-C1 (CASH)	POSTED	2025	11	2025-11-20 16:12:50	2025-11-20 16:20:17
1	1	2025-11-10	PAY-PRM-1762759501-C1-1	Pembayaran Order PRM-1762759501-C1 (QRIS)	POSTED	2025	11	2025-11-10 14:25:01	2025-11-20 16:20:21
3	1	2025-12-24	PAY-PRM-1763629970-C1-8	Pembayaran Order PRM-1763629970-C1 (CASH)	DRAFT	2025	12	2025-12-24 00:46:12	2025-12-24 00:46:12
4	1	2025-12-24	FEE-ACCR-1	Akru Fee order #PRM-1763629970-C1	DRAFT	2025	12	2025-12-24 00:46:12	2025-12-24 00:46:12
5	1	2025-12-24	PAY-PRM-1762763802-C1-9	Pembayaran Order PRM-1762763802-C1 (CASH)	DRAFT	2025	12	2025-12-24 00:46:25	2025-12-24 00:46:25
6	1	2025-12-24	FEE-ACCR-2	Akru Fee order #PRM-1762763802-C1	DRAFT	2025	12	2025-12-24 00:46:25	2025-12-24 00:46:25
7	1	2025-12-24	PAY-PRM-1762762854-C1-10	Pembayaran Order PRM-1762762854-C1 (CASH)	DRAFT	2025	12	2025-12-24 00:46:36	2025-12-24 00:46:36
8	1	2025-12-24	FEE-ACCR-3	Akru Fee order #PRM-1762762854-C1	DRAFT	2025	12	2025-12-24 00:46:36	2025-12-24 00:46:36
10	1	2025-12-24	PAY-PRM-1766525547-C1-11	Pembayaran Order PRM-1766525547-C1 (CASH)	DRAFT	2025	12	2025-12-24 04:32:27	2025-12-24 04:32:27
11	1	2025-12-24	PAY-PRM-1766525580-C1-12	Pembayaran Order PRM-1766525580-C1 (CASH)	DRAFT	2025	12	2025-12-24 04:33:00	2025-12-24 04:33:00
12	1	2025-12-24	FEE-ACCR-4	Akru Fee order #PRM-1766525580-C1	DRAFT	2025	12	2025-12-24 04:33:00	2025-12-24 04:33:00
13	1	2025-12-24	PAY-PRM-1766525547-C1-13	Pembayaran Order PRM-1766525547-C1 (CASH)	DRAFT	2025	12	2025-12-24 04:33:28	2025-12-24 04:33:28
14	1	2025-12-24	FEE-ACCR-5	Akru Fee order #PRM-1766525547-C1	DRAFT	2025	12	2025-12-24 04:33:28	2025-12-24 04:33:28
15	1	2026-01-14	PAY-PRM-1768407932-C1-16	Pembayaran Order PRM-1768407932-C1 (CASH)	DRAFT	2026	1	2026-01-14 23:26:31	2026-01-14 23:26:31
17	1	2026-01-14	PAY-PRM-1768408119-C1-17	Pembayaran Order PRM-1768408119-C1 (CASH)	DRAFT	2026	1	2026-01-14 23:28:39	2026-01-14 23:28:39
18	1	2026-01-14	FEE-ACCR-7	Akru Fee order #PRM-1768408119-C1	DRAFT	2026	1	2026-01-14 23:28:39	2026-01-14 23:28:39
21	1	2026-01-15	FEE-ACCR-8	Akru Fee order #PRM-1768412961-C1	POSTED	2026	1	2026-01-15 00:49:21	2026-01-15 01:01:27
20	1	2026-01-15	PAY-PRM-1768412961-C1-19	Pembayaran Order PRM-1768412961-C1 (CASH)	POSTED	2026	1	2026-01-15 00:49:21	2026-01-15 01:01:32
16	1	2026-01-14	FEE-ACCR-6	Akru Fee order #PRM-1768407932-C1	POSTED	2026	1	2026-01-14 23:26:31	2026-01-15 01:01:34
9	1	2025-12-24	CASH-MOVE-2	Cash move #2 (Brankas → Bank)	POSTED	2025	12	2025-12-24 00:48:58	2026-01-15 01:01:37
23	1	2026-01-15	PAY-PRM-1768478643-C1-21	Pembayaran Order PRM-1768478643-C1 (CASH)	DRAFT	2026	1	2026-01-15 19:04:03	2026-01-15 19:04:03
24	1	2026-01-15	FEE-ACCR-9	Akru Fee order #PRM-1768478643-C1	DRAFT	2026	1	2026-01-15 19:04:03	2026-01-15 19:04:03
25	1	2026-01-15	PAY-PRM-1768479711-C1-22	Pembayaran Order PRM-1768479711-C1 (CASH)	DRAFT	2026	1	2026-01-15 19:21:51	2026-01-15 19:21:51
26	1	2026-01-15	FEE-ACCR-10	Akru Fee order #PRM-1768479711-C1	DRAFT	2026	1	2026-01-15 19:21:51	2026-01-15 19:21:51
27	1	2026-01-15	PAY-PRM-1768480248-C1-23	Pembayaran Order PRM-1768480248-C1 (CASH)	DRAFT	2026	1	2026-01-15 19:30:48	2026-01-15 19:30:48
28	1	2026-01-15	FEE-ACCR-11	Akru Fee order #PRM-1768480248-C1	DRAFT	2026	1	2026-01-15 19:30:49	2026-01-15 19:30:49
30	1	2026-01-15	PAY-PRM-1768480452-C1-25	Pembayaran Order PRM-1768480452-C1 (CASH)	DRAFT	2026	1	2026-01-15 19:34:12	2026-01-15 19:34:12
31	1	2026-01-15	FEE-ACCR-12	Akru Fee order #PRM-1768480452-C1	DRAFT	2026	1	2026-01-15 19:34:12	2026-01-15 19:34:12
34	1	2026-01-15	PAY-PRM-1768480755-C1-28	Pembayaran Order PRM-1768480755-C1 (CASH)	DRAFT	2026	1	2026-01-15 19:39:15	2026-01-15 19:39:15
35	1	2026-01-15	FEE-ACCR-13	Akru Fee order #PRM-1768480755-C1	DRAFT	2026	1	2026-01-15 19:39:15	2026-01-15 19:39:15
37	1	2026-01-15	PAY-PRM-1768492416-C1-31	Pembayaran Order PRM-1768492416-C1 (CASH)	DRAFT	2026	1	2026-01-15 22:53:36	2026-01-15 22:53:36
38	1	2026-01-15	FEE-ACCR-14	Akru Fee order #PRM-1768492416-C1	DRAFT	2026	1	2026-01-15 22:53:36	2026-01-15 22:53:36
39	1	2026-01-15	PAY-PRM-1768492455-C1-32	Pembayaran Order PRM-1768492455-C1 (CASH)	DRAFT	2026	1	2026-01-15 22:54:15	2026-01-15 22:54:15
40	1	2026-01-15	FEE-ACCR-15	Akru Fee order #PRM-1768492455-C1	DRAFT	2026	1	2026-01-15 22:54:15	2026-01-15 22:54:15
41	1	2026-01-15	PAY-PRM-1768492470-C1-33	Pembayaran Order PRM-1768492470-C1 (CASH)	DRAFT	2026	1	2026-01-15 22:54:30	2026-01-15 22:54:30
42	1	2026-01-15	FEE-ACCR-16	Akru Fee order #PRM-1768492470-C1	DRAFT	2026	1	2026-01-15 22:54:30	2026-01-15 22:54:30
43	1	2026-01-15	PAY-PRM-1768492516-C1-34	Pembayaran Order PRM-1768492516-C1 (CASH)	DRAFT	2026	1	2026-01-15 22:55:16	2026-01-15 22:55:16
44	1	2026-01-15	FEE-ACCR-17	Akru Fee order #PRM-1768492516-C1	DRAFT	2026	1	2026-01-15 22:55:16	2026-01-15 22:55:16
45	1	2026-01-15	PAY-PRM-1768492527-C1-35	Pembayaran Order PRM-1768492527-C1 (CASH)	DRAFT	2026	1	2026-01-15 22:55:27	2026-01-15 22:55:27
46	1	2026-01-15	FEE-ACCR-18	Akru Fee order #PRM-1768492527-C1	DRAFT	2026	1	2026-01-15 22:55:27	2026-01-15 22:55:27
47	1	2026-01-15	PAY-PRM-1768492536-C1-36	Pembayaran Order PRM-1768492536-C1 (CASH)	DRAFT	2026	1	2026-01-15 22:55:36	2026-01-15 22:55:36
48	1	2026-01-15	FEE-ACCR-19	Akru Fee order #PRM-1768492536-C1	DRAFT	2026	1	2026-01-15 22:55:36	2026-01-15 22:55:36
\.


--
-- Data for Name: journal_lines; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."journal_lines" ("id", "journal_id", "account_id", "cabang_id", "debit", "credit", "ref_type", "ref_id", "created_at", "updated_at") FROM stdin;
1	1	3	1	250000.00	0.00	ORDER_PAYMENT	1	2025-11-10 14:25:01	2025-11-10 14:25:01
2	1	13	1	0.00	250000.00	ORDER_PAYMENT	1	2025-11-10 14:25:01	2025-11-10 14:25:01
3	2	3	1	50000.00	0.00	ORDER_PAYMENT	7	2025-11-20 16:12:50	2025-11-20 16:12:50
4	2	13	1	0.00	50000.00	ORDER_PAYMENT	7	2025-11-20 16:12:50	2025-11-20 16:12:50
5	3	3	1	1050000.00	0.00	ORDER_PAYMENT	8	2025-12-24 00:46:12	2025-12-24 00:46:12
6	3	13	1	0.00	1050000.00	ORDER_PAYMENT	8	2025-12-24 00:46:12	2025-12-24 00:46:12
7	4	17	1	5000.00	0.00	FEE_ENTRY	1	2025-12-24 00:46:12	2025-12-24 00:46:12
8	4	8	1	0.00	5000.00	FEE_ENTRY	1	2025-12-24 00:46:12	2025-12-24 00:46:12
9	5	3	1	250000.00	0.00	ORDER_PAYMENT	9	2025-12-24 00:46:25	2025-12-24 00:46:25
10	5	13	1	0.00	250000.00	ORDER_PAYMENT	9	2025-12-24 00:46:25	2025-12-24 00:46:25
11	6	17	1	5000.00	0.00	FEE_ENTRY	2	2025-12-24 00:46:25	2025-12-24 00:46:25
12	6	8	1	0.00	5000.00	FEE_ENTRY	2	2025-12-24 00:46:25	2025-12-24 00:46:25
13	7	3	1	250000.00	0.00	ORDER_PAYMENT	10	2025-12-24 00:46:36	2025-12-24 00:46:36
14	7	13	1	0.00	250000.00	ORDER_PAYMENT	10	2025-12-24 00:46:36	2025-12-24 00:46:36
15	8	17	1	5000.00	0.00	FEE_ENTRY	3	2025-12-24 00:46:36	2025-12-24 00:46:36
16	8	8	1	0.00	5000.00	FEE_ENTRY	3	2025-12-24 00:46:36	2025-12-24 00:46:36
17	9	4	1	1550000.00	0.00	CASH_MOVE	2	2025-12-24 00:48:58	2025-12-24 00:48:58
18	9	3	1	0.00	1550000.00	CASH_MOVE	2	2025-12-24 00:48:58	2025-12-24 00:48:58
19	10	3	1	50000.00	0.00	ORDER_PAYMENT	11	2025-12-24 04:32:27	2025-12-24 04:32:27
20	10	13	1	0.00	50000.00	ORDER_PAYMENT	11	2025-12-24 04:32:27	2025-12-24 04:32:27
21	11	3	1	400000.00	0.00	ORDER_PAYMENT	12	2025-12-24 04:33:00	2025-12-24 04:33:00
22	11	13	1	0.00	400000.00	ORDER_PAYMENT	12	2025-12-24 04:33:00	2025-12-24 04:33:00
23	12	17	1	5000.00	0.00	FEE_ENTRY	4	2025-12-24 04:33:00	2025-12-24 04:33:00
24	12	8	1	0.00	5000.00	FEE_ENTRY	4	2025-12-24 04:33:00	2025-12-24 04:33:00
25	13	3	1	100000.00	0.00	ORDER_PAYMENT	13	2025-12-24 04:33:28	2025-12-24 04:33:28
26	13	13	1	0.00	100000.00	ORDER_PAYMENT	13	2025-12-24 04:33:28	2025-12-24 04:33:28
27	14	17	1	5000.00	0.00	FEE_ENTRY	5	2025-12-24 04:33:28	2025-12-24 04:33:28
28	14	8	1	0.00	5000.00	FEE_ENTRY	5	2025-12-24 04:33:28	2025-12-24 04:33:28
29	15	3	1	250000.00	0.00	ORDER_PAYMENT	16	2026-01-14 23:26:31	2026-01-14 23:26:31
30	15	13	1	0.00	250000.00	ORDER_PAYMENT	16	2026-01-14 23:26:31	2026-01-14 23:26:31
31	16	17	1	5000.00	0.00	FEE_ENTRY	6	2026-01-14 23:26:31	2026-01-14 23:26:31
32	16	8	1	0.00	5000.00	FEE_ENTRY	6	2026-01-14 23:26:31	2026-01-14 23:26:31
33	17	3	1	85000.00	0.00	ORDER_PAYMENT	17	2026-01-14 23:28:39	2026-01-14 23:28:39
34	17	13	1	0.00	85000.00	ORDER_PAYMENT	17	2026-01-14 23:28:39	2026-01-14 23:28:39
35	18	17	1	5000.00	0.00	FEE_ENTRY	7	2026-01-14 23:28:39	2026-01-14 23:28:39
36	18	8	1	0.00	5000.00	FEE_ENTRY	7	2026-01-14 23:28:39	2026-01-14 23:28:39
39	20	3	1	650000.00	0.00	ORDER_PAYMENT	19	2026-01-15 00:49:21	2026-01-15 00:49:21
40	20	13	1	0.00	650000.00	ORDER_PAYMENT	19	2026-01-15 00:49:21	2026-01-15 00:49:21
41	21	17	1	5000.00	0.00	FEE_ENTRY	8	2026-01-15 00:49:21	2026-01-15 00:49:21
42	21	8	1	0.00	5000.00	FEE_ENTRY	8	2026-01-15 00:49:21	2026-01-15 00:49:21
45	23	3	1	650000.00	0.00	ORDER_PAYMENT	21	2026-01-15 19:04:03	2026-01-15 19:04:03
46	23	13	1	0.00	650000.00	ORDER_PAYMENT	21	2026-01-15 19:04:03	2026-01-15 19:04:03
47	24	17	1	5000.00	0.00	FEE_ENTRY	9	2026-01-15 19:04:03	2026-01-15 19:04:03
48	24	8	1	0.00	5000.00	FEE_ENTRY	9	2026-01-15 19:04:03	2026-01-15 19:04:03
49	25	3	1	400000.00	0.00	ORDER_PAYMENT	22	2026-01-15 19:21:51	2026-01-15 19:21:51
50	25	13	1	0.00	400000.00	ORDER_PAYMENT	22	2026-01-15 19:21:51	2026-01-15 19:21:51
51	26	17	1	5000.00	0.00	FEE_ENTRY	10	2026-01-15 19:21:51	2026-01-15 19:21:51
52	26	8	1	0.00	5000.00	FEE_ENTRY	10	2026-01-15 19:21:51	2026-01-15 19:21:51
53	27	3	1	400000.00	0.00	ORDER_PAYMENT	23	2026-01-15 19:30:48	2026-01-15 19:30:48
54	27	13	1	0.00	400000.00	ORDER_PAYMENT	23	2026-01-15 19:30:48	2026-01-15 19:30:48
55	28	17	1	5000.00	0.00	FEE_ENTRY	11	2026-01-15 19:30:49	2026-01-15 19:30:49
56	28	8	1	0.00	5000.00	FEE_ENTRY	11	2026-01-15 19:30:49	2026-01-15 19:30:49
59	30	3	1	650000.00	0.00	ORDER_PAYMENT	25	2026-01-15 19:34:12	2026-01-15 19:34:12
60	30	13	1	0.00	650000.00	ORDER_PAYMENT	25	2026-01-15 19:34:12	2026-01-15 19:34:12
61	31	17	1	5000.00	0.00	FEE_ENTRY	12	2026-01-15 19:34:12	2026-01-15 19:34:12
62	31	8	1	0.00	5000.00	FEE_ENTRY	12	2026-01-15 19:34:12	2026-01-15 19:34:12
67	34	3	1	150000.00	0.00	ORDER_PAYMENT	28	2026-01-15 19:39:15	2026-01-15 19:39:15
68	34	13	1	0.00	150000.00	ORDER_PAYMENT	28	2026-01-15 19:39:15	2026-01-15 19:39:15
69	35	17	1	5000.00	0.00	FEE_ENTRY	13	2026-01-15 19:39:15	2026-01-15 19:39:15
70	35	8	1	0.00	5000.00	FEE_ENTRY	13	2026-01-15 19:39:15	2026-01-15 19:39:15
73	37	3	1	85000.00	0.00	ORDER_PAYMENT	31	2026-01-15 22:53:36	2026-01-15 22:53:36
74	37	13	1	0.00	85000.00	ORDER_PAYMENT	31	2026-01-15 22:53:36	2026-01-15 22:53:36
75	38	17	1	5000.00	0.00	FEE_ENTRY	14	2026-01-15 22:53:36	2026-01-15 22:53:36
76	38	8	1	0.00	5000.00	FEE_ENTRY	14	2026-01-15 22:53:36	2026-01-15 22:53:36
77	39	3	1	85000.00	0.00	ORDER_PAYMENT	32	2026-01-15 22:54:15	2026-01-15 22:54:15
78	39	13	1	0.00	85000.00	ORDER_PAYMENT	32	2026-01-15 22:54:15	2026-01-15 22:54:15
79	40	17	1	5000.00	0.00	FEE_ENTRY	15	2026-01-15 22:54:15	2026-01-15 22:54:15
80	40	8	1	0.00	5000.00	FEE_ENTRY	15	2026-01-15 22:54:15	2026-01-15 22:54:15
81	41	3	1	250000.00	0.00	ORDER_PAYMENT	33	2026-01-15 22:54:30	2026-01-15 22:54:30
82	41	13	1	0.00	250000.00	ORDER_PAYMENT	33	2026-01-15 22:54:30	2026-01-15 22:54:30
83	42	17	1	5000.00	0.00	FEE_ENTRY	16	2026-01-15 22:54:30	2026-01-15 22:54:30
84	42	8	1	0.00	5000.00	FEE_ENTRY	16	2026-01-15 22:54:30	2026-01-15 22:54:30
85	43	3	1	250000.00	0.00	ORDER_PAYMENT	34	2026-01-15 22:55:16	2026-01-15 22:55:16
86	43	13	1	0.00	250000.00	ORDER_PAYMENT	34	2026-01-15 22:55:16	2026-01-15 22:55:16
87	44	17	1	5000.00	0.00	FEE_ENTRY	17	2026-01-15 22:55:16	2026-01-15 22:55:16
88	44	8	1	0.00	5000.00	FEE_ENTRY	17	2026-01-15 22:55:16	2026-01-15 22:55:16
89	45	3	1	85000.00	0.00	ORDER_PAYMENT	35	2026-01-15 22:55:27	2026-01-15 22:55:27
90	45	13	1	0.00	85000.00	ORDER_PAYMENT	35	2026-01-15 22:55:27	2026-01-15 22:55:27
91	46	17	1	5000.00	0.00	FEE_ENTRY	18	2026-01-15 22:55:27	2026-01-15 22:55:27
92	46	8	1	0.00	5000.00	FEE_ENTRY	18	2026-01-15 22:55:27	2026-01-15 22:55:27
93	47	3	1	85000.00	0.00	ORDER_PAYMENT	36	2026-01-15 22:55:36	2026-01-15 22:55:36
94	47	13	1	0.00	85000.00	ORDER_PAYMENT	36	2026-01-15 22:55:36	2026-01-15 22:55:36
95	48	17	1	5000.00	0.00	FEE_ENTRY	19	2026-01-15 22:55:36	2026-01-15 22:55:36
96	48	8	1	0.00	5000.00	FEE_ENTRY	19	2026-01-15 22:55:36	2026-01-15 22:55:36
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."migrations" ("id", "migration", "batch") FROM stdin;
1	0001_01_01_000000_create_users_table	1
2	0001_01_01_000001_create_cache_table	1
3	0001_01_01_000002_create_jobs_table	1
4	2025_10_10_163000_create_personal_access_tokens_table	1
5	2025_10_10_163102_create_permission_tables	1
6	2025_10_10_235604_add_email_verified_at_to_users_table	1
7	2025_10_11_034254_create_cabangs_table	1
8	2025_10_11_034314_create_gudangs_table	1
9	2025_10_11_034328_alter_users_add_fk_cabang	1
10	2025_10_11_155442_create_categories_table	1
11	2025_10_11_164844_create_products_table	1
12	2025_10_11_164857_create_product_variants_table	1
13	2025_10_11_164921_create_product_media_table	1
14	2025_10_11_222030_create_variant_stocks_table	1
15	2025_10_13_163035_create_orders_table	1
16	2025_10_13_163117_create_order_items_table	1
17	2025_10_13_163143_create_payments_table	1
18	2025_10_15_141249_add_indexes_to_product_media_table	1
19	2025_10_16_114348_create_audit_logs_table	1
20	2025_10_16_144328_create_deliveries_table	1
21	2025_10_16_144357_create_delivery_events_table	1
22	2025_10_17_094949_create_cash_tables	1
23	2025_10_19_140501_create_fees_table	1
24	2025_10_19_140645_create_fee_entries_table	1
25	2025_10_19_211100_add_paid_at_to_orders_table	1
26	2025_10_21_110720_create_customers_tables	1
27	2025_10_21_111710_create_customer_timelines_table	1
28	2025_10_21_111736_add_fk_orders_customer	1
29	2025_10_23_155723_create_settings_table	1
30	2025_10_23_155810_create_backups_table	1
31	2025_10_23_164213_alter_audit_logs_add_occurred_at	1
32	2025_10_24_141645_create_accounts_table	1
33	2025_10_24_141733_create_fiscal_periods_table	1
34	2025_10_24_141758_create_journal_entries_table	1
35	2025_10_24_141829_create_journal_lines_table	1
36	2025_10_28_150702_add_customer_snapshot_to_orders	1
37	2025_10_29_095742_add_cash_position_to_orders	1
38	2025_10_29_113547_order_change_logs_table	1
39	2025_10_29_131948_create_receipts_table	1
40	2025_10_29_144826_add_sj_columns_to_deliveries_table	1
41	2025_12_24_014220_create_stock_lots_table	2
42	2025_12_24_014316_create_stock_movements_table	2
43	2025_12_24_015322_create_order_item_lot_allocations_table	2
44	2025_12_24_015343_add_rop_fields_to_variant_stocks_table	2
\.


--
-- Data for Name: model_has_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."model_has_permissions" ("permission_id", "model_type", "model_id") FROM stdin;
\.


--
-- Data for Name: model_has_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."model_has_roles" ("role_id", "model_type", "model_id") FROM stdin;
1	App\\Models\\User	1
2	App\\Models\\User	2
3	App\\Models\\User	3
4	App\\Models\\User	4
\.


--
-- Data for Name: order_change_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."order_change_logs" ("id", "order_id", "actor_id", "action", "diff_json", "note", "occurred_at", "created_at", "updated_at") FROM stdin;
1	1	3	REPRINT	{"format":58}	\N	2025-11-10 14:25:01+07	2025-11-10 14:25:01+07	2025-11-10 14:25:01+07
2	1	3	REPRINT	{"format":58}	\N	2025-11-10 14:25:01+07	2025-11-10 14:25:01+07	2025-11-10 14:25:01+07
3	4	3	REPRINT	{"format":58}	\N	2025-11-10 14:52:53+07	2025-11-10 14:52:53+07	2025-11-10 14:52:53+07
4	4	3	REPRINT	{"format":58}	\N	2025-11-10 14:52:53+07	2025-11-10 14:52:53+07	2025-11-10 14:52:53+07
5	5	3	REPRINT	{"format":58}	\N	2025-11-10 14:57:37+07	2025-11-10 14:57:37+07	2025-11-10 14:57:37+07
6	5	3	REPRINT	{"format":58}	\N	2025-11-10 14:57:37+07	2025-11-10 14:57:37+07	2025-11-10 14:57:37+07
7	6	3	REPRINT	{"format":58}	\N	2025-11-10 15:20:55+07	2025-11-10 15:20:55+07	2025-11-10 15:20:55+07
8	6	3	REPRINT	{"format":58}	\N	2025-11-10 15:20:55+07	2025-11-10 15:20:55+07	2025-11-10 15:20:55+07
9	7	3	REPRINT	{"format":58}	\N	2025-11-10 15:36:43+07	2025-11-10 15:36:43+07	2025-11-10 15:36:43+07
10	7	3	REPRINT	{"format":58}	\N	2025-11-10 15:36:43+07	2025-11-10 15:36:43+07	2025-11-10 15:36:43+07
11	8	2	REPRINT	{"format":58}	\N	2025-11-20 16:12:50+07	2025-11-20 16:12:50+07	2025-11-20 16:12:50+07
12	8	2	REPRINT	{"format":58}	\N	2025-11-20 16:12:50+07	2025-11-20 16:12:50+07	2025-11-20 16:12:50+07
13	9	3	REPRINT	{"format":58}	\N	2025-12-24 04:32:27+07	2025-12-24 04:32:27+07	2025-12-24 04:32:27+07
14	9	3	REPRINT	{"format":58}	\N	2025-12-24 04:32:27+07	2025-12-24 04:32:27+07	2025-12-24 04:32:27+07
15	10	3	REPRINT	{"format":58}	\N	2025-12-24 04:33:00+07	2025-12-24 04:33:00+07	2025-12-24 04:33:00+07
16	11	3	REPRINT	{"format":58}	\N	2026-01-12 21:52:41+07	2026-01-12 21:52:41+07	2026-01-12 21:52:41+07
17	11	3	REPRINT	{"format":58}	\N	2026-01-12 21:52:41+07	2026-01-12 21:52:41+07	2026-01-12 21:52:41+07
18	12	2	REPRINT	{"format":58}	\N	2026-01-14 23:25:30+07	2026-01-14 23:25:30+07	2026-01-14 23:25:30+07
19	12	2	REPRINT	{"format":58}	\N	2026-01-14 23:25:30+07	2026-01-14 23:25:30+07	2026-01-14 23:25:30+07
20	13	2	REPRINT	{"format":58}	\N	2026-01-14 23:28:40+07	2026-01-14 23:28:40+07	2026-01-14 23:28:40+07
21	13	2	REPRINT	{"format":58}	\N	2026-01-14 23:28:40+07	2026-01-14 23:28:40+07	2026-01-14 23:28:40+07
22	15	2	REPRINT	{"format":58}	\N	2026-01-15 00:49:21+07	2026-01-15 00:49:21+07	2026-01-15 00:49:21+07
23	15	2	REPRINT	{"format":58}	\N	2026-01-15 00:49:21+07	2026-01-15 00:49:21+07	2026-01-15 00:49:21+07
24	17	3	REPRINT	{"format":58}	\N	2026-01-15 19:04:03+07	2026-01-15 19:04:03+07	2026-01-15 19:04:03+07
25	17	3	REPRINT	{"format":58}	\N	2026-01-15 19:04:04+07	2026-01-15 19:04:04+07	2026-01-15 19:04:04+07
26	18	3	REPRINT	{"format":58}	\N	2026-01-15 19:21:51+07	2026-01-15 19:21:51+07	2026-01-15 19:21:51+07
27	18	3	REPRINT	{"format":58}	\N	2026-01-15 19:21:51+07	2026-01-15 19:21:51+07	2026-01-15 19:21:51+07
28	19	3	REPRINT	{"format":58}	\N	2026-01-15 19:30:49+07	2026-01-15 19:30:49+07	2026-01-15 19:30:49+07
29	19	3	REPRINT	{"format":58}	\N	2026-01-15 19:30:49+07	2026-01-15 19:30:49+07	2026-01-15 19:30:49+07
30	21	3	REPRINT	{"format":58}	\N	2026-01-15 19:34:13+07	2026-01-15 19:34:13+07	2026-01-15 19:34:13+07
31	21	3	REPRINT	{"format":58}	\N	2026-01-15 19:34:13+07	2026-01-15 19:34:13+07	2026-01-15 19:34:13+07
32	24	3	REPRINT	{"format":58}	\N	2026-01-15 19:39:15+07	2026-01-15 19:39:15+07	2026-01-15 19:39:15+07
33	24	3	REPRINT	{"format":58}	\N	2026-01-15 19:39:15+07	2026-01-15 19:39:15+07	2026-01-15 19:39:15+07
34	27	3	REPRINT	{"format":58}	\N	2026-01-15 22:53:36+07	2026-01-15 22:53:36+07	2026-01-15 22:53:36+07
35	27	3	REPRINT	{"format":58}	\N	2026-01-15 22:53:36+07	2026-01-15 22:53:36+07	2026-01-15 22:53:36+07
36	28	3	REPRINT	{"format":58}	\N	2026-01-15 22:54:15+07	2026-01-15 22:54:15+07	2026-01-15 22:54:15+07
37	29	3	REPRINT	{"format":58}	\N	2026-01-15 22:54:30+07	2026-01-15 22:54:30+07	2026-01-15 22:54:30+07
38	29	3	REPRINT	{"format":58}	\N	2026-01-15 22:54:30+07	2026-01-15 22:54:30+07	2026-01-15 22:54:30+07
39	30	3	REPRINT	{"format":58}	\N	2026-01-15 22:55:16+07	2026-01-15 22:55:16+07	2026-01-15 22:55:16+07
40	31	3	REPRINT	{"format":58}	\N	2026-01-15 22:55:27+07	2026-01-15 22:55:27+07	2026-01-15 22:55:27+07
41	32	3	REPRINT	{"format":58}	\N	2026-01-15 22:55:37+07	2026-01-15 22:55:37+07	2026-01-15 22:55:37+07
\.


--
-- Data for Name: order_item_lot_allocations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."order_item_lot_allocations" ("id", "order_item_id", "stock_lot_id", "qty_allocated", "unit_cost", "created_at", "updated_at") FROM stdin;
1	11	5	1	\N	2025-12-24 04:33:00	2025-12-24 04:33:00
2	12	1	1	\N	2025-12-24 04:33:00	2025-12-24 04:33:00
3	10	1	1	\N	2025-12-24 04:33:28	2025-12-24 04:33:28
4	15	3	1	\N	2026-01-14 23:26:31	2026-01-14 23:26:31
5	16	7	1	\N	2026-01-14 23:28:39	2026-01-14 23:28:39
6	20	3	1	\N	2026-01-15 00:49:21	2026-01-15 00:49:21
7	21	1	1	\N	2026-01-15 00:49:21	2026-01-15 00:49:21
8	22	5	1	\N	2026-01-15 00:49:21	2026-01-15 00:49:21
9	26	3	1	\N	2026-01-15 19:04:03	2026-01-15 19:04:03
10	27	1	1	\N	2026-01-15 19:04:03	2026-01-15 19:04:03
11	28	5	1	\N	2026-01-15 19:04:03	2026-01-15 19:04:03
12	29	1	1	\N	2026-01-15 19:21:51	2026-01-15 19:21:51
13	30	5	1	\N	2026-01-15 19:21:51	2026-01-15 19:21:51
14	31	2	1	\N	2026-01-15 19:30:49	2026-01-15 19:30:49
15	32	5	1	\N	2026-01-15 19:30:49	2026-01-15 19:30:49
17	35	3	2	\N	2026-01-15 19:34:12	2026-01-15 19:34:12
18	36	2	1	\N	2026-01-15 19:34:12	2026-01-15 19:34:12
21	41	2	1	\N	2026-01-15 19:39:15	2026-01-15 19:39:15
22	44	9	1	\N	2026-01-15 22:53:36	2026-01-15 22:53:36
23	45	9	1	\N	2026-01-15 22:54:15	2026-01-15 22:54:15
24	46	6	1	\N	2026-01-15 22:54:30	2026-01-15 22:54:30
25	47	6	1	\N	2026-01-15 22:55:16	2026-01-15 22:55:16
26	48	9	1	\N	2026-01-15 22:55:27	2026-01-15 22:55:27
27	49	9	1	\N	2026-01-15 22:55:36	2026-01-15 22:55:36
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."order_items" ("id", "order_id", "variant_id", "name_snapshot", "price", "discount", "qty", "line_total", "created_at", "updated_at") FROM stdin;
1	1	1	choco flavour - 	250000.00	0.00	1.00	250000.00	2025-11-10 14:25:01	2025-11-10 14:25:01
4	4	1	choco flavour - 	250000.00	0.00	1.00	250000.00	2025-11-10 14:52:52	2025-11-10 14:52:52
5	5	1	choco flavour - 	250000.00	0.00	3.00	750000.00	2025-11-10 14:57:37	2025-11-10 14:57:37
6	6	1	choco flavour - 	250000.00	0.00	1.00	250000.00	2025-11-10 15:20:54	2025-11-10 15:20:54
7	7	1	choco flavour - 	250000.00	0.00	1.00	250000.00	2025-11-10 15:36:42	2025-11-10 15:36:42
8	8	2	choco flavour - 	150000.00	0.00	4.00	600000.00	2025-11-20 16:12:50	2025-11-20 16:12:50
9	8	1	choco flavour - 	250000.00	0.00	2.00	500000.00	2025-11-20 16:12:50	2025-11-20 16:12:50
10	9	2	choco flavour - 	150000.00	0.00	1.00	150000.00	2025-12-24 04:32:27	2025-12-24 04:32:27
11	10	1	choco flavour - 	250000.00	0.00	1.00	250000.00	2025-12-24 04:33:00	2025-12-24 04:33:00
12	10	2	choco flavour - 	150000.00	0.00	1.00	150000.00	2025-12-24 04:33:00	2025-12-24 04:33:00
13	11	2	choco flavour - 	150000.00	0.00	1.00	150000.00	2026-01-12 21:52:38	2026-01-12 21:52:38
14	11	1	choco flavour - 	250000.00	0.00	1.00	250000.00	2026-01-12 21:52:38	2026-01-12 21:52:38
15	12	3	Choco lover - 	250000.00	0.00	1.00	250000.00	2026-01-14 23:25:32	2026-01-14 23:25:32
16	13	4	Tube Class - 	85000.00	0.00	1.00	85000.00	2026-01-14 23:28:39	2026-01-14 23:28:39
20	15	3	Choco lover - 	250000.00	0.00	1.00	250000.00	2026-01-15 00:49:21	2026-01-15 00:49:21
21	15	2	choco flavour - 	150000.00	0.00	1.00	150000.00	2026-01-15 00:49:21	2026-01-15 00:49:21
22	15	1	choco flavour - 	250000.00	0.00	1.00	250000.00	2026-01-15 00:49:21	2026-01-15 00:49:21
26	17	3	Choco lover - 	250000.00	0.00	1.00	250000.00	2026-01-15 19:04:03	2026-01-15 19:04:03
27	17	2	choco flavour - 	150000.00	0.00	1.00	150000.00	2026-01-15 19:04:03	2026-01-15 19:04:03
28	17	1	choco flavour - 	250000.00	0.00	1.00	250000.00	2026-01-15 19:04:03	2026-01-15 19:04:03
29	18	2	choco flavour - 	150000.00	0.00	1.00	150000.00	2026-01-15 19:21:51	2026-01-15 19:21:51
30	18	1	choco flavour - 	250000.00	0.00	1.00	250000.00	2026-01-15 19:21:51	2026-01-15 19:21:51
31	19	2	choco flavour - 	150000.00	0.00	1.00	150000.00	2026-01-15 19:30:48	2026-01-15 19:30:48
32	19	1	choco flavour - 	250000.00	0.00	1.00	250000.00	2026-01-15 19:30:48	2026-01-15 19:30:48
35	21	3	Choco lover - 	250000.00	0.00	2.00	500000.00	2026-01-15 19:34:12	2026-01-15 19:34:12
36	21	2	choco flavour - 	150000.00	0.00	1.00	150000.00	2026-01-15 19:34:12	2026-01-15 19:34:12
41	24	2	choco flavour - 	150000.00	0.00	1.00	150000.00	2026-01-15 19:39:15	2026-01-15 19:39:15
44	27	4	Tube Class - 	85000.00	0.00	1.00	85000.00	2026-01-15 22:53:36	2026-01-15 22:53:36
45	28	4	Tube Class - 	85000.00	0.00	1.00	85000.00	2026-01-15 22:54:15	2026-01-15 22:54:15
46	29	3	Choco lover - 	250000.00	0.00	1.00	250000.00	2026-01-15 22:54:30	2026-01-15 22:54:30
47	30	3	Choco lover - 	250000.00	0.00	1.00	250000.00	2026-01-15 22:55:16	2026-01-15 22:55:16
48	31	4	Tube Class - 	85000.00	0.00	1.00	85000.00	2026-01-15 22:55:27	2026-01-15 22:55:27
49	32	4	Tube Class - 	85000.00	0.00	1.00	85000.00	2026-01-15 22:55:36	2026-01-15 22:55:36
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."orders" ("id", "kode", "cabang_id", "gudang_id", "cashier_id", "customer_id", "status", "subtotal", "discount", "tax", "service_fee", "grand_total", "paid_total", "channel", "note", "ordered_at", "created_at", "updated_at", "paid_at", "customer_name", "customer_phone", "customer_address", "cash_position") FROM stdin;
1	PRM-1762759501-C1	1	1	3	1	PAID	250000.00	0.00	0.00	0.00	250000.00	250000.00	POS	\N	2025-11-10 14:25:01	2025-11-10 14:25:01	2025-11-10 14:25:01	2025-11-10 14:25:01+07	galuh	081214695222	\N	CUSTOMER
4	PRM-1762761172-C1	1	1	3	1	UNPAID	250000.00	0.00	0.00	0.00	250000.00	0.00	POS	\N	2025-11-10 14:52:52	2025-11-10 14:52:52	2025-11-10 14:52:52	\N	galuh	081214695222	\N	CASHIER
5	PRM-1762761457-C1	1	1	3	1	UNPAID	750000.00	0.00	0.00	0.00	750000.00	0.00	POS	\N	2025-11-10 14:57:37	2025-11-10 14:57:37	2025-11-10 14:57:37	\N	galuh	081214695222	\N	CASHIER
8	PRM-1763629970-C1	1	1	2	2	PAID	1100000.00	0.00	0.00	0.00	1100000.00	1100000.00	POS	\N	2025-11-20 16:12:50	2025-11-20 16:12:50	2025-12-24 00:46:12	2025-12-24 00:46:12+07	Mang Aden	08586554548788	\N	CUSTOMER
24	PRM-1768480755-C1	1	1	3	1	PAID	150000.00	0.00	0.00	0.00	150000.00	150000.00	POS	\N	2026-01-15 19:39:15	2026-01-15 19:39:15	2026-01-15 19:39:15	2026-01-15 19:39:15+07	galuh	081214695222	\N	CASHIER
7	PRM-1762763802-C1	1	1	3	1	PAID	250000.00	0.00	0.00	0.00	250000.00	250000.00	POS	\N	2025-11-10 15:36:42	2025-11-10 15:36:42	2025-12-24 00:46:25	2025-12-24 00:46:25+07	galuh	081214695222	\N	CASHIER
17	PRM-1768478643-C1	1	1	3	1	PAID	650000.00	0.00	0.00	0.00	650000.00	650000.00	POS	\N	2026-01-15 19:04:03	2026-01-15 19:04:03	2026-01-15 19:04:03	2026-01-15 19:04:03+07	galuh	081214695222	\N	CASHIER
6	PRM-1762762854-C1	1	1	3	1	PAID	250000.00	0.00	0.00	0.00	250000.00	250000.00	POS	\N	2025-11-10 15:20:54	2025-11-10 15:20:54	2025-12-24 00:46:36	2025-12-24 00:46:36+07	galuh	081214695222	\N	CASHIER
10	PRM-1766525580-C1	1	1	3	2	PAID	400000.00	0.00	0.00	0.00	400000.00	400000.00	POS	\N	2025-12-24 04:33:00	2025-12-24 04:33:00	2025-12-24 04:33:00	2025-12-24 04:33:00+07	Mang Aden	08586554548788	\N	CASHIER
18	PRM-1768479711-C1	1	1	3	4	PAID	400000.00	0.00	0.00	0.00	400000.00	400000.00	POS	\N	2026-01-15 19:21:51	2026-01-15 19:21:51	2026-01-15 19:21:51	2026-01-15 19:21:51+07	jajang	081452565585	\N	CASHIER
9	PRM-1766525547-C1	1	1	3	1	PAID	150000.00	0.00	0.00	0.00	150000.00	150000.00	POS	\N	2025-12-24 04:32:27	2025-12-24 04:32:27	2025-12-24 04:33:28	2025-12-24 04:33:28+07	galuh	081214695222	\N	CASHIER
11	PRM-1768229558-C1	1	1	3	1	UNPAID	400000.00	0.00	0.00	0.00	400000.00	0.00	POS	\N	2026-01-12 21:52:38	2026-01-12 21:52:38	2026-01-12 21:52:38	\N	galuh	081214695222	\N	CASHIER
12	PRM-1768407932-C1	1	1	2	1	PAID	250000.00	0.00	0.00	0.00	250000.00	250000.00	POS	\N	2026-01-14 23:25:32	2026-01-14 23:25:32	2026-01-14 23:26:31	2026-01-14 23:26:31+07	galuh	081214695222	\N	CASHIER
31	PRM-1768492527-C1	1	1	3	3	PAID	85000.00	0.00	0.00	0.00	85000.00	85000.00	POS	\N	2026-01-15 22:55:27	2026-01-15 22:55:27	2026-01-15 22:55:27	2026-01-15 22:55:27+07	irfan	085865809424	\N	CASHIER
13	PRM-1768408119-C1	1	1	2	1	PAID	85000.00	0.00	0.00	0.00	85000.00	85000.00	POS	\N	2026-01-14 23:28:39	2026-01-14 23:28:39	2026-01-14 23:28:39	2026-01-14 23:28:39+07	galuh	081214695222	\N	CASHIER
19	PRM-1768480248-C1	1	1	3	1	PAID	400000.00	0.00	0.00	0.00	400000.00	400000.00	POS	\N	2026-01-15 19:30:48	2026-01-15 19:30:48	2026-01-15 19:30:49	2026-01-15 19:30:48+07	galuh	081214695222	\N	CASHIER
15	PRM-1768412961-C1	1	1	2	1	PAID	650000.00	0.00	0.00	0.00	650000.00	650000.00	POS	\N	2026-01-15 00:49:21	2026-01-15 00:49:21	2026-01-15 00:49:21	2026-01-15 00:49:21+07	galuh	081214695222	\N	CASHIER
21	PRM-1768480452-C1	1	1	3	1	PAID	650000.00	0.00	0.00	0.00	650000.00	650000.00	POS	\N	2026-01-15 19:34:12	2026-01-15 19:34:12	2026-01-15 19:34:12	2026-01-15 19:34:12+07	galuh	081214695222	\N	CASHIER
27	PRM-1768492416-C1	1	1	3	1	PAID	85000.00	0.00	0.00	0.00	85000.00	85000.00	POS	\N	2026-01-15 22:53:36	2026-01-15 22:53:36	2026-01-15 22:53:36	2026-01-15 22:53:36+07	galuh	081214695222	\N	CASHIER
32	PRM-1768492536-C1	1	1	3	1	PAID	85000.00	0.00	0.00	0.00	85000.00	85000.00	POS	\N	2026-01-15 22:55:36	2026-01-15 22:55:36	2026-01-15 22:55:36	2026-01-15 22:55:36+07	galuh	081214695222	\N	CASHIER
28	PRM-1768492455-C1	1	1	3	4	PAID	85000.00	0.00	0.00	0.00	85000.00	85000.00	POS	\N	2026-01-15 22:54:15	2026-01-15 22:54:15	2026-01-15 22:54:15	2026-01-15 22:54:15+07	jajang	081452565585	\N	CASHIER
29	PRM-1768492470-C1	1	1	3	1	PAID	250000.00	0.00	0.00	0.00	250000.00	250000.00	POS	\N	2026-01-15 22:54:30	2026-01-15 22:54:30	2026-01-15 22:54:30	2026-01-15 22:54:30+07	galuh	081214695222	\N	CASHIER
30	PRM-1768492516-C1	1	1	3	1	PAID	250000.00	0.00	0.00	0.00	250000.00	250000.00	POS	\N	2026-01-15 22:55:16	2026-01-15 22:55:16	2026-01-15 22:55:16	2026-01-15 22:55:16+07	galuh	081214695222	\N	CASHIER
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."payments" ("id", "order_id", "method", "amount", "status", "ref_no", "payload_json", "paid_at", "created_at", "updated_at") FROM stdin;
1	1	QRIS	250000.00	SUCCESS	\N	\N	2025-11-10 14:25:01	2025-11-10 14:25:01	2025-11-10 14:25:01
2	4	XENDIT	250000.00	PENDING	691199d43d7103f0eec3b119	{"checkout_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/691199d43d7103f0eec3b119","xendit":{"id":"691199d43d7103f0eec3b119","external_id":"ORD-PRM-1762761172-C1-1762761172","user_id":"69118173c7e3fbadc0029d08","status":"PENDING","merchant_name":"Project","merchant_profile_picture_url":"https:\\/\\/du8nwjtfkinx.cloudfront.net\\/xendit.png","amount":250000,"description":"Pembayaran Order PRM-1762761172-C1","expiry_date":"2025-11-11T07:52:52.668Z","invoice_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/691199d43d7103f0eec3b119","available_banks":[{"bank_code":"BNC","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BSI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"PERMATA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BCA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MANDIRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BJB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"SAHABAT_SAMPOERNA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MUAMALAT","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"CIMB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0}],"available_retail_outlets":[{"retail_outlet_name":"INDOMARET"},{"retail_outlet_name":"ALFAMART"}],"available_ewallets":[{"ewallet_type":"SHOPEEPAY"},{"ewallet_type":"ASTRAPAY"},{"ewallet_type":"JENIUSPAY"},{"ewallet_type":"DANA"},{"ewallet_type":"LINKAJA"},{"ewallet_type":"OVO"},{"ewallet_type":"NEXCASH"},{"ewallet_type":"GOPAY"}],"available_qr_codes":[{"qr_code_type":"QRIS"}],"available_direct_debits":[{"direct_debit_type":"DD_BRI"},{"direct_debit_type":"DD_MANDIRI"}],"available_paylaters":[{"paylater_type":"KREDIVO"},{"paylater_type":"AKULAKU"},{"paylater_type":"ATOME"}],"should_exclude_credit_card":false,"should_send_email":false,"success_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/success","failure_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/failed","created":"2025-11-10T07:52:52.876Z","updated":"2025-11-10T07:52:52.876Z","currency":"IDR","metadata":null}}	\N	2025-11-10 14:52:53	2025-11-10 14:52:53
3	6	XENDIT	250000.00	PENDING	6911a06682a2207940da19a8	{"checkout_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/6911a06682a2207940da19a8","xendit":{"id":"6911a06682a2207940da19a8","external_id":"ORD-PRM-1762762854-C1-1762762854","user_id":"69118173c7e3fbadc0029d08","status":"PENDING","merchant_name":"Project","merchant_profile_picture_url":"https:\\/\\/du8nwjtfkinx.cloudfront.net\\/xendit.png","amount":250000,"description":"Pembayaran Order PRM-1762762854-C1","expiry_date":"2025-11-11T08:20:55.168Z","invoice_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/6911a06682a2207940da19a8","available_banks":[{"bank_code":"BRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MUAMALAT","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MANDIRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"SAHABAT_SAMPOERNA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"PERMATA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BSI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"CIMB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BJB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BCA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNC","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0}],"available_retail_outlets":[{"retail_outlet_name":"INDOMARET"},{"retail_outlet_name":"ALFAMART"}],"available_ewallets":[{"ewallet_type":"SHOPEEPAY"},{"ewallet_type":"ASTRAPAY"},{"ewallet_type":"JENIUSPAY"},{"ewallet_type":"DANA"},{"ewallet_type":"LINKAJA"},{"ewallet_type":"OVO"},{"ewallet_type":"NEXCASH"},{"ewallet_type":"GOPAY"}],"available_qr_codes":[{"qr_code_type":"QRIS"}],"available_direct_debits":[{"direct_debit_type":"DD_BRI"},{"direct_debit_type":"DD_MANDIRI"}],"available_paylaters":[{"paylater_type":"KREDIVO"},{"paylater_type":"AKULAKU"},{"paylater_type":"ATOME"}],"should_exclude_credit_card":false,"should_send_email":false,"success_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/success","failure_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/failed","created":"2025-11-10T08:20:55.189Z","updated":"2025-11-10T08:20:55.189Z","currency":"IDR","metadata":null}}	\N	2025-11-10 15:20:55	2025-11-10 15:20:55
4	6	XENDIT	250000.00	PENDING	6911a2003d7103f0eec3bb4c	{"checkout_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/6911a2003d7103f0eec3bb4c","xendit":{"id":"6911a2003d7103f0eec3bb4c","external_id":"ORD-PRM-1762762854-C1-1762763264","user_id":"69118173c7e3fbadc0029d08","status":"PENDING","merchant_name":"Project","merchant_profile_picture_url":"https:\\/\\/du8nwjtfkinx.cloudfront.net\\/xendit.png","amount":250000,"description":"Pembayaran Order PRM-1762762854-C1","expiry_date":"2025-11-11T08:27:44.420Z","invoice_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/6911a2003d7103f0eec3bb4c","available_banks":[{"bank_code":"BRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MUAMALAT","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MANDIRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"SAHABAT_SAMPOERNA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"PERMATA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BSI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"CIMB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BJB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BCA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNC","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0}],"available_retail_outlets":[{"retail_outlet_name":"INDOMARET"},{"retail_outlet_name":"ALFAMART"}],"available_ewallets":[{"ewallet_type":"SHOPEEPAY"},{"ewallet_type":"ASTRAPAY"},{"ewallet_type":"JENIUSPAY"},{"ewallet_type":"DANA"},{"ewallet_type":"LINKAJA"},{"ewallet_type":"OVO"},{"ewallet_type":"NEXCASH"},{"ewallet_type":"GOPAY"}],"available_qr_codes":[{"qr_code_type":"QRIS"}],"available_direct_debits":[{"direct_debit_type":"DD_BRI"},{"direct_debit_type":"DD_MANDIRI"}],"available_paylaters":[{"paylater_type":"KREDIVO"},{"paylater_type":"AKULAKU"},{"paylater_type":"ATOME"}],"should_exclude_credit_card":false,"should_send_email":false,"success_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/success","failure_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/failed","created":"2025-11-10T08:27:44.524Z","updated":"2025-11-10T08:27:44.524Z","currency":"IDR","metadata":null}}	\N	2025-11-10 15:27:44	2025-11-10 15:27:44
5	7	XENDIT	250000.00	PENDING	6911a41b82a2207940da1d7f	{"checkout_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/6911a41b82a2207940da1d7f","xendit":{"id":"6911a41b82a2207940da1d7f","external_id":"ORD-PRM-1762763802-C1-1762763802","user_id":"69118173c7e3fbadc0029d08","status":"PENDING","merchant_name":"Project","merchant_profile_picture_url":"https:\\/\\/du8nwjtfkinx.cloudfront.net\\/xendit.png","amount":250000,"description":"Pembayaran Order PRM-1762763802-C1","expiry_date":"2025-11-11T08:36:43.324Z","invoice_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/6911a41b82a2207940da1d7f","available_banks":[{"bank_code":"PERMATA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"CIMB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"SAHABAT_SAMPOERNA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BSI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNC","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MANDIRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MUAMALAT","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BJB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BCA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0}],"available_retail_outlets":[{"retail_outlet_name":"INDOMARET"},{"retail_outlet_name":"ALFAMART"}],"available_ewallets":[{"ewallet_type":"SHOPEEPAY"},{"ewallet_type":"ASTRAPAY"},{"ewallet_type":"JENIUSPAY"},{"ewallet_type":"DANA"},{"ewallet_type":"LINKAJA"},{"ewallet_type":"OVO"},{"ewallet_type":"NEXCASH"},{"ewallet_type":"GOPAY"}],"available_qr_codes":[{"qr_code_type":"QRIS"}],"available_direct_debits":[{"direct_debit_type":"DD_BRI"},{"direct_debit_type":"DD_MANDIRI"}],"available_paylaters":[{"paylater_type":"KREDIVO"},{"paylater_type":"AKULAKU"},{"paylater_type":"ATOME"}],"should_exclude_credit_card":false,"should_send_email":false,"success_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/success","failure_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/failed","created":"2025-11-10T08:36:43.412Z","updated":"2025-11-10T08:36:43.412Z","currency":"IDR","metadata":null}}	\N	2025-11-10 15:36:43	2025-11-10 15:36:43
6	5	XENDIT	250000.00	PENDING	6911a5c83d7103f0eec3bf90	{"checkout_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/6911a5c83d7103f0eec3bf90","xendit":{"id":"6911a5c83d7103f0eec3bf90","external_id":"ORD-PRM-1762761457-C1-1762764231","user_id":"69118173c7e3fbadc0029d08","status":"PENDING","merchant_name":"Project","merchant_profile_picture_url":"https:\\/\\/du8nwjtfkinx.cloudfront.net\\/xendit.png","amount":250000,"description":"Pembayaran Order PRM-1762761457-C1","expiry_date":"2025-11-11T08:43:52.638Z","invoice_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/6911a5c83d7103f0eec3bf90","available_banks":[{"bank_code":"PERMATA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"CIMB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"SAHABAT_SAMPOERNA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BSI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNC","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MANDIRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MUAMALAT","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BJB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BCA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0}],"available_retail_outlets":[{"retail_outlet_name":"INDOMARET"},{"retail_outlet_name":"ALFAMART"}],"available_ewallets":[{"ewallet_type":"SHOPEEPAY"},{"ewallet_type":"ASTRAPAY"},{"ewallet_type":"JENIUSPAY"},{"ewallet_type":"DANA"},{"ewallet_type":"LINKAJA"},{"ewallet_type":"OVO"},{"ewallet_type":"NEXCASH"},{"ewallet_type":"GOPAY"}],"available_qr_codes":[{"qr_code_type":"QRIS"}],"available_direct_debits":[{"direct_debit_type":"DD_BRI"},{"direct_debit_type":"DD_MANDIRI"}],"available_paylaters":[{"paylater_type":"KREDIVO"},{"paylater_type":"AKULAKU"},{"paylater_type":"ATOME"}],"should_exclude_credit_card":false,"should_send_email":false,"success_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/success","failure_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/failed","created":"2025-11-10T08:43:52.714Z","updated":"2025-11-10T08:43:52.714Z","currency":"IDR","metadata":null}}	\N	2025-11-10 15:43:52	2025-11-10 15:43:52
7	8	CASH	50000.00	SUCCESS	\N	\N	2025-11-20 16:12:50	2025-11-20 16:12:50	2025-11-20 16:12:50
8	8	CASH	1050000.00	SUCCESS	\N	{"holder_id":2,"collected_at":"2025-12-23T17:46:13.082Z"}	2025-12-24 00:46:12	2025-12-24 00:46:12	2025-12-24 00:46:12
9	7	CASH	250000.00	SUCCESS	\N	{"holder_id":2,"collected_at":"2025-12-23T17:46:26.847Z"}	2025-12-24 00:46:25	2025-12-24 00:46:25	2025-12-24 00:46:25
10	6	CASH	250000.00	SUCCESS	\N	{"holder_id":2,"collected_at":"2025-12-23T17:46:37.680Z"}	2025-12-24 00:46:36	2025-12-24 00:46:36	2025-12-24 00:46:36
11	9	CASH	50000.00	SUCCESS	\N	\N	2025-12-24 04:32:27	2025-12-24 04:32:27	2025-12-24 04:32:27
12	10	CASH	400000.00	SUCCESS	\N	\N	2025-12-24 04:33:00	2025-12-24 04:33:00	2025-12-24 04:33:00
13	9	CASH	100000.00	SUCCESS	\N	{"holder_id":2,"collected_at":"2025-12-23T21:33:29.091Z"}	2025-12-24 04:33:28	2025-12-24 04:33:28	2025-12-24 04:33:28
14	11	XENDIT	400000.00	PENDING	69650ab612d7fb66309695d0	{"checkout_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/69650ab612d7fb66309695d0","xendit":{"id":"69650ab612d7fb66309695d0","external_id":"ORD-PRM-1768229558-C1-1768229558","user_id":"69118173c7e3fbadc0029d08","status":"PENDING","merchant_name":"Project","merchant_profile_picture_url":"https:\\/\\/du8nwjtfkinx.cloudfront.net\\/xendit.png","amount":400000,"description":"Pembayaran Order PRM-1768229558-C1","expiry_date":"2026-01-13T14:52:38.776Z","invoice_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/69650ab612d7fb66309695d0","available_banks":[{"bank_code":"CIMB","collection_type":"POOL","transfer_amount":400000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNC","collection_type":"POOL","transfer_amount":400000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"PERMATA","collection_type":"POOL","transfer_amount":400000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MUAMALAT","collection_type":"POOL","transfer_amount":400000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MANDIRI","collection_type":"POOL","transfer_amount":400000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNI","collection_type":"POOL","transfer_amount":400000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BCA","collection_type":"POOL","transfer_amount":400000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BSI","collection_type":"POOL","transfer_amount":400000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"SAHABAT_SAMPOERNA","collection_type":"POOL","transfer_amount":400000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BJB","collection_type":"POOL","transfer_amount":400000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BRI","collection_type":"POOL","transfer_amount":400000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0}],"available_retail_outlets":[],"available_ewallets":[{"ewallet_type":"SHOPEEPAY"},{"ewallet_type":"ASTRAPAY"},{"ewallet_type":"JENIUSPAY"},{"ewallet_type":"DANA"},{"ewallet_type":"LINKAJA"},{"ewallet_type":"OVO"},{"ewallet_type":"NEXCASH"},{"ewallet_type":"GOPAY"}],"available_qr_codes":[{"qr_code_type":"QRIS"}],"available_direct_debits":[{"direct_debit_type":"DD_BRI"},{"direct_debit_type":"DD_MANDIRI"}],"available_paylaters":[{"paylater_type":"KREDIVO"},{"paylater_type":"AKULAKU"},{"paylater_type":"ATOME"}],"should_exclude_credit_card":false,"should_send_email":false,"success_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/success","failure_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/failed","created":"2026-01-12T14:52:38.982Z","updated":"2026-01-12T14:52:38.982Z","currency":"IDR","metadata":null}}	\N	2026-01-12 21:52:40	2026-01-12 21:52:40
15	5	XENDIT	250000.00	PENDING	6965116fc951f34f1740684a	{"checkout_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/6965116fc951f34f1740684a","xendit":{"id":"6965116fc951f34f1740684a","external_id":"ORD-PRM-1762761457-C1-1768231280","user_id":"69118173c7e3fbadc0029d08","status":"PENDING","merchant_name":"Project","merchant_profile_picture_url":"https:\\/\\/du8nwjtfkinx.cloudfront.net\\/xendit.png","amount":250000,"description":"Pembayaran Order PRM-1762761457-C1","expiry_date":"2026-01-13T15:21:20.014Z","invoice_url":"https:\\/\\/checkout-staging.xendit.co\\/web\\/6965116fc951f34f1740684a","available_banks":[{"bank_code":"CIMB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"PERMATA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BNC","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MANDIRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"MUAMALAT","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BSI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BRI","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BJB","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"SAHABAT_SAMPOERNA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0},{"bank_code":"BCA","collection_type":"POOL","transfer_amount":250000,"bank_branch":"Virtual Account","account_holder_name":"PROJECT","identity_amount":0}],"available_retail_outlets":[],"available_ewallets":[{"ewallet_type":"SHOPEEPAY"},{"ewallet_type":"ASTRAPAY"},{"ewallet_type":"JENIUSPAY"},{"ewallet_type":"DANA"},{"ewallet_type":"LINKAJA"},{"ewallet_type":"OVO"},{"ewallet_type":"NEXCASH"},{"ewallet_type":"GOPAY"}],"available_qr_codes":[{"qr_code_type":"QRIS"}],"available_direct_debits":[{"direct_debit_type":"DD_BRI"},{"direct_debit_type":"DD_MANDIRI"}],"available_paylaters":[{"paylater_type":"KREDIVO"},{"paylater_type":"AKULAKU"},{"paylater_type":"ATOME"}],"should_exclude_credit_card":false,"should_send_email":false,"success_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/success","failure_redirect_url":"http:\\/\\/localhost:5173\\/payment\\/failed","created":"2026-01-12T15:21:20.274Z","updated":"2026-01-12T15:21:20.274Z","currency":"IDR","metadata":null}}	\N	2026-01-12 22:21:21	2026-01-12 22:21:21
16	12	CASH	250000.00	SUCCESS	\N	{"holder_id":1,"collected_at":"2026-01-14T16:26:34.575Z"}	2026-01-14 23:26:31	2026-01-14 23:26:31	2026-01-14 23:26:31
17	13	CASH	85000.00	SUCCESS	\N	\N	2026-01-14 23:28:39	2026-01-14 23:28:39	2026-01-14 23:28:39
19	15	CASH	650000.00	SUCCESS	\N	\N	2026-01-15 00:49:21	2026-01-15 00:49:21	2026-01-15 00:49:21
21	17	CASH	650000.00	SUCCESS	\N	\N	2026-01-15 19:04:03	2026-01-15 19:04:03	2026-01-15 19:04:03
22	18	CASH	400000.00	SUCCESS	\N	\N	2026-01-15 19:21:51	2026-01-15 19:21:51	2026-01-15 19:21:51
23	19	CASH	400000.00	SUCCESS	\N	\N	2026-01-15 19:30:48	2026-01-15 19:30:48	2026-01-15 19:30:48
25	21	CASH	650000.00	SUCCESS	\N	\N	2026-01-15 19:34:12	2026-01-15 19:34:12	2026-01-15 19:34:12
28	24	CASH	150000.00	SUCCESS	\N	\N	2026-01-15 19:39:15	2026-01-15 19:39:15	2026-01-15 19:39:15
31	27	CASH	85000.00	SUCCESS	\N	{"holder_id":3}	2026-01-15 22:53:36	2026-01-15 22:53:36	2026-01-15 22:53:36
32	28	CASH	85000.00	SUCCESS	\N	{"holder_id":3}	2026-01-15 22:54:15	2026-01-15 22:54:15	2026-01-15 22:54:15
33	29	CASH	250000.00	SUCCESS	\N	{"holder_id":3}	2026-01-15 22:54:30	2026-01-15 22:54:30	2026-01-15 22:54:30
34	30	CASH	250000.00	SUCCESS	\N	{"holder_id":3}	2026-01-15 22:55:16	2026-01-15 22:55:16	2026-01-15 22:55:16
35	31	CASH	85000.00	SUCCESS	\N	{"holder_id":3}	2026-01-15 22:55:27	2026-01-15 22:55:27	2026-01-15 22:55:27
36	32	CASH	85000.00	SUCCESS	\N	{"holder_id":3}	2026-01-15 22:55:36	2026-01-15 22:55:36	2026-01-15 22:55:36
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."permissions" ("id", "name", "guard_name", "created_at", "updated_at") FROM stdin;
\.


--
-- Data for Name: personal_access_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."personal_access_tokens" ("id", "tokenable_type", "tokenable_id", "name", "token", "abilities", "last_used_at", "expires_at", "created_at", "updated_at") FROM stdin;
44	App\\Models\\User	2	api	e0f84cda24da01d2aea2fe3b5ad1e3ef62b8610fbd99d928427362907295390a	["*"]	2026-01-30 13:23:06	\N	2026-01-30 13:23:05	2026-01-30 13:23:06
31	App\\Models\\User	1	api	dc52dbfefc7b632397f3d2b6c9d5acb4d2269c7497e9be46e75999f7f0169a0c	["*"]	2026-01-12 22:21:20	\N	2026-01-12 22:20:52	2026-01-12 22:21:20
28	App\\Models\\User	2	api	23428e86632500fbe8362056d1899c192feb24bd1576f383b8a7338d8d2b82bb	["*"]	2025-12-24 04:34:00	\N	2025-12-24 04:33:39	2025-12-24 04:34:00
32	App\\Models\\User	3	api	9c79440943ada833480226e05704e720e1209d8534f445d6cef2492a8ffb2924	["*"]	2026-01-12 22:41:38	\N	2026-01-12 22:22:25	2026-01-12 22:41:38
41	App\\Models\\User	1	api	d4843861e15e9e0c21e5b4264a1e1d2bc3f393d6898bd9246c0a19e42247c24c	["*"]	2026-01-16 00:41:17	\N	2026-01-16 00:39:32	2026-01-16 00:41:17
2	App\\Models\\User	1	api	5cc967a1c632525f59e2a3a6ca1c53b6a456144ecde428b1f72c25d921d5795c	["*"]	2025-11-10 15:43:51	\N	2025-11-10 14:01:30	2025-11-10 15:43:51
\.


--
-- Data for Name: product_media; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."product_media" ("id", "product_id", "disk", "path", "mime", "size_kb", "is_primary", "sort_order", "created_at", "updated_at") FROM stdin;
4	1	public	products/1/cwIKY3iMGjvA2GV2CVy60n1D3tIoOst3t4xxrZ9E.png	image/png	389	t	0	2025-11-10 14:22:40	2025-11-10 14:22:40
5	2	public	products/2/Dol0vfQaM3YaHkvEKL3vdWk3npsLCqA93DTGeQBZ.png	image/png	94	f	0	2025-11-20 16:07:22	2025-11-20 16:07:43
6	2	public	products/2/FKoocJFq6z7YSazdsB04O4jS8YqxIsjbiX0XtfYe.png	image/png	120	t	0	2025-11-20 16:07:32	2025-11-20 16:07:43
\.


--
-- Data for Name: product_variants; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."product_variants" ("id", "product_id", "size", "type", "tester", "sku", "harga", "is_active", "created_at", "updated_at") FROM stdin;
1	1	large	500gr	\N	F-1	250000.00	t	2025-11-10 14:19:53	2025-11-10 14:19:53
2	1	small	250gr	\N	F-2	150000.00	t	2025-11-10 14:20:06	2025-11-10 14:20:06
3	2	250gr	M	Tester	Y-1	250000.00	t	2025-11-20 16:07:03	2025-11-20 16:07:03
4	3	500 gram	\N	\N	F-02	85000.00	t	2026-01-14 23:22:18	2026-01-14 23:22:18
5	4	500 gram	\N	\N	P-01	25000.00	t	2026-01-14 23:27:52	2026-01-14 23:27:52
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."products" ("id", "category_id", "nama", "slug", "deskripsi", "is_active", "created_at", "updated_at") FROM stdin;
1	2	choco flavour	choco-flavour	\N	t	2025-11-10 14:19:34	2025-11-10 14:19:34
2	1	Choco lover	choco-lover	penyka coklat	t	2025-11-20 16:06:15	2025-11-20 16:06:15
3	3	Tube Class	tube-class	\N	t	2026-01-14 23:21:48	2026-01-14 23:21:48
4	4	Pudding Extra	pudding-extra	\N	t	2026-01-14 23:27:07	2026-01-14 23:27:07
\.


--
-- Data for Name: receipts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."receipts" ("id", "order_id", "print_format", "html_snapshot", "wa_url", "printed_by", "printed_at", "reprint_of_id", "created_at", "updated_at") FROM stdin;
1	1	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1762759501-C1</b> • 2025-11-10 14:25</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-11-10 14:25:01+07	\N	2025-11-10 14:25:01	2025-11-10 14:25:01
2	1	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1762759501-C1</b> • 2025-11-10 14:25</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-11-10 14:25:01+07	\N	2025-11-10 14:25:01	2025-11-10 14:25:01
3	4	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1762761172-C1</b> • 2025-11-10 14:52</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>250000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-11-10 14:52:53+07	\N	2025-11-10 14:52:53	2025-11-10 14:52:53
4	4	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1762761172-C1</b> • 2025-11-10 14:52</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>250000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-11-10 14:52:53+07	\N	2025-11-10 14:52:53	2025-11-10 14:52:53
5	5	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1762761457-C1</b> • 2025-11-10 14:57</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>3 x 250000.00</td><td class='right'>750000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">750000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>750000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>750000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-11-10 14:57:37+07	\N	2025-11-10 14:57:37	2025-11-10 14:57:37
6	5	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1762761457-C1</b> • 2025-11-10 14:57</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>3 x 250000.00</td><td class='right'>750000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">750000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>750000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>750000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-11-10 14:57:38+07	\N	2025-11-10 14:57:38	2025-11-10 14:57:38
7	6	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1762762854-C1</b> • 2025-11-10 15:20</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>250000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-11-10 15:20:55+07	\N	2025-11-10 15:20:55	2025-11-10 15:20:55
8	6	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1762762854-C1</b> • 2025-11-10 15:20</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>250000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-11-10 15:20:55+07	\N	2025-11-10 15:20:55	2025-11-10 15:20:55
9	7	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1762763802-C1</b> • 2025-11-10 15:36</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>250000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-11-10 15:36:43+07	\N	2025-11-10 15:36:43	2025-11-10 15:36:43
10	7	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1762763802-C1</b> • 2025-11-10 15:36</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>250000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-11-10 15:36:43+07	\N	2025-11-10 15:36:43	2025-11-10 15:36:43
11	8	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1763629970-C1</b> • 2025-11-20 16:12</div>\n      <div class="small">Kasir: Admin 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>4 x 150000.00</td><td class='right'>600000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>2 x 250000.00</td><td class='right'>500000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">1100000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>1100000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">50000.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>1050000.00</b></td></tr><tr><td class="lbl small muted">DP</td><td class="val small muted">50000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	2	2025-11-20 16:12:50+07	\N	2025-11-20 16:12:50	2025-11-20 16:12:50
12	8	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1763629970-C1</b> • 2025-11-20 16:12</div>\n      <div class="small">Kasir: Admin 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>4 x 150000.00</td><td class='right'>600000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>2 x 250000.00</td><td class='right'>500000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">1100000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>1100000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">50000.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>1050000.00</b></td></tr><tr><td class="lbl small muted">DP</td><td class="val small muted">50000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	2	2025-11-20 16:12:50+07	\N	2025-11-20 16:12:50	2025-11-20 16:12:50
13	9	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1766525547-C1</b> • 2025-12-24 04:32</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">150000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>150000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">50000.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>100000.00</b></td></tr><tr><td class="lbl small muted">DP</td><td class="val small muted">50000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-12-24 04:32:27+07	\N	2025-12-24 04:32:27	2025-12-24 04:32:27
14	9	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1766525547-C1</b> • 2025-12-24 04:32</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">150000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>150000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">50000.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>100000.00</b></td></tr><tr><td class="lbl small muted">DP</td><td class="val small muted">50000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-12-24 04:32:27+07	\N	2025-12-24 04:32:27	2025-12-24 04:32:27
15	10	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1766525580-C1</b> • 2025-12-24 04:33</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">400000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>400000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">400000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2025-12-24 04:33:00+07	\N	2025-12-24 04:33:00	2025-12-24 04:33:00
16	11	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768229558-C1</b> • 2026-01-12 21:52</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">400000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>400000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>400000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-12 21:52:41+07	\N	2026-01-12 21:52:41	2026-01-12 21:52:41
17	11	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768229558-C1</b> • 2026-01-12 21:52</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">400000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>400000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>400000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-12 21:52:41+07	\N	2026-01-12 21:52:41	2026-01-12 21:52:41
18	12	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768407932-C1</b> • 2026-01-14 23:25</div>\n      <div class="small">Kasir: Admin 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Choco lover - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>250000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	2	2026-01-14 23:25:30+07	\N	2026-01-14 23:25:30	2026-01-14 23:25:30
19	12	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768407932-C1</b> • 2026-01-14 23:25</div>\n      <div class="small">Kasir: Admin 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Choco lover - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Sisa Bayar</b></td><td class="val"><b>250000.00</b></td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>UNPAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	2	2026-01-14 23:25:30+07	\N	2026-01-14 23:25:30	2026-01-14 23:25:30
20	13	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768408119-C1</b> • 2026-01-14 23:28</div>\n      <div class="small">Kasir: Admin 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Tube Class - </td></tr><tr><td class='small'>1 x 85000.00</td><td class='right'>85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">85000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>85000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	2	2026-01-14 23:28:40+07	\N	2026-01-14 23:28:40	2026-01-14 23:28:40
21	13	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768408119-C1</b> • 2026-01-14 23:28</div>\n      <div class="small">Kasir: Admin 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Tube Class - </td></tr><tr><td class='small'>1 x 85000.00</td><td class='right'>85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">85000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>85000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	2	2026-01-14 23:28:40+07	\N	2026-01-14 23:28:40	2026-01-14 23:28:40
22	15	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768412961-C1</b> • 2026-01-15 00:49</div>\n      <div class="small">Kasir: Admin 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Choco lover - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">650000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>650000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">650000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	2	2026-01-15 00:49:21+07	\N	2026-01-15 00:49:21	2026-01-15 00:49:21
23	15	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768412961-C1</b> • 2026-01-15 00:49</div>\n      <div class="small">Kasir: Admin 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Choco lover - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">650000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>650000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">650000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	2	2026-01-15 00:49:21+07	\N	2026-01-15 00:49:21	2026-01-15 00:49:21
24	17	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768478643-C1</b> • 2026-01-15 19:04</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Choco lover - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">650000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>650000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">650000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 19:04:04+07	\N	2026-01-15 19:04:04	2026-01-15 19:04:04
25	17	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768478643-C1</b> • 2026-01-15 19:04</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Choco lover - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">650000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>650000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">650000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 19:04:04+07	\N	2026-01-15 19:04:04	2026-01-15 19:04:04
26	18	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768479711-C1</b> • 2026-01-15 19:21</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">400000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>400000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">400000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 19:21:51+07	\N	2026-01-15 19:21:51	2026-01-15 19:21:51
27	18	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768479711-C1</b> • 2026-01-15 19:21</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">400000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>400000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">400000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 19:21:51+07	\N	2026-01-15 19:21:51	2026-01-15 19:21:51
28	19	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768480248-C1</b> • 2026-01-15 19:30</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">400000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>400000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">400000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 19:30:49+07	\N	2026-01-15 19:30:49	2026-01-15 19:30:49
29	19	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768480248-C1</b> • 2026-01-15 19:30</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">400000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>400000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">400000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 19:30:49+07	\N	2026-01-15 19:30:49	2026-01-15 19:30:49
30	21	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768480452-C1</b> • 2026-01-15 19:34</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Choco lover - </td></tr><tr><td class='small'>2 x 250000.00</td><td class='right'>500000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">650000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>650000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">650000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 19:34:13+07	\N	2026-01-15 19:34:13	2026-01-15 19:34:13
31	21	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768480452-C1</b> • 2026-01-15 19:34</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Choco lover - </td></tr><tr><td class='small'>2 x 250000.00</td><td class='right'>500000.00</td></tr><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">650000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>650000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">650000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 19:34:13+07	\N	2026-01-15 19:34:13	2026-01-15 19:34:13
32	24	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768480755-C1</b> • 2026-01-15 19:39</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">150000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>150000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">150000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 19:39:15+07	\N	2026-01-15 19:39:15	2026-01-15 19:39:15
33	24	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768480755-C1</b> • 2026-01-15 19:39</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>choco flavour - </td></tr><tr><td class='small'>1 x 150000.00</td><td class='right'>150000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">150000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>150000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">150000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 19:39:15+07	\N	2026-01-15 19:39:15	2026-01-15 19:39:15
34	27	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768492416-C1</b> • 2026-01-15 22:53</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Tube Class - </td></tr><tr><td class='small'>1 x 85000.00</td><td class='right'>85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">85000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>85000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 22:53:36+07	\N	2026-01-15 22:53:36	2026-01-15 22:53:36
35	27	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768492416-C1</b> • 2026-01-15 22:53</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Tube Class - </td></tr><tr><td class='small'>1 x 85000.00</td><td class='right'>85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">85000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>85000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 22:53:36+07	\N	2026-01-15 22:53:36	2026-01-15 22:53:36
36	28	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768492455-C1</b> • 2026-01-15 22:54</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Tube Class - </td></tr><tr><td class='small'>1 x 85000.00</td><td class='right'>85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">85000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>85000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 22:54:15+07	\N	2026-01-15 22:54:15	2026-01-15 22:54:15
37	29	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768492470-C1</b> • 2026-01-15 22:54</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Choco lover - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 22:54:30+07	\N	2026-01-15 22:54:30	2026-01-15 22:54:30
38	29	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768492470-C1</b> • 2026-01-15 22:54</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Choco lover - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 22:54:30+07	\N	2026-01-15 22:54:30	2026-01-15 22:54:30
39	30	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768492516-C1</b> • 2026-01-15 22:55</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Choco lover - </td></tr><tr><td class='small'>1 x 250000.00</td><td class='right'>250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">250000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>250000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">250000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 22:55:16+07	\N	2026-01-15 22:55:16	2026-01-15 22:55:16
40	31	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768492527-C1</b> • 2026-01-15 22:55</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Tube Class - </td></tr><tr><td class='small'>1 x 85000.00</td><td class='right'>85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">85000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>85000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 22:55:27+07	\N	2026-01-15 22:55:27	2026-01-15 22:55:27
41	32	58	<!doctype html><html><head><meta charset="utf-8"><style>\n*{box-sizing:border-box}\nbody{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:12px;margin:0;padding:0;color:#111}\n.wrap{width:58mm;max-width:58mm;margin:0 auto;padding:6px}\nh1,h2,h3,p{margin:0;padding:0}\n.center{text-align:center}\n.right{text-align:right}\n.muted{color:#555}\n.row{display:flex;justify-content:space-between;gap:8px}\n.hr{border-top:1px dashed #333;margin:6px 0}\ntable{width:100%;border-collapse:collapse}\ntd{vertical-align:top;padding:2px 0}\n.small{font-size:11px}\n.tot td{padding-top:4px}\n.tot .lbl{width:60%}\n.tot .val{width:40%;text-align:right}\n</style></head>\n<body onload="setTimeout(()=>{window.print&&window.print()},10)">\n  <div class="wrap">\n    <div class="center">\n      <h2>POS PRIME</h2>\n      <div class="small muted">Cabang Pusat • Gudang Utama</div>\n      <div class="small">No: <b>PRM-1768492536-C1</b> • 2026-01-15 22:55</div>\n      <div class="small">Kasir: Kasir 1</div>\n      <div class="hr"></div>\n    </div>\n\n    <table><tr><td colspan='2'>Tube Class - </td></tr><tr><td class='small'>1 x 85000.00</td><td class='right'>85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <table class="tot"><tr><td class="lbl">Subtotal</td><td class="val">85000.00</td></tr><tr><td class="lbl">Discount</td><td class="val">0.00</td></tr><tr><td class="lbl">Service</td><td class="val">0.00</td></tr><tr><td class="lbl">Tax</td><td class="val">0.00</td></tr><tr><td class="lbl"><b>Grand Total</b></td><td class="val"><b>85000.00</b></td></tr><tr><td class="lbl">Paid</td><td class="val">85000.00</td></tr></table>\n    <div class="hr"></div>\n\n    <div class="center small">Status: <b>PAID</b></div>\n    <div class="center small muted">Terima kasih 🙏</div>\n  </div>\n</body></html>	\N	3	2026-01-15 22:55:37+07	\N	2026-01-15 22:55:37	2026-01-15 22:55:37
\.


--
-- Data for Name: role_has_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."role_has_permissions" ("permission_id", "role_id") FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."roles" ("id", "name", "guard_name", "created_at", "updated_at") FROM stdin;
1	superadmin	web	2025-11-10 13:02:11	2025-11-10 13:02:11
2	admin_cabang	web	2025-11-10 13:02:11	2025-11-10 13:02:11
3	kasir	web	2025-11-10 13:02:11	2025-11-10 13:02:11
4	kurir	web	2025-11-10 13:02:11	2025-11-10 13:02:11
5	gudang	web	2025-11-10 13:02:11	2025-11-10 13:02:11
6	sales	web	2025-11-10 13:02:11	2025-11-10 13:02:11
\.


--
-- Data for Name: settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."settings" ("id", "scope", "scope_id", "key", "value_json", "created_at", "updated_at") FROM stdin;
6	USER	2	ui.preferences	{"darkMode":false}	2025-11-20 16:24:29	2025-11-20 16:24:30
1	GLOBAL	\N	acc.cash_id	{"id":3}	2025-12-24 00:41:00	2025-12-24 00:41:00
2	GLOBAL	\N	acc.bank_id	{"id":4}	2025-12-24 00:41:00	2025-12-24 00:41:00
3	GLOBAL	\N	acc.sales_id	{"id":13}	2025-12-24 00:41:00	2025-12-24 00:41:00
4	GLOBAL	\N	acc.fee_expense_id	{"id":17}	2025-12-24 00:41:00	2025-12-24 00:41:00
5	GLOBAL	\N	acc.fee_payable_id	{"id":8}	2025-12-24 00:41:00	2025-12-24 00:41:00
\.


--
-- Data for Name: stock_lots; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."stock_lots" ("id", "cabang_id", "gudang_id", "product_variant_id", "lot_no", "received_at", "expires_at", "qty_received", "qty_remaining", "unit_cost", "created_at", "updated_at") FROM stdin;
4	1	1	2	LOT-20251224-F2-0742	2025-12-24 00:00:00	2026-01-24	5	5	\N	2025-12-24 04:18:01	2025-12-24 04:18:01
7	1	1	4	LOT-20260114-F02-1680	2026-01-14 00:00:00	2026-01-17	1	0	\N	2026-01-14 23:25:03	2026-01-14 23:28:39
8	1	1	5	LOT-20260115-P01-6456	2026-01-15 00:00:00	\N	5	5	\N	2026-01-15 19:03:00	2026-01-15 19:03:00
1	1	1	2	LOT-20251224-F2-4659	2025-12-24 00:00:00	\N	5	0	\N	2025-12-24 03:55:57	2026-01-15 19:21:51
5	1	1	1	LOT-20251224-F1-0017	2025-12-24 00:00:00	2026-01-24	5	0	\N	2025-12-24 04:18:25	2026-01-15 19:30:49
3	1	1	3	LOT-20251224-Y1-2449	2025-12-24 00:00:00	\N	5	0	\N	2025-12-24 04:03:29	2026-01-15 19:34:12
2	1	1	2	LOT-20251224-F2-6671	2025-12-24 00:00:00	\N	4	1	\N	2025-12-24 03:57:40	2026-01-15 19:39:15
6	1	1	3	LOT-20251224-Y1-0917	2025-12-24 00:00:00	2026-01-24	5	3	\N	2025-12-24 04:21:35	2026-01-15 22:55:16
9	1	1	4	LOT-20260115-F02-8905	2026-01-15 00:00:00	\N	5	1	\N	2026-01-15 19:03:28	2026-01-15 22:55:36
10	1	1	5	LOT-20260116-P01-8774	2026-01-16 00:00:00	\N	6	6	\N	2026-01-16 00:40:19	2026-01-16 00:40:19
11	1	1	4	LOT-20260116-F02-2719	2026-01-16 00:00:00	\N	6	6	\N	2026-01-16 00:40:31	2026-01-16 00:40:31
12	1	1	3	LOT-20260116-Y1-0355	2026-01-16 00:00:00	\N	6	6	\N	2026-01-16 00:40:47	2026-01-16 00:40:47
13	1	1	1	LOT-20260116-F1-4378	2026-01-16 00:00:00	\N	6	6	\N	2026-01-16 00:40:57	2026-01-16 00:40:57
14	1	1	2	LOT-20260116-F2-6834	2026-01-16 00:00:00	\N	6	6	\N	2026-01-16 00:41:07	2026-01-16 00:41:07
\.


--
-- Data for Name: stock_movements; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."stock_movements" ("id", "cabang_id", "gudang_id", "product_variant_id", "stock_lot_id", "type", "qty", "unit_cost", "ref_type", "ref_id", "note", "created_at", "updated_at") FROM stdin;
1	1	1	2	1	IN	5	\N	PURCHASE	\N	RECEIVE	2025-12-24 03:55:57	2025-12-24 03:55:57
2	1	1	2	2	IN	4	\N	PURCHASE	\N	RECEIVE	2025-12-24 03:57:40	2025-12-24 03:57:40
3	1	1	3	3	IN	5	\N	PURCHASE	\N	RECEIVE	2025-12-24 04:03:29	2025-12-24 04:03:29
4	1	1	2	4	IN	5	\N	PURCHASE	\N	RECEIVE	2025-12-24 04:18:01	2025-12-24 04:18:01
5	1	1	1	5	IN	5	\N	PURCHASE	\N	RECEIVE	2025-12-24 04:18:25	2025-12-24 04:18:25
6	1	1	3	6	IN	5	\N	PURCHASE	\N	RECEIVE	2025-12-24 04:21:35	2025-12-24 04:21:35
7	1	1	1	5	OUT	-1	\N	SALE	11	SALE#PRM-1766525580-C1	2025-12-24 04:33:00	2025-12-24 04:33:00
8	1	1	2	1	OUT	-1	\N	SALE	12	SALE#PRM-1766525580-C1	2025-12-24 04:33:00	2025-12-24 04:33:00
9	1	1	2	1	OUT	-1	\N	SALE	10	SALE#PRM-1766525547-C1	2025-12-24 04:33:28	2025-12-24 04:33:28
10	1	1	4	7	IN	1	\N	PURCHASE	\N	RECEIVE	2026-01-14 23:25:03	2026-01-14 23:25:03
11	1	1	3	3	OUT	-1	\N	SALE	15	SALE#PRM-1768407932-C1	2026-01-14 23:26:31	2026-01-14 23:26:31
12	1	1	4	7	OUT	-1	\N	SALE	16	SALE#PRM-1768408119-C1	2026-01-14 23:28:39	2026-01-14 23:28:39
13	1	1	3	3	OUT	-1	\N	SALE	20	SALE#PRM-1768412961-C1	2026-01-15 00:49:21	2026-01-15 00:49:21
14	1	1	2	1	OUT	-1	\N	SALE	21	SALE#PRM-1768412961-C1	2026-01-15 00:49:21	2026-01-15 00:49:21
15	1	1	1	5	OUT	-1	\N	SALE	22	SALE#PRM-1768412961-C1	2026-01-15 00:49:21	2026-01-15 00:49:21
16	1	1	5	8	IN	5	\N	PURCHASE	\N	RECEIVE	2026-01-15 19:03:00	2026-01-15 19:03:00
17	1	1	4	9	IN	5	\N	PURCHASE	\N	RECEIVE	2026-01-15 19:03:28	2026-01-15 19:03:28
18	1	1	3	3	OUT	-1	\N	SALE	26	SALE#PRM-1768478643-C1	2026-01-15 19:04:03	2026-01-15 19:04:03
19	1	1	2	1	OUT	-1	\N	SALE	27	SALE#PRM-1768478643-C1	2026-01-15 19:04:03	2026-01-15 19:04:03
20	1	1	1	5	OUT	-1	\N	SALE	28	SALE#PRM-1768478643-C1	2026-01-15 19:04:03	2026-01-15 19:04:03
21	1	1	2	1	OUT	-1	\N	SALE	29	SALE#PRM-1768479711-C1	2026-01-15 19:21:51	2026-01-15 19:21:51
22	1	1	1	5	OUT	-1	\N	SALE	30	SALE#PRM-1768479711-C1	2026-01-15 19:21:51	2026-01-15 19:21:51
23	1	1	2	2	OUT	-1	\N	SALE	31	SALE#PRM-1768480248-C1	2026-01-15 19:30:49	2026-01-15 19:30:49
24	1	1	1	5	OUT	-1	\N	SALE	32	SALE#PRM-1768480248-C1	2026-01-15 19:30:49	2026-01-15 19:30:49
26	1	1	3	3	OUT	-2	\N	SALE	35	SALE#PRM-1768480452-C1	2026-01-15 19:34:12	2026-01-15 19:34:12
27	1	1	2	2	OUT	-1	\N	SALE	36	SALE#PRM-1768480452-C1	2026-01-15 19:34:12	2026-01-15 19:34:12
30	1	1	2	2	OUT	-1	\N	SALE	41	SALE#PRM-1768480755-C1	2026-01-15 19:39:15	2026-01-15 19:39:15
31	1	1	4	9	OUT	-1	\N	SALE	44	SALE#PRM-1768492416-C1	2026-01-15 22:53:36	2026-01-15 22:53:36
32	1	1	4	9	OUT	-1	\N	SALE	45	SALE#PRM-1768492455-C1	2026-01-15 22:54:15	2026-01-15 22:54:15
33	1	1	3	6	OUT	-1	\N	SALE	46	SALE#PRM-1768492470-C1	2026-01-15 22:54:30	2026-01-15 22:54:30
34	1	1	3	6	OUT	-1	\N	SALE	47	SALE#PRM-1768492516-C1	2026-01-15 22:55:16	2026-01-15 22:55:16
35	1	1	4	9	OUT	-1	\N	SALE	48	SALE#PRM-1768492527-C1	2026-01-15 22:55:27	2026-01-15 22:55:27
36	1	1	4	9	OUT	-1	\N	SALE	49	SALE#PRM-1768492536-C1	2026-01-15 22:55:36	2026-01-15 22:55:36
37	1	1	5	10	IN	6	\N	PURCHASE	\N	RECEIVE	2026-01-16 00:40:19	2026-01-16 00:40:19
38	1	1	4	11	IN	6	\N	PURCHASE	\N	RECEIVE	2026-01-16 00:40:31	2026-01-16 00:40:31
39	1	1	3	12	IN	6	\N	PURCHASE	\N	RECEIVE	2026-01-16 00:40:47	2026-01-16 00:40:47
40	1	1	1	13	IN	6	\N	PURCHASE	\N	RECEIVE	2026-01-16 00:40:57	2026-01-16 00:40:57
41	1	1	2	14	IN	6	\N	PURCHASE	\N	RECEIVE	2026-01-16 00:41:07	2026-01-16 00:41:07
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."users" ("id", "name", "email", "phone", "password", "cabang_id", "role", "is_active", "remember_token", "created_at", "updated_at", "email_verified_at") FROM stdin;
1	Superadmin	superadmin@gmail.com	081234567890	$2y$12$WU5rPFENvTnITklyYa04hOiMra3QkoGydeKicx.GJBCLf6iqDmdLW	\N	superadmin	t	\N	2025-11-10 13:02:11	2025-12-24 00:40:59	\N
2	Admin 1	admin1@gmail.com	081111111111	$2y$12$.EKe.1Cmjaf5NMwZUR0s9ulj/0hNtruzKn.ubOUvdfTQgTvilstrm	1	admin_cabang	t	\N	2025-11-10 13:02:12	2025-12-24 00:41:00	\N
3	Kasir 1	kasir1@gmail.com	082222222222	$2y$12$r0Dpd1S5iUdYksftHuIPXedsFiFAz5qLWRHfBXtcwzmvKDhyYGz5a	1	kasir	t	\N	2025-11-10 13:02:12	2025-12-24 00:41:00	\N
4	Kurir 1	kurir1@gmail.com	083333333333	$2y$12$3tzCA2XBHLC9tLMPLyZamOTzizwMcnGlYya.sUabf2tb8G/LWGKIe	1	kurir	t	\N	2025-11-10 13:02:12	2025-12-24 00:41:00	\N
\.


--
-- Data for Name: variant_stocks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY "public"."variant_stocks" ("id", "cabang_id", "gudang_id", "product_variant_id", "qty", "min_stok", "created_at", "updated_at", "safety_stock", "lead_time_days", "reorder_point") FROM stdin;
5	1	1	5	11	11	2026-01-14 23:28:08	2026-01-16 00:40:19	\N	\N	\N
4	1	1	4	7	10	2026-01-14 23:24:33	2026-01-16 00:40:31	0	\N	3
3	1	1	3	9	5	2025-12-24 03:58:36	2026-01-16 00:40:47	0	\N	3
2	1	1	1	6	5	2025-11-10 14:21:36	2026-01-16 00:40:57	3	\N	8
1	1	1	2	12	5	2025-11-10 14:21:27	2026-01-16 00:41:07	5	\N	12
\.


--
-- Name: accounts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."accounts_id_seq"', 20, true);


--
-- Name: audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."audit_logs_id_seq"', 728, true);


--
-- Name: backups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."backups_id_seq"', 1, false);


--
-- Name: cabangs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."cabangs_id_seq"', 1, true);


--
-- Name: cash_holders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."cash_holders_id_seq"', 3, true);


--
-- Name: cash_moves_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."cash_moves_id_seq"', 10, true);


--
-- Name: cash_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."cash_sessions_id_seq"', 2, true);


--
-- Name: cash_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."cash_transactions_id_seq"', 7, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."categories_id_seq"', 6, true);


--
-- Name: customer_timelines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."customer_timelines_id_seq"', 4, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."customers_id_seq"', 4, true);


--
-- Name: deliveries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."deliveries_id_seq"', 4, true);


--
-- Name: delivery_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."delivery_events_id_seq"', 11, true);


--
-- Name: failed_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."failed_jobs_id_seq"', 1, false);


--
-- Name: fee_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."fee_entries_id_seq"', 19, true);


--
-- Name: fees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."fees_id_seq"', 1, true);


--
-- Name: fiscal_periods_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."fiscal_periods_id_seq"', 1, false);


--
-- Name: gudangs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."gudangs_id_seq"', 1, true);


--
-- Name: jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."jobs_id_seq"', 1, false);


--
-- Name: journal_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."journal_entries_id_seq"', 48, true);


--
-- Name: journal_lines_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."journal_lines_id_seq"', 96, true);


--
-- Name: migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."migrations_id_seq"', 44, true);


--
-- Name: order_change_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."order_change_logs_id_seq"', 41, true);


--
-- Name: order_item_lot_allocations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."order_item_lot_allocations_id_seq"', 27, true);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."order_items_id_seq"', 49, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."orders_id_seq"', 32, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."payments_id_seq"', 36, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."permissions_id_seq"', 1, false);


--
-- Name: personal_access_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."personal_access_tokens_id_seq"', 44, true);


--
-- Name: product_media_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."product_media_id_seq"', 6, true);


--
-- Name: product_variants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."product_variants_id_seq"', 5, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."products_id_seq"', 4, true);


--
-- Name: receipts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."receipts_id_seq"', 41, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."roles_id_seq"', 6, true);


--
-- Name: settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."settings_id_seq"', 6, true);


--
-- Name: stock_lots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."stock_lots_id_seq"', 14, true);


--
-- Name: stock_movements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."stock_movements_id_seq"', 41, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."users_id_seq"', 4, true);


--
-- Name: variant_stocks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('"public"."variant_stocks_id_seq"', 5, true);


--
-- Name: accounts accounts_code_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_code_unique" UNIQUE ("code");


--
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_pkey" PRIMARY KEY ("id");


--
-- Name: audit_logs audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."audit_logs"
    ADD CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id");


--
-- Name: backups backups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."backups"
    ADD CONSTRAINT "backups_pkey" PRIMARY KEY ("id");


--
-- Name: cabangs cabangs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cabangs"
    ADD CONSTRAINT "cabangs_pkey" PRIMARY KEY ("id");


--
-- Name: cache_locks cache_locks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cache_locks"
    ADD CONSTRAINT "cache_locks_pkey" PRIMARY KEY ("key");


--
-- Name: cache cache_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cache"
    ADD CONSTRAINT "cache_pkey" PRIMARY KEY ("key");


--
-- Name: cash_holders cash_holders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_holders"
    ADD CONSTRAINT "cash_holders_pkey" PRIMARY KEY ("id");


--
-- Name: cash_moves cash_moves_idempotency_key_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_moves"
    ADD CONSTRAINT "cash_moves_idempotency_key_unique" UNIQUE ("idempotency_key");


--
-- Name: cash_moves cash_moves_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_moves"
    ADD CONSTRAINT "cash_moves_pkey" PRIMARY KEY ("id");


--
-- Name: cash_sessions cash_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_sessions"
    ADD CONSTRAINT "cash_sessions_pkey" PRIMARY KEY ("id");


--
-- Name: cash_transactions cash_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_transactions"
    ADD CONSTRAINT "cash_transactions_pkey" PRIMARY KEY ("id");


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_pkey" PRIMARY KEY ("id");


--
-- Name: categories categories_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."categories"
    ADD CONSTRAINT "categories_slug_unique" UNIQUE ("slug");


--
-- Name: customer_timelines customer_timelines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."customer_timelines"
    ADD CONSTRAINT "customer_timelines_pkey" PRIMARY KEY ("id");


--
-- Name: customers customers_cabang_id_phone_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."customers"
    ADD CONSTRAINT "customers_cabang_id_phone_unique" UNIQUE ("cabang_id", "phone");


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."customers"
    ADD CONSTRAINT "customers_pkey" PRIMARY KEY ("id");


--
-- Name: deliveries deliveries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."deliveries"
    ADD CONSTRAINT "deliveries_pkey" PRIMARY KEY ("id");


--
-- Name: delivery_events delivery_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."delivery_events"
    ADD CONSTRAINT "delivery_events_pkey" PRIMARY KEY ("id");


--
-- Name: failed_jobs failed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."failed_jobs"
    ADD CONSTRAINT "failed_jobs_pkey" PRIMARY KEY ("id");


--
-- Name: failed_jobs failed_jobs_uuid_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."failed_jobs"
    ADD CONSTRAINT "failed_jobs_uuid_unique" UNIQUE ("uuid");


--
-- Name: fee_entries fee_entries_fee_id_ref_type_ref_id_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fee_entries"
    ADD CONSTRAINT "fee_entries_fee_id_ref_type_ref_id_unique" UNIQUE ("fee_id", "ref_type", "ref_id");


--
-- Name: fee_entries fee_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fee_entries"
    ADD CONSTRAINT "fee_entries_pkey" PRIMARY KEY ("id");


--
-- Name: fees fees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fees"
    ADD CONSTRAINT "fees_pkey" PRIMARY KEY ("id");


--
-- Name: fiscal_periods fiscal_periods_cabang_id_year_month_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fiscal_periods"
    ADD CONSTRAINT "fiscal_periods_cabang_id_year_month_unique" UNIQUE ("cabang_id", "year", "month");


--
-- Name: fiscal_periods fiscal_periods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fiscal_periods"
    ADD CONSTRAINT "fiscal_periods_pkey" PRIMARY KEY ("id");


--
-- Name: gudangs gudangs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."gudangs"
    ADD CONSTRAINT "gudangs_pkey" PRIMARY KEY ("id");


--
-- Name: job_batches job_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."job_batches"
    ADD CONSTRAINT "job_batches_pkey" PRIMARY KEY ("id");


--
-- Name: jobs jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."jobs"
    ADD CONSTRAINT "jobs_pkey" PRIMARY KEY ("id");


--
-- Name: journal_entries journal_entries_cabang_id_number_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."journal_entries"
    ADD CONSTRAINT "journal_entries_cabang_id_number_unique" UNIQUE ("cabang_id", "number");


--
-- Name: journal_entries journal_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."journal_entries"
    ADD CONSTRAINT "journal_entries_pkey" PRIMARY KEY ("id");


--
-- Name: journal_lines journal_lines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."journal_lines"
    ADD CONSTRAINT "journal_lines_pkey" PRIMARY KEY ("id");


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."migrations"
    ADD CONSTRAINT "migrations_pkey" PRIMARY KEY ("id");


--
-- Name: model_has_permissions model_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."model_has_permissions"
    ADD CONSTRAINT "model_has_permissions_pkey" PRIMARY KEY ("permission_id", "model_id", "model_type");


--
-- Name: model_has_roles model_has_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."model_has_roles"
    ADD CONSTRAINT "model_has_roles_pkey" PRIMARY KEY ("role_id", "model_id", "model_type");


--
-- Name: order_change_logs order_change_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."order_change_logs"
    ADD CONSTRAINT "order_change_logs_pkey" PRIMARY KEY ("id");


--
-- Name: order_item_lot_allocations order_item_lot_allocations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."order_item_lot_allocations"
    ADD CONSTRAINT "order_item_lot_allocations_pkey" PRIMARY KEY ("id");


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_pkey" PRIMARY KEY ("id");


--
-- Name: orders orders_kode_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_kode_unique" UNIQUE ("kode");


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_pkey" PRIMARY KEY ("id");


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."payments"
    ADD CONSTRAINT "payments_pkey" PRIMARY KEY ("id");


--
-- Name: permissions permissions_name_guard_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."permissions"
    ADD CONSTRAINT "permissions_name_guard_name_unique" UNIQUE ("name", "guard_name");


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."permissions"
    ADD CONSTRAINT "permissions_pkey" PRIMARY KEY ("id");


--
-- Name: personal_access_tokens personal_access_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."personal_access_tokens"
    ADD CONSTRAINT "personal_access_tokens_pkey" PRIMARY KEY ("id");


--
-- Name: personal_access_tokens personal_access_tokens_token_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."personal_access_tokens"
    ADD CONSTRAINT "personal_access_tokens_token_unique" UNIQUE ("token");


--
-- Name: product_media product_media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."product_media"
    ADD CONSTRAINT "product_media_pkey" PRIMARY KEY ("id");


--
-- Name: product_variants product_variants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."product_variants"
    ADD CONSTRAINT "product_variants_pkey" PRIMARY KEY ("id");


--
-- Name: product_variants product_variants_product_id_size_type_tester_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."product_variants"
    ADD CONSTRAINT "product_variants_product_id_size_type_tester_unique" UNIQUE ("product_id", "size", "type", "tester");


--
-- Name: product_variants product_variants_sku_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."product_variants"
    ADD CONSTRAINT "product_variants_sku_unique" UNIQUE ("sku");


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_pkey" PRIMARY KEY ("id");


--
-- Name: products products_slug_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_slug_unique" UNIQUE ("slug");


--
-- Name: receipts receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."receipts"
    ADD CONSTRAINT "receipts_pkey" PRIMARY KEY ("id");


--
-- Name: role_has_permissions role_has_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."role_has_permissions"
    ADD CONSTRAINT "role_has_permissions_pkey" PRIMARY KEY ("permission_id", "role_id");


--
-- Name: roles roles_name_guard_name_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_name_guard_name_unique" UNIQUE ("name", "guard_name");


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."roles"
    ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("id");


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."settings"
    ADD CONSTRAINT "settings_pkey" PRIMARY KEY ("id");


--
-- Name: settings settings_scope_key_uk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."settings"
    ADD CONSTRAINT "settings_scope_key_uk" UNIQUE ("scope", "scope_id", "key");


--
-- Name: stock_lots stock_lots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."stock_lots"
    ADD CONSTRAINT "stock_lots_pkey" PRIMARY KEY ("id");


--
-- Name: stock_movements stock_movements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."stock_movements"
    ADD CONSTRAINT "stock_movements_pkey" PRIMARY KEY ("id");


--
-- Name: users users_email_unique; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_unique" UNIQUE ("email");


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");


--
-- Name: variant_stocks variant_stocks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."variant_stocks"
    ADD CONSTRAINT "variant_stocks_pkey" PRIMARY KEY ("id");


--
-- Name: variant_stocks variant_stocks_unique_gudang_variant; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."variant_stocks"
    ADD CONSTRAINT "variant_stocks_unique_gudang_variant" UNIQUE ("gudang_id", "product_variant_id");


--
-- Name: accounts_cabang_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "accounts_cabang_id_index" ON "public"."accounts" USING "btree" ("cabang_id");


--
-- Name: accounts_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "accounts_is_active_index" ON "public"."accounts" USING "btree" ("is_active");


--
-- Name: accounts_parent_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "accounts_parent_id_index" ON "public"."accounts" USING "btree" ("parent_id");


--
-- Name: accounts_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "accounts_type_index" ON "public"."accounts" USING "btree" ("type");


--
-- Name: audit_logs_action_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "audit_logs_action_index" ON "public"."audit_logs" USING "btree" ("action");


--
-- Name: audit_logs_actor_type_actor_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "audit_logs_actor_type_actor_id_index" ON "public"."audit_logs" USING "btree" ("actor_type", "actor_id");


--
-- Name: audit_logs_model_model_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "audit_logs_model_model_id_index" ON "public"."audit_logs" USING "btree" ("model", "model_id");


--
-- Name: audit_logs_occurred_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "audit_logs_occurred_at_index" ON "public"."audit_logs" USING "btree" ("occurred_at");


--
-- Name: cabangs_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "cabangs_is_active_index" ON "public"."cabangs" USING "btree" ("is_active");


--
-- Name: cabangs_kota_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "cabangs_kota_is_active_index" ON "public"."cabangs" USING "btree" ("kota", "is_active");


--
-- Name: cash_holders_cabang_id_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "cash_holders_cabang_id_name_index" ON "public"."cash_holders" USING "btree" ("cabang_id", "name");


--
-- Name: cash_moves_moved_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "cash_moves_moved_at_index" ON "public"."cash_moves" USING "btree" ("moved_at");


--
-- Name: cash_sessions_cabang_id_cashier_id_opened_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "cash_sessions_cabang_id_cashier_id_opened_at_index" ON "public"."cash_sessions" USING "btree" ("cabang_id", "cashier_id", "opened_at");


--
-- Name: cash_sessions_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "cash_sessions_status_index" ON "public"."cash_sessions" USING "btree" ("status");


--
-- Name: cash_transactions_ref_type_ref_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "cash_transactions_ref_type_ref_id_index" ON "public"."cash_transactions" USING "btree" ("ref_type", "ref_id");


--
-- Name: cash_transactions_session_id_occurred_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "cash_transactions_session_id_occurred_at_index" ON "public"."cash_transactions" USING "btree" ("session_id", "occurred_at");


--
-- Name: categories_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "categories_is_active_index" ON "public"."categories" USING "btree" ("is_active");


--
-- Name: customer_timelines_customer_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "customer_timelines_customer_id_index" ON "public"."customer_timelines" USING "btree" ("customer_id");


--
-- Name: customers_cabang_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "customers_cabang_id_index" ON "public"."customers" USING "btree" ("cabang_id");


--
-- Name: customers_cabang_id_phone_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "customers_cabang_id_phone_index" ON "public"."customers" USING "btree" ("cabang_id", "phone");


--
-- Name: deliveries_assigned_to_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "deliveries_assigned_to_status_index" ON "public"."deliveries" USING "btree" ("assigned_to", "status");


--
-- Name: deliveries_requested_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "deliveries_requested_at_index" ON "public"."deliveries" USING "btree" ("requested_at");


--
-- Name: deliveries_sj_number_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "deliveries_sj_number_index" ON "public"."deliveries" USING "btree" ("sj_number");


--
-- Name: delivery_events_delivery_id_occurred_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "delivery_events_delivery_id_occurred_at_index" ON "public"."delivery_events" USING "btree" ("delivery_id", "occurred_at");


--
-- Name: fee_entries_cabang_id_period_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fee_entries_cabang_id_period_date_index" ON "public"."fee_entries" USING "btree" ("cabang_id", "period_date");


--
-- Name: fee_entries_owner_user_id_pay_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fee_entries_owner_user_id_pay_status_index" ON "public"."fee_entries" USING "btree" ("owner_user_id", "pay_status");


--
-- Name: fees_cabang_id_kind_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fees_cabang_id_kind_is_active_index" ON "public"."fees" USING "btree" ("cabang_id", "kind", "is_active");


--
-- Name: fiscal_periods_cabang_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fiscal_periods_cabang_id_index" ON "public"."fiscal_periods" USING "btree" ("cabang_id");


--
-- Name: fiscal_periods_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "fiscal_periods_status_index" ON "public"."fiscal_periods" USING "btree" ("status");


--
-- Name: gudangs_cabang_id_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "gudangs_cabang_id_is_active_index" ON "public"."gudangs" USING "btree" ("cabang_id", "is_active");


--
-- Name: gudangs_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "gudangs_is_active_index" ON "public"."gudangs" USING "btree" ("is_active");


--
-- Name: jobs_queue_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "jobs_queue_index" ON "public"."jobs" USING "btree" ("queue");


--
-- Name: journal_entries_cabang_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "journal_entries_cabang_id_index" ON "public"."journal_entries" USING "btree" ("cabang_id");


--
-- Name: journal_entries_journal_date_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "journal_entries_journal_date_index" ON "public"."journal_entries" USING "btree" ("journal_date");


--
-- Name: journal_entries_number_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "journal_entries_number_index" ON "public"."journal_entries" USING "btree" ("number");


--
-- Name: journal_entries_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "journal_entries_status_index" ON "public"."journal_entries" USING "btree" ("status");


--
-- Name: journal_lines_account_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "journal_lines_account_id_index" ON "public"."journal_lines" USING "btree" ("account_id");


--
-- Name: journal_lines_cabang_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "journal_lines_cabang_id_index" ON "public"."journal_lines" USING "btree" ("cabang_id");


--
-- Name: journal_lines_journal_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "journal_lines_journal_id_index" ON "public"."journal_lines" USING "btree" ("journal_id");


--
-- Name: journal_lines_ref_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "journal_lines_ref_id_index" ON "public"."journal_lines" USING "btree" ("ref_id");


--
-- Name: journal_lines_ref_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "journal_lines_ref_type_index" ON "public"."journal_lines" USING "btree" ("ref_type");


--
-- Name: model_has_permissions_model_id_model_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "model_has_permissions_model_id_model_type_index" ON "public"."model_has_permissions" USING "btree" ("model_id", "model_type");


--
-- Name: model_has_roles_model_id_model_type_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "model_has_roles_model_id_model_type_index" ON "public"."model_has_roles" USING "btree" ("model_id", "model_type");


--
-- Name: order_change_logs_action_occurred_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "order_change_logs_action_occurred_at_index" ON "public"."order_change_logs" USING "btree" ("action", "occurred_at");


--
-- Name: order_change_logs_order_id_occurred_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "order_change_logs_order_id_occurred_at_index" ON "public"."order_change_logs" USING "btree" ("order_id", "occurred_at");


--
-- Name: order_item_lot_allocations_order_item_id_stock_lot_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "order_item_lot_allocations_order_item_id_stock_lot_id_index" ON "public"."order_item_lot_allocations" USING "btree" ("order_item_id", "stock_lot_id");


--
-- Name: order_items_order_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "order_items_order_id_index" ON "public"."order_items" USING "btree" ("order_id");


--
-- Name: order_items_variant_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "order_items_variant_id_index" ON "public"."order_items" USING "btree" ("variant_id");


--
-- Name: orders_cabang_id_ordered_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "orders_cabang_id_ordered_at_index" ON "public"."orders" USING "btree" ("cabang_id", "ordered_at");


--
-- Name: orders_cash_position_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "orders_cash_position_index" ON "public"."orders" USING "btree" ("cash_position");


--
-- Name: orders_cashier_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "orders_cashier_id_index" ON "public"."orders" USING "btree" ("cashier_id");


--
-- Name: orders_gudang_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "orders_gudang_id_index" ON "public"."orders" USING "btree" ("gudang_id");


--
-- Name: orders_paid_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "orders_paid_at_index" ON "public"."orders" USING "btree" ("paid_at");


--
-- Name: orders_status_channel_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "orders_status_channel_index" ON "public"."orders" USING "btree" ("status", "channel");


--
-- Name: payments_order_id_method_status_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "payments_order_id_method_status_index" ON "public"."payments" USING "btree" ("order_id", "method", "status");


--
-- Name: payments_paid_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "payments_paid_at_index" ON "public"."payments" USING "btree" ("paid_at");


--
-- Name: personal_access_tokens_expires_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "personal_access_tokens_expires_at_index" ON "public"."personal_access_tokens" USING "btree" ("expires_at");


--
-- Name: personal_access_tokens_tokenable_type_tokenable_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "personal_access_tokens_tokenable_type_tokenable_id_index" ON "public"."personal_access_tokens" USING "btree" ("tokenable_type", "tokenable_id");


--
-- Name: product_media_primary_sort_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "product_media_primary_sort_idx" ON "public"."product_media" USING "btree" ("product_id", "is_primary", "sort_order");


--
-- Name: product_media_product_id_is_primary_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "product_media_product_id_is_primary_index" ON "public"."product_media" USING "btree" ("product_id", "is_primary");


--
-- Name: product_variants_product_id_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "product_variants_product_id_is_active_index" ON "public"."product_variants" USING "btree" ("product_id", "is_active");


--
-- Name: products_category_id_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "products_category_id_is_active_index" ON "public"."products" USING "btree" ("category_id", "is_active");


--
-- Name: receipts_order_id_printed_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "receipts_order_id_printed_at_index" ON "public"."receipts" USING "btree" ("order_id", "printed_at");


--
-- Name: settings_scope_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "settings_scope_idx" ON "public"."settings" USING "btree" ("scope", "scope_id");


--
-- Name: stock_lots_gudang_id_product_variant_id_expires_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "stock_lots_gudang_id_product_variant_id_expires_at_index" ON "public"."stock_lots" USING "btree" ("gudang_id", "product_variant_id", "expires_at");


--
-- Name: stock_lots_gudang_id_product_variant_id_received_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "stock_lots_gudang_id_product_variant_id_received_at_index" ON "public"."stock_lots" USING "btree" ("gudang_id", "product_variant_id", "received_at");


--
-- Name: stock_movements_gudang_id_product_variant_id_created_at_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "stock_movements_gudang_id_product_variant_id_created_at_index" ON "public"."stock_movements" USING "btree" ("gudang_id", "product_variant_id", "created_at");


--
-- Name: users_cabang_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "users_cabang_id_index" ON "public"."users" USING "btree" ("cabang_id");


--
-- Name: users_is_active_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "users_is_active_index" ON "public"."users" USING "btree" ("is_active");


--
-- Name: users_phone_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "users_phone_index" ON "public"."users" USING "btree" ("phone");


--
-- Name: users_role_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "users_role_index" ON "public"."users" USING "btree" ("role");


--
-- Name: variant_stocks_cabang_id_gudang_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "variant_stocks_cabang_id_gudang_id_index" ON "public"."variant_stocks" USING "btree" ("cabang_id", "gudang_id");


--
-- Name: variant_stocks_product_variant_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "variant_stocks_product_variant_id_index" ON "public"."variant_stocks" USING "btree" ("product_variant_id");


--
-- Name: accounts accounts_cabang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_cabang_id_foreign" FOREIGN KEY ("cabang_id") REFERENCES "public"."cabangs"("id") ON DELETE SET NULL;


--
-- Name: accounts accounts_parent_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."accounts"
    ADD CONSTRAINT "accounts_parent_id_foreign" FOREIGN KEY ("parent_id") REFERENCES "public"."accounts"("id") ON DELETE RESTRICT;


--
-- Name: cash_holders cash_holders_cabang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_holders"
    ADD CONSTRAINT "cash_holders_cabang_id_foreign" FOREIGN KEY ("cabang_id") REFERENCES "public"."cabangs"("id");


--
-- Name: cash_moves cash_moves_approved_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_moves"
    ADD CONSTRAINT "cash_moves_approved_by_foreign" FOREIGN KEY ("approved_by") REFERENCES "public"."users"("id");


--
-- Name: cash_moves cash_moves_from_holder_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_moves"
    ADD CONSTRAINT "cash_moves_from_holder_id_foreign" FOREIGN KEY ("from_holder_id") REFERENCES "public"."cash_holders"("id");


--
-- Name: cash_moves cash_moves_submitted_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_moves"
    ADD CONSTRAINT "cash_moves_submitted_by_foreign" FOREIGN KEY ("submitted_by") REFERENCES "public"."users"("id");


--
-- Name: cash_moves cash_moves_to_holder_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_moves"
    ADD CONSTRAINT "cash_moves_to_holder_id_foreign" FOREIGN KEY ("to_holder_id") REFERENCES "public"."cash_holders"("id");


--
-- Name: cash_sessions cash_sessions_cabang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_sessions"
    ADD CONSTRAINT "cash_sessions_cabang_id_foreign" FOREIGN KEY ("cabang_id") REFERENCES "public"."cabangs"("id");


--
-- Name: cash_sessions cash_sessions_cashier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_sessions"
    ADD CONSTRAINT "cash_sessions_cashier_id_foreign" FOREIGN KEY ("cashier_id") REFERENCES "public"."users"("id");


--
-- Name: cash_transactions cash_transactions_session_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cash_transactions"
    ADD CONSTRAINT "cash_transactions_session_id_foreign" FOREIGN KEY ("session_id") REFERENCES "public"."cash_sessions"("id") ON DELETE CASCADE;


--
-- Name: deliveries deliveries_assigned_to_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."deliveries"
    ADD CONSTRAINT "deliveries_assigned_to_foreign" FOREIGN KEY ("assigned_to") REFERENCES "public"."users"("id") ON DELETE SET NULL;


--
-- Name: deliveries deliveries_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."deliveries"
    ADD CONSTRAINT "deliveries_order_id_foreign" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE RESTRICT;


--
-- Name: delivery_events delivery_events_delivery_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."delivery_events"
    ADD CONSTRAINT "delivery_events_delivery_id_foreign" FOREIGN KEY ("delivery_id") REFERENCES "public"."deliveries"("id") ON DELETE CASCADE;


--
-- Name: fiscal_periods fiscal_periods_cabang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."fiscal_periods"
    ADD CONSTRAINT "fiscal_periods_cabang_id_foreign" FOREIGN KEY ("cabang_id") REFERENCES "public"."cabangs"("id") ON DELETE CASCADE;


--
-- Name: gudangs gudangs_cabang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."gudangs"
    ADD CONSTRAINT "gudangs_cabang_id_foreign" FOREIGN KEY ("cabang_id") REFERENCES "public"."cabangs"("id") ON DELETE CASCADE;


--
-- Name: journal_entries journal_entries_cabang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."journal_entries"
    ADD CONSTRAINT "journal_entries_cabang_id_foreign" FOREIGN KEY ("cabang_id") REFERENCES "public"."cabangs"("id") ON DELETE CASCADE;


--
-- Name: journal_lines journal_lines_account_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."journal_lines"
    ADD CONSTRAINT "journal_lines_account_id_foreign" FOREIGN KEY ("account_id") REFERENCES "public"."accounts"("id") ON DELETE RESTRICT;


--
-- Name: journal_lines journal_lines_cabang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."journal_lines"
    ADD CONSTRAINT "journal_lines_cabang_id_foreign" FOREIGN KEY ("cabang_id") REFERENCES "public"."cabangs"("id") ON DELETE CASCADE;


--
-- Name: journal_lines journal_lines_journal_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."journal_lines"
    ADD CONSTRAINT "journal_lines_journal_id_foreign" FOREIGN KEY ("journal_id") REFERENCES "public"."journal_entries"("id") ON DELETE CASCADE;


--
-- Name: model_has_permissions model_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."model_has_permissions"
    ADD CONSTRAINT "model_has_permissions_permission_id_foreign" FOREIGN KEY ("permission_id") REFERENCES "public"."permissions"("id") ON DELETE CASCADE;


--
-- Name: model_has_roles model_has_roles_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."model_has_roles"
    ADD CONSTRAINT "model_has_roles_role_id_foreign" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id") ON DELETE CASCADE;


--
-- Name: order_change_logs order_change_logs_actor_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."order_change_logs"
    ADD CONSTRAINT "order_change_logs_actor_id_foreign" FOREIGN KEY ("actor_id") REFERENCES "public"."users"("id") ON DELETE SET NULL;


--
-- Name: order_change_logs order_change_logs_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."order_change_logs"
    ADD CONSTRAINT "order_change_logs_order_id_foreign" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE;


--
-- Name: order_items order_items_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_order_id_foreign" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE;


--
-- Name: order_items order_items_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."order_items"
    ADD CONSTRAINT "order_items_variant_id_foreign" FOREIGN KEY ("variant_id") REFERENCES "public"."product_variants"("id") ON DELETE RESTRICT;


--
-- Name: orders orders_cabang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_cabang_id_foreign" FOREIGN KEY ("cabang_id") REFERENCES "public"."cabangs"("id") ON DELETE RESTRICT;


--
-- Name: orders orders_cashier_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_cashier_id_foreign" FOREIGN KEY ("cashier_id") REFERENCES "public"."users"("id") ON DELETE RESTRICT;


--
-- Name: orders orders_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_customer_id_fkey" FOREIGN KEY ("customer_id") REFERENCES "public"."customers"("id") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: orders orders_gudang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."orders"
    ADD CONSTRAINT "orders_gudang_id_foreign" FOREIGN KEY ("gudang_id") REFERENCES "public"."gudangs"("id") ON DELETE RESTRICT;


--
-- Name: payments payments_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."payments"
    ADD CONSTRAINT "payments_order_id_foreign" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON DELETE CASCADE;


--
-- Name: product_media product_media_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."product_media"
    ADD CONSTRAINT "product_media_product_id_foreign" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;


--
-- Name: product_variants product_variants_product_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."product_variants"
    ADD CONSTRAINT "product_variants_product_id_foreign" FOREIGN KEY ("product_id") REFERENCES "public"."products"("id") ON DELETE CASCADE;


--
-- Name: products products_category_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."products"
    ADD CONSTRAINT "products_category_id_foreign" FOREIGN KEY ("category_id") REFERENCES "public"."categories"("id") ON DELETE RESTRICT;


--
-- Name: receipts receipts_order_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."receipts"
    ADD CONSTRAINT "receipts_order_id_foreign" FOREIGN KEY ("order_id") REFERENCES "public"."orders"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: receipts receipts_printed_by_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."receipts"
    ADD CONSTRAINT "receipts_printed_by_foreign" FOREIGN KEY ("printed_by") REFERENCES "public"."users"("id") ON DELETE SET NULL;


--
-- Name: receipts receipts_reprint_of_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."receipts"
    ADD CONSTRAINT "receipts_reprint_of_id_foreign" FOREIGN KEY ("reprint_of_id") REFERENCES "public"."receipts"("id") ON DELETE SET NULL;


--
-- Name: role_has_permissions role_has_permissions_permission_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."role_has_permissions"
    ADD CONSTRAINT "role_has_permissions_permission_id_foreign" FOREIGN KEY ("permission_id") REFERENCES "public"."permissions"("id") ON DELETE CASCADE;


--
-- Name: role_has_permissions role_has_permissions_role_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."role_has_permissions"
    ADD CONSTRAINT "role_has_permissions_role_id_foreign" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id") ON DELETE CASCADE;


--
-- Name: users users_cabang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_cabang_id_foreign" FOREIGN KEY ("cabang_id") REFERENCES "public"."cabangs"("id") ON DELETE SET NULL;


--
-- Name: variant_stocks variant_stocks_cabang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."variant_stocks"
    ADD CONSTRAINT "variant_stocks_cabang_id_foreign" FOREIGN KEY ("cabang_id") REFERENCES "public"."cabangs"("id") ON DELETE CASCADE;


--
-- Name: variant_stocks variant_stocks_gudang_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."variant_stocks"
    ADD CONSTRAINT "variant_stocks_gudang_id_foreign" FOREIGN KEY ("gudang_id") REFERENCES "public"."gudangs"("id") ON DELETE CASCADE;


--
-- Name: variant_stocks variant_stocks_product_variant_id_foreign; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."variant_stocks"
    ADD CONSTRAINT "variant_stocks_product_variant_id_foreign" FOREIGN KEY ("product_variant_id") REFERENCES "public"."product_variants"("id") ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

\unrestrict 0HrWxNNaG3Ni4SVAHM21dIcvi0ojMseA1YtvxvGNndtno5d4aFM7c0d9VZXapVX

