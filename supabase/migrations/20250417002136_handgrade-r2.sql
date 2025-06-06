create schema if not exists "pgmq_public";
create extension if not exists pgmq;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION pgmq_public.archive(queue_name text, message_id bigint)
 RETURNS boolean
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$ begin return pgmq.archive( queue_name := queue_name, msg_id := message_id ); end; $function$
;

CREATE OR REPLACE FUNCTION pgmq_public.delete(queue_name text, message_id bigint)
 RETURNS boolean
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$ begin return pgmq.delete( queue_name := queue_name, msg_id := message_id ); end; $function$
;

CREATE OR REPLACE FUNCTION pgmq_public.pop(queue_name text)
 RETURNS SETOF pgmq.message_record
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$ begin return query select * from pgmq.pop( queue_name := queue_name ); end; $function$
;

CREATE OR REPLACE FUNCTION pgmq_public.read(queue_name text, sleep_seconds integer, n integer)
 RETURNS SETOF pgmq.message_record
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$ begin return query select * from pgmq.read( queue_name := queue_name, vt := sleep_seconds, qty := n ); end; $function$
;

CREATE OR REPLACE FUNCTION pgmq_public.send(queue_name text, message jsonb, sleep_seconds integer DEFAULT 0)
 RETURNS SETOF bigint
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$ begin return query select * from pgmq.send( queue_name := queue_name, msg := message, delay := sleep_seconds ); end; $function$
;

CREATE OR REPLACE FUNCTION pgmq_public.send_batch(queue_name text, messages jsonb[], sleep_seconds integer DEFAULT 0)
 RETURNS SETOF bigint
 LANGUAGE plpgsql
 SET search_path TO ''
AS $function$ begin return query select * from pgmq.send_batch( queue_name := queue_name, msgs := messages, delay := sleep_seconds ); end; $function$
;


revoke delete on table "public"."calculated_score" from "anon";

revoke insert on table "public"."calculated_score" from "anon";

revoke references on table "public"."calculated_score" from "anon";

revoke select on table "public"."calculated_score" from "anon";

revoke trigger on table "public"."calculated_score" from "anon";

revoke truncate on table "public"."calculated_score" from "anon";

revoke update on table "public"."calculated_score" from "anon";

revoke delete on table "public"."calculated_score" from "authenticated";

revoke insert on table "public"."calculated_score" from "authenticated";

revoke references on table "public"."calculated_score" from "authenticated";

revoke select on table "public"."calculated_score" from "authenticated";

revoke trigger on table "public"."calculated_score" from "authenticated";

revoke truncate on table "public"."calculated_score" from "authenticated";

revoke update on table "public"."calculated_score" from "authenticated";

revoke delete on table "public"."calculated_score" from "service_role";

revoke insert on table "public"."calculated_score" from "service_role";

revoke references on table "public"."calculated_score" from "service_role";

revoke select on table "public"."calculated_score" from "service_role";

revoke trigger on table "public"."calculated_score" from "service_role";

revoke truncate on table "public"."calculated_score" from "service_role";

revoke update on table "public"."calculated_score" from "service_role";

drop table "public"."calculated_score";

create table "public"."rubric_parts" (
    "id" bigint generated by default as identity not null,
    "created_at" timestamp with time zone not null default now(),
    "class_id" bigint not null,
    "rubric_id" bigint not null,
    "name" text not null,
    "description" text,
    "ordinal" numeric not null,
    "data" jsonb
);


alter table "public"."rubric_parts" enable row level security;

alter table "public"."rubric_checks" drop column "allow_other_points";

alter table "public"."rubric_checks" add column "data" jsonb;

alter table "public"."rubric_checks" alter column "is_comment_required" set default false;

alter table "public"."rubric_criteria" add column "data" jsonb;

alter table "public"."rubric_criteria" add column "ordinal" integer not null default 0;

alter table "public"."rubric_criteria" add column "rubric_part_id" bigint not null;

CREATE UNIQUE INDEX rubric_parts_pkey ON public.rubric_parts USING btree (id);

alter table "public"."rubric_parts" add constraint "rubric_parts_pkey" PRIMARY KEY using index "rubric_parts_pkey";

alter table "public"."rubric_criteria" add constraint "rubric_criteria_rubric_part_id_fkey" FOREIGN KEY (rubric_part_id) REFERENCES "public".rubric_parts(id) not valid;

alter table "public"."rubric_criteria" validate constraint "rubric_criteria_rubric_part_id_fkey";

alter table "public"."rubric_parts" add constraint "rubric_parts_class_id_fkey" FOREIGN KEY (class_id) REFERENCES public.classes(id) not valid;

alter table "public"."rubric_parts" validate constraint "rubric_parts_class_id_fkey";

alter table "public"."rubric_parts" add constraint "rubric_parts_rubric_id_fkey" FOREIGN KEY (rubric_id) REFERENCES public.rubrics(id) not valid;

alter table "public"."rubric_parts" validate constraint "rubric_parts_rubric_id_fkey";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.assignments_grader_config_auto_populate()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
    declare 
    rubric_id int;
    begin
  
  INSERT INTO autograder (id) VALUES (NEW.id);
  INSERT INTO autograder_regression_test (autograder_id,repository) VALUES (NEW.id, NEW.template_repo);
  INSERT INTO rubrics (name, class_id) VALUES ('Grading Rubric', NEW.class_id) RETURNING id into rubric_id;
  UPDATE assignments set grading_rubric_id=rubric_id WHERE id=NEW.id;
  RETURN NULL;
end;$function$
;

grant delete on table "public"."rubric_parts" to "anon";

grant insert on table "public"."rubric_parts" to "anon";

grant references on table "public"."rubric_parts" to "anon";

grant select on table "public"."rubric_parts" to "anon";

grant trigger on table "public"."rubric_parts" to "anon";

grant truncate on table "public"."rubric_parts" to "anon";

grant update on table "public"."rubric_parts" to "anon";

grant delete on table "public"."rubric_parts" to "authenticated";

grant insert on table "public"."rubric_parts" to "authenticated";

grant references on table "public"."rubric_parts" to "authenticated";

grant select on table "public"."rubric_parts" to "authenticated";

grant trigger on table "public"."rubric_parts" to "authenticated";

grant truncate on table "public"."rubric_parts" to "authenticated";

grant update on table "public"."rubric_parts" to "authenticated";

grant delete on table "public"."rubric_parts" to "service_role";

grant insert on table "public"."rubric_parts" to "service_role";

grant references on table "public"."rubric_parts" to "service_role";

grant select on table "public"."rubric_parts" to "service_role";

grant trigger on table "public"."rubric_parts" to "service_role";

grant truncate on table "public"."rubric_parts" to "service_role";

grant update on table "public"."rubric_parts" to "service_role";

create policy "instructors CRUD"
on "public"."rubric_checks"
as permissive
for all
to public
using (public.authorizeforclassinstructor(class_id));


create policy "instructors CRUD"
on "public"."rubric_criteria"
as permissive
for all
to public
using (public.authorizeforclassinstructor(class_id));


create policy "authorizeforclass"
on "public"."rubric_parts"
as permissive
for select
to public
using (public.authorizeforclass(class_id));


create policy "instructors CRUD"
on "public"."rubric_parts"
as permissive
for all
to public
using (public.authorizeforclassinstructor(class_id));



