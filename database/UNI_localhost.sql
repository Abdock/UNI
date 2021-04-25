--
-- PostgreSQL database dump
--

-- Dumped from database version 12.5
-- Dumped by pg_dump version 12.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE "UNI";
--
-- Name: UNI; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "UNI" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Russian_Kazakhstan.1251' LC_CTYPE = 'Russian_Kazakhstan.1251';


ALTER DATABASE "UNI" OWNER TO postgres;

\connect "UNI"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: calc_grade(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.calc_grade() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
            IF new.grade > 100 THEN
                new.grade = 100;
            end if;
            IF new.grade < 0 THEN
                new.grade = 0;
            end if;
            if new.weight > 1 then
                new.weight = 1; 
            end if;
            if new.weight < 0 then
                new.weight = 0;
            end if;
            if new.week > 7 then
                update exam set endterm = 0 where exam.student_id = new.student_id and exam.subject_id = new.subject_id;
            else
                update exam set midterm = 0 where exam.student_id = new.student_id and exam.subject_id = new.subject_id;
            end if;
            update exam set final = 0 where exam.student_id = new.student_id and exam.subject_id = new.subject_id;
            if exists(select * from exam where student_id = new.student_id and subject_id = new.subject_id) then
                if new.week > 7 then
                    update exam set endterm = endterm + (new.grade * new.weight) where exam.student_id = new.student_id and exam.subject_id = new.subject_id;
                else
                    update exam set midterm = midterm + (new.grade * new.weight) where exam.student_id = new.student_id and exam.subject_id = new.subject_id;
                end if;
            else
                insert into exam(student_id, subject_id) values(new.student_id, new.subject_id);
                if new.week > 7 then
                    update exam set endterm = endterm + (new.grade * new.weight) where exam.student_id = new.student_id and exam.subject_id = new.subject_id;
                else
                    update exam set midterm = midterm + (new.grade * new.weight) where exam.student_id = new.student_id and exam.subject_id = new.subject_id;
                end if;
            end if;
            update exam set final = midterm * 0.3 + endterm * 0.3 + session * 0.4 where exam.student_id = new.student_id and exam.subject_id = new.subject_id;
            return new;
        END;
$$;


ALTER FUNCTION public.calc_grade() OWNER TO postgres;

--
-- Name: check_level(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.check_level() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
            if (old.grade is not null and new.grade > old.grade and new.grade >= 80) then
                update student set english_skill = english_skill + 1 where student.student_id = new.student_id;
            else 
                if (old.grade is null and new.grade >= 80) then
                    update student set english_skill = english_skill + 1 where student.student_id = new.student_id;
                end if;
            end if;
            return new;
        end;
$$;


ALTER FUNCTION public.check_level() OWNER TO postgres;

--
-- Name: current_week(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.current_week(st bigint) RETURNS integer
    LANGUAGE sql
    AS $$
        select (current_date - begin_date) / 7 from semesters_date
            join student s on semesters_date.semester_id = s.semester_id
                and s.student_id = st
    $$;


ALTER FUNCTION public.current_week(st bigint) OWNER TO postgres;

--
-- Name: forecast_for_student_of_subject(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.forecast_for_student_of_subject(us bigint, sub bigint) RETURNS double precision
    LANGUAGE sql
    AS $$
        SELECT AVG(grade) * AVG(weight) * (14 - MAX(week)) FROM attendance a JOIN users u
        ON u.user_id = us AND u.second_id = a.student_id AND a.subject_id = sub
    $$;


ALTER FUNCTION public.forecast_for_student_of_subject(us bigint, sub bigint) OWNER TO postgres;

--
-- Name: get_all_sessions_date(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_all_sessions_date(us bigint) RETURNS TABLE(subject_id bigint, subject_name character varying, session_date date, credits integer)
    LANGUAGE sql
    AS $$
        SELECT s1.subject_id, s1.subject_name, a.session_date, s1.credits FROM subject s1
            JOIN attendance a on s1.subject_id = a.subject_id
            JOIN student s on a.student_id = s.student_id
            JOIN users u on u.second_id = s.student_id AND u.user_id = us
        WHERE a.session_date > current_date
    $$;


ALTER FUNCTION public.get_all_sessions_date(us bigint) OWNER TO postgres;

--
-- Name: get_current_attendance(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_current_attendance(us bigint, sub bigint) RETURNS double precision
    LANGUAGE sql
    AS $$
        SELECT ( COUNT(*)::double precision / 14.0) FROM users u 
            JOIN student s ON u.second_id = s.student_id AND u.user_id = us
            JOIN attendance a on s.student_id = a.student_id AND a.subject_id = sub
    $$;


ALTER FUNCTION public.get_current_attendance(us bigint, sub bigint) OWNER TO postgres;

--
-- Name: is_second_semester(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_second_semester(st bigint) RETURNS boolean
    LANGUAGE sql
    AS $$
        select (current_date - begin_date) / 7 <= (end_date - begin_date) / 7 / 2 from semesters_date
            join student s on semesters_date.semester_id = s.semester_id
                and s.student_id = 5
    $$;


ALTER FUNCTION public.is_second_semester(st bigint) OWNER TO postgres;

--
-- Name: midterms_grade_calc(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.midterms_grade_calc() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (is_second_semester(new.student_id)) THEN
        IF (EXISTS(SELECT mr.group_id, mr.subject_id FROM student s
                  JOIN "group" g ON s.group_id = g.group_id AND new.student_id = s.student_id
                  JOIN endterm_result mr on g.group_id = mr.group_id AND mr.subject_id = new.subject_id)) THEN
            INSERT INTO endterm_result(group_id, subject_id, excellent, good, middle, low) 
            VALUES((select group_id from student where student.student_id = new.student_id), new.subject_id,
                ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 90, 100),
                ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 70, 89),
                ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 50, 69),
                ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 0, 50));
        ELSE
            UPDATE endterm_result
            SET
                excellent = ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 90, 100),
                good = ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 70, 89),
                middle = ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 50, 69),
                low = ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 0, 50)
            WHERE endterm_result.subject_id = new.subject_id
              AND endterm_result.group_id = (SELECT g.group_id FROM
                "group" g JOIN
                student s3 on g.group_id = s3.group_id AND s3.student_id = new.student_id);
        END IF;
    ELSE
        IF (EXISTS(SELECT mr.group_id, mr.subject_id FROM student s
                      JOIN "group" g ON s.group_id = g.group_id AND new.student_id = s.student_id
                      JOIN midterm_result mr on g.group_id = mr.group_id AND mr.subject_id = new.subject_id)) THEN
            INSERT INTO midterm_result(group_id, subject_id, excellent, good, middle, low)
            VALUES((select group_id from student where student.student_id = new.student_id), new.subject_id,
                   ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 90, 100),
                   ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 70, 89),
                   ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 50, 69),
                   ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 0, 50));
        ELSE
            UPDATE midterm_result
            SET
                excellent = ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 90, 100),
                good = ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 70, 89),
                middle = ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 50, 69),
                low = ratio_of_student_in_group((select g.group_id from "group" g join student s2 on g.group_id = s2.group_id and s2.student_id = new.student_id), new.subject_id, 0, 50)
            WHERE midterm_result.subject_id = new.subject_id
              AND midterm_result.group_id = (SELECT g.group_id FROM
                "group" g JOIN
                student s3 on g.group_id = s3.group_id AND s3.student_id = new.student_id);
        END IF;
    END IF;
    RETURN NEW;
end;
$$;


ALTER FUNCTION public.midterms_grade_calc() OWNER TO postgres;

--
-- Name: ratio_of_student_in_group(bigint, bigint, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ratio_of_student_in_group(gid bigint, sid bigint, grade_begin double precision, grade_end double precision) RETURNS double precision
    LANGUAGE sql
    AS $$
        select t1.cnt::double precision / t2.cnt::double precision from 
        (select count(*) as cnt from students_of_group_that_have_midterm_grade_in_range(gid, sid, grade_begin, grade_end)) as t1,
        (select count(*) as cnt from students_of_group(gid)) as t2;
    $$;


ALTER FUNCTION public.ratio_of_student_in_group(gid bigint, sid bigint, grade_begin double precision, grade_end double precision) OWNER TO postgres;

--
-- Name: student_avg_grade_of_subject(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.student_avg_grade_of_subject(users_id bigint, lesson_id bigint) RETURNS double precision
    LANGUAGE sql
    AS $$
        SELECT AVG(grade) FROM attendance a JOIN
            student s on a.student_id = s.student_id AND a.subject_id = lesson_id JOIN
            users u on u.second_id = s.student_id AND u.user_id = users_id
    $$;


ALTER FUNCTION public.student_avg_grade_of_subject(users_id bigint, lesson_id bigint) OWNER TO postgres;

--
-- Name: student_current_grade_of_subject(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.student_current_grade_of_subject(users_id bigint, lesson_id bigint) RETURNS double precision
    LANGUAGE sql
    AS $$
        SELECT SUM(a.grade * a.weight) FROM attendance a JOIN
            student s on a.student_id = s.student_id AND a.subject_id = lesson_id JOIN
            users u on u.second_id = s.student_id AND u.user_id = users_id
    $$;


ALTER FUNCTION public.student_current_grade_of_subject(users_id bigint, lesson_id bigint) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    week integer NOT NULL,
    student_id bigint NOT NULL,
    subject_id bigint NOT NULL,
    grade double precision,
    weight double precision,
    homework_deadline date DEFAULT CURRENT_DATE NOT NULL,
    session_date date
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: student_grades_of_subject(bigint, bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.student_grades_of_subject(users_id bigint, lesson_id bigint) RETURNS SETOF public.attendance
    LANGUAGE sql
    AS $$
        SELECT a.* FROM attendance a JOIN
            student s on a.student_id = s.student_id AND a.subject_id = lesson_id JOIN
            users u on u.second_id = s.student_id AND u.user_id = users_id
    $$;


ALTER FUNCTION public.student_grades_of_subject(users_id bigint, lesson_id bigint) OWNER TO postgres;

--
-- Name: subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject (
    subject_id bigint NOT NULL,
    subject_name character varying NOT NULL,
    credits integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.subject OWNER TO postgres;

--
-- Name: student_subjects(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.student_subjects(users_id bigint) RETURNS SETOF public.subject
    LANGUAGE sql
    AS $$
        SELECT s3.* FROM users u
            JOIN student s ON u.second_id = s.student_id AND u.user_id = users_id
            JOIN "group" g on s.group_id = g.group_id
            JOIN schedule s2 on g.group_id = s2.group_id
            JOIN subject s3 on s2.subject_id = s3.subject_id
    $$;


ALTER FUNCTION public.student_subjects(users_id bigint) OWNER TO postgres;

--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    student_id bigint NOT NULL,
    student_name character varying(50) NOT NULL,
    student_surname character varying(50) NOT NULL,
    phone_number character varying(20) NOT NULL,
    enrollment_date date DEFAULT CURRENT_DATE NOT NULL,
    speciality_id integer NOT NULL,
    group_id bigint,
    course smallint DEFAULT 1 NOT NULL,
    english_skill integer DEFAULT 1 NOT NULL,
    semester_id bigint DEFAULT 1 NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: students_of_group(bigint); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.students_of_group(gid bigint) RETURNS SETOF public.student
    LANGUAGE sql
    AS $$
    select s.* from "group" g
            join student s on g.group_id = s.group_id and g.group_id = gid;
    $$;


ALTER FUNCTION public.students_of_group(gid bigint) OWNER TO postgres;

--
-- Name: students_of_group_that_have_midterm_grade_in_range(bigint, bigint, double precision, double precision); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.students_of_group_that_have_midterm_grade_in_range(g_id bigint, sid bigint, grade_begin double precision, grade_end double precision) RETURNS SETOF public.student
    LANGUAGE sql
    AS $$
    select s.* from "group" g
            join student s on g.group_id = s.group_id and g.group_id = g_id
            join schedule s2 on g.group_id = s2.group_id
            join subject s3 on s2.subject_id = s3.subject_id and s3.subject_id = sid
            join exam e on s.student_id = e.student_id and e.subject_id = s3.subject_id
                and e.midterm between grade_begin and grade_end;
    $$;


ALTER FUNCTION public.students_of_group_that_have_midterm_grade_in_range(g_id bigint, sid bigint, grade_begin double precision, grade_end double precision) OWNER TO postgres;

--
-- Name: subject_of_student(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.subject_of_student() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
            insert into exam(student_id, subject_id) 
            select s.student_id, s2.subject_id from student s
            join "group" g on s.group_id = g.group_id and new.group_id = g.group_id
            join subject s2 on new.subject_id = s2.subject_id;
            return new;
        END;
$$;


ALTER FUNCTION public.subject_of_student() OWNER TO postgres;

--
-- Name: endterm_result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.endterm_result (
    group_id bigint NOT NULL,
    subject_id bigint NOT NULL,
    excellent double precision DEFAULT 0 NOT NULL,
    good double precision DEFAULT 0 NOT NULL,
    middle double precision DEFAULT 0 NOT NULL,
    low double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public.endterm_result OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    event_id bigint NOT NULL,
    event_icon character varying(300) DEFAULT 'https://www.flaticon.com/svg/vstatic/svg/2983/2983719.svg?token=exp=1619271065~hmac=e4077eed42b8004e6c898075f0b3b6ec'::character varying NOT NULL,
    event_date date NOT NULL,
    title character varying(200) NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: event_event_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.event_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.event_event_id_seq OWNER TO postgres;

--
-- Name: event_event_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.event_event_id_seq OWNED BY public.events.event_id;


--
-- Name: exam; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exam (
    student_id bigint NOT NULL,
    subject_id bigint NOT NULL,
    midterm double precision DEFAULT 0 NOT NULL,
    endterm double precision DEFAULT 0 NOT NULL,
    session double precision DEFAULT 0 NOT NULL,
    final double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public.exam OWNER TO postgres;

--
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty (
    faculty_id integer NOT NULL,
    faculty_name character varying(100) NOT NULL
);


ALTER TABLE public.faculty OWNER TO postgres;

--
-- Name: faculty_faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.faculty ALTER COLUMN faculty_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.faculty_faculty_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."group" (
    group_id bigint NOT NULL,
    group_name character varying(30) NOT NULL,
    curator_id bigint NOT NULL
);


ALTER TABLE public."group" OWNER TO postgres;

--
-- Name: group_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."group" ALTER COLUMN group_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.group_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: level_test_result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.level_test_result (
    student_id bigint NOT NULL,
    grade double precision NOT NULL,
    pass_date date DEFAULT CURRENT_DATE NOT NULL
);


ALTER TABLE public.level_test_result OWNER TO postgres;

--
-- Name: midterm_result; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.midterm_result (
    group_id bigint NOT NULL,
    subject_id bigint NOT NULL,
    excellent double precision DEFAULT 0 NOT NULL,
    good double precision DEFAULT 0 NOT NULL,
    middle double precision DEFAULT 0 NOT NULL,
    low double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public.midterm_result OWNER TO postgres;

--
-- Name: schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schedule (
    group_id bigint NOT NULL,
    subject_id bigint NOT NULL
);


ALTER TABLE public.schedule OWNER TO postgres;

--
-- Name: semesters_date; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.semesters_date (
    semester_id bigint NOT NULL,
    begin_date date NOT NULL,
    end_date date NOT NULL,
    midterm_date date,
    endterm_date date,
    session_date date
);


ALTER TABLE public.semesters_date OWNER TO postgres;

--
-- Name: semesters_date_semester_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.semesters_date_semester_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.semesters_date_semester_id_seq OWNER TO postgres;

--
-- Name: semesters_date_semester_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.semesters_date_semester_id_seq OWNED BY public.semesters_date.semester_id;


--
-- Name: speciality; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.speciality (
    speciality_id integer NOT NULL,
    speciality_name character varying(100) NOT NULL,
    faculty_id integer NOT NULL
);


ALTER TABLE public.speciality OWNER TO postgres;

--
-- Name: speciality_speciality_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.speciality ALTER COLUMN speciality_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.speciality_speciality_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: speciality_teacher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.speciality_teacher (
    specilaity_id integer NOT NULL,
    teacher_id bigint NOT NULL
);


ALTER TABLE public.speciality_teacher OWNER TO postgres;

--
-- Name: student_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.student ALTER COLUMN student_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.student_student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
);


--
-- Name: subject_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.subject ALTER COLUMN subject_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.subject_subject_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: teacher; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher (
    teacher_id bigint NOT NULL,
    teacher_name character varying(50) NOT NULL,
    teacher_surname character varying(50) NOT NULL,
    employment_date date DEFAULT CURRENT_DATE NOT NULL,
    phone_number character varying(50) NOT NULL
);


ALTER TABLE public.teacher OWNER TO postgres;

--
-- Name: teacher_subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teacher_subject (
    teacher_id bigint NOT NULL,
    subject_id bigint NOT NULL
);


ALTER TABLE public.teacher_subject OWNER TO postgres;

--
-- Name: teacher_teacher_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.teacher ALTER COLUMN teacher_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.teacher_teacher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 2147483647
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id bigint NOT NULL,
    password character varying DEFAULT 'Password123'::character varying NOT NULL,
    type character varying DEFAULT 'student'::character varying NOT NULL,
    second_id bigint NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: events event_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events ALTER COLUMN event_id SET DEFAULT nextval('public.event_event_id_seq'::regclass);


--
-- Name: semesters_date semester_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semesters_date ALTER COLUMN semester_id SET DEFAULT nextval('public.semesters_date_semester_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (1, 5, 1, 80, 0.1, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (1, 5, 2, 90, 0.1, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (1, 5, 4, 75, 0.1, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (2, 5, 1, 88, 0.05, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (2, 5, 2, 68, 0.05, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (3, 5, 1, 78, 0.15, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (3, 5, 4, 91, 0.1, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (1, 5, 3, 65, 0.1, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (2, 5, 3, 50, 0.05, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (3, 5, 3, 0, 0.05, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (4, 5, 3, 80, 0.1, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (4, 5, 1, 80, 0.05, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (4, 5, 4, 90, 0.1, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (4, 5, 2, 100, 0.1, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (5, 5, 1, 80, 0.05, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (5, 5, 4, 90, 0.1, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (5, 5, 2, 100, 0.1, '2021-04-24', NULL);
INSERT INTO public.attendance (week, student_id, subject_id, grade, weight, homework_deadline, session_date) VALUES (5, 5, 3, 0, 0.1, '2021-04-24', NULL);


--
-- Data for Name: endterm_result; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: exam; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.exam (student_id, subject_id, midterm, endterm, session, final) VALUES (5, 1, 34.099999999999994, 0, 0, 10.229999999999999);
INSERT INTO public.exam (student_id, subject_id, midterm, endterm, session, final) VALUES (5, 4, 39.1, 0, 0, 11.73);
INSERT INTO public.exam (student_id, subject_id, midterm, endterm, session, final) VALUES (5, 2, 37.4, 0, 0, 11.219999999999999);
INSERT INTO public.exam (student_id, subject_id, midterm, endterm, session, final) VALUES (5, 3, 17, 0, 0, 5.1);


--
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.faculty (faculty_id, faculty_name) OVERRIDING SYSTEM VALUE VALUES (1, 'Information Technology');


--
-- Data for Name: group; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public."group" (group_id, group_name, curator_id) OVERRIDING SYSTEM VALUE VALUES (1, 'ITIS-1914', 1);
INSERT INTO public."group" (group_id, group_name, curator_id) OVERRIDING SYSTEM VALUE VALUES (2, 'ITIS-1902', 2);


--
-- Data for Name: level_test_result; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.level_test_result (student_id, grade, pass_date) VALUES (5, 85, '2021-04-24');


--
-- Data for Name: midterm_result; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schedule (group_id, subject_id) VALUES (1, 1);
INSERT INTO public.schedule (group_id, subject_id) VALUES (1, 2);
INSERT INTO public.schedule (group_id, subject_id) VALUES (1, 4);
INSERT INTO public.schedule (group_id, subject_id) VALUES (2, 1);
INSERT INTO public.schedule (group_id, subject_id) VALUES (2, 2);
INSERT INTO public.schedule (group_id, subject_id) VALUES (2, 3);
INSERT INTO public.schedule (group_id, subject_id) VALUES (2, 4);
INSERT INTO public.schedule (group_id, subject_id) VALUES (1, 3);


--
-- Data for Name: semesters_date; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.semesters_date (semester_id, begin_date, end_date, midterm_date, endterm_date, session_date) VALUES (1, '2020-09-01', '2021-06-15', NULL, NULL, NULL);


--
-- Data for Name: speciality; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.speciality (speciality_id, speciality_name, faculty_id) OVERRIDING SYSTEM VALUE VALUES (1, 'IS', 1);
INSERT INTO public.speciality (speciality_id, speciality_name, faculty_id) OVERRIDING SYSTEM VALUE VALUES (2, 'CSSE', 1);
INSERT INTO public.speciality (speciality_id, speciality_name, faculty_id) OVERRIDING SYSTEM VALUE VALUES (3, 'CS', 1);


--
-- Data for Name: speciality_teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.speciality_teacher (specilaity_id, teacher_id) VALUES (1, 1);
INSERT INTO public.speciality_teacher (specilaity_id, teacher_id) VALUES (1, 2);
INSERT INTO public.speciality_teacher (specilaity_id, teacher_id) VALUES (1, 3);
INSERT INTO public.speciality_teacher (specilaity_id, teacher_id) VALUES (1, 5);
INSERT INTO public.speciality_teacher (specilaity_id, teacher_id) VALUES (1, 6);
INSERT INTO public.speciality_teacher (specilaity_id, teacher_id) VALUES (1, 7);


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.student (student_id, student_name, student_surname, phone_number, enrollment_date, speciality_id, group_id, course, english_skill, semester_id) OVERRIDING SYSTEM VALUE VALUES (6, 'Тимур', 'Мерекеев', '8 778 777 77 77', '2021-04-23', 1, 1, 1, 1, 1);
INSERT INTO public.student (student_id, student_name, student_surname, phone_number, enrollment_date, speciality_id, group_id, course, english_skill, semester_id) OVERRIDING SYSTEM VALUE VALUES (7, 'Ержигит', 'Мырзабаев', '8 778 946 34 67', '2021-04-23', 1, 2, 1, 1, 1);
INSERT INTO public.student (student_id, student_name, student_surname, phone_number, enrollment_date, speciality_id, group_id, course, english_skill, semester_id) OVERRIDING SYSTEM VALUE VALUES (5, 'Абдусаттар', 'Касымбеков', '8 707 898 98 32', '0001-01-01', 1, 1, 0, 2, 1);


--
-- Data for Name: subject; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.subject (subject_id, subject_name, credits) OVERRIDING SYSTEM VALUE VALUES (1, 'Math', 5);
INSERT INTO public.subject (subject_id, subject_name, credits) OVERRIDING SYSTEM VALUE VALUES (2, 'Algorithm and Data Structures', 5);
INSERT INTO public.subject (subject_id, subject_name, credits) OVERRIDING SYSTEM VALUE VALUES (4, 'Introduction to Web Development', 5);
INSERT INTO public.subject (subject_id, subject_name, credits) OVERRIDING SYSTEM VALUE VALUES (3, 'History', 3);


--
-- Data for Name: teacher; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.teacher (teacher_id, teacher_name, teacher_surname, employment_date, phone_number) OVERRIDING SYSTEM VALUE VALUES (1, 'Aigerim', 'Kairatovna', '2021-04-22', '+7 777 777 77 77');
INSERT INTO public.teacher (teacher_id, teacher_name, teacher_surname, employment_date, phone_number) OVERRIDING SYSTEM VALUE VALUES (2, 'Temirlan', 'Satylhanov', '2021-04-22', '+7 777 777 77 77');
INSERT INTO public.teacher (teacher_id, teacher_name, teacher_surname, employment_date, phone_number) OVERRIDING SYSTEM VALUE VALUES (3, 'Fahriddin', 'Umarov', '2021-04-23', '+7 777 777 77 77');
INSERT INTO public.teacher (teacher_id, teacher_name, teacher_surname, employment_date, phone_number) OVERRIDING SYSTEM VALUE VALUES (5, 'Василий', 'Сербин', '0001-01-01', '8 776 666 77 66');
INSERT INTO public.teacher (teacher_id, teacher_name, teacher_surname, employment_date, phone_number) OVERRIDING SYSTEM VALUE VALUES (6, 'Роман', 'Чесноков', '0001-01-01', '8 777 777 77 77');
INSERT INTO public.teacher (teacher_id, teacher_name, teacher_surname, employment_date, phone_number) OVERRIDING SYSTEM VALUE VALUES (7, 'Mohamed', 'Hamada', '0001-01-01', '8 777 777 77 76');


--
-- Data for Name: teacher_subject; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (1, 2);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (2, 2);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (1, 4);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (2, 1);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (2, 3);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (3, 1);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (2, 4);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (5, 1);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (5, 2);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (3, 4);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (6, 1);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (6, 2);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (6, 3);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (6, 4);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (7, 1);
INSERT INTO public.teacher_subject (teacher_id, subject_id) VALUES (7, 3);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users (user_id, password, type, second_id) VALUES (9, 'Password123', 'teacher', 1);
INSERT INTO public.users (user_id, password, type, second_id) VALUES (10, 'Password123', 'teacher', 2);
INSERT INTO public.users (user_id, password, type, second_id) VALUES (11, 'Password123', 'teacher', 3);
INSERT INTO public.users (user_id, password, type, second_id) VALUES (12, 'Password123', 'teacher', 5);
INSERT INTO public.users (user_id, password, type, second_id) VALUES (13, 'Password123', 'teacher', 6);
INSERT INTO public.users (user_id, password, type, second_id) VALUES (14, 'Password123', 'teacher', 7);
INSERT INTO public.users (user_id, password, type, second_id) VALUES (15, 'Password123', 'student', 5);
INSERT INTO public.users (user_id, password, type, second_id) VALUES (16, 'Password123', 'student', 6);
INSERT INTO public.users (user_id, password, type, second_id) VALUES (17, 'Password123', 'student', 7);


--
-- Name: event_event_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.event_event_id_seq', 1, false);


--
-- Name: faculty_faculty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_faculty_id_seq', 1, true);


--
-- Name: group_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.group_group_id_seq', 3, true);


--
-- Name: semesters_date_semester_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.semesters_date_semester_id_seq', 1, true);


--
-- Name: speciality_speciality_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.speciality_speciality_id_seq', 3, true);


--
-- Name: student_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_student_id_seq', 7, true);


--
-- Name: subject_subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subject_subject_id_seq', 4, true);


--
-- Name: teacher_teacher_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.teacher_teacher_id_seq', 8, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 17, true);


--
-- Name: attendance attendance_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pk PRIMARY KEY (subject_id, student_id, week);


--
-- Name: endterm_result endterm_result_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endterm_result
    ADD CONSTRAINT endterm_result_pk PRIMARY KEY (subject_id);


--
-- Name: events event_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT event_pk PRIMARY KEY (event_id);


--
-- Name: exam exams_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam
    ADD CONSTRAINT exams_pk PRIMARY KEY (student_id, subject_id);


--
-- Name: faculty faculty_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pk PRIMARY KEY (faculty_id);


--
-- Name: group group_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_pk PRIMARY KEY (group_id);


--
-- Name: level_test_result level_test_result_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.level_test_result
    ADD CONSTRAINT level_test_result_pk PRIMARY KEY (student_id);


--
-- Name: midterm_result midterm_result_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.midterm_result
    ADD CONSTRAINT midterm_result_pk PRIMARY KEY (subject_id);


--
-- Name: schedule schedule_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_pk PRIMARY KEY (group_id, subject_id);


--
-- Name: semesters_date semesters_date_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.semesters_date
    ADD CONSTRAINT semesters_date_pk PRIMARY KEY (semester_id);


--
-- Name: speciality speciality_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speciality
    ADD CONSTRAINT speciality_pk PRIMARY KEY (speciality_id);


--
-- Name: speciality_teacher speciality_teacher_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speciality_teacher
    ADD CONSTRAINT speciality_teacher_pk PRIMARY KEY (specilaity_id, teacher_id);


--
-- Name: student student_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pk PRIMARY KEY (student_id);


--
-- Name: subject subject_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_pk PRIMARY KEY (subject_id);


--
-- Name: teacher teacher_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher
    ADD CONSTRAINT teacher_pk PRIMARY KEY (teacher_id);


--
-- Name: teacher_subject teacher_subject_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subject
    ADD CONSTRAINT teacher_subject_pk PRIMARY KEY (teacher_id, subject_id);


--
-- Name: users users_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pk PRIMARY KEY (user_id);


--
-- Name: attendance_week_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX attendance_week_idx ON public.attendance USING btree (week, student_id, subject_id);


--
-- Name: event_event_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX event_event_id_uindex ON public.events USING btree (event_id);


--
-- Name: faculty_faculty_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX faculty_faculty_id_idx ON public.faculty USING btree (faculty_id);


--
-- Name: group_group_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX group_group_id_idx ON public."group" USING btree (group_id);


--
-- Name: level_test_result_student_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX level_test_result_student_id_uindex ON public.level_test_result USING btree (student_id);


--
-- Name: schedule_group_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX schedule_group_id_idx ON public.schedule USING btree (group_id, subject_id);


--
-- Name: semesters_date_semester_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX semesters_date_semester_id_uindex ON public.semesters_date USING btree (semester_id);


--
-- Name: speciality_speciality_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX speciality_speciality_id_idx ON public.speciality USING btree (speciality_id);


--
-- Name: speciality_teacher_specilaity_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX speciality_teacher_specilaity_id_idx ON public.speciality_teacher USING btree (specilaity_id, teacher_id);


--
-- Name: student_student_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX student_student_id_idx ON public.student USING btree (student_id);


--
-- Name: subject_subject_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX subject_subject_id_idx ON public.subject USING btree (subject_id);


--
-- Name: teacher_subject_teacher_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX teacher_subject_teacher_id_idx ON public.teacher_subject USING btree (teacher_id, subject_id);


--
-- Name: teacher_teacher_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX teacher_teacher_id_idx ON public.teacher USING btree (teacher_id);


--
-- Name: users_user_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX users_user_id_uindex ON public.users USING btree (user_id);


--
-- Name: schedule add_subjects_to_student; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER add_subjects_to_student AFTER INSERT ON public.schedule FOR EACH ROW EXECUTE FUNCTION public.subject_of_student();


--
-- Name: level_test_result modify_level; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER modify_level AFTER INSERT OR UPDATE ON public.level_test_result FOR EACH ROW EXECUTE FUNCTION public.check_level();


--
-- Name: attendance recalc_grade; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER recalc_grade AFTER INSERT OR UPDATE ON public.attendance FOR EACH ROW EXECUTE FUNCTION public.calc_grade();


--
-- Name: exam recalc_midterms_grade; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER recalc_midterms_grade AFTER UPDATE ON public.exam FOR EACH ROW EXECUTE FUNCTION public.midterms_grade_calc();


--
-- Name: attendance attendance_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_fk FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: attendance attendance_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_fk_1 FOREIGN KEY (subject_id) REFERENCES public.subject(subject_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: endterm_result endterm_result___fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endterm_result
    ADD CONSTRAINT endterm_result___fk_1 FOREIGN KEY (subject_id) REFERENCES public.subject(subject_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: endterm_result endterm_result_group_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.endterm_result
    ADD CONSTRAINT endterm_result_group_group_id_fk FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: exam exams_student_student_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam
    ADD CONSTRAINT exams_student_student_id_fk FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: exam exams_subject_subject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exam
    ADD CONSTRAINT exams_subject_subject_id_fk FOREIGN KEY (subject_id) REFERENCES public.subject(subject_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: group group_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."group"
    ADD CONSTRAINT group_fk FOREIGN KEY (curator_id) REFERENCES public.teacher(teacher_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: level_test_result level_test_result_student_student_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.level_test_result
    ADD CONSTRAINT level_test_result_student_student_id_fk FOREIGN KEY (student_id) REFERENCES public.student(student_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: midterm_result midterm_result_subject_subject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.midterm_result
    ADD CONSTRAINT midterm_result_subject_subject_id_fk FOREIGN KEY (subject_id) REFERENCES public.subject(subject_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: midterm_result midterm_results_group_group_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.midterm_result
    ADD CONSTRAINT midterm_results_group_group_id_fk FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: schedule schedule_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_fk FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: schedule schedule_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schedule
    ADD CONSTRAINT schedule_fk_1 FOREIGN KEY (subject_id) REFERENCES public.subject(subject_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: speciality speciality_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speciality
    ADD CONSTRAINT speciality_fk FOREIGN KEY (faculty_id) REFERENCES public.faculty(faculty_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: speciality_teacher speciality_teacher_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speciality_teacher
    ADD CONSTRAINT speciality_teacher_fk FOREIGN KEY (specilaity_id) REFERENCES public.speciality(speciality_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: speciality_teacher speciality_teacher_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.speciality_teacher
    ADD CONSTRAINT speciality_teacher_fk_1 FOREIGN KEY (teacher_id) REFERENCES public.teacher(teacher_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: student student_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_fk FOREIGN KEY (group_id) REFERENCES public."group"(group_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: student student_semesters_date_semester_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_semesters_date_semester_id_fk FOREIGN KEY (semester_id) REFERENCES public.semesters_date(semester_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: teacher_subject teacher_subject_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subject
    ADD CONSTRAINT teacher_subject_fk FOREIGN KEY (teacher_id) REFERENCES public.teacher(teacher_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: teacher_subject teacher_subject_fk_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teacher_subject
    ADD CONSTRAINT teacher_subject_fk_1 FOREIGN KEY (subject_id) REFERENCES public.subject(subject_id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

