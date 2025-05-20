--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Ubuntu 16.8-0ubuntu0.24.10.1)
-- Dumped by pg_dump version 16.8 (Ubuntu 16.8-0ubuntu0.24.10.1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: educations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.educations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    type text DEFAULT 'Full time'::text,
    institute character varying(255) NOT NULL,
    degree character varying(50) NOT NULL,
    discipline character varying(50) NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    description character varying(255) DEFAULT NULL::character varying,
    CONSTRAINT educations_type_check CHECK ((type = ANY (ARRAY['Part time'::text, 'Full time'::text])))
);


ALTER TABLE public.educations OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    start_date date NOT NULL,
    end_date date,
    location character varying(255) DEFAULT NULL::character varying,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: experiences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.experiences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    type text DEFAULT 'Job'::text,
    organisation character varying(255) NOT NULL,
    designation character varying(255) NOT NULL,
    location character varying(255) NOT NULL,
    start_date date NOT NULL,
    end_date date,
    ctc numeric(10,2),
    description character varying(255) DEFAULT NULL::character varying,
    CONSTRAINT experiences_type_check CHECK ((type = ANY (ARRAY['Job'::text, 'Internship'::text])))
);


ALTER TABLE public.experiences OWNER TO postgres;

--
-- Name: hero_section; Type: TABLE; Schema: public; Owner: shyam
--

CREATE TABLE public.hero_section (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text NOT NULL,
    hero_image character varying(255) DEFAULT NULL::character varying,
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT single_row CHECK ((id = 1))
);


ALTER TABLE public.hero_section OWNER TO shyam;

--
-- Name: hero_section_id_seq; Type: SEQUENCE; Schema: public; Owner: shyam
--

CREATE SEQUENCE public.hero_section_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.hero_section_id_seq OWNER TO shyam;

--
-- Name: hero_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: shyam
--

ALTER SEQUENCE public.hero_section_id_seq OWNED BY public.hero_section.id;


--
-- Name: membership_applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.membership_applications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    membership_level text NOT NULL,
    sign character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    status text DEFAULT 'pending'::text,
    CONSTRAINT membership_applications_membership_level_check CHECK ((membership_level = ANY (ARRAY['level1_networking'::text, 'level2_volunteering'::text]))),
    CONSTRAINT membership_applications_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text])))
);


ALTER TABLE public.membership_applications OWNER TO postgres;

--
-- Name: organisationdetails; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisationdetails (
    organisation character varying(100)
);


ALTER TABLE public.organisationdetails OWNER TO postgres;

--
-- Name: otp_email; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_email (
    email character varying(50) NOT NULL,
    otp character varying(6) NOT NULL,
    verified boolean,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.otp_email OWNER TO postgres;

--
-- Name: otp_email_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.otp_email_attempts (
    email character varying(50) NOT NULL,
    attempts integer DEFAULT 0,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.otp_email_attempts OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    user_id uuid NOT NULL,
    title text NOT NULL,
    first_name character varying(64) NOT NULL,
    last_name character varying(64),
    dob date NOT NULL,
    sex text NOT NULL,
    category text NOT NULL,
    nationality character varying(15) NOT NULL,
    religion character varying(16),
    address character varying(128) NOT NULL,
    pincode character varying(10) NOT NULL,
    state character varying(64) NOT NULL,
    city character varying(64) NOT NULL,
    country character varying(64) NOT NULL,
    phone character varying(15),
    alt_phone character varying(15),
    alt_email character varying(255),
    linkedin character varying(50),
    github character varying(50),
    registration_no character varying(20) NOT NULL,
    roll_no character varying(16),
    sign character varying(255) DEFAULT NULL::character varying,
    avatar character varying(255) DEFAULT NULL::character varying,
    CONSTRAINT profiles_category_check CHECK ((category = ANY (ARRAY['General'::text, 'OBC'::text, 'SC'::text, 'ST'::text, 'EWS'::text]))),
    CONSTRAINT profiles_sex_check CHECK ((sex = ANY (ARRAY['Male'::text, 'Female'::text, 'Others'::text]))),
    CONSTRAINT profiles_title_check CHECK ((title = ANY (ARRAY['Mr'::text, 'Mrs'::text, 'Ms'::text, 'Dr'::text])))
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email character varying(50) NOT NULL,
    password character varying(100) NOT NULL,
    role text[] DEFAULT ARRAY['user'::text] NOT NULL,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT role_valid_values CHECK ((role <@ ARRAY['admin'::text, 'coordinator'::text, 'alumni'::text, 'user'::text])),
    CONSTRAINT users_role_check CHECK ((role <@ ARRAY['admin'::text, 'coordinator'::text, 'alumni'::text, 'user'::text]))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: web_messages; Type: TABLE; Schema: public; Owner: shyam
--

CREATE TABLE public.web_messages (
    message_from text NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(50) NOT NULL,
    phone character varying(100) NOT NULL,
    message text NOT NULL,
    designation character varying(100),
    department character varying(100),
    avatar character varying(255) NOT NULL,
    CONSTRAINT web_messages_message_from_check CHECK ((message_from = ANY (ARRAY['director'::text, 'president'::text])))
);


ALTER TABLE public.web_messages OWNER TO shyam;

--
-- Name: hero_section id; Type: DEFAULT; Schema: public; Owner: shyam
--

ALTER TABLE ONLY public.hero_section ALTER COLUMN id SET DEFAULT nextval('public.hero_section_id_seq'::regclass);


--
-- Data for Name: educations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.educations (id, user_id, type, institute, degree, discipline, start_date, end_date, description) FROM stdin;
37d9fbbc-802d-4d61-b692-ab3e26f134a3	2552266c-0217-4587-b4e9-f329430b4886	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ELECTRICAL ENGINEERING	2020-12-02	2024-06-14	
7402a7d8-b7e4-4915-a05b-b4e433db3a91	435dad5a-08dd-493e-b63a-f4ef7da9dafb	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	CSE	2020-12-02	2024-06-14	
3e50a1d5-d465-4623-9af1-ffce33cd93d9	fc3a71da-d0e9-424a-a4cc-5c317fa0cc6e	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-12-02	2024-06-14	
c140d118-0a54-4b08-bccd-86718fee5b61	038be5c6-1f7f-4264-92b2-a047e6daef7b	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and Communication Engineering	2020-12-02	2024-05-31	
29aa36fd-9d26-4607-aa6e-0131738c8d5c	471d354d-2f31-4f76-83b9-cf448fa0c181	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and Communication Engineering	2020-12-02	2024-05-31	
1976bb69-ded6-440b-b5b9-f41be5da8e9c	163af0e1-8854-4854-bbea-7e60e32604db	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-10-15	2024-05-31	
5d618dde-1460-45a1-90fb-10a8788950cc	5c3b783a-c9be-41b8-969f-2a581769de04	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ECE	2020-12-12	2024-06-16	
92ff045c-6e08-46ef-8a9b-c01dde6de0d0	f912e1d0-bbbc-40f7-97ac-e3f5fb311ea5	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science & Engineering	2020-12-01	2024-06-21	
b00ec869-d86d-4712-ba5a-79b0652f33b9	5f95f86f-40c3-4b2e-af12-90461409b76b	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and communication engineering 	2020-11-14	2024-06-05	
ec1ce7de-12ae-490c-8952-b25661ead9fa	a0ec86c7-e6de-434a-ad35-4be4368be6e4	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering 	2020-11-09	2024-06-05	
cd529ef7-df4f-49c3-9424-213d9e028420	5916bb17-d31d-4c2c-90c6-5b7db870bb26	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical	2020-12-01	2024-06-01	
407a151b-51ed-4306-9ba8-2da014f3cc56	f17989eb-85b8-420d-aec6-c18fd169bd62	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical engineering 	2020-12-02	2024-06-01	
7a83b1bf-1369-49e4-a98c-278a64fee4e8	5344a300-740c-4bbd-b419-8875608c8503	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	NA	2020-12-11	2024-06-05	
c8bacf10-608c-4824-b67a-d8eee38290cb	7e7e61a5-3661-4de6-8051-de6ef376f156	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical 	2020-12-02	2024-06-14	
54cfbabc-ad41-40a8-803b-c7629af6d918	ed665ee1-7d11-4b6e-b1a0-a86c4ad0d6d8	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	electrical	2020-06-01	2024-05-01	
ccf934a9-f2ae-4518-907e-3fc13073fc8c	cdec78ed-442e-47ae-834d-3927c23f87d8	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and Communication Engineering 	2020-12-02	2024-06-14	
94a74156-d8c9-4187-bde0-2178b469c576	c068c2f5-b1a6-41c4-87e7-1af25a047b84	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	NA	2020-12-11	2024-06-05	
eabdefe7-d299-40ca-ab68-7c153f49194f	4e19018c-3aed-4544-b36b-f5206067c714	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ECE 	2020-11-20	2024-12-31	
7041a690-bf96-4f96-ae33-de4d138c7e31	b0d3f92c-e370-4836-b97a-8914b23cf74c	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-12-20	2024-06-05	
ad464259-14d8-4ff4-b637-6d47123db579	6b8e198e-a3c2-4145-b3e5-5c45b487e0cc	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and Communication Engineering 	2020-12-11	2024-06-05	
cb990b1f-a4ac-4965-86f2-6cffc00c016c	1d4acb90-9587-4b9b-b1fc-e7e5f8472b68	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-12-07	2024-06-05	
c02587f3-d188-4911-b809-5f2f7245d0bf	6ced3636-553f-4988-96d5-8e9f6f5861b9	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ELECTRONICS AND COMMUNICATION ENGINEERING	2020-12-02	2024-05-29	
d326d218-d930-42fc-bd73-0cc547b217ff	701d20ab-0b73-49c6-87fa-950b4916d1cf	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ELECTRONICS AND COMMUNICATIONS ENGINEERING 	2020-12-02	2024-06-05	
f68f7344-e695-4d7a-9e39-9f2c5420b0c2	ec74e358-3fb1-4d80-b169-b889f2e18e7c	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science and Engineering	2020-12-01	2024-06-15	
38e0bb2b-baa8-4dfc-b903-acff2eda9c82	bda41421-b65d-4cb8-9a02-9b491e96220f	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical engineering 	2020-12-07	2024-05-31	
843243bb-aa83-4fcf-9984-7d093dc59e7e	cf95fd56-ceac-414f-99b4-8151fe18b359	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical 	2020-12-10	2024-05-30	
65f42620-8232-4c4e-a575-66f0841221bb	6b0fbd0b-9633-498f-8c37-d6fc060b6d1c	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical Engineering 	2020-10-15	2024-05-29	
27c8252d-d801-49df-94fe-30dea5b266e7	684cde69-6b1c-49ff-b9e9-5e2a544ae1bb	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ELECTRICAL ENGINEERING 	2020-11-10	2024-05-29	
477f040d-1e44-406d-b008-7d399ac312d9	53586e31-5205-4257-9806-a58b96c22787	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-09-01	2024-06-05	
022acc0f-9cd8-4184-81aa-9c030f368915	ebc1677c-190e-44e8-bac3-306d9d406950	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and communication Engineering 	2020-12-02	2024-06-14	
df3a8e5d-dc4c-423b-93a9-724ebc3d50e3	e023620f-d685-4f8a-b921-c7625c5cd615	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ECE	2020-12-02	2024-06-14	
ea1872c1-ce63-4ffd-9f73-a93b7d004d66	05eff4c5-7ce0-4351-aa19-576c16813353	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical Engineering 	2020-12-07	2024-05-29	
66b3e5f3-6125-4bdc-b1db-72dbf8271e75	e7ea86e4-8410-46b6-a8ec-6008c8fd4f4b	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and communication 	2020-08-08	2024-05-29	
e3930d5b-0225-408d-9f58-0a4be35bd5b6	46134da6-1ae5-4d1b-98d4-e5275aa12e67	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering 	2020-12-05	2024-06-06	
30d4b6f8-607d-4fc5-9b34-ba286edab329	330615fc-a3e5-46b2-b1d4-3c3b3032d1a7	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-11-30	2024-06-30	
bc62690e-31da-4bc2-be25-5e566c701479	ee72263e-3160-48e4-bcef-6a896cd1e0e8	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical engineering 	2020-12-01	2024-05-29	
9ce2fbf9-b353-4435-8153-8922f20391eb	aaad8207-90ae-4d08-b793-ee82852380e6	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-12-01	2002-05-29	
c529e0a1-57f1-4d43-b846-0c4ac9ae0fa0	6011ddc1-7dac-44f8-b47e-be392c0d4c25	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ELECTRICAL ENGINEERING	2020-12-09	2024-06-01	
e44f9312-63a5-4076-a17b-7e5369ddf1f5	bc117c08-fc12-40f6-acfc-2719a051fa5b	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical engineering 	2020-12-02	2024-06-01	
483e1a19-55b4-4004-bd72-2dcf9cc3c1ee	0e2d7f9d-a1d4-4649-ac7f-eb9eb8263a51	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ELECTRICAL ENGINEERING	2020-12-09	2024-06-05	
ed88ef57-a545-4269-9908-e3c4bb860370	34ec64da-31bd-467d-b01b-25579737805e	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering 	2020-12-01	2024-06-06	
1fdabcf7-0cce-449a-811e-4ed176632e2e	a6a5a8c7-e5f9-4e88-8c7b-8a3bfdd5cb9a	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and Communication Engineering	2020-12-01	2024-06-05	
9fa58b2d-874f-4a47-ae98-0526e0b26dcd	069df11f-3e77-401d-8d75-d6042568f82e	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and Communication Engineering	2020-12-01	2024-06-05	
f30d887d-c84b-4229-bc92-1f878d7e4eee	5826165c-34dc-41f3-b92d-f1ebca7c6d6c	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ELECTRICAL ENGINEERING	2020-12-08	2024-06-04	
ee2991ec-025c-4cc7-9526-cb760c986957	4519971e-c235-47d8-94ee-ac5970e7fbbc	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Civil	2020-12-08	2024-06-05	
84bb2e58-cf12-4064-8682-d0c94145884c	db62dcdc-dee7-47b0-96ea-6279cc39815b	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-12-02	2024-06-14	
66a65180-53f7-40c2-87e4-3614383252f2	579ca13f-afc3-4096-9a60-4447045a805d	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-12-01	2024-06-01	
bf5983cb-6b88-429b-8a3c-297f056734c7	e532ec17-d075-4c19-97e3-7ef00221dec2	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical 	2020-12-22	2024-05-29	
0653fde1-cc9f-492d-9d02-4110c5e6673b	397c2040-43a7-4b8a-8f48-6ea632263edc	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering 	2020-12-01	2024-06-01	
9d3738cd-973e-4a86-a07a-f06c376cb512	4c6c25aa-15e8-4535-a858-a9b16a979b11	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ELECTRICAL ENGINEERING	2020-12-02	2024-06-01	
5fc04c35-8124-4994-8a53-d5a33fae17d8	980becfb-6eda-402a-adfa-9f36af4bd7de	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical Engineering	2020-12-01	2024-06-30	
290bd03c-4699-473e-aa35-a2c9e869506b	01e34890-985d-45b1-a80d-ac3926afb74d	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical Engineering 	2020-12-07	2024-06-30	
d7dc75a2-124f-44e7-b547-f45d159fb320	952e3643-5a42-49d9-9320-a1daa3fe03e2	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and Communication Engineering 	2020-12-01	2024-06-04	
b8130724-1e0c-43a7-898a-a33c9ae8314d	53ca35ee-09d0-4cc2-b967-0e2cc5adcc7b	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical engineering 	2020-11-07	2024-05-29	
90d95217-dc46-41e6-a325-f3d0c2ce1fba	c3e6cfa5-396e-47a2-8fa2-20747ab787e6	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	MECHANICAL	2020-11-07	2024-05-31	
70274d4c-9d98-4921-aa15-ac9e02c9e3b7	221d5abf-b72b-435f-ab34-3b8a8781d37f	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	MECHANICAL ENGINEERING	2020-11-07	2024-05-31	
42023f14-82da-49ad-9679-895aacbea54b	c45cd835-f58b-42bc-86ed-21acc3e47ca3	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and communication engineering 	2020-12-07	2024-05-29	
fa1c364c-7cbc-408e-898e-9f02ff7f1233	3a333cf4-3876-4a0a-a599-b8065b127033	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical 	2020-08-11	2024-06-01	
d92113f8-76e0-49e9-9aa1-926815c3cb33	cfa52b66-aa64-4453-b716-be3685ac959e	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering 	2020-12-10	2024-06-05	
09247ca2-bec1-49f9-9090-d821b7fa2d21	d391ddca-46a1-4080-831a-647966a5d205	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-12-01	2024-05-29	
4b942c69-508c-4951-9d56-d74a077515ed	73a89400-2702-464f-9c49-31d07c94e0c5	Full time	National Institute of Technology, Arunachal Pradesh	PhD	ORGANIC CHEMISTRY 	2020-08-12	2024-05-21	
a9d856d2-d8b2-4dd1-9ea9-9b534c9876de	3fb2cdc6-e085-449e-a626-39741460067a	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Civil Engineering 	2020-12-01	2024-06-01	
9a0dfc20-692d-48ab-8b70-cb723b2b54c0	70a0286c-a108-46c4-a9ed-7f673358436d	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-12-01	2024-06-01	
6baf4a22-9dc1-4535-a24d-cd42b0f51942	7633a608-50a6-48db-93fc-3ac9b37267a6	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science and Engineering 	2020-12-17	2024-06-05	
0a9fcd6d-2229-4a45-8cce-485d089c7364	ed9581c0-e7ef-4407-ae46-70d86b988471	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical engineering 	2020-12-02	2024-06-01	
4e82a686-7b76-4d03-9df3-73bbcc636923	805c68af-8734-4c19-ae1c-baf67024d52b	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical engineering 	2020-12-02	2024-06-01	
3ec2e0a3-79b3-4714-8e63-dd084eb5aa82	b06f757a-1ef9-4487-bbbf-f489794e4d7e	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	computer science and engineering	2020-12-01	2024-06-05	
feadeb71-4088-421c-a639-dd013f732a91	79554e97-b1e2-4bfd-855f-4b65aa74144f	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science & Engineering (CSE)	2020-12-07	2024-06-05	
5ed979f2-596e-4bd5-ad66-0861af9e21a9	65ff0434-a6d0-46e4-b1d1-15322bcc9f72	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science and Engineering	2020-12-01	2024-06-01	
641484c1-3a78-4956-bce3-a909ba54bbcc	ff52307e-8175-46a5-b7f1-fd218303af6c	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science and Engineering 	2020-06-01	2024-06-01	
10163bcc-3e1a-4c25-b4db-45e2205aabbb	388cdf71-0a20-4ad7-9c37-d5c70eb1013b	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical Engineering	2020-09-22	2024-05-31	
59fe182a-64ff-433d-8ae7-09dc251f6630	a72fcb88-c9f8-4f2e-89a8-27bef713c6bd	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical Engineering	2020-09-10	2024-06-10	
46e2505d-e24b-467a-b4f9-47c6b424c147	40ff6408-62f4-445d-9a68-e5d849e9b4ec	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-12-02	2024-06-14	
dd0a5adb-dff8-4242-a1ee-b32c481261c7	ae9396a3-77ea-45dc-9f65-bb89b8ec10e5	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and communication Engineering 	2020-12-02	2024-05-31	
1c07f65b-ea41-4eb6-bab4-2ca79b6552ee	d4a699d8-2805-44f4-8a3c-8ab4b56cdd20	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Civil	2020-06-05	2024-06-05	
459e3f1d-e28f-4747-b040-f6b6d33bc6c2	feb82a39-ca9b-4cef-adcc-7b7c942d1153	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Civil Engineering 	2020-06-05	2024-06-05	
24fc34a6-dad5-4b16-a0f5-32c410c8bd0e	200f18a1-4f27-402c-a673-d198fba751b2	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	CIVIL ENGINEERING	2020-12-02	2024-06-04	
7104b902-875b-4862-b622-91575230713c	8fdcfa48-5d88-4063-9b3a-095961b5d72d	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	CSE	2020-11-20	2024-06-01	
5e77f7a0-96c6-4404-a7a7-b7bc4664b1be	81440d27-e7a8-469c-8448-f6f2183b7752	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	CSE	2020-12-20	2024-07-29	
d2c4d0a5-0b28-4598-bdfa-6bc5b904ab5f	e1c121fc-36b0-43eb-bbff-110fb0b51426	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science and Engineering	2020-12-20	2024-07-29	
27b14855-485a-4dab-8fd1-9984dde2f5a0	e58e02cb-e655-4965-bbef-6e8888a2438a	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science and Engineering 	2020-12-20	2024-06-20	
c64183c8-c030-419f-ac7b-3ea3c3ff014a	cc619f64-f641-432c-bad7-75b6042e1c5b	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ECE	2020-12-18	2024-06-18	
872b75e9-1145-4933-9922-0ae3a109629f	50f7ccec-7111-4dba-af10-6c40c2fa5c35	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	CSE	2020-12-20	2024-06-18	
d7299011-75e6-401d-93ea-58a1e2b9e6ae	875e5149-931e-4961-b295-30484348a2b5	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and communication engineering 	2020-12-07	2024-05-29	
a43e4d86-9e8a-4584-8d3c-d8bf97aef705	bd3b6c24-e9b8-40e3-a595-a6f0297a1e74	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ELECTRONICS AND COMMUNICATION ENGINEERING	2020-12-11	2024-06-04	
7be8277f-1442-4141-a7de-ebb6b7e9be05	0f53af60-a986-47c8-92bf-28947e50c79a	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	MECHANICAL	2020-09-16	2024-05-29	
2a5096c4-58b3-43ac-9e23-0b56386ca85a	371d711e-f4e6-4d1e-bc24-50816ee510ea	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ECE	2020-11-01	2024-06-01	
28536ea3-5dce-4eef-82ac-7869f98ae97d	91789307-9880-4360-9c20-f3373a62bcf2	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical Engineering	2020-11-21	2024-05-29	I have successfully completed my B.Tech course in discipline of Mechanical Engineering (2020-2024) with flying colors.
c3d91365-b6d5-483b-b4a7-3efcf97e0c67	501e08db-bbad-429f-9e42-a05fcbaea837	Full time	National Institute of Technology, Arunachal Pradesh	B.Tech	Mechanical Engineering	2020-11-21	2024-05-29	I have successfully completed my B.Tech course in department of  Mechanical Engineering in batch 2020-24
285cae39-0e9c-422b-938d-6df12d16c5ce	524575a5-da66-4d21-bffe-c69247f80eaf	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical Engineering	2020-06-20	2024-05-30	
b4cf6218-a185-46bc-ab1c-29ad7d175f94	7577a281-d299-4784-906e-c7a0f2fad587	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science and Engineering 	2020-12-02	2024-06-14	
c5c56a59-0d60-4f2b-8519-e4836cfde446	9d7c7fbb-92ce-44f1-a018-15378dbc3370	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Mechanical Engineering	2020-11-21	2024-05-30	
b2be10e6-5882-40e0-841f-36f3420b3031	c5743050-8d2d-4ba3-a57a-5255a013686b	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electrical engineering	2020-12-01	2024-06-15	
7f858f35-7f29-4d4f-8461-91e0fe6c74a2	2e833904-c774-4f55-ae9e-8c553b3a331e	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	CIVIL 	2020-12-01	2024-06-01	
acccd6be-aee7-40e4-ae55-94240021ce64	e89c5141-8e28-46a0-9c20-0454f4433fd8	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science	2020-01-12	2024-06-06	
1319e5f3-38cd-456b-bfe6-416a5e6f9cb0	6a4bc22e-19d9-4e85-a5e5-7858d0923d3d	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	EE	2020-11-24	2024-05-31	
bca1249a-67f5-4880-bb4a-9988bac1e12c	53bacd86-068a-482b-b87e-59ce48eb018d	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	CE	2020-11-24	2024-05-31	
1819ed22-f14e-49ef-9961-07e883a89d3b	647418e1-776d-48ac-9bd5-3fb9bdaa759e	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science and Engineering 	2020-12-21	2024-06-29	
5b38b846-2d7d-47a5-8936-88077437fae6	e4a375e4-91f8-4e1c-bd63-d6afa6bb2ed7	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Me	2020-12-01	2024-05-31	
7fbc5ec6-d126-4be9-b608-3dc02da39590	c7711e63-9298-4c5d-b734-b099ebc4a50b	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	ECE	2020-12-12	2024-06-18	
f94035d4-b092-4097-ad64-48ea00cb0279	7c3fec8b-7791-4000-9f05-05df8f4b9526	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	B.TECH MECHANICAL	2020-12-01	2024-05-31	
f762e4e2-196e-493c-801a-bb7a0b544048	3745b5e8-77a0-466d-8336-d340e64a2111	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science and Engineering 	2020-12-01	2024-06-05	
e9e2e54e-7ef7-448c-9696-fcce7e887629	5ff2ba04-dc59-42a2-b8a2-6a94cfb535a8	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	computer science and engineering 	2020-12-01	2024-06-01	
ed4c50f1-33e4-451b-9d21-23f9094768c0	260f2d36-6354-4af0-b04e-9c0131cde2f7	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Electronics and Communication Engineering 	2020-12-01	2024-05-29	
38749135-14d6-480e-9bd6-9993f3d3f58d	e2a68729-3fdc-47aa-b812-9ad2de0f9441	Full time	National Institute of Technology, Arunachal Pradesh	Bachelor of Technology	Computer Science and Engineering	2020-09-05	2024-06-05	
\.


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.events (id, title, description, start_date, end_date, location, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: experiences; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.experiences (id, user_id, type, organisation, designation, location, start_date, end_date, ctc, description) FROM stdin;
\.


--
-- Data for Name: hero_section; Type: TABLE DATA; Schema: public; Owner: shyam
--

COPY public.hero_section (id, title, description, hero_image, updated_at) FROM stdin;
1	Celebrating the 11th convocation of NIT Arunachal Pradesh	On December 9, we welcomed approximately 200, 2024 graduates to the 11th convocation ceremony of the National Institute of Technology Arunachal Pradesh	hero/DSC_6283-31.jpg	2025-03-31 23:32:07.393394
\.


--
-- Data for Name: membership_applications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.membership_applications (id, user_id, membership_level, sign, created_at, updated_at, status) FROM stdin;
9c67ffcf-b521-41ff-b0af-56cd7564c23f	3a333cf4-3876-4a0a-a599-b8065b127033	level1_networking	3a333cf4-3876-4a0a-a599-b8065b1270331716370844689.jpg	2024-05-22 09:40:44.700889	2024-05-22 09:40:44.700889	pending
89318c7a-04d7-42d8-a305-6794fffdb175	038be5c6-1f7f-4264-92b2-a047e6daef7b	level1_networking	038be5c6-1f7f-4264-92b2-a047e6daef7b1716270299654.jpg	2024-05-21 05:44:59.6553	2024-05-21 05:44:59.6553	pending
bd10013e-c011-434d-9aeb-cf9d0f846613	471d354d-2f31-4f76-83b9-cf448fa0c181	level1_networking	471d354d-2f31-4f76-83b9-cf448fa0c1811716270729939.jpg	2024-05-21 05:52:09.941212	2024-05-21 05:52:09.941212	pending
1af2198d-3521-4689-83e7-77a1a58490f3	163af0e1-8854-4854-bbea-7e60e32604db	level1_networking	163af0e1-8854-4854-bbea-7e60e32604db1716276686284.jpeg	2024-05-21 07:31:26.511047	2024-05-21 07:31:26.511047	pending
8702acb5-46cd-4675-af86-5cc39dd1e206	5c3b783a-c9be-41b8-969f-2a581769de04	level1_networking	5c3b783a-c9be-41b8-969f-2a581769de041716279466019.jpg	2024-05-21 08:17:46.021179	2024-05-21 08:17:46.021179	pending
abf25b46-3ea2-4cc9-8cf1-49bf2e0e4f56	f17989eb-85b8-420d-aec6-c18fd169bd62	level1_networking	f17989eb-85b8-420d-aec6-c18fd169bd621716291792909.jpg	2024-05-21 11:43:12.913198	2024-05-21 11:43:12.913198	pending
14dd7511-3b1c-4a73-8970-74d1ddc5c707	5344a300-740c-4bbd-b419-8875608c8503	level1_networking	5344a300-740c-4bbd-b419-8875608c85031716291805223.jpeg	2024-05-21 11:43:26.222141	2024-05-21 11:43:26.222141	pending
601d61f6-4250-4240-9874-77de9cca17dd	7e7e61a5-3661-4de6-8051-de6ef376f156	level1_networking	7e7e61a5-3661-4de6-8051-de6ef376f1561716292048254.jpg	2024-05-21 11:47:28.256782	2024-05-21 11:47:28.256782	pending
a5c466c5-52a6-482b-a308-ef279dcc1987	cdec78ed-442e-47ae-834d-3927c23f87d8	level1_networking	cdec78ed-442e-47ae-834d-3927c23f87d81716292307567.jpg	2024-05-21 11:51:47.570668	2024-05-21 11:51:47.570668	pending
2937e634-940b-40da-9b93-fff80e4a5f35	c068c2f5-b1a6-41c4-87e7-1af25a047b84	level1_networking	c068c2f5-b1a6-41c4-87e7-1af25a047b841716292323083.jpg	2024-05-21 11:52:03.742528	2024-05-21 11:52:03.742528	pending
4f6c76a8-c572-4ead-9773-e3214a4d8e74	4e19018c-3aed-4544-b36b-f5206067c714	level1_networking	4e19018c-3aed-4544-b36b-f5206067c7141716292764743.jpg	2024-05-21 11:59:24.747999	2024-05-21 11:59:24.747999	pending
3156de55-040d-4a9c-beb8-2df985e9587f	6b8e198e-a3c2-4145-b3e5-5c45b487e0cc	level1_networking	6b8e198e-a3c2-4145-b3e5-5c45b487e0cc1716297494645.jpg	2024-05-21 13:18:14.64781	2024-05-21 13:18:14.64781	pending
4c74b6bd-f5c9-4cb8-97ab-c731df3ef69f	6ced3636-553f-4988-96d5-8e9f6f5861b9	level1_networking	6ced3636-553f-4988-96d5-8e9f6f5861b91716298341993.jpg	2024-05-21 13:32:22.171687	2024-05-21 13:32:22.171687	pending
72111b94-9a79-4a32-a8c6-e169c687ac48	f912e1d0-bbbc-40f7-97ac-e3f5fb311ea5	level2_volunteering	f912e1d0-bbbc-40f7-97ac-e3f5fb311ea51716299139064.jpg	2024-05-21 13:45:39.065941	2024-05-21 13:45:39.065941	pending
4a959ddb-ac16-44d4-87ae-9c0a1574ade6	701d20ab-0b73-49c6-87fa-950b4916d1cf	level1_networking	701d20ab-0b73-49c6-87fa-950b4916d1cf1716299163609.jpeg	2024-05-21 13:46:03.612115	2024-05-21 13:46:03.612115	pending
8f048780-4a0b-47f5-82e1-1d6a9a9707af	1d4acb90-9587-4b9b-b1fc-e7e5f8472b68	level1_networking	1d4acb90-9587-4b9b-b1fc-e7e5f8472b681716299173904.jpg	2024-05-21 13:46:13.905829	2024-05-21 13:46:13.905829	pending
522efc64-0b11-42f2-8da8-b29a0fd9b81b	ed665ee1-7d11-4b6e-b1a0-a86c4ad0d6d8	level2_volunteering	ed665ee1-7d11-4b6e-b1a0-a86c4ad0d6d81716299740115.jpg	2024-05-21 13:55:40.116881	2024-05-21 13:55:40.116881	pending
cd62c904-9865-4ef0-8cd1-758a17711665	ec74e358-3fb1-4d80-b169-b889f2e18e7c	level1_networking	ec74e358-3fb1-4d80-b169-b889f2e18e7c1716300363798.jpg	2024-05-21 14:06:03.800265	2024-05-21 14:06:03.800265	pending
3acc497f-a45c-4d67-87f2-e3b27a635a69	bda41421-b65d-4cb8-9a02-9b491e96220f	level1_networking	bda41421-b65d-4cb8-9a02-9b491e96220f1716301103596.jpg	2024-05-21 14:18:23.625707	2024-05-21 14:18:23.625707	pending
e52caa95-6932-43ed-a70e-f57a00a90a06	6b0fbd0b-9633-498f-8c37-d6fc060b6d1c	level2_volunteering	6b0fbd0b-9633-498f-8c37-d6fc060b6d1c1716301668502.jpg	2024-05-21 14:27:49.529797	2024-05-21 14:27:49.529797	pending
a15095f0-9aa4-40c6-a06d-6182b5722c5f	684cde69-6b1c-49ff-b9e9-5e2a544ae1bb	level1_networking	684cde69-6b1c-49ff-b9e9-5e2a544ae1bb1716304109799.jpg	2024-05-21 15:08:29.800566	2024-05-21 15:08:29.800566	pending
b921a6d4-c984-4f61-b0d1-c3f33eb8caf8	5f95f86f-40c3-4b2e-af12-90461409b76b	level2_volunteering	5f95f86f-40c3-4b2e-af12-90461409b76b1716309015799.jpg	2024-05-21 16:30:15.810774	2024-05-21 16:30:15.810774	pending
88b73209-0322-4027-aa97-6cdff96aeabf	a0ec86c7-e6de-434a-ad35-4be4368be6e4	level1_networking	a0ec86c7-e6de-434a-ad35-4be4368be6e41716317903238.jpg	2024-05-21 18:58:23.256674	2024-05-21 18:58:23.256674	pending
4f50873c-066a-4118-9bb9-5b6a0746b7f7	e023620f-d685-4f8a-b921-c7625c5cd615	level1_networking	e023620f-d685-4f8a-b921-c7625c5cd6151716318484432.jpeg	2024-05-21 19:08:04.433894	2024-05-21 19:08:04.433894	pending
ec93eef5-ff42-4612-a3d5-631d9d7e639e	05eff4c5-7ce0-4351-aa19-576c16813353	level1_networking	05eff4c5-7ce0-4351-aa19-576c168133531716321995747.jpeg	2024-05-21 20:06:35.749034	2024-05-21 20:06:35.749034	pending
a2679cf8-1411-406c-867d-07c7aba126be	e7ea86e4-8410-46b6-a8ec-6008c8fd4f4b	level2_volunteering	e7ea86e4-8410-46b6-a8ec-6008c8fd4f4b1716345094720.jpg	2024-05-22 02:31:38.480606	2024-05-22 02:31:38.480606	pending
20144da2-f7c3-41d4-9603-94b44c7f2190	46134da6-1ae5-4d1b-98d4-e5275aa12e67	level1_networking	46134da6-1ae5-4d1b-98d4-e5275aa12e671716351284816.jpeg	2024-05-22 04:14:44.817516	2024-05-22 04:14:44.817516	pending
65d4df40-0f45-4d32-b807-fa85a9000d94	330615fc-a3e5-46b2-b1d4-3c3b3032d1a7	level2_volunteering	330615fc-a3e5-46b2-b1d4-3c3b3032d1a71716352503739.jpg	2024-05-22 04:35:03.744836	2024-05-22 04:35:03.744836	pending
c909b129-5209-4fb0-9539-8a54f95c348c	ebc1677c-190e-44e8-bac3-306d9d406950	level1_networking	ebc1677c-190e-44e8-bac3-306d9d4069501716353201746.jpg	2024-05-22 04:46:41.800965	2024-05-22 04:46:41.800965	pending
17f42f03-71a2-4a26-9497-6fac5229d0be	ee72263e-3160-48e4-bcef-6a896cd1e0e8	level1_networking	ee72263e-3160-48e4-bcef-6a896cd1e0e81716357474315.jpg	2024-05-22 05:57:54.316628	2024-05-22 05:57:54.316628	pending
9e1e1e6d-5b0f-4435-b695-5f2b91a07d68	cf95fd56-ceac-414f-99b4-8151fe18b359	level1_networking	cf95fd56-ceac-414f-99b4-8151fe18b3591716359225395.jpg	2024-05-22 06:27:05.50253	2024-05-22 06:27:05.50253	pending
8d623fec-194f-4ed7-ad4a-28782fcaf0b0	6011ddc1-7dac-44f8-b47e-be392c0d4c25	level2_volunteering	6011ddc1-7dac-44f8-b47e-be392c0d4c251716364430702.jpg	2024-05-22 07:53:50.749753	2024-05-22 07:53:50.749753	pending
23a67d86-567e-4846-b3ea-538d307180b2	bc117c08-fc12-40f6-acfc-2719a051fa5b	level1_networking	bc117c08-fc12-40f6-acfc-2719a051fa5b1716365219696.jpg	2024-05-22 08:06:59.867928	2024-05-22 08:06:59.867928	pending
e2657d4a-6244-4a25-bc1d-84f8d08aa5cf	0e2d7f9d-a1d4-4649-ac7f-eb9eb8263a51	level1_networking	0e2d7f9d-a1d4-4649-ac7f-eb9eb8263a511716365378725.jpg	2024-05-22 08:09:40.494319	2024-05-22 08:09:40.494319	pending
32247949-1fc8-4398-904d-6f690ec80d19	34ec64da-31bd-467d-b01b-25579737805e	level1_networking	34ec64da-31bd-467d-b01b-25579737805e1716365971755.jpg	2024-05-22 08:19:31.789689	2024-05-22 08:19:31.789689	pending
ad3281b5-f838-48b8-9a73-b52337f1e73b	a6a5a8c7-e5f9-4e88-8c7b-8a3bfdd5cb9a	level1_networking	a6a5a8c7-e5f9-4e88-8c7b-8a3bfdd5cb9a1716365983101.jpg	2024-05-22 08:19:43.102832	2024-05-22 08:19:43.102832	pending
48537f07-ec65-463f-afa5-eca5956964ac	069df11f-3e77-401d-8d75-d6042568f82e	level1_networking	069df11f-3e77-401d-8d75-d6042568f82e1716366259936.jpg	2024-05-22 08:24:19.938459	2024-05-22 08:24:19.938459	pending
d6d9257d-7ca0-4a0d-a5f2-e572adede856	5826165c-34dc-41f3-b92d-f1ebca7c6d6c	level1_networking	5826165c-34dc-41f3-b92d-f1ebca7c6d6c1716368687364.jpg	2024-05-22 09:04:55.25394	2024-05-22 09:04:55.25394	pending
92a3421c-37b6-419f-be66-10f634671780	e532ec17-d075-4c19-97e3-7ef00221dec2	level1_networking	e532ec17-d075-4c19-97e3-7ef00221dec21716370067290.jpeg	2024-05-22 09:27:48.001758	2024-05-22 09:27:48.001758	pending
8f11097e-3bae-487f-970b-041ae5e7b64a	397c2040-43a7-4b8a-8f48-6ea632263edc	level1_networking	397c2040-43a7-4b8a-8f48-6ea632263edc1716370230310.jpg	2024-05-22 09:30:30.312016	2024-05-22 09:30:30.312016	pending
665da4dd-69ac-46f6-911b-7e61119da63c	4c6c25aa-15e8-4535-a858-a9b16a979b11	level1_networking	4c6c25aa-15e8-4535-a858-a9b16a979b111716370329748.jpg	2024-05-22 09:32:09.749208	2024-05-22 09:32:09.749208	pending
8b33cdf9-88fc-482b-9d29-89db99239445	aaad8207-90ae-4d08-b793-ee82852380e6	level1_networking	aaad8207-90ae-4d08-b793-ee82852380e61716372726744.jpeg	2024-05-22 10:12:06.745897	2024-05-22 10:12:06.745897	pending
3249cdd1-42c9-41c9-a107-3a130d04d832	b0d3f92c-e370-4836-b97a-8914b23cf74c	level1_networking	b0d3f92c-e370-4836-b97a-8914b23cf74c1716372994938.jpg	2024-05-22 10:16:34.940603	2024-05-22 10:16:34.940603	pending
114df8dc-a07a-4bec-86ea-357cb8852991	cfa52b66-aa64-4453-b716-be3685ac959e	level1_networking	cfa52b66-aa64-4453-b716-be3685ac959e1716374247172.jpg	2024-05-22 10:37:27.526309	2024-05-22 10:37:27.526309	pending
e615f35f-7944-45fe-a54f-78c8c5e9c429	d391ddca-46a1-4080-831a-647966a5d205	level1_networking	d391ddca-46a1-4080-831a-647966a5d2051716374255989.jpg	2024-05-22 10:37:35.994316	2024-05-22 10:37:35.994316	pending
fd82af0c-055d-47ae-ae24-356cfaa0d49f	73a89400-2702-464f-9c49-31d07c94e0c5	level1_networking	73a89400-2702-464f-9c49-31d07c94e0c51716374372990.png	2024-05-22 10:39:32.991371	2024-05-22 10:39:32.991371	pending
84fa78c8-fd57-4e33-a80d-111c23dc5c97	3fb2cdc6-e085-449e-a626-39741460067a	level1_networking	3fb2cdc6-e085-449e-a626-39741460067a1716374815746.jpeg	2024-05-22 10:46:55.74799	2024-05-22 10:46:55.74799	pending
c69396ae-63a0-4a29-b904-4c1e0dac63a6	70a0286c-a108-46c4-a9ed-7f673358436d	level1_networking	70a0286c-a108-46c4-a9ed-7f673358436d1716375289285.jpeg	2024-05-22 10:54:49.324713	2024-05-22 10:54:49.324713	pending
2cd6ef4a-9861-4d21-89f2-5e0477b3fcdd	ed9581c0-e7ef-4407-ae46-70d86b988471	level1_networking	ed9581c0-e7ef-4407-ae46-70d86b9884711716375794918.jpg	2024-05-22 11:03:14.920337	2024-05-22 11:03:14.920337	pending
6dfc0a05-d4b7-4c7b-b227-5d358f09fe85	7633a608-50a6-48db-93fc-3ac9b37267a6	level1_networking	7633a608-50a6-48db-93fc-3ac9b37267a61716375999926.png	2024-05-22 11:06:39.964369	2024-05-22 11:06:39.964369	pending
b6ec4d9b-02ff-4366-aee5-6a925c0a8bee	53586e31-5205-4257-9806-a58b96c22787	level1_networking	53586e31-5205-4257-9806-a58b96c227871716376373302.jpeg	2024-05-22 11:12:53.303985	2024-05-22 11:12:53.303985	pending
af2f428f-95f3-4904-ac7c-0b3d737780c2	805c68af-8734-4c19-ae1c-baf67024d52b	level1_networking	805c68af-8734-4c19-ae1c-baf67024d52b1716376438067.jpg	2024-05-22 11:13:58.069054	2024-05-22 11:13:58.069054	pending
96959d4d-9c97-40a1-aaeb-86565b26a361	b06f757a-1ef9-4487-bbbf-f489794e4d7e	level1_networking	b06f757a-1ef9-4487-bbbf-f489794e4d7e1716383551692.jpg	2024-05-22 13:12:31.693354	2024-05-22 13:12:31.693354	pending
7b794549-3390-4bcb-9f9d-db454ff6c6ab	79554e97-b1e2-4bfd-855f-4b65aa74144f	level1_networking	79554e97-b1e2-4bfd-855f-4b65aa74144f1716389040296.jpg	2024-05-22 14:44:00.298177	2024-05-22 14:44:00.298177	pending
b84cfe27-65a2-4ce7-b388-22a0ad56424e	65ff0434-a6d0-46e4-b1d1-15322bcc9f72	level2_volunteering	65ff0434-a6d0-46e4-b1d1-15322bcc9f721716389859715.png	2024-05-22 14:57:39.720406	2024-05-22 14:57:39.720406	pending
99807404-9ed8-4120-a8ea-f9e539855989	ff52307e-8175-46a5-b7f1-fd218303af6c	level1_networking	ff52307e-8175-46a5-b7f1-fd218303af6c1716390660066.jpg	2024-05-22 15:11:00.086246	2024-05-22 15:11:00.086246	pending
ed64dd39-9f24-4062-a01e-a46e563e03ba	a72fcb88-c9f8-4f2e-89a8-27bef713c6bd	level1_networking	a72fcb88-c9f8-4f2e-89a8-27bef713c6bd1716402081946.jpg	2024-05-22 18:21:21.947818	2024-05-22 18:21:21.947818	pending
1015f86a-1ed9-4810-bc82-920261980f9e	388cdf71-0a20-4ad7-9c37-d5c70eb1013b	level1_networking	388cdf71-0a20-4ad7-9c37-d5c70eb1013b1716402344688.jpg	2024-05-22 18:25:44.689757	2024-05-22 18:25:44.689757	pending
1dd5d873-928d-4dfd-b38a-7269c69cda96	40ff6408-62f4-445d-9a68-e5d849e9b4ec	level1_networking	40ff6408-62f4-445d-9a68-e5d849e9b4ec1716443465634.jpg	2024-05-23 05:51:05.65893	2024-05-23 05:51:05.65893	pending
38513b36-eda3-47d8-97e2-b7fa1e12145a	ae9396a3-77ea-45dc-9f65-bb89b8ec10e5	level1_networking	ae9396a3-77ea-45dc-9f65-bb89b8ec10e51716446914860.jpg	2024-05-23 06:48:34.971837	2024-05-23 06:48:34.971837	pending
53bfbe05-17fc-444c-8ac5-3f52290976d3	feb82a39-ca9b-4cef-adcc-7b7c942d1153	level1_networking	feb82a39-ca9b-4cef-adcc-7b7c942d11531716447199488.jpg	2024-05-23 06:53:19.754636	2024-05-23 06:53:19.754636	pending
5b72a760-3e64-4e44-b032-0ca05d7effd6	8fdcfa48-5d88-4063-9b3a-095961b5d72d	level1_networking	8fdcfa48-5d88-4063-9b3a-095961b5d72d1716451086372.jpg	2024-05-23 07:58:06.374294	2024-05-23 07:58:06.374294	pending
80c96c47-0f22-4442-880f-6286195897f6	81440d27-e7a8-469c-8448-f6f2183b7752	level1_networking	81440d27-e7a8-469c-8448-f6f2183b77521716461230480.jpg	2024-05-23 10:47:10.482593	2024-05-23 10:47:10.482593	pending
e6449b8f-3911-4a56-b6ea-5a055467927d	e1c121fc-36b0-43eb-bbff-110fb0b51426	level1_networking	e1c121fc-36b0-43eb-bbff-110fb0b514261716473078743.jpeg	2024-05-23 14:04:38.745502	2024-05-23 14:04:38.745502	pending
31ab233b-78bb-4674-9db5-3463ef3584eb	50f7ccec-7111-4dba-af10-6c40c2fa5c35	level1_networking	50f7ccec-7111-4dba-af10-6c40c2fa5c351716474230493.png	2024-05-23 14:23:50.49496	2024-05-23 14:23:50.49496	pending
7e29cda4-fb13-477a-8487-198b5e0fd2b3	e58e02cb-e655-4965-bbef-6e8888a2438a	level2_volunteering	e58e02cb-e655-4965-bbef-6e8888a2438a1716474268063.jpg	2024-05-23 14:24:28.064713	2024-05-23 14:24:28.064713	pending
6660b0a3-a071-4c23-9f7c-9a08591b4ec6	2552266c-0217-4587-b4e9-f329430b4886	level1_networking	2552266c-0217-4587-b4e9-f329430b48861716478441635.jpg	2024-05-23 15:34:01.636938	2024-05-23 15:34:01.636938	pending
91821821-b44d-47a9-b943-fa321b81cc3c	4519971e-c235-47d8-94ee-ac5970e7fbbc	level1_networking	4519971e-c235-47d8-94ee-ac5970e7fbbc1716478758414.jpg	2024-05-23 15:39:18.444252	2024-05-23 15:39:18.444252	pending
ef54c91e-7a82-41c9-88a3-27f8e7208bcd	d4a699d8-2805-44f4-8a3c-8ab4b56cdd20	level1_networking	d4a699d8-2805-44f4-8a3c-8ab4b56cdd201716478775284.jpg	2024-05-23 15:39:35.286364	2024-05-23 15:39:35.286364	pending
3e7895e7-e1f8-4461-8791-d34994929d55	435dad5a-08dd-493e-b63a-f4ef7da9dafb	level1_networking	435dad5a-08dd-493e-b63a-f4ef7da9dafb1716479813610.jpg	2024-05-23 15:56:53.612296	2024-05-23 15:56:53.612296	pending
7580d8bd-06b3-458f-92fe-57972216bd95	db62dcdc-dee7-47b0-96ea-6279cc39815b	level1_networking	db62dcdc-dee7-47b0-96ea-6279cc39815b1716480808354.jpg	2024-05-23 16:13:28.44636	2024-05-23 16:13:28.44636	pending
aaffb2bb-e6da-4df5-b8b4-5a2f7511c0e5	fc3a71da-d0e9-424a-a4cc-5c317fa0cc6e	level1_networking	fc3a71da-d0e9-424a-a4cc-5c317fa0cc6e1716481331628.jpg	2024-05-23 16:22:11.629723	2024-05-23 16:22:11.629723	pending
30d96f72-6769-45a7-81ac-24b2dbcf73c6	579ca13f-afc3-4096-9a60-4447045a805d	level1_networking	579ca13f-afc3-4096-9a60-4447045a805d1716482373630.jpg	2024-05-23 16:39:33.631164	2024-05-23 16:39:33.631164	pending
78bab362-fc97-4bb5-9657-2e740d2f6229	5916bb17-d31d-4c2c-90c6-5b7db870bb26	level2_volunteering	5916bb17-d31d-4c2c-90c6-5b7db870bb261716519596789.jpg	2024-05-24 02:59:56.791314	2024-05-24 02:59:56.791314	pending
9005f3ea-19dc-4bd4-9e8e-629f98478465	980becfb-6eda-402a-adfa-9f36af4bd7de	level1_networking	980becfb-6eda-402a-adfa-9f36af4bd7de1716529596923.jpg	2024-05-24 05:46:36.925822	2024-05-24 05:46:36.925822	pending
2cdd895b-a343-43d8-a026-ad143a2c6223	01e34890-985d-45b1-a80d-ac3926afb74d	level1_networking	01e34890-985d-45b1-a80d-ac3926afb74d1716529827343.jpg	2024-05-24 05:50:27.398493	2024-05-24 05:50:27.398493	pending
58de8081-c980-45b8-9013-3e6366301882	952e3643-5a42-49d9-9320-a1daa3fe03e2	level1_networking	952e3643-5a42-49d9-9320-a1daa3fe03e21716530167814.jpg	2024-05-24 05:56:07.86611	2024-05-24 05:56:07.86611	pending
5ab4fc3a-6b77-4ffb-9106-e969d636e544	53ca35ee-09d0-4cc2-b967-0e2cc5adcc7b	level2_volunteering	53ca35ee-09d0-4cc2-b967-0e2cc5adcc7b1716531519400.jpg	2024-05-24 06:18:39.401401	2024-05-24 06:18:39.401401	pending
e684abeb-b7f7-40c9-a8a4-c7b24298c804	c3e6cfa5-396e-47a2-8fa2-20747ab787e6	level2_volunteering	c3e6cfa5-396e-47a2-8fa2-20747ab787e61716532869067.jpg	2024-05-24 06:41:11.097477	2024-05-24 06:41:11.097477	pending
61cca1db-52fe-4b46-b557-a5828f3987bd	221d5abf-b72b-435f-ab34-3b8a8781d37f	level2_volunteering	221d5abf-b72b-435f-ab34-3b8a8781d37f1716533155935.jpeg	2024-05-24 06:45:55.952725	2024-05-24 06:45:55.952725	pending
aa4da9f8-8652-4d39-a6b0-daaed4cca2ee	c45cd835-f58b-42bc-86ed-21acc3e47ca3	level2_volunteering	c45cd835-f58b-42bc-86ed-21acc3e47ca31716533224586.jpg	2024-05-24 06:47:04.730691	2024-05-24 06:47:04.730691	pending
86ffcfe1-0c4f-47c1-8b6e-31e4259a4b72	875e5149-931e-4961-b295-30484348a2b5	level2_volunteering	875e5149-931e-4961-b295-30484348a2b51716534302201.jpg	2024-05-24 07:05:02.229297	2024-05-24 07:05:02.229297	pending
cd110669-110a-4832-8dea-1da2ee2f2812	bd3b6c24-e9b8-40e3-a595-a6f0297a1e74	level1_networking	bd3b6c24-e9b8-40e3-a595-a6f0297a1e741716535028917.png	2024-05-24 07:17:08.926395	2024-05-24 07:17:08.926395	pending
541ad7a2-99e9-474f-a753-21021acf89ea	0f53af60-a986-47c8-92bf-28947e50c79a	level2_volunteering	0f53af60-a986-47c8-92bf-28947e50c79a1716535325566.jpeg	2024-05-24 07:22:05.578613	2024-05-24 07:22:05.578613	pending
191b2aa1-eaa3-4a59-b582-2546b35063c8	371d711e-f4e6-4d1e-bc24-50816ee510ea	level1_networking	371d711e-f4e6-4d1e-bc24-50816ee510ea1716535537083.jpg	2024-05-24 07:25:37.202518	2024-05-24 07:25:37.202518	pending
ef07b658-1f57-46f4-a7a0-e4db4b55160c	524575a5-da66-4d21-bffe-c69247f80eaf	level1_networking	524575a5-da66-4d21-bffe-c69247f80eaf1716543868948.jpg	2024-05-24 09:44:28.94956	2024-05-24 09:44:28.94956	pending
1c196e44-8302-4266-93bf-845fecd80e26	7577a281-d299-4784-906e-c7a0f2fad587	level1_networking	7577a281-d299-4784-906e-c7a0f2fad5871716545938634.jpeg	2024-05-24 10:18:58.635996	2024-05-24 10:18:58.635996	pending
89326f08-8f9f-45a2-9065-f21966095c6e	501e08db-bbad-429f-9e42-a05fcbaea837	level1_networking	501e08db-bbad-429f-9e42-a05fcbaea8371716548395623.jpg	2024-05-24 10:59:55.625097	2024-05-24 10:59:55.625097	pending
d5679609-dc79-450d-9c8c-bfd0070ef97f	91789307-9880-4360-9c20-f3373a62bcf2	level1_networking	91789307-9880-4360-9c20-f3373a62bcf21716549010813.jpeg	2024-05-24 11:10:10.899055	2024-05-24 11:10:10.899055	pending
15918200-96b1-407e-9281-a87f6e66eed0	9d7c7fbb-92ce-44f1-a018-15378dbc3370	level1_networking	9d7c7fbb-92ce-44f1-a018-15378dbc33701716549261605.jpeg	2024-05-24 11:14:21.681002	2024-05-24 11:14:21.681002	pending
bafbc771-0523-4198-b100-7ba7d3be4198	c5743050-8d2d-4ba3-a57a-5255a013686b	level1_networking	c5743050-8d2d-4ba3-a57a-5255a013686b1716549591238.jpg	2024-05-24 11:19:51.240463	2024-05-24 11:19:51.240463	pending
6f7d6000-7d0a-4d32-9e76-dd9baa438167	2e833904-c774-4f55-ae9e-8c553b3a331e	level1_networking	2e833904-c774-4f55-ae9e-8c553b3a331e1716549626017.jpg	2024-05-24 11:20:26.188334	2024-05-24 11:20:26.188334	pending
004d6e5e-6fe8-4972-b91c-daf0b3857503	6a4bc22e-19d9-4e85-a5e5-7858d0923d3d	level1_networking	6a4bc22e-19d9-4e85-a5e5-7858d0923d3d1716551542759.jpg	2024-05-24 11:52:22.761058	2024-05-24 11:52:22.761058	pending
6fc2a030-0c03-449b-8c34-5f17a9b327d4	53bacd86-068a-482b-b87e-59ce48eb018d	level1_networking	53bacd86-068a-482b-b87e-59ce48eb018d1716551643931.jpg	2024-05-24 11:54:03.93289	2024-05-24 11:54:03.93289	pending
db818cec-063e-4e84-9408-1973e1653a17	e89c5141-8e28-46a0-9c20-0454f4433fd8	level1_networking	e89c5141-8e28-46a0-9c20-0454f4433fd81716552953406.jpg	2024-05-24 12:15:53.407464	2024-05-24 12:15:53.407464	pending
4c06109c-3d45-4d15-904f-844a90486bf7	e4a375e4-91f8-4e1c-bd63-d6afa6bb2ed7	level1_networking	e4a375e4-91f8-4e1c-bd63-d6afa6bb2ed71716575337041.jpg	2024-05-24 18:28:57.042595	2024-05-24 18:28:57.042595	pending
b9dbd8d3-e7cb-4a27-93ee-c0895bb9525a	c7711e63-9298-4c5d-b734-b099ebc4a50b	level1_networking	c7711e63-9298-4c5d-b734-b099ebc4a50b1716579009209.jpg	2024-05-24 19:30:09.574261	2024-05-24 19:30:09.574261	pending
f67b0317-d1cd-4c3b-b594-07f7d1320055	7c3fec8b-7791-4000-9f05-05df8f4b9526	level2_volunteering	7c3fec8b-7791-4000-9f05-05df8f4b95261716612608663.jpg	2024-05-25 04:50:08.664773	2024-05-25 04:50:08.664773	pending
7ea22433-40c5-4462-a319-e6b234ff42e8	3745b5e8-77a0-466d-8336-d340e64a2111	level2_volunteering	3745b5e8-77a0-466d-8336-d340e64a21111716619329166.jpeg	2024-05-25 06:42:09.168174	2024-05-25 06:42:09.168174	rejected
0bf5d486-92df-427d-8f62-2417da5e3f15	3745b5e8-77a0-466d-8336-d340e64a2111	level2_volunteering	3745b5e8-77a0-466d-8336-d340e64a21111716619512767.png	2024-05-25 06:45:12.769202	2024-05-25 06:45:12.769202	pending
d252cf03-25b7-441a-b94b-972acdf8ab19	647418e1-776d-48ac-9bd5-3fb9bdaa759e	level1_networking	647418e1-776d-48ac-9bd5-3fb9bdaa759e1716619785922.jpeg	2024-05-25 06:49:45.924116	2024-05-25 06:49:45.924116	pending
8b4151b8-4add-4099-abce-932f736d2f6c	5ff2ba04-dc59-42a2-b8a2-6a94cfb535a8	level2_volunteering	5ff2ba04-dc59-42a2-b8a2-6a94cfb535a81716631174009.jpg	2024-05-25 09:59:34.011243	2024-05-25 09:59:34.011243	pending
fde0b690-45e6-45cc-9e77-9fd4bfb5363e	260f2d36-6354-4af0-b04e-9c0131cde2f7	level1_networking	260f2d36-6354-4af0-b04e-9c0131cde2f71716708354176.jpg	2024-05-26 07:25:54.188557	2024-05-26 07:25:54.188557	pending
cbfc50d3-1c03-46de-9ed2-18345739ed13	e2a68729-3fdc-47aa-b812-9ad2de0f9441	level1_networking	e2a68729-3fdc-47aa-b812-9ad2de0f94411716744677770.jpg	2024-05-26 17:31:17.774014	2024-05-26 17:31:17.774014	pending
\.


--
-- Data for Name: organisationdetails; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.organisationdetails (organisation) FROM stdin;
\.


--
-- Data for Name: otp_email; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otp_email (email, otp, verified, created_at, updated_at) FROM stdin;
jatavathshivashankar@gmail.com	343822	t	2024-05-21 17:46:50.817119	2024-05-21 17:47:11.140996
shyam.bonkers@gmail.com	581072	t	2024-05-09 10:10:01.959145	2024-05-09 10:10:27.98382
nandrammeena6655@gmail.com	968286	t	2024-05-12 10:50:05.7084	2024-05-12 10:50:25.483253
aaryan3783@gmail.com	142836	t	2024-05-12 17:36:18.174242	2024-05-12 17:36:47.77272
kkartik0156@gmail.com	690275	f	2024-05-12 17:43:08.015748	2024-05-12 17:43:08.015748
karankumarsahtkg2018@gmail.com	383067	t	2024-05-12 17:56:15.651427	2024-05-12 17:56:39.211777
chandrashekhar.uniflik@gmail.com	592125	f	2024-05-20 12:19:32.144106	2024-05-20 12:19:32.144106
gauravdev131@gmail.com	686551	t	2024-05-21 18:55:03.144905	2024-05-21 18:55:32.828488
rajkumar02061@gmail.com	499944	t	2024-05-21 18:55:43.034642	2024-05-21 18:56:26.112233
rehan.devesh16@gmail.com	934560	t	2024-05-21 19:55:31.869766	2024-05-21 19:55:49.988458
saurabhsandy134@gmail.com	768588	t	2024-05-22 18:11:18.068411	2024-05-22 18:11:43.545385
contact.marry.lusi@gmail.com	748330	t	2024-05-22 01:55:22.594253	2024-05-22 01:55:48.94506
akashsingh.ars1@gmail.com	768442	t	2024-05-22 04:06:35.307758	2024-05-22 04:07:06.963061
rahulsah6003@gmail.com	879493	t	2024-05-08 19:42:16.458307	2024-05-20 18:29:07.848433
namangupta037@gmail.com	133637	t	2024-05-21 03:25:27.492733	2024-05-21 03:25:48.92708
raviraushanjnb386@gmail.com	291856	t	2024-05-21 05:23:23.657107	2024-05-21 05:24:02.718117
vaibhavmishra1501@gmail.com	429788	t	2024-05-21 05:34:45.668265	2024-05-21 05:35:09.206795
vinaybeniwal777@gmail.com	431563	t	2024-05-21 07:06:05.475078	2024-05-21 07:06:20.140778
deshavathshivakumar@gmail.com	195050	t	2024-05-21 08:07:58.096927	2024-05-21 08:08:30.661216
achutapoorna2002@gmail.com	401180	t	2024-05-21 08:21:42.721968	2024-05-21 08:22:04.864901
jatavathshiva2001@gmail.com	875400	t	2024-05-21 08:22:24.9966	2024-05-21 08:22:45.918168
sandeepsanjipogu2002@gmail.com	463190	t	2024-05-21 09:48:30.410135	2024-05-21 09:49:37.172828
tsaijosh123@gmail.com	557094	t	2024-05-21 10:18:59.763011	2024-05-21 10:19:23.31244
priyassinha71202@gmail.com	207235	t	2024-05-21 10:22:42.004002	2024-05-21 10:23:03.421158
tarhradhe600@gmail.com	822557	t	2024-05-21 10:25:09.820838	2024-05-21 10:25:35.788222
ch.harikrishna3429@gmail.com	902262	t	2024-05-22 04:06:38.534125	2024-05-22 04:08:06.653654
nichtalo123@gmail.com	958447	t	2024-05-21 10:28:19.172737	2024-05-21 10:29:08.671028
bhupendraup14@gmail.com	895110	t	2024-05-21 11:28:57.884764	2024-05-21 11:29:19.170072
ankit49303@gmail.com	478507	t	2024-05-21 11:29:21.968917	2024-05-21 11:29:50.696764
balajee536@gmail.com	473286	t	2024-05-21 11:30:41.085008	2024-05-21 11:31:03.650806
sangetempamaney18@gmail.com	136279	t	2024-05-21 11:36:22.819696	2024-05-21 11:36:49.526272
debajitdoley999@gmail.com	716981	t	2024-05-21 11:37:15.352695	2024-05-21 11:37:40.168242
laxmiprasadratna@gmail.com	450446	t	2024-05-21 11:44:47.757907	2024-05-21 11:45:23.577278
mallesh69069@gmail.com	363081	t	2024-05-21 12:46:41.452349	2024-05-21 12:47:30.204237
dileepkanchupati33@gmail.com	646350	t	2024-05-21 12:47:13.35992	2024-05-21 12:47:49.500948
tassomoryang@gmail.com	512631	t	2024-05-21 13:13:27.230441	2024-05-21 13:14:08.505387
vamsiemani1@gmail.com	927718	t	2024-05-21 13:19:46.617355	2024-05-21 13:20:07.217962
poornaachuta117@gmail.com	390944	f	2024-05-21 13:34:35.970876	2024-05-21 13:34:35.970876
poornaachuta1177@gmail.com	175671	t	2024-05-21 13:35:26.110748	2024-05-21 13:35:52.235889
govindkumarjha31@gmail.com	537330	t	2024-05-21 14:03:22.796869	2024-05-21 14:04:33.921918
kumarmohit0203@gmail.com	566256	t	2024-05-21 14:10:24.050833	2024-05-21 14:10:44.622183
avireya123@gmail.com	190799	t	2024-05-21 14:10:45.369961	2024-05-21 14:11:04.238672
riteshshandilya9262@gmail.com	949137	t	2024-05-22 05:45:26.667391	2024-05-22 05:46:11.54997
karthikchowdary291@gmail.com	630062	t	2024-05-21 14:36:34.577934	2024-05-21 14:41:50.616991
hanumize007@gmail.com	104170	t	2024-05-21 15:01:33.134163	2024-05-21 15:01:52.683517
saurabhkumar80998@gmail.com	353824	t	2024-05-21 15:41:50.364842	2024-05-21 15:43:58.937952
harshrathor427@gmail.com	766511	t	2024-05-21 17:27:10.515684	2024-05-21 17:27:42.1232
krdeepakkdkm@gmail.com	535375	t	2024-05-22 05:51:36.261963	2024-05-22 05:52:03.085509
ayushkumarmehta2002@gmail.com	657875	t	2024-05-22 06:50:39.206126	2024-05-22 06:51:06.025106
vijaydui123@gmail.com	431953	f	2024-05-22 07:13:53.007965	2024-05-22 07:15:06.146876
wangdiranidolma@gmail.com	871077	t	2024-05-22 07:41:46.757247	2024-05-22 07:42:14.75608
vijaydui111@gmail.com	239480	t	2024-05-22 07:41:40.281017	2024-05-22 07:44:54.376169
novinbaruah@gmail.com	111956	t	2024-05-22 07:58:18.356152	2024-05-22 07:58:37.605127
ranitaki10@gmail.com	316924	t	2024-05-22 07:45:09.080412	2024-05-22 08:03:53.830027
cutedesert5@gmail.com	506535	t	2024-05-22 08:03:40.249447	2024-05-22 08:03:58.013129
biswadeepsingh28@gmail.com	449886	t	2024-05-22 08:12:10.941114	2024-05-22 08:12:31.74495
tadaryaku5@gmail.com	434398	t	2024-05-22 08:43:58.71029	2024-05-22 08:44:19.101879
Aaradhya.s0001@gmail.com	217410	t	2024-05-22 09:07:01.009054	2024-05-22 09:07:26.364501
aaradhya.s0001@gmail.com	690111	t	2024-05-22 09:08:08.365328	2024-05-22 09:08:43.305485
saumyaraj9534@gmail.com	860493	t	2024-05-22 09:11:36.096678	2024-05-22 09:12:06.683613
deybiman9391@gmail.com	490500	t	2024-05-22 09:22:06.552744	2024-05-22 09:22:33.418224
riteshshandilya62031@gmail.com	981303	t	2024-05-22 10:28:07.988206	2024-05-22 10:28:27.96396
Chaderdeep95@gmail.com	456720	t	2024-05-22 09:30:36.736212	2024-05-22 09:31:50.188517
shivasaiv5@gmail.com	163174	t	2024-05-22 10:19:04.489205	2024-05-22 10:21:09.741666
ac.meena63@gmail.com	719935	t	2024-05-22 10:31:17.680062	2024-05-22 10:31:34.047373
vinaybeniwal90@gmail.com	279449	t	2024-05-22 10:50:56.882524	2024-05-22 10:51:21.248952
ankitkushawah7562@gmail.com	742318	t	2024-05-22 10:52:05.35044	2024-05-22 10:52:43.547617
jr7122002rj@gmail.com	420610	t	2024-05-22 10:52:56.42549	2024-05-22 10:53:11.254427
moranamit632@gmail.com	463782	t	2024-05-22 10:55:18.447271	2024-05-22 10:55:53.466913
likhatassam1@gmail.com	415317	t	2024-05-22 13:00:17.014973	2024-05-22 13:00:54.625323
gamjumlaye@gmail.com	838097	t	2024-05-23 04:43:26.228713	2024-05-24 05:57:46.470453
btriku555@gmail.com	393258	t	2024-05-22 14:29:36.166982	2024-05-22 14:29:53.280948
piyushsingh9491@gmail.com	348703	t	2024-05-22 15:04:20.380583	2024-05-22 15:04:42.763937
pranshuanjay@gmail.com	533972	t	2024-05-22 18:10:35.222381	2024-05-22 18:11:27.916543
priyadarshankumar926@gmail.com	796733	t	2024-05-23 06:43:38.066281	2024-05-23 06:44:07.543269
prince841460ps@gmail.com	383652	t	2024-05-23 05:33:32.597457	2024-05-23 05:34:25.310433
abhishekbasantgupta@gmail.com	439100	t	2024-05-23 06:01:26.586847	2024-05-23 06:02:12.118901
choudharyabhi4387@gmail.com	324620	t	2024-05-23 06:31:37.757942	2024-05-23 06:32:01.77171
rajnishantkumar428@gmail.com	163788	t	2024-05-23 06:42:02.150305	2024-05-26 06:35:48.333131
rahulkumarstm1609@gmail.com	421939	t	2024-05-23 07:21:16.603947	2024-05-23 07:21:46.817687
9436264521n@gmail.com	121513	t	2024-05-23 07:44:49.893709	2024-05-23 07:46:08.842516
shimonshiromaniss@gmail.com	417337	t	2024-05-23 10:29:48.45949	2024-05-23 10:30:12.493356
baburamyadav2690@gmail.com	475610	t	2024-05-23 13:43:41.253407	2024-05-23 13:44:05.210113
paswansonu578@gmail.com	552497	t	2024-05-23 14:11:31.507936	2024-05-23 14:12:08.0421
devkanyal07@gmail.com	848049	t	2024-05-23 14:06:54.492538	2024-05-23 14:09:01.49536
adityakumarhems01@gmail.com	852095	t	2024-05-23 15:27:28.183378	2024-05-23 15:28:05.616444
saurabhroy40227@gmail.com	699394	t	2024-05-23 15:58:08.388033	2024-05-23 15:58:40.454623
ck020237@gmail.com	998322	t	2024-05-23 15:59:54.746525	2024-05-23 16:00:20.060416
ervishalsah2302@gmail.com	104854	t	2024-05-23 16:03:48.800292	2024-05-23 16:04:12.797419
dasjipu@gmail.com	100798	t	2024-05-23 17:36:15.726207	2024-05-23 17:36:55.942049
prokashpegu19@gmail.com	519100	t	2024-05-23 21:10:37.17659	2024-05-23 21:11:11.7306
kadebharath@gmail.com	131437	t	2024-05-24 02:46:20.521754	2024-05-24 02:48:29.717394
mantrimahesh999@gmail.com	320046	t	2024-05-24 05:32:37.238526	2024-05-24 05:33:05.87961
ch36praneeth@gmail.com	450930	t	2024-05-21 07:57:10.458101	2024-05-24 05:40:56.38171
Nathmanju557@gmail.com	222387	t	2024-05-24 05:50:07.509632	2024-05-24 05:50:25.085088
bomgeyinyo12@gmail.com	600982	t	2024-05-24 06:27:08.827847	2024-05-24 06:27:26.697847
ngomlejummo@gmail.com	632323	t	2024-05-24 06:33:46.088465	2024-05-24 06:34:06.885014
pertinusha43@gmail.com	340900	t	2024-05-24 06:38:11.250728	2024-05-24 06:38:30.467634
irennaraww.com@gmail.com	710794	f	2024-05-24 06:51:21.99359	2024-05-24 06:51:21.99359
irenmaraww.com@gmail.com	462492	t	2024-05-24 06:53:09.806563	2024-05-24 06:53:32.23669
kapakirankumar5@gmail.com	319690	t	2024-05-24 06:57:28.517085	2024-05-24 06:57:51.482211
tejaswiniii612@gmail.com	752256	t	2024-05-24 07:05:29.334116	2024-05-24 07:05:52.763827
rahulkumarrohan485@gmail.com	171625	t	2024-05-24 07:12:18.934516	2024-05-24 07:12:48.58909
akhilatgkp@gmail.com	536777	t	2024-05-24 07:12:44.826331	2024-05-24 07:17:00.044239
rishavpoddar6397@gmail.com	812025	t	2024-05-24 08:45:37.093673	2024-05-24 08:54:29.744897
Kumarabhinav0211@gmail.com	222319	t	2024-05-24 09:18:51.777514	2024-05-24 09:19:13.763295
wahgemadap@gmail.com	901920	t	2024-05-24 09:19:49.000273	2024-05-24 09:20:17.875287
debiaamang@gmail.com	216409	f	2024-05-24 09:52:40.957343	2024-05-24 09:53:25.854426
16agrawalshivani@gmail.com	589151	t	2024-05-24 10:07:57.953254	2024-05-24 10:08:27.885293
kumarabhinav0298@gmail.com	689238	t	2024-05-24 10:58:05.320516	2024-05-24 10:58:28.148774
naveenjakhar1203@gmail.com	654460	f	2024-05-24 11:01:13.012443	2024-05-24 11:05:38.463652
kundanmeena572001@gmail.com	475846	t	2024-05-24 11:07:53.662416	2024-05-24 11:08:18.375798
naveenjakhar2004@gmail.com	179491	t	2024-05-24 11:07:56.507352	2024-05-24 11:08:20.284273
brormukesh2002@gmail.com	571827	t	2024-05-24 11:18:20.950821	2024-05-24 11:18:58.211154
archanachawala59@gmail.com	589177	t	2024-05-24 11:29:25.959341	2024-05-24 11:29:47.981478
praveenk6117@gmail.com	552050	t	2024-05-24 11:37:37.983162	2024-05-24 11:38:43.745905
singhsima2000@gmail.com	565498	t	2024-05-24 15:28:25.8789	2024-05-24 15:31:23.606918
sonumeena09799@gmail.com	966593	t	2024-05-24 18:11:27.489662	2024-05-24 18:11:50.633439
shivamce2011@gmail.com	514123	t	2024-05-24 18:12:42.779045	2024-05-24 18:13:54.488098
udaykiranrathod2003@gmail.com	359153	t	2024-05-24 18:34:50.500921	2024-05-24 18:35:18.593143
waiimekruk@gmail.com	443331	t	2024-05-24 09:54:52.767171	2024-05-25 04:17:02.63807
lankapallibindhu@gmail.com	109538	t	2024-05-26 06:46:36.948891	2024-05-26 06:47:30.902334
chandueduru@gmail.com	145560	t	2024-05-26 07:28:35.087316	2024-05-26 07:29:24.437805
louichtaid64@gmail.com	646590	t	2024-05-24 18:21:28.954117	2024-05-26 08:35:42.954192
tripathics17@gmail.com	418618	t	2024-05-08 20:16:32.736956	2025-05-19 23:25:11.22248
\.


--
-- Data for Name: otp_email_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.otp_email_attempts (email, attempts, created_at, updated_at) FROM stdin;
gauravdev131@gmail.com	0	2024-05-21 18:55:03.147685	2024-05-21 18:55:03.147685
rajkumar02061@gmail.com	0	2024-05-21 18:55:43.036803	2024-05-21 18:55:43.036803
shyam.bonkers@gmail.com	0	2024-05-09 10:10:01.995493	2024-05-09 10:10:01.995493
nandrammeena6655@gmail.com	0	2024-05-12 10:50:05.710864	2024-05-12 10:50:05.710864
aaryan3783@gmail.com	0	2024-05-12 17:36:18.176386	2024-05-12 17:36:18.176386
kkartik0156@gmail.com	1	2024-05-12 17:43:08.018004	2024-05-12 17:43:08.018004
karankumarsahtkg2018@gmail.com	0	2024-05-12 17:56:15.653773	2024-05-12 17:56:15.653773
chandrashekhar.uniflik@gmail.com	1	2024-05-20 12:19:32.238273	2024-05-20 12:19:32.238273
rehan.devesh16@gmail.com	0	2024-05-21 19:55:31.871837	2024-05-21 19:55:31.871837
contact.marry.lusi@gmail.com	0	2024-05-22 01:55:22.597421	2024-05-22 01:55:22.597421
shimonshiromaniss@gmail.com	0	2024-05-23 10:29:48.461837	2024-05-23 10:29:48.461837
akashsingh.ars1@gmail.com	0	2024-05-22 04:06:35.3099	2024-05-22 04:06:35.3099
ch.harikrishna3429@gmail.com	0	2024-05-22 04:06:38.535744	2024-05-22 04:06:38.535744
riteshshandilya9262@gmail.com	0	2024-05-22 05:45:26.670638	2024-05-22 05:45:26.670638
rahulsah6003@gmail.com	0	2024-05-08 19:42:16.460182	2024-05-20 18:28:50.927465
namangupta037@gmail.com	0	2024-05-21 03:25:27.496064	2024-05-21 03:25:27.496064
raviraushanjnb386@gmail.com	0	2024-05-21 05:23:23.66053	2024-05-21 05:23:23.66053
vaibhavmishra1501@gmail.com	0	2024-05-21 05:34:45.671643	2024-05-21 05:34:45.671643
vinaybeniwal777@gmail.com	0	2024-05-21 07:06:05.478568	2024-05-21 07:06:05.478568
deshavathshivakumar@gmail.com	0	2024-05-21 08:07:58.099651	2024-05-21 08:07:58.099651
achutapoorna2002@gmail.com	0	2024-05-21 08:21:42.724261	2024-05-21 08:21:42.724261
jatavathshiva2001@gmail.com	0	2024-05-21 08:22:24.99867	2024-05-21 08:22:24.99867
sandeepsanjipogu2002@gmail.com	0	2024-05-21 09:48:30.413864	2024-05-21 09:48:30.413864
tsaijosh123@gmail.com	0	2024-05-21 10:18:59.765262	2024-05-21 10:18:59.765262
priyassinha71202@gmail.com	0	2024-05-21 10:22:42.006625	2024-05-21 10:22:42.006625
tarhradhe600@gmail.com	0	2024-05-21 10:25:09.823983	2024-05-21 10:25:09.823983
nichtalo123@gmail.com	0	2024-05-21 10:28:19.175158	2024-05-21 10:28:49.16014
bhupendraup14@gmail.com	0	2024-05-21 11:28:57.887331	2024-05-21 11:28:57.887331
ankit49303@gmail.com	0	2024-05-21 11:29:21.971013	2024-05-21 11:29:21.971013
balajee536@gmail.com	0	2024-05-21 11:30:41.086961	2024-05-21 11:30:41.086961
sangetempamaney18@gmail.com	0	2024-05-21 11:36:22.821805	2024-05-21 11:36:22.821805
debajitdoley999@gmail.com	0	2024-05-21 11:37:15.354286	2024-05-21 11:37:15.354286
laxmiprasadratna@gmail.com	0	2024-05-21 11:44:47.759973	2024-05-21 11:44:47.759973
mallesh69069@gmail.com	0	2024-05-21 12:46:41.454746	2024-05-21 12:46:41.454746
dileepkanchupati33@gmail.com	0	2024-05-21 12:47:13.362306	2024-05-21 12:47:13.362306
tassomoryang@gmail.com	0	2024-05-21 13:13:27.233068	2024-05-21 13:13:27.233068
vamsiemani1@gmail.com	0	2024-05-21 13:19:46.619922	2024-05-21 13:19:46.619922
poornaachuta117@gmail.com	1	2024-05-21 13:34:35.972839	2024-05-21 13:34:35.972839
poornaachuta1177@gmail.com	0	2024-05-21 13:35:26.112944	2024-05-21 13:35:26.112944
krdeepakkdkm@gmail.com	0	2024-05-22 05:51:36.26471	2024-05-22 05:51:36.26471
govindkumarjha31@gmail.com	0	2024-05-21 14:03:22.798839	2024-05-21 14:04:11.939993
kumarmohit0203@gmail.com	0	2024-05-21 14:10:24.052794	2024-05-21 14:10:24.052794
avireya123@gmail.com	0	2024-05-21 14:10:45.372197	2024-05-21 14:10:45.372197
ayushkumarmehta2002@gmail.com	0	2024-05-22 06:50:39.208546	2024-05-22 06:50:39.208546
karthikchowdary291@gmail.com	0	2024-05-21 14:36:34.580613	2024-05-21 14:41:36.709825
hanumize007@gmail.com	0	2024-05-21 15:01:33.13658	2024-05-21 15:01:33.13658
saurabhkumar80998@gmail.com	0	2024-05-21 15:41:50.36725	2024-05-21 15:41:50.36725
harshrathor427@gmail.com	0	2024-05-21 17:27:10.519815	2024-05-21 17:27:10.519815
jatavathshivashankar@gmail.com	0	2024-05-21 17:46:50.819585	2024-05-21 17:46:50.819585
riteshshandilya62031@gmail.com	0	2024-05-22 10:28:07.990263	2024-05-22 10:28:07.990263
vijaydui123@gmail.com	3	2024-05-22 07:13:53.010517	2024-05-22 07:15:13.877617
wangdiranidolma@gmail.com	0	2024-05-22 07:41:46.758924	2024-05-22 07:41:46.758924
vijaydui111@gmail.com	0	2024-05-22 07:41:40.283301	2024-05-22 07:41:40.283301
novinbaruah@gmail.com	0	2024-05-22 07:58:18.35898	2024-05-22 07:58:18.35898
ranitaki10@gmail.com	0	2024-05-22 07:45:09.082789	2024-05-22 08:03:32.985975
cutedesert5@gmail.com	0	2024-05-22 08:03:40.251141	2024-05-22 08:03:40.251141
biswadeepsingh28@gmail.com	0	2024-05-22 08:12:10.943292	2024-05-22 08:12:10.943292
tadaryaku5@gmail.com	0	2024-05-22 08:43:58.712569	2024-05-22 08:43:58.712569
Aaradhya.s0001@gmail.com	0	2024-05-22 09:07:01.011339	2024-05-22 09:07:01.011339
ac.meena63@gmail.com	0	2024-05-22 10:31:17.682366	2024-05-22 10:31:17.682366
aaradhya.s0001@gmail.com	0	2024-05-22 09:08:08.367421	2024-05-22 09:08:27.294649
saumyaraj9534@gmail.com	0	2024-05-22 09:11:36.098879	2024-05-22 09:11:36.098879
deybiman9391@gmail.com	0	2024-05-22 09:22:06.555043	2024-05-22 09:22:06.555043
Chaderdeep95@gmail.com	0	2024-05-22 09:30:36.737921	2024-05-22 09:31:25.194183
vinaybeniwal90@gmail.com	0	2024-05-22 10:50:56.885066	2024-05-22 10:50:56.885066
shivasaiv5@gmail.com	0	2024-05-22 10:19:04.492535	2024-05-22 10:20:55.901851
ankitkushawah7562@gmail.com	0	2024-05-22 10:52:05.35284	2024-05-22 10:52:05.35284
jr7122002rj@gmail.com	0	2024-05-22 10:52:56.427268	2024-05-22 10:52:56.427268
moranamit632@gmail.com	0	2024-05-22 10:55:18.449117	2024-05-22 10:55:18.449117
likhatassam1@gmail.com	0	2024-05-22 13:00:17.017958	2024-05-22 13:00:17.017958
prince841460ps@gmail.com	0	2024-05-23 05:33:32.599202	2024-05-23 05:34:02.975448
abhishekbasantgupta@gmail.com	0	2024-05-23 06:01:26.589197	2024-05-23 06:01:26.589197
btriku555@gmail.com	0	2024-05-22 14:29:36.16935	2024-05-22 14:29:36.16935
piyushsingh9491@gmail.com	0	2024-05-22 15:04:20.383858	2024-05-22 15:04:20.383858
pranshuanjay@gmail.com	0	2024-05-22 18:10:35.22529	2024-05-22 18:10:35.22529
saurabhsandy134@gmail.com	0	2024-05-22 18:11:18.070266	2024-05-22 18:11:18.070266
gamjumlaye@gmail.com	0	2024-05-23 04:43:26.231612	2024-05-24 05:57:24.274479
choudharyabhi4387@gmail.com	0	2024-05-23 06:31:37.760237	2024-05-23 06:31:37.760237
priyadarshankumar926@gmail.com	0	2024-05-23 06:43:38.068175	2024-05-23 06:43:38.068175
rahulkumarstm1609@gmail.com	0	2024-05-23 07:21:16.606324	2024-05-23 07:21:16.606324
9436264521n@gmail.com	0	2024-05-23 07:44:49.895902	2024-05-23 07:44:49.895902
baburamyadav2690@gmail.com	0	2024-05-23 13:43:41.256818	2024-05-23 13:43:41.256818
paswansonu578@gmail.com	0	2024-05-23 14:11:31.510292	2024-05-23 14:11:31.510292
devkanyal07@gmail.com	0	2024-05-23 14:06:54.495445	2024-05-23 14:08:40.619599
adityakumarhems01@gmail.com	0	2024-05-23 15:27:28.185903	2024-05-23 15:27:28.185903
saurabhroy40227@gmail.com	0	2024-05-23 15:58:08.390454	2024-05-23 15:58:08.390454
ck020237@gmail.com	0	2024-05-23 15:59:54.748703	2024-05-23 15:59:54.748703
ervishalsah2302@gmail.com	0	2024-05-23 16:03:48.802213	2024-05-23 16:03:48.802213
dasjipu@gmail.com	0	2024-05-23 17:36:15.727775	2024-05-23 17:36:15.727775
prokashpegu19@gmail.com	0	2024-05-23 21:10:37.178899	2024-05-23 21:10:37.178899
kadebharath@gmail.com	0	2024-05-24 02:46:20.524249	2024-05-24 02:48:06.584969
mantrimahesh999@gmail.com	0	2024-05-24 05:32:37.240175	2024-05-24 05:32:37.240175
ch36praneeth@gmail.com	0	2024-05-21 07:57:10.461084	2024-05-24 05:40:39.104508
Nathmanju557@gmail.com	0	2024-05-24 05:50:07.511804	2024-05-24 05:50:07.511804
bomgeyinyo12@gmail.com	0	2024-05-24 06:27:08.829472	2024-05-24 06:27:08.829472
ngomlejummo@gmail.com	0	2024-05-24 06:33:46.090522	2024-05-24 06:33:46.090522
pertinusha43@gmail.com	0	2024-05-24 06:38:11.252619	2024-05-24 06:38:11.252619
irennaraww.com@gmail.com	1	2024-05-24 06:51:21.996065	2024-05-24 06:51:21.996065
irenmaraww.com@gmail.com	0	2024-05-24 06:53:09.808862	2024-05-24 06:53:09.808862
kapakirankumar5@gmail.com	0	2024-05-24 06:57:28.519061	2024-05-24 06:57:28.519061
tejaswiniii612@gmail.com	0	2024-05-24 07:05:29.336161	2024-05-24 07:05:29.336161
rahulkumarrohan485@gmail.com	0	2024-05-24 07:12:18.936633	2024-05-24 07:12:18.936633
akhilatgkp@gmail.com	0	2024-05-24 07:12:44.828155	2024-05-24 07:16:31.803916
rishavpoddar6397@gmail.com	0	2024-05-24 08:45:37.096098	2024-05-24 08:53:52.148462
Kumarabhinav0211@gmail.com	0	2024-05-24 09:18:51.779917	2024-05-24 09:18:51.779917
wahgemadap@gmail.com	0	2024-05-24 09:19:49.002031	2024-05-24 09:19:49.002031
debiaamang@gmail.com	2	2024-05-24 09:52:40.959876	2024-05-24 09:53:25.856302
16agrawalshivani@gmail.com	0	2024-05-24 10:07:57.955153	2024-05-24 10:07:57.955153
kumarabhinav0298@gmail.com	0	2024-05-24 10:58:05.322496	2024-05-24 10:58:05.322496
naveenjakhar1203@gmail.com	6	2024-05-24 11:01:13.014273	2024-05-24 11:05:38.465856
kundanmeena572001@gmail.com	0	2024-05-24 11:07:53.665806	2024-05-24 11:07:53.665806
naveenjakhar2004@gmail.com	0	2024-05-24 11:07:56.508932	2024-05-24 11:07:56.508932
brormukesh2002@gmail.com	0	2024-05-24 11:18:20.953238	2024-05-24 11:18:20.953238
archanachawala59@gmail.com	0	2024-05-24 11:29:26.188139	2024-05-24 11:29:26.188139
praveenk6117@gmail.com	0	2024-05-24 11:37:37.985122	2024-05-24 11:37:37.985122
singhsima2000@gmail.com	0	2024-05-24 15:28:25.881329	2024-05-24 15:30:50.642735
sonumeena09799@gmail.com	0	2024-05-24 18:11:27.492299	2024-05-24 18:11:27.492299
shivamce2011@gmail.com	0	2024-05-24 18:12:42.781609	2024-05-24 18:13:34.970465
udaykiranrathod2003@gmail.com	0	2024-05-24 18:34:50.503283	2024-05-24 18:34:50.503283
waiimekruk@gmail.com	0	2024-05-24 09:54:52.769017	2024-05-25 04:16:39.926693
rajnishantkumar428@gmail.com	0	2024-05-23 06:42:02.152321	2024-05-26 06:35:35.0254
lankapallibindhu@gmail.com	0	2024-05-26 06:46:36.952254	2024-05-26 06:46:36.952254
chandueduru@gmail.com	0	2024-05-26 07:28:35.090007	2024-05-26 07:28:35.090007
louichtaid64@gmail.com	0	2024-05-24 18:21:28.956178	2024-05-26 08:35:19.902942
tripathics17@gmail.com	0	2024-05-08 20:16:32.738748	2025-05-19 23:24:59.768921
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (user_id, title, first_name, last_name, dob, sex, category, nationality, religion, address, pincode, state, city, country, phone, alt_phone, alt_email, linkedin, github, registration_no, roll_no, sign, avatar) FROM stdin;
f17989eb-85b8-420d-aec6-c18fd169bd62	Mr	Bhupendra 	Senger	2020-12-27	Male	General	India 	Hindu	b -26 gali no 1 sarvodaya nagar ghaziabad	201009	UTTAR PRADESH	GHAZIABAD	India	09899192256	\N	\N	\N	\N	0000001328/A/2021	EE/20/12	\N	\N
4e19018c-3aed-4544-b36b-f5206067c714	Mr	Debajit 	Doley 	2000-01-01	Male	ST	Indian 	Hindu 	North Lakhimpur 	787055	Assam 	North Lakhimpur 	India 	9401657467	\N	\N	\N	\N	0000001287/A/2020	ECE/20/06	\N	\N
a4c761dd-b75a-475b-b555-d9696554cb30	Mr	Chandrashekhar	Tripathi	1970-01-01	Male	General	Indian	-	-	791113	-	-	-	-	\N	\N	\N	\N	38	38	\N	\N
ec74e358-3fb1-4d80-b169-b889f2e18e7c	Mr	Naman 	Gupta 	2001-12-12	Male	General	Indian 	Hindu 	VPO. Rajnota, teh. Paota	303110	Rajasthan 	Jaipur 	India	9511504432	\N	\N	\N	\N	0000001282/A/2020	CSE/20/34	\N	\N
163af0e1-8854-4854-bbea-7e60e32604db	Mr	Vinay	Beniwal	2002-09-09	Male	OBC	INDIAN	Hindu	 Raghunathpura ,Jhunjhunu ,Rajasthan	333038	Rajasthan 	jhunjhunu	India	7597663459	8619725132		\N	\N	0000001342/A/2021	EE/20/26	\N	\N
5344a300-740c-4bbd-b419-8875608c8503	Mr	Achuta Poorna Chandra	Shekar 	2002-11-02	Male	General	Indain	Hindu 	D/no:-27/8/627,N-T-R Nagar,Nellore 	524002	Andhra Pradesh 	Nellore	India 	8074799133	6033936693	poornaachuta1177@gmail.com		\N	0000001304/A/2021	ECE/20/23	\N	\N
5ff2ba04-dc59-42a2-b8a2-6a94cfb535a8	Mr	SANDEEP KUMAR	SANJIPOGU	2002-08-13	Male	SC	INDIAN	HINDU	kurnool,andhra pradesh	518313	andhra pradesh	kurnool	INDIA	9160544155	6281958901			\N	0000001280/A/2020	CSE/20/32	\N	\N
21af335f-f670-4cf6-bf69-e027de42b417	Mr	Telugu 	Sai joshith	2003-06-29	Male	OBC	INDIAN	HINDU	1/418-5-7,maruthi nagar	516001	Andhra Pradesh	kadapa	INDIA	9010163222	\N		\N	\N	0000001277/A/2020	CSE/20/29	\N	\N
c068c2f5-b1a6-41c4-87e7-1af25a047b84	Mr	Ratna Laxmi	Prasad	2002-01-22	Male	General	INDIAN	HINDU	2-41, main road, Dugnepalli 	504201	Telangana	MANCHERIAL	India	7993270878	\N	\N	\N	\N	0000001285/A/2020	ECE/20/04	\N	\N
b0d3f92c-e370-4836-b97a-8914b23cf74c	Mr	Kanchupati	Dileep	2003-06-14	Male	SC	Indian	Hindu	Ganeshwarapuram, Varikuntapadu, Nellore, Andhra Pradesh, 524221.	524221	ANDHRA PRADESH	NELLORE	INDIA	9502489261	8500182606	sk8928223@gmail.com	\N	\N	0000001344/A/2021	EE/20/28	\N	\N
6b8e198e-a3c2-4145-b3e5-5c45b487e0cc	Mr	Ramavath	Mallesh	2002-01-18	Male	ST	Indian	Hindu	4-15 chedurubavi thanda , (Ainole) , Achampet,Nagar kurnool (509375), Telangana	509375	Telangana	Nagarkurnool	India	6302006905	8500035539	ramavath16191@gmail.com	\N	\N	0000001303/A/2020	ECE/20/22	\N	\N
701d20ab-0b73-49c6-87fa-950b4916d1cf	Mr	Achuta Poorna Chandra 	Shekar 	2002-11-02	Male	General	Indian 	Hindu	D/no:-27/8/627,N-T-R Nagar,Nellore 	524002	Andhra Pradesh 	Nellore 	Indai 	8074799133	6033936693	achutapoorna2002@gmail.com		\N	0000001304/A/2020	ECE/20/23	\N	\N
bda41421-b65d-4cb8-9a02-9b491e96220f	Mr	Mohit 	Kumar	2003-03-02	Male	OBC	Indian	Hindu	Gurdaha khurd ,post- manjhi, district -Saran,841313	841313	Bihar	Saran	India	9472818422	9934686119	\N	\N	\N	0000001369/A/2021	ME/20/22	\N	\N
cf95fd56-ceac-414f-99b4-8151fe18b359	Mr	Yash	Raj	2001-12-25	Male	SC	Indian 	Hindu	Ratnarh 	802203	Bihar	Ara	India	9479414068	\N	\N	\N	\N	000000/1377/A/2021	ME/20/30	\N	\N
6b0fbd0b-9633-498f-8c37-d6fc060b6d1c	Mr	Shishir 	Kumar 	2002-03-25	Male	General	Indian	Hindu 	Vill & Po Basauli, Madhubani 	847121	Bihar	Madhubani 	India	9711879313	8974636400	sunitijha096@gmail.com	https://www.linkedin.com/in/shishir-jha-59136520b/	\N	0000001359/A/2021	ME/20/12	\N	\N
684cde69-6b1c-49ff-b9e9-5e2a544ae1bb	Mr	Linggen 	Mize 	2003-06-13	Male	ST	Indian 	Donyi polo 	Napit village,pasighat 	791102	Arunachal pradesh 	Pasighat	India 	6033931584	\N	\N	\N	\N	0000001341/A/2021	EE/20/25	\N	\N
e023620f-d685-4f8a-b921-c7625c5cd615	Mr	Raj	Kumar	2002-04-13	Male	OBC	Indian	Hindu	Near Prabhat zarda Factory,New Area Sikandarpur,Muzaffarpur.	842001	BIHAR	Muzaffarpur	India	9470472733	9162834303	\N	\N	\N	0000001316/A/2020	ECE/20/35	\N	\N
d391ddca-46a1-4080-831a-647966a5d205	Mr	Ritesh	Kumar	2002-10-08	Male	EWS	INDIAN	Hindu	Rampur Chhapkahiya, P.S- Govindganj, P.O- Chhapkahiya, Dist-East Champaran	845458	Bihar	Motihari	India	6203127387	9472320640	\N	\N	\N	0000001334/A/2021	EE/20/18	\N	\N
e7ea86e4-8410-46b6-a8ec-6008c8fd4f4b	Ms	Marry lusi	Tamin	2003-08-07	Female	ST	Indian	Christian 	F-sector,Itanagar, Arunachal Pradesh 	791111	Arunachal Pradesh 	Itanagar	India	8131896817	9436650373	marry.btech.ece.20@nitap.ac.in		\N	0000001299/A/2020	Ece/20/18	\N	\N
46134da6-1ae5-4d1b-98d4-e5275aa12e67	Mr	Hari Krishna Guptha	Chitluri	2002-09-03	Male	EWS	India	Hindu	6-45, Ramalayam street, Borrampalem	534451	Andhra Pradesh	borrampalem	India	7013504051	\N	\N	\N	\N	0000001345/A/2021	EE/20/29	\N	\N
aaad8207-90ae-4d08-b793-ee82852380e6	Mr	Ritesh	Kumar	2002-10-08	Male	EWS	Indian	Hindu	Rampur Chhapkahiya, P.S-Govindganj, P.O- Chhapkahiya, Dist- East Champaran	845458	Bihar	Motihari	India	6203127387	9472320640	\N	\N	\N	0000001334/A/2021	EE/20/18	\N	\N
ee72263e-3160-48e4-bcef-6a896cd1e0e8	Mr	Deepak 	Kumar	2002-08-01	Male	OBC	Indian	Hindu	Naya Tola , speaker chowk , Muzaffarpur  ,Bihar	842001	Bihar	Muzaffarpur	India	+918873547093	9708483776	\N	\N	\N	0000001333/A/2021	EE/20/17	\N	\N
6011ddc1-7dac-44f8-b47e-be392c0d4c25	Ms	RANI DOLMA	WANGDI  	2002-08-01	Female	ST	INDIAN	BUDDHIST 	Miao ,District Changlang,Arunachal Pradesh	792122	Arunachal Pradesh	MIAO	India	06009969741	\N	rani.btech.ee.20@nitap.ac.in	\N	\N	0000001320/A/2021	EE/20/04	\N	\N
069df11f-3e77-401d-8d75-d6042568f82e	Mr	Vijay 	Dui	2002-02-04	Male	ST	Indian	Donipolo	po/ps Siyum, District upper subansiri arunachal pradesh 	791122	Arunachal Pradesh 	Daporijo	India	8729972118	6033942738	vijaydui123@gmail.com		\N	0000001290/A/2020	ECE/20/09	\N	\N
bc117c08-fc12-40f6-acfc-2719a051fa5b	Mr	Novin	Baruah	2002-07-20	Male	OBC	Indian	Hindu	Lilabari,Lakhimpur	787051	Assam	North Lakhimpur	India	6033906838			\N	\N	0000001323/A/2021	EE/20/07	\N	\N
0e2d7f9d-a1d4-4649-ac7f-eb9eb8263a51	Ms	RANI	TAKI	2002-05-10	Female	ST	INDIAN	DONYI POLO 	PASIGHAT,DIST-EAST SIANG	7921102	Arunachal Pradesh	PASIGHAT	India	06033948747	7630040002	rani.btech.ee.20@nitap.ac.in	\N	\N	0000001337/A/2021	EE/20/21	\N	\N
a6a5a8c7-e5f9-4e88-8c7b-8a3bfdd5cb9a	Mr	Keisham Biswadeep	Singh	2000-07-31	Male	OBC	Indian	Hindu	High Region ,Power house colony	791102	Arunachal Pradesh	Pasighat	India	9436208518	8290974877	biswadeepsingh7@gmail.com	\N	\N	0000001295/A/2020	ECE/20/14	\N	\N
5826165c-34dc-41f3-b92d-f1ebca7c6d6c	Ms	TADAR	YAKU	2004-03-04	Female	ST	INDIAN	DONYI POLO	CHIMPU,ITANAGAR	791109	Arunachal Pradesh	ITANAGAR	India	8798317785		tadar.btech.ee.20@nitap.ac.in	\N	\N	0000001321/A/2021	EE/20/05	\N	\N
73a89400-2702-464f-9c49-31d07c94e0c5	Dr	Biman 	Dey 	1993-11-21	Male	General	INDIAN	HINDU	RILBONG SHILLONG MEGHALAYA 	793106	MEGHALAYA 	SHILLONG 	India 	6033908775	\N		\N	\N	00157/B/2020	PHD/2020/02	\N	\N
cfa52b66-aa64-4453-b716-be3685ac959e	Mr	Veda	Shivasai 	2001-11-28	Male	EWS	Indian 	Hindu 	317/A, dammaiguda, near Dubai building, keesara Mandal , Nagaram,Medchal-malkajgiri	500083	Telangana 	Hyderabad 	India 	8639479353	8500408489			\N	0000001344/A/2021	EE/20/24	\N	\N
ed9581c0-e7ef-4407-ae46-70d86b988471	Mr	Amit 	Moran	2002-03-28	Male	OBC	Indian 	Hindu	Mahadevpur Namsai Arunachal Pradesh 	792105	Arunachal Pradesh 	Namsai 	India	6009268465	\N	moranamit6@gmail.com	\N	\N	0000001326/A/2021	EE/20/10	\N	\N
3fb2cdc6-e085-449e-a626-39741460067a	Mr	sachin	Narera	2002-04-20	Male	ST	INDIAN	HINDU	49 roop nagar 2nd mahesh nagar Jaipur 	302014	rajasthan	jaipur	india	7426824583	7597294583		\N	\N	0000001239/A/2020	CE/20/29	\N	\N
70a0286c-a108-46c4-a9ed-7f673358436d	Mr	Vinay	Beniwal	2002-09-09	Male	OBC	INDIAN	Hindu	 Raghunathpura ,Jhunjhunu ,Rajasthan	333041	Rajasthan 	jhunjhunu	India	7597663459			\N	\N	0000001342/A/2021	EE/20/26	\N	\N
805c68af-8734-4c19-ae1c-baf67024d52b	Mr	Ankit	Kumar	2003-01-10	Male	OBC	Indian	Hindu	Rafipur,kaji tola 	841286	Bihar 	Siwan 	India 	8544147657	7562932871	ak2009993@gmail.com			0000001348/A/2021	EE/20/33	\N	\N
435dad5a-08dd-493e-b63a-f4ef7da9dafb	Mr	Gaurav	Dev	2001-01-08	Male	OBC	India	Hindu	Bhagalpur	813222	Bihar	Bhagalpur	India	8544550037	6201312718	gauravkr648@gmail.com	\N	\N	0000001273/A/2020	CSE/20/25	\N	avatar/435dad5a-08dd-493e-b63a-f4ef7da9dafb.jpg
ff52307e-8175-46a5-b7f1-fd218303af6c	Mr	Piyush 	Singh	2001-05-18	Male	General	Indian 	Hinduism 	Kushmaur, Mau,Uttar Pradesh	275103	Uttar Pradesh	Mau	India	+918258876226	\N		\N	\N	0000001266/A/2020	CSE/20/18	\N	\N
388cdf71-0a20-4ad7-9c37-d5c70eb1013b	Mr	SAURABH 	MEENA	2002-03-23	Male	ST	Indian	Hindu	Railway Colony, Gangapur City, Rajasthan	322200	Rajasthan	Gangapur City	Indian	9413943002	7976122863			\N	0000001373/A/2021	ME/20/26	\N	\N
40ff6408-62f4-445d-9a68-e5d849e9b4ec	Mr	Prince Kumar	Singh	2001-05-24	Male	OBC	Indian	Hindu	Vill+P.O: Kaituka Lachhi, P.S: Amnour	841460	Bihar	Chapra	India	7279947903	9905021360			\N	0000001383/A/2021	EE/20/30	\N	\N
feb82a39-ca9b-4cef-adcc-7b7c942d1153	Mr	Abhishek 	Kumar	2002-07-06	Male	OBC	Indian	Hindu	Mallahtoli. Deo, Aurangabad, Bihar, 824202	824202	Bihar	Auranagabad	India	8340329399	9471815805	\N	\N	\N	0000001233/A/2020	CE/20/23	\N	\N
d4a699d8-2805-44f4-8a3c-8ab4b56cdd20	Mr	Abhinav Kumar	Choudhary	2003-01-18	Male	OBC	Indian	Hindu	SW-020-0365, Laliyahi	854102	Bihar	Katihar	India	8414804484	8544643332			\N	0000001223/A/2020	CE/20/13	\N	\N
200f18a1-4f27-402c-a673-d198fba751b2	Mr	Priyadarshan	kumar	2002-01-07	Male	OBC	INDIAN	HINDUISM	TARAR, DAUDNAGAR, AURANGABAD BIHAR	824143	Bihar	DAUDNAGAR	INDIA	7870774511	9472354535		\N	\N	0000001234/A/2020	CE/20/24	\N	\N
8fdcfa48-5d88-4063-9b3a-095961b5d72d	Mr	Neeraj 	Kumar	2001-12-12	Male	OBC	Indian	Hindu	Lakhanpur-tal Desari,vaishali	844504	Bihar	Hajipur 	India	69094 19803	\N			\N	0000001267/A/2000	CSE/20/19	\N	\N
e58e02cb-e655-4965-bbef-6e8888a2438a	Mr	DEV SINGH 	KANYAL 	2002-07-12	Male	General	Indian	Hindu	106/A Sindhi Colony, Luniyapura	453441	Madhya Pradesh	Mhow	India	+919407454771	\N	dev.btech.cse.20@nitap.ac.in	\N	\N	0000001269/A/2020	CSE/20/21	\N	\N
cc619f64-f641-432c-bad7-75b6042e1c5b	Mr	Jatavath 	Shankar	2001-08-04	Male	ST	INDIAN	HINDU	22-14 Chandrayan pally thanda ,Amangal (M) ,Ranga Reddy(Dist)	509321	Telangana	Hyderabad	India	7997923580	9440877025	jatavathshiva2001@gmail.com	https://www.linkedin.com/in/jatavathshiva117	\N	0000001294/A/2020	ECE/20/13	\N	\N
50f7ccec-7111-4dba-af10-6c40c2fa5c35	Mr	Sonu	Paswan	2000-06-28	Male	SC	India	Hindu	29,Bajrang wel soc, Hans Vijay nagar, Kargil Road, Nallasopara east	401209	Maharashtra 	Mumbai	India	7715945711	\N		linkedin.com/in/sonu-paswan	\N	0000001256/A/2020	CSE/20/08	\N	\N
2552266c-0217-4587-b4e9-f329430b4886	Mr	RAHUL	KUMAR	2000-09-16	Male	OBC	Indian	Hindu	VILL:- JAYNAGAR , PS:-SONBARSA , POST OFFICE:-BANDARJHULA	843302	Bihar	Sitamarhi	India	+918581892529	\N	\N	\N	\N	0000001227/A/2020	EE/20/34	\N	\N
4519971e-c235-47d8-94ee-ac5970e7fbbc	Mr	Aditya 	Kumar	2003-08-08	Male	General	India 	Hindu	Sbs colony gaya , bihar 	823001	Bihar 	Gaya 	India 	8797301904	8603527391			\N	0000001243/A/2020	Ce/20/33	\N	\N
579ca13f-afc3-4096-9a60-4447045a805d	Mr	Chandrashekhar 	Kumar	2001-04-27	Male	OBC	Indian	Hindu	AT+POST-BALUAHA, DISCT-SAHARSA, PS-MAHISHI	852216	BIHAR	SAHARSA	India	07597488704	6202331232	shekhar90600@gmail.com		\N	0000001346/A/2021	EE/20/31	\N	\N
fe15687a-c509-4358-aaa9-dd4a2bfc89ed	Mr	Pritam	Das	2000-08-25	Male	OBC	Indian 	Hindu	DN Govt College, itanagar	791113	Arunachal Pradesh 	Itanagar 	India	6033951631	\N	ashirathore27@gmail.com	\N	\N	0000001271/A/2020	CSE/20/23	\N	\N
980becfb-6eda-402a-adfa-9f36af4bd7de	Mr	Mahesh	Manthri	2003-01-02	Male	General	Indian	Hindu	9-43, Lalpuram, Guntur, Andhra Pradesh	522017	Andhra Pradesh	Guntur	India	7396759914	8500187941	\N		\N	0000001367/A/2021	ME/20/20	\N	\N
01e34890-985d-45b1-a80d-ac3926afb74d	Mr	Praneeth 	Challa	2002-05-21	Male	General	Indian	Hindu	Vijayawada, Payakapuram, Prashanthi Nagar,3rd line.	520015	Andhra Pradesh	Vijayawada	India	+919441966691	\N	\N	\N	\N	0000001365/A/2021 	ME/20/18	\N	\N
952e3643-5a42-49d9-9320-a1daa3fe03e2	Mr	M	Manjunath	2001-11-25	Male	SC	Indian	Hindu	H NO: 44-34 , Roja Street , Prakash Nagar , Kurnool	518004	Andhra Pradesh 	Kurnool 	India	7285905686	8374499194	mandalamanjunath557@gmail.com	\N	\N	0000001296/A/2020	ECE/20/15	\N	\N
875e5149-931e-4961-b295-30484348a2b5	Mrs	Yania	Mara	2001-08-23	Female	ST	Indian	Christianity 	Polo colony , Upper subansiri	791122	Arunachal Pradesh 	Daporijo	India	6033973193	7629929568	pesticidesdouble21@gmail.com	\N	\N	0000001288/A/2020	ECE/20/07	\N	\N
0f53af60-a986-47c8-92bf-28947e50c79a	Ms	tejaswini	gore	2002-03-04	Female	SC	INDIAN	HINDU	lashkarwadi, jalgoan , dapoli	415712	Maharashtra	Dapoli	india	8177993147	9404334482	\N	\N	\N	0000001360/A/2021	ME/20/13	\N	\N
7577a281-d299-4784-906e-c7a0f2fad587	Ms	Shivani 	Agrawal 	2000-07-25	Female	General	Indian 	Hindu 	Jaiswal Compound Club Road Beside Axis Bank Mithanpura Muzaffarpur 	842001	Bihar	Muzaffarpur	India	07544004984	\N	\N		\N	0000001335/A/2021	CSE/20/36	\N	\N
9d7c7fbb-92ce-44f1-a018-15378dbc3370	Mr	Kumar	Abhinav	2001-11-02	Male	General	Indian	Hindu	Flat no 207 Gyan Apartment Kankarbagh Patna Bihar 800020	800019	Bihar	Patna	India	7849893972	\N	\N	\N	\N	0000001372/A/2021	ME/20/25	\N	\N
2e833904-c774-4f55-ae9e-8c553b3a331e	Mr	Naveen 	Jakhar	2004-03-12	Male	OBC	Indian	Hindu	3RJD SANSARDESAR , BIKANER , RAJASTHAN	334023	Rajasthan	Bikaner	India	+919772118282	\N	Naveenjakhar1203@gmail.com	\N	\N	0000001246/A/2020	CE/20/36	\N	\N
c5743050-8d2d-4ba3-a57a-5255a013686b	Mr	Kundan 	Meena	2001-07-05	Male	ST	Indian	Hindu	Peepalda, khandar, sawai madhopur 	322025	Rajasthan 	Sawai Madhopur 	India	6261645913	\N	kundanmeena966@gmail.com		\N	0000001331/A/2021	EE/20/15	\N	\N
53bacd86-068a-482b-b87e-59ce48eb018d	Mr	MUKESH 	KUMAR	2002-04-21	Male	SC	INDIAN	HINDU	 WARD NO. 03, LALEWALA (59 LNP), RIDMALSAR, SRIGANGANAGAR, RAJASTHAN	335057	RAJASTHAN	SRI GANGANAGAR	INDIA	9460096955	9116780018	mukeshbror10@gmail.com			0000001244/A/2020	CE/20/34	\N	\N
e89c5141-8e28-46a0-9c20-0454f4433fd8	Ms	Archana 	Chawala	2003-03-13	Female	SC	Indian	Hindu	Vill.mandoli dist. Sikar Rajasthan	332403	Rajasthan	Sikar	India	7665041354			\N	\N	0000001258/2020	CSE/20/10	\N	\N
6a4bc22e-19d9-4e85-a5e5-7858d0923d3d	Mr	PRAVEEN	KUMAR	2001-04-25	Male	SC	INDIAN	HINDU	H. NO 3515 REGARO KI KOTHI GHAT GATE JAIPUR 	302003	RAJASTHAN	JAIPUR	INDIA	7737816009	9001171126			\N	0000001382/A/2021	EE/20/01	\N	\N
647418e1-776d-48ac-9bd5-3fb9bdaa759e	Mr	Harsh 	Pathak 	2002-10-25	Male	General	Indian	Hindu	121, Vrajbhumi park society, Nr. New r.t.o road, vastral, ahmedabad-382418	382418	Gujarat	Ahmedabad	India	9898116490	8780425368	singhsima2000@gmail.com	\N	\N	0000001276/A/2020	CSE/20/28 	\N	\N
e4a375e4-91f8-4e1c-bd63-d6afa6bb2ed7	Mr	Ashok Kumar 	Meena	2002-03-05	Male	ST	Indian 	Hindu	Village:- shyamota, post:- Mainpura, district:- Sawai Madhopur 	322027	Rajasthan 	Sawai Madhopur 	India	6375568107	8306170798	meenaashokshyamota@gmail.com	\N	\N	0000001363/A/2021	ME/20/16	\N	\N
e2a68729-3fdc-47aa-b812-9ad2de0f9441	Mr	Louich	Taid	2001-03-10	Male	ST	Indian	Hindu	Near raja hotel, gogamukh	787034	Assam	Gogamukh	India	9402470726	\N	\N	\N	\N	0000001263/A/2020	Cse/20/15	\N	\N
7e7e61a5-3661-4de6-8051-de6ef376f156	Mr	Ankit 	Raj	2002-03-20	Male	EWS	Indian	Hindu 	Vill.:- Raj kharsa, P.O.:- koil bhupat, P.S:- Mehendiya, Dist.:- Arwal	804428	Bihar	Arwal 	India	6287083304	\N	\N	\N	\N	0000001362/A/2021	ME/20/15	\N	avatar/7e7e61a5-3661-4de6-8051-de6ef376f156.jpg
ed665ee1-7d11-4b6e-b1a0-a86c4ad0d6d8	Mr	sange	maney	2002-06-09	Male	ST	indian	buddhist	Dechengthang village,mechukha shi yomi district Arunachal pradesh	791002	Arunachal Pradesh	Itanagar	India	09863727373	6033974355	sangetempamaney@gmail.com	Sange Tempa Maney	\N	0000001325/A/2021	EE/20/09	\N	avatar/ed665ee1-7d11-4b6e-b1a0-a86c4ad0d6d8.jpg
038be5c6-1f7f-4264-92b2-a047e6daef7b	Mr	Ravi	Raushan	2002-02-10	Male	OBC	Indian	Hinduism	Kohra,Tehta,Makhdumpur,Jehanabad	804427	Bihar	Jehanabad	India	9693879241	\N	\N	www.linkedin.com/in/ravi-raushan-9258a1188	\N	0000001308/A/2020	ECE/20/27	\N	avatar/038be5c6-1f7f-4264-92b2-a047e6daef7b.jpg
471d354d-2f31-4f76-83b9-cf448fa0c181	Mr	Vaibhav	Mishra	2002-03-22	Male	General	Indian	Hinduism	P 9, Type 3, KLP, Hindan Airforce Station, Ghaziabad, Uttar Pradesh	201004	Uttar Pradesh	Ghaziabad	India	9470630290	8860184453		www.linkedin.com/in/vaibhav-mishra-a1a737231	\N	0000001315/A/2020	ECE/20/34	\N	avatar/471d354d-2f31-4f76-83b9-cf448fa0c181.jpg
5c3b783a-c9be-41b8-969f-2a581769de04	Mr	SHIVA	KUMAR	2003-06-12	Male	ST	INDIAN	HINDU	BODA BANDA THANDA , 6-9	509102	TELANGANA	KOLLAPUR	India	6033955771	9121907322	shivakumardeshavath60@gmail.com	\N		0000001313/A/2020	ECE/20/32	\N	avatar/5c3b783a-c9be-41b8-969f-2a581769de04.jpg
f912e1d0-bbbc-40f7-97ac-e3f5fb311ea5	Ms	Priya	Sinha	2002-02-12	Female	General	Indian	Hindu	FLAT NO. 404, BANDANA ENCLAVE ,BHOOTHNATH ROAD,NEAR ST. JOSEPH'S HIGH SCHOOL	800026	Bihar	Patna	India	9508867077	\N	priya.official.imp@gmail.com	https://www.linkedin.com/in/priya-sinha-398259230	https://github.com/priya7sinha12	0000001335/A/2020	CSE/20/35	\N	avatar/f912e1d0-bbbc-40f7-97ac-e3f5fb311ea5.jpg
cdec78ed-442e-47ae-834d-3927c23f87d8	Mr	Bala 	Jee	2003-08-17	Male	EWS	Indian 	Hindu	Vill+post:- Shahar Telpa, p.s:-Karpi,Dist:-Arwal	804419	Bihar	Arwal	India	7808671081	9123233995	balajee6570@gmail.com	\N	\N	0000001286/A/2020	ECE/20/05	\N	avatar/cdec78ed-442e-47ae-834d-3927c23f87d8.jpg
6ced3636-553f-4988-96d5-8e9f6f5861b9	Mr	EMANI	VAMSI	2002-04-19	Male	OBC	INDIAN	HINDU	7-11, OPP Rice Mill, Vengalayapalem, Ankireddipalem	522005	Andhra Pradesh	Guntur	India	7794925115	8985689154	vamsiemani123@gmail.com	https://www.linkedin.com/in/emani-vamsi-538209145/	\N	0000001306/A/2020	ECE/20/25	\N	avatar/6ced3636-553f-4988-96d5-8e9f6f5861b9.jpg
1d4acb90-9587-4b9b-b1fc-e7e5f8472b68	Ms	Tasso	Moryang	2001-06-03	Female	ST	Indian	Christian	Hari Village, Ziro, Lower Subansiri District	791120	Arunachal Pradesh	Ziro	India	8014923239	6033954707	tassomoryang768@gmail.com	\N	\N	0000001319/A/2021	EE/20/03	\N	avatar/1d4acb90-9587-4b9b-b1fc-e7e5f8472b68.jpg
53586e31-5205-4257-9806-a58b96c22787	Mr	saurav	kumar yadav	2001-05-06	Male	OBC	Indian	Hindu	Vill-Garua Maksoodpur , PO-Garua Maksoodpur 	232329	Uttar Pradesh	Ghazipur	India	6033940659	8787834480	saurav80998@gmail.com	\N	\N	001330/A/2021	EE/20/14	\N	avatar/53586e31-5205-4257-9806-a58b96c22787.jpg
5f95f86f-40c3-4b2e-af12-90461409b76b	Mr	Tarh 	Radhe	2002-04-14	Male	ST	Indian	Donyi polo	G-EXTENSION NAHARLAGUN Near Phed water pump	791110	Arunachal Pradesh 	NAHARLAGUN	India	9863201296	\N	\N	\N	\N	1291/A/2020	ECE/20/10	\N	avatar/5f95f86f-40c3-4b2e-af12-90461409b76b.jpg
a0ec86c7-e6de-434a-ad35-4be4368be6e4	Mr	Nich 	Talo	2002-06-25	Male	ST	Indian	Christian 	Naharlagun 	791110	Arunachal Pradesh 	Naharlagun 	India	9366067295	\N		\N	\N	0000001322/A/2021	EE/20/06	\N	avatar/a0ec86c7-e6de-434a-ad35-4be4368be6e4.jpg
ebc1677c-190e-44e8-bac3-306d9d406950	Mr	Harsh	Rathor	2003-12-19	Male	General	Indian 	Hindu	SHRI RAM COLONY KOTLA ROAD FZD	283203	UTTER PRADESH	FIROZABAD	India 	08474939388	9105797692		\N	\N	0000001289/A/2020	ECE/20/08	\N	avatar/ebc1677c-190e-44e8-bac3-306d9d406950.jpg
397c2040-43a7-4b8a-8f48-6ea632263edc	Mr	Ayush	Kumar Mehta	2002-05-13	Male	OBC	Indian	Hindu	Naya Tola Raghopur, Ward No.-04, P.S.-Raghopur, P.O.-Jia Ram Raghopur, Dist.-Supaul, State-Bihar, PIN-852111	852111	Bihar	Supaul	India	09470847332	\N	\N		\N	0000001384/A/2021	EE/20/23	\N	avatar/397c2040-43a7-4b8a-8f48-6ea632263edc.jpg
4c6c25aa-15e8-4535-a858-a9b16a979b11	Ms	SAUMYA	RAJ	2002-04-30	Female	General	INDIAN	HINDU	BEGUSARAI BIHAR	851101	BIHAR	BEGUSARAI	INDIA	9031153794			https://www.linkedin.com/in/saumya-raj-81a340173		0000001336/A/2021	EE/20/20	\N	avatar/4c6c25aa-15e8-4535-a858-a9b16a979b11.jpg
05eff4c5-7ce0-4351-aa19-576c16813353	Mr	Devesh	Rehan	2002-11-16	Male	General	Indian	Hindu	FCA 79/1 B-Block Bhatia Colony, Ballabgarh,	121004	Haryana	Faridabad	India	8376977946	\N	\N	\N	\N	0000001379/A/2021	ME/20/32	\N	avatar/05eff4c5-7ce0-4351-aa19-576c16813353.jpg
330615fc-a3e5-46b2-b1d4-3c3b3032d1a7	Mr	Akash	Singh	2001-12-09	Male	OBC	Indian	Hindu	SS Residency, Bolav, Olpad, Surat	394110	Gujarat	Bolav	India	9521877470	\N		www.linkedin.com/in/akash-singh-a8a5a122b	\N	0000001237/A/2020	EE/20/36	\N	avatar/330615fc-a3e5-46b2-b1d4-3c3b3032d1a7.jpg
34ec64da-31bd-467d-b01b-25579737805e	Mr	Licha	Tubi	2002-02-28	Male	ST	Indian 	Christian 	Pachin colony, Naharlagun 	791110	Arunachal pradesh 	Naharlagun 	India	9366664966	\N	2bleecha@gmail.com	\N	\N	0000001324/A/2021	EE/20/08	\N	avatar/34ec64da-31bd-467d-b01b-25579737805e.jpg
e532ec17-d075-4c19-97e3-7ef00221dec2	Ms	Aaradhya	Sharma	2002-04-01	Female	General	Indian	Hindu	7 Chha 27 Jawahar Nagar jaipur 	302004	Rajasthan 	Jaipur	India	7597209550	\N	\N	\N	\N	0000001376/A/2021	ME/20/29	\N	avatar/e532ec17-d075-4c19-97e3-7ef00221dec2.jpg
3a333cf4-3876-4a0a-a599-b8065b127033	Mr	Deep 	Chader	2002-05-07	Male	ST	Indian 	Hindu 	GUMSINGTAYING,VILLAGE TAKSING UPPER SUBANSHRI ARUNACHAL PRADESH	791122	Arunachal Pradesh	Daporijo	India	09402648388	9436864681	chaderdeep95@gmail.com	\N	\N	0000001351/A/2021	Me/20/04	\N	avatar/3a333cf4-3876-4a0a-a599-b8065b127033.jpg
7633a608-50a6-48db-93fc-3ac9b37267a6	Mr	RONALDO	JERANG	2003-12-07	Male	ST	Indian	Christian 	sille-oyan, oyan village	791102	Arunachal Pradesh	pasighat	India	6033969699	7005648782	ronaldojerang8@gmail.com		\N	0000001253/A/2020	CSE/20/05	\N	avatar/7633a608-50a6-48db-93fc-3ac9b37267a6.jpg
b06f757a-1ef9-4487-bbbf-f489794e4d7e	Mr	LIKHA 	TASSAM	2001-03-04	Male	ST	INDIAN	CHRISTIAN	qtr-no 46 mowb-II itanagar	791111	ARUNACHAL PRADESH	ITANAGAR	INDIA	6033936115	\N	\N	\N	\N	0000001252/A/2020	CSE/20/04	\N	avatar/b06f757a-1ef9-4487-bbbf-f489794e4d7e.jpg
c45cd835-f58b-42bc-86ed-21acc3e47ca3	Mrs	Usha	Pertin	2002-11-21	Female	ST	Indian	Christianity 	Vivek Vihar, itanagar 	791113	Arunachal Pradesh 	Itanagar 	India	93665 36824 	\N	pesticidesdouble21@gmail.com	\N	\N	0000001312/A/2020	ECE/20/31	\N	avatar/c45cd835-f58b-42bc-86ed-21acc3e47ca3.jpg
bd3b6c24-e9b8-40e3-a595-a6f0297a1e74	Mr	KIRAN KUMAR	KAPA	2002-07-10	Male	SC	INDIAN	HINDU	Andhra pradesh	533201	Andhra Pradesh	Amalapuram	India	9485249962	8341753789	kirankumarkapa1@gmail.com	\N	\N	0000001314/A/2020	ECE/20/33	\N	avatar/bd3b6c24-e9b8-40e3-a595-a6f0297a1e74.jpg
79554e97-b1e2-4bfd-855f-4b65aa74144f	Mr	Bamin Tilling	Riku	2002-02-22	Male	ST	Indian	Christianity	Near Khadi and Board Industry Board, Chandranagar	791113	Arunachal Pradesh	Itanagar	India	6033856693	\N	\N	www.linkedin.com/in/bamin-tilling-riku-636366242	https://github.com/Bamin60338	0000001255/A/2020	CSE/20/07	\N	avatar/79554e97-b1e2-4bfd-855f-4b65aa74144f.jpg
a72fcb88-c9f8-4f2e-89a8-27bef713c6bd	Mr	Pranshu Anjay	Agarwal	2001-07-02	Male	General	Indian	Hindu	E1561, Lower Miao	792121	Arunachal Pradesh	Miao	India	9436429537		pranshu2001agarwal@gmail.com	www.linkedin.com/in/pranshu-agarwal-6a0b92213	\N	0000001349/A/2021	ME/20/02	\N	avatar/a72fcb88-c9f8-4f2e-89a8-27bef713c6bd.jpg
81440d27-e7a8-469c-8448-f6f2183b7752	Mr	Shimon	Shiromani	2002-09-25	Male	ST	Indian	Hindu	Global Sapphire Apartment	834003	Jharkhand	Ranchi	India	8678875054	\N	\N	\N	\N	0000001272/A/2020	CSE/20/24	\N	avatar/81440d27-e7a8-469c-8448-f6f2183b7752.jpg
e1c121fc-36b0-43eb-bbff-110fb0b51426	Mr	Baburam	Yadav	2003-07-03	Male	OBC	Indian	Hindu	Village- Dharnipur Bishayan, Gambhirpur, Azamgarh	276302	Uttar Pradesh	Azamgarh	India	7376356928		by902005@gmail.com	\N	\N	0000001275/A/2020	CSE/20/27	\N	avatar/e1c121fc-36b0-43eb-bbff-110fb0b51426.jpg
fc3a71da-d0e9-424a-a4cc-5c317fa0cc6e	Mr	SAURABH	ROY	2001-07-07	Male	OBC	INDIAN	HINDU	VILLAGE- KEOTNA, VIA- GHOGHARDIHA	847402	Bihar	Madhubani	India	07488654339	9060764366	srv40227@gmail.com	\N	\N	0000001238/A/2020	EE/20/35	\N	avatar/fc3a71da-d0e9-424a-a4cc-5c317fa0cc6e.jpg
db62dcdc-dee7-47b0-96ea-6279cc39815b	Mr	Vishal	Kumar	2002-08-10	Male	OBC	Indian	Hindu	Vill- PAWAI, PS - KORHA	854104	Bihar	Katihar	India	9508767544	9473312274	ervishalkr02@gmail.com	linkedin.com/in/vishal-kumar-644599205	\N	0000001343/A/2021	EE/20/27	\N	avatar/db62dcdc-dee7-47b0-96ea-6279cc39815b.jpg
5916bb17-d31d-4c2c-90c6-5b7db870bb26	Mr	Kade Bharath	Gowd	2000-10-04	Male	OBC	Indian	Hindu	15-50-3-5,BEHIND MPP ELEMENTARY SCHOOL, PATTIKONDA	518380	Andhra Pradesh	PATTIKONDA	India	9347464634	\N		\N	\N	0000001366/A/2021	ME/20/19	\N	avatar/5916bb17-d31d-4c2c-90c6-5b7db870bb26.jpg
53ca35ee-09d0-4cc2-b967-0e2cc5adcc7b	Mr	GAMJUM 	LAYE	2002-01-01	Male	ST	INDIAN	Christian 	RWD complex,Basar, Leparada ,Arunachal Pradesh 	791101	Arunachal Pradesh 	Basar	INDIA	8132927410	9436287975			\N	0000001350/A/2021	Me/20/03	\N	avatar/53ca35ee-09d0-4cc2-b967-0e2cc5adcc7b.jpg
c3e6cfa5-396e-47a2-8fa2-20747ab787e6	Mr	JUMMO	NGOMLE	2002-03-08	Male	ST	INDIAN	DONYI POLO	6 KILO	791111	ARUNACHAL PRADESH	ITANAGAR	INDIA	6033936148	\N		\N	\N	0000001361/A/2021	ME/20/14	\N	avatar/c3e6cfa5-396e-47a2-8fa2-20747ab787e6.jpg
221d5abf-b72b-435f-ab34-3b8a8781d37f	Mr	BOMGE	YINYO	2002-10-18	Male	ST	INDIAN	CHRISTIAN	RUYI VILLAGE NEAR DPGC COLLEGE KAMBA 	791000	ARUNACHAL PRADESH	KAMBA	INDIA	6909811907	9485282991	bomgeyinyokarka@gmail.com			0000001352/A/2021	ME/20/05	\N	avatar/221d5abf-b72b-435f-ab34-3b8a8781d37f.jpg
371d711e-f4e6-4d1e-bc24-50816ee510ea	Mr	Rahul	kumar	1999-07-03	Male	OBC	INDIAN	HINDU	Vill-Muraudpur,Post-Jhauwan,PS-Awatar Nagar,Dist-Saran,841216	841216	Bihar	Chhapra	India	8083004323	\N	\N	https://www.linkedin.com/in/rahul-kumar-0501a728a	\N	0000001317/A/2020	ECE/20/36	\N	avatar/371d711e-f4e6-4d1e-bc24-50816ee510ea.jpg
91789307-9880-4360-9c20-f3373a62bcf2	Mr	Rishav 	Kumar	2002-09-29	Male	OBC	Indian	Hindu	55 Rupam Villa, Near Divyani Tower ,Vasant Vihar Colony, Zeromile ,Bhagalpur	813210	Bihar	Bhagalpur	India	8529779859	9233402324	rishavkumarpoddar7@gmail.com	https://www.linkedin.com/in/rishav-kumar6397		0000001368/A/2021	ME/20/21	\N	avatar/91789307-9880-4360-9c20-f3373a62bcf2.jpg
501e08db-bbad-429f-9e42-a05fcbaea837	Mr	Akhil Kumar	Verma	2003-05-07	Male	OBC	Indian	Hindu	House No.321 Bargadwa Maharajganj, Uttar Pradesh	273303	Uttar Pradesh	Maharajganj	India	+91 7524875932	+91 9695591577	prakharverma731@gmail.com	http://linkedin.com/in/akhil-kumar-verma-155036217	\N	0000001375/A/2021	ME/20/28	\N	avatar/501e08db-bbad-429f-9e42-a05fcbaea837.jpg
524575a5-da66-4d21-bffe-c69247f80eaf	Mr	MADAP 	WAGE	2002-01-20	Male	ST	INDIAN	Christian	Papu nalah, Naharlagun,papum pare, Arunachal Pradesh	791109	Arunachal Pradesh	Naharlagun	India	9863089062	6033967147		\N	\N	0000001324/A/2021	EE/20/16	\N	avatar/524575a5-da66-4d21-bffe-c69247f80eaf.jpg
c7711e63-9298-4c5d-b734-b099ebc4a50b	Mr	Jatavath	Shankar	2001-08-04	Male	ST	INDIAN	HINDU	22-14 Chandrayan pally thanda ,Amangal (M) ,Ranga Reddy(Dist)	509321	Telangana	Hyderabad	India	07997923580	9440877025	jatavathshivashankar@gmail.com	https://www.linkedin.com/in/jatavathshiva117	\N	0000001294/A/2020	ECE/20/13	\N	avatar/c7711e63-9298-4c5d-b734-b099ebc4a50b.jpg
7c3fec8b-7791-4000-9f05-05df8f4b9526	Ms	MEKRUK 	WAII	2002-12-28	Female	ST	INDIAN	DONYI-POLO	8798050348	790102	ARUNACHAL PRADESH	NAHARLAGUN	INDIA	8798050348	6033916621	makchung2025@gmail.com	\N	\N	0000001355/A/2021	ME/20/08	\N	avatar/7c3fec8b-7791-4000-9f05-05df8f4b9526.jpg
3745b5e8-77a0-466d-8336-d340e64a2111	Mr	Pursottam 	Sah	2002-10-11	Male	OBC	INDIAN	Hindu	Jyoti Nagar Tinsukia Assam	786125	Assam	Tinsukia	India	6033938402	8259053265	pursottam.btech.cse.20@nitap.ac.in	https://linkedin.com/in/pursottamsah	https://github.com/Pursottam6003	0000001380/A/2020	CSE/20/37	\N	avatar/3745b5e8-77a0-466d-8336-d340e64a2111.jpg
ae9396a3-77ea-45dc-9f65-bb89b8ec10e5	Mr	Nishant	Raj	2002-12-02	Male	OBC	Indian 	Hindu 	Village - Shahpur.  Post - Uttarnawan. P.S. - Rahui . District - Nalanda	803119	Bihar	Biharsharif	India	+916206759911	9471010744	rajnishantkumar@outlook.com	\N	\N	0000001297/A/2020	ECE/20/16	\N	avatar/ae9396a3-77ea-45dc-9f65-bb89b8ec10e5.jpg
260f2d36-6354-4af0-b04e-9c0131cde2f7	Ms	Bindhu	Lankapalli 	2003-05-23	Female	SC	Indian	Hindu	Flat No: 46, Sai Srinivasa Gardens, Godowns Road, Kesarapalli	521102	Andhra Pradesh 	Vijayawada	India	8074216044	6033936681		\N	\N	0000001310/A/2021	ECE/20/29	\N	avatar/260f2d36-6354-4af0-b04e-9c0131cde2f7.jpg
65ff0434-a6d0-46e4-b1d1-15322bcc9f72	Mr	Chandrashekhar	Tripathi	2001-03-17	Male	General	Indian	Hinduism	HIG-29, Vistar Nagar	273007	Uttar Pradesh	Gorakhpur	India	8448052150			https://linkedin.com/in/tripathics	https://github.com/tripathics	0000001309/A/2021	CSE/20/38	\N	avatar/65ff0434-a6d0-46e4-b1d1-15322bcc9f72.jpeg?updated_at=1747678218221
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, password, role, created_at, updated_at) FROM stdin;
a4c761dd-b75a-475b-b555-d9696554cb30	chandrashekhar.btech.cse.20@nitap.ac.in	$2b$10$HANUVsoonQZF1ehbfsaVquzvYS9TTQvVZ2GYO50aSJlhizC4KBooW	{admin}	2024-05-08 19:34:51.062639	2025-05-19 23:28:29.920772
435dad5a-08dd-493e-b63a-f4ef7da9dafb	gauravdev131@gmail.com	$2b$10$WUHeSCwLBdvU4p0ZSVNFPe8Vu./CPeVJOW6yS9139MWdXPwruYXXC	{user}	2024-05-21 18:55:51.872603	2025-05-19 23:28:29.920772
d491e942-ecfb-4cb1-ab5a-3e4a797a58ab	nandrammeena6655@gmail.com	$2b$10$DbVGNERvH1BQ5DARTgzjset23.2IDsgKsmWqRVf27P3mELm9ixFgu	{user}	2024-05-12 10:50:47.469289	2025-05-19 23:28:29.920772
1e892bef-35b9-4903-8425-af80046c8ee6	aaryan3783@gmail.com	$2b$10$GoMBmOsScQ88kl0xh49S0O8QaowG4cwFwj5htITE7fhJvodk2XgEW	{user}	2024-05-12 17:37:02.090405	2025-05-19 23:28:29.920772
cbb6bce5-dfb3-4c3d-98cf-0c7c431868db	karankumarsahtkg2018@gmail.com	$2b$10$KUbNj4jqFPHK.6LGTNzsMOSi.jnOuh0FPESizahpZQHVJyUAMk0V6	{user}	2024-05-12 17:56:52.872076	2025-05-19 23:28:29.920772
3745b5e8-77a0-466d-8336-d340e64a2111	rahulsah6003@gmail.com	$2b$10$5FtqZOavbA4q4.YmcbZ6AuXcN4YUR51wwmu8l1xl6XY5p.IFfBYrC	{user}	2024-05-20 18:29:16.433587	2025-05-19 23:28:29.920772
ec74e358-3fb1-4d80-b169-b889f2e18e7c	namangupta037@gmail.com	$2b$10$4n1WO3c9Q3LGhDk9CksmTu2o3q7eL66q37ixKr7bSgP9yUO6AFKo2	{user}	2024-05-21 03:26:16.391065	2025-05-19 23:28:29.920772
038be5c6-1f7f-4264-92b2-a047e6daef7b	raviraushanjnb386@gmail.com	$2b$10$/6vAGwJw9jEcr/gdPTuMoeorRPc68zLmQP824wfdBotdK.ReJ0EZW	{user}	2024-05-21 05:24:21.757799	2025-05-19 23:28:29.920772
471d354d-2f31-4f76-83b9-cf448fa0c181	vaibhavmishra1501@gmail.com	$2b$10$ALl0rOJgXgSMLkasVnjTf.f45zpPt6eOSoFm/wIO03xc12D0cV3SC	{user}	2024-05-21 05:35:28.304307	2025-05-19 23:28:29.920772
163af0e1-8854-4854-bbea-7e60e32604db	vinaybeniwal777@gmail.com	$2b$10$t35dzfk/GcYOBrramA6wSu0hfJpahTnNKctCP9vKXrypS3YW3s9re	{user}	2024-05-21 07:06:32.757658	2025-05-19 23:28:29.920772
5c3b783a-c9be-41b8-969f-2a581769de04	deshavathshivakumar@gmail.com	$2b$10$0k8e/jn/7or.xKC/SZl2x.F21aMt0ZH7JBZZkx9cH6eb0o5MDC8iK	{user}	2024-05-21 08:08:56.346827	2025-05-19 23:28:29.920772
5344a300-740c-4bbd-b419-8875608c8503	achutapoorna2002@gmail.com	$2b$10$6CvxqUfxApt769GQWmE.POhd7hzKEcmgIlgKaUT1tq5bTD8wRJ7by	{user}	2024-05-21 08:22:25.597564	2025-05-19 23:28:29.920772
c7711e63-9298-4c5d-b734-b099ebc4a50b	jatavathshiva2001@gmail.com	$2b$10$0U9ZOFTUn/hHXPGE3vsfweeFBqj2iBHuBtZx7YSiIIf9/QvKVdi.G	{user}	2024-05-21 08:23:06.816416	2025-05-19 23:28:29.920772
5ff2ba04-dc59-42a2-b8a2-6a94cfb535a8	sandeepsanjipogu2002@gmail.com	$2b$10$3g/FLWBwYEUM27/qCCnV7OPfaVpmECTzezvf2D7gCUvKuSsxtp/p6	{user}	2024-05-21 09:49:52.228876	2025-05-19 23:28:29.920772
21af335f-f670-4cf6-bf69-e027de42b417	tsaijosh123@gmail.com	$2b$10$Vj7PlmzEh9YQb1Mx/dv55OgOTYJ3iNwZ2tn/ddOfwiUO1tSrt25/q	{user}	2024-05-21 10:19:38.360445	2025-05-19 23:28:29.920772
f912e1d0-bbbc-40f7-97ac-e3f5fb311ea5	priyassinha71202@gmail.com	$2b$10$VYmxPlQGApqlaEVBxbpWA.YBHKBpYZksfnSlNFuG9ioKEsoYR.VLm	{user}	2024-05-21 10:23:26.69062	2025-05-19 23:28:29.920772
5f95f86f-40c3-4b2e-af12-90461409b76b	tarhradhe600@gmail.com	$2b$10$tOvDdhop.SqgGr5uKWiNuOVqBmv3zhIC6RqXiZ.AFaonKnoB/9yim	{user}	2024-05-21 10:25:47.364096	2025-05-19 23:28:29.920772
a0ec86c7-e6de-434a-ad35-4be4368be6e4	nichtalo123@gmail.com	$2b$10$H/7y4DLdNW0vMMQ15W6dEehmu2aKszW3SW29pfwZ0asfDGzb5BaQu	{user}	2024-05-21 10:29:23.030783	2025-05-19 23:28:29.920772
f17989eb-85b8-420d-aec6-c18fd169bd62	bhupendraup14@gmail.com	$2b$10$bGrptZ5s5AW0I95onSy/ZeeuxR6okIv1z.v811wDY76sNFNmitpqi	{user}	2024-05-21 11:29:36.715786	2025-05-19 23:28:29.920772
7e7e61a5-3661-4de6-8051-de6ef376f156	ankit49303@gmail.com	$2b$10$TmEH4sV1n4gQcJQl7ryNzOm.bMIQW48ha.HwW9sPQP17KOoUuHWsS	{user}	2024-05-21 11:30:07.779942	2025-05-19 23:28:29.920772
cdec78ed-442e-47ae-834d-3927c23f87d8	balajee536@gmail.com	$2b$10$nPBfFvdhKKCqfihUYc9oa.5YMOKRKv5wAEOq9/G8zOV5ptPpATWYy	{user}	2024-05-21 11:31:19.702377	2025-05-19 23:28:29.920772
ed665ee1-7d11-4b6e-b1a0-a86c4ad0d6d8	sangetempamaney18@gmail.com	$2b$10$ZZhoHUC3eNa88Yhv9Tc.DuVEsIF.5lMR/KAcc2BVhyCGo4d6NQ.6K	{user}	2024-05-21 11:37:07.394244	2025-05-19 23:28:29.920772
4e19018c-3aed-4544-b36b-f5206067c714	debajitdoley999@gmail.com	$2b$10$rTlIEMq8GW1hKAwhaucEJ.0rLjkAVFyv9Yl0/.1D/wwoKeYzPgLqS	{user}	2024-05-21 11:37:56.877482	2025-05-19 23:28:29.920772
c068c2f5-b1a6-41c4-87e7-1af25a047b84	laxmiprasadratna@gmail.com	$2b$10$5Ix0MvFt8tXXOeoXJPTbd.PM/F3khgd8ol5yVPwpoOh/0ZNYI9chy	{user}	2024-05-21 11:45:40.304233	2025-05-19 23:28:29.920772
6b8e198e-a3c2-4145-b3e5-5c45b487e0cc	mallesh69069@gmail.com	$2b$10$DR9X74jZZSUFSR4wWd17l.6/mo48fPvE44/T4h3/IuoTE264ejyyq	{user}	2024-05-21 12:47:50.267829	2025-05-19 23:28:29.920772
b0d3f92c-e370-4836-b97a-8914b23cf74c	dileepkanchupati33@gmail.com	$2b$10$4H7ZvY4yJpJzSLLo/JbRk.CcxVTmmGWuJhaXwlUUsvn6lM7rmezWO	{user}	2024-05-21 12:48:06.802502	2025-05-19 23:28:29.920772
1d4acb90-9587-4b9b-b1fc-e7e5f8472b68	tassomoryang@gmail.com	$2b$10$1mAhWWMhnLdtDh4Lh.NdE.WhPLvOIK.0KAmfUytLMVv1Kxr/Opl.G	{user}	2024-05-21 13:14:32.037332	2025-05-19 23:28:29.920772
6ced3636-553f-4988-96d5-8e9f6f5861b9	vamsiemani1@gmail.com	$2b$10$m0N.pOS5EPXADC5bOrT/k.2XkAIRn00ZqtqVqHm9Ha5vcn6gMaqNC	{user}	2024-05-21 13:20:24.088059	2025-05-19 23:28:29.920772
701d20ab-0b73-49c6-87fa-950b4916d1cf	poornaachuta1177@gmail.com	$2b$10$juYVdWoyn987PWwzFUUHhuUXaxyxtKru5GoMfJ8OLygFOZMEcyU/S	{user}	2024-05-21 13:36:12.240227	2025-05-19 23:28:29.920772
6b0fbd0b-9633-498f-8c37-d6fc060b6d1c	govindkumarjha31@gmail.com	$2b$10$de8TjFv7iAavnq2GCRAsZuka94TKIhl8hjIvEYTltW6r9DbxiNl9S	{user}	2024-05-21 14:04:50.170125	2025-05-19 23:28:29.920772
bda41421-b65d-4cb8-9a02-9b491e96220f	kumarmohit0203@gmail.com	$2b$10$eULfEDKQEj3DNR8nKLD9cesaCEvluhLRsDwH2Wx8FHlHH3DDcD1Re	{user}	2024-05-21 14:11:10.391647	2025-05-19 23:28:29.920772
cf95fd56-ceac-414f-99b4-8151fe18b359	avireya123@gmail.com	$2b$10$iIjYs5hNlMKBeOMrr/RbAe.qMI9PyweROUfei7K3BvRl4q2P0jSrS	{user}	2024-05-21 14:11:18.231081	2025-05-19 23:28:29.920772
c9cea689-538f-45cd-9d70-a26447e63fad	karthikchowdary291@gmail.com	$2b$10$H6YHimqoZkSCqlx6iEoh8u..EDj0HVqpUoelbEbxPVibfgQ0GyJq2	{user}	2024-05-21 14:42:04.380833	2025-05-19 23:28:29.920772
684cde69-6b1c-49ff-b9e9-5e2a544ae1bb	hanumize007@gmail.com	$2b$10$214PVRERCSMDRD0UvfRsrumZCN8NFG697ksyyS/6TdvZyd0zaZc9C	{user}	2024-05-21 15:02:37.290775	2025-05-19 23:28:29.920772
53586e31-5205-4257-9806-a58b96c22787	saurabhkumar80998@gmail.com	$2b$10$eMNCvCZ7hqueDdryrnhY0eT8BqfnSCdnvYUcfLp7cPj/uI9qR0Pp6	{user}	2024-05-21 15:44:28.028819	2025-05-19 23:28:29.920772
ebc1677c-190e-44e8-bac3-306d9d406950	harshrathor427@gmail.com	$2b$10$kYktkHy9vQ6a7bjDArUP.OAeBPPan70R6jFDctIDCQ5RyYclDmhNe	{user}	2024-05-21 17:27:57.439156	2025-05-19 23:28:29.920772
cc619f64-f641-432c-bad7-75b6042e1c5b	jatavathshivashankar@gmail.com	$2b$10$e9Q2G.Y9Q3uEHFK2K9dSte8NS7Cgx38xVCLzmwM0Mo/.2E41b2oLC	{user}	2024-05-21 17:47:31.386539	2025-05-19 23:28:29.920772
e023620f-d685-4f8a-b921-c7625c5cd615	rajkumar02061@gmail.com	$2b$10$j7nkUTtKPy1sO3Vy1p22buBd051iy7SPww5R2P4cWA4tT1t6Rn.Me	{user}	2024-05-21 18:56:51.702884	2025-05-19 23:28:29.920772
05eff4c5-7ce0-4351-aa19-576c16813353	rehan.devesh16@gmail.com	$2b$10$2dVLO63cXlu6.R6m9TqDrOcwPsxOl1q7Augbio3FX.oIZIFSc76la	{user}	2024-05-21 19:56:07.080775	2025-05-19 23:28:29.920772
e7ea86e4-8410-46b6-a8ec-6008c8fd4f4b	contact.marry.lusi@gmail.com	$2b$10$WxJJ12tBw24JXrRL4gg3r.uk8.ip0o.Mse1QpHl31ugonNP5jGaaq	{user}	2024-05-22 01:56:18.052016	2025-05-19 23:28:29.920772
330615fc-a3e5-46b2-b1d4-3c3b3032d1a7	akashsingh.ars1@gmail.com	$2b$10$UpWxsp9oSOHfb8CkrfRVQ.LZE8CJpglbRCy7oz7lBQU9Z7aTix31y	{user}	2024-05-22 04:07:34.387762	2025-05-19 23:28:29.920772
46134da6-1ae5-4d1b-98d4-e5275aa12e67	ch.harikrishna3429@gmail.com	$2b$10$lpaOyd1ut9rIRLuVdwAuKOeRbhVL8xbsKVoEptgq8MfsmSXH2yKDa	{user}	2024-05-22 04:08:19.568151	2025-05-19 23:28:29.920772
aaad8207-90ae-4d08-b793-ee82852380e6	riteshshandilya9262@gmail.com	$2b$10$xc5WkEb16sDOZqDwCbPinObNOttlWJMR1f3o0AyoAyhxFq3OgeNcS	{user}	2024-05-22 05:46:28.240705	2025-05-19 23:28:29.920772
ee72263e-3160-48e4-bcef-6a896cd1e0e8	krdeepakkdkm@gmail.com	$2b$10$x9SBpbExMWJdq.6T79EDHuyzv0dq6WknwDfPdKNScnpiSwm6nRn4C	{user}	2024-05-22 05:52:21.61242	2025-05-19 23:28:29.920772
397c2040-43a7-4b8a-8f48-6ea632263edc	ayushkumarmehta2002@gmail.com	$2b$10$TnjyXtbqbuOdX8NkAZ5TE.rfWUR8/2/T7hZBm8X8cuRULtI90.rF6	{user}	2024-05-22 06:51:26.880964	2025-05-19 23:28:29.920772
6011ddc1-7dac-44f8-b47e-be392c0d4c25	wangdiranidolma@gmail.com	$2b$10$tJuxHLRnGAUqIWTjJg2sI.1LsKbw0/vG5vbBGvB7B1inJ9gV3kvNm	{user}	2024-05-22 07:43:00.800325	2025-05-19 23:28:29.920772
069df11f-3e77-401d-8d75-d6042568f82e	vijaydui111@gmail.com	$2b$10$i9pYFrFepkyXV/xfTJFro.46I.YX20SSh7r4xQgridkpV/WZ6mmRi	{user}	2024-05-22 07:45:42.926958	2025-05-19 23:28:29.920772
bc117c08-fc12-40f6-acfc-2719a051fa5b	novinbaruah@gmail.com	$2b$10$WbvkQ62fyMlLCkrWHdMfluN5oThOBGpKlDDc92ra378jCpr0Tuh6.	{user}	2024-05-22 07:58:53.774	2025-05-19 23:28:29.920772
0e2d7f9d-a1d4-4649-ac7f-eb9eb8263a51	ranitaki10@gmail.com	$2b$10$jMeDKHow6nq1cs3CVLnT9uOL0q4tYk9EtBAoFCJwrrW1GR5qIvMA.	{user}	2024-05-22 08:04:29.592464	2025-05-19 23:28:29.920772
34ec64da-31bd-467d-b01b-25579737805e	cutedesert5@gmail.com	$2b$10$8gUBhin12uDpki1kAtmleOKRRbCT37hiINEwNBvwnjUi13Hh9RHVO	{user}	2024-05-22 08:04:36.050133	2025-05-19 23:28:29.920772
a6a5a8c7-e5f9-4e88-8c7b-8a3bfdd5cb9a	biswadeepsingh28@gmail.com	$2b$10$CYBRfYzy4KzJJihsL8t6ue/FWJw5vrNr96dZOctLykU2sGLWWjlsW	{user}	2024-05-22 08:13:05.561269	2025-05-19 23:28:29.920772
5826165c-34dc-41f3-b92d-f1ebca7c6d6c	tadaryaku5@gmail.com	$2b$10$oAmaJjrWMvizlEoS2yc4JOeDc4G0FPp1WC6MtiT4gQjfIf0w1WuAS	{user}	2024-05-22 08:45:21.545214	2025-05-19 23:28:29.920772
e532ec17-d075-4c19-97e3-7ef00221dec2	aaradhya.s0001@gmail.com	$2b$10$xnGa9hTMegjOegx4uIb7yemXo8y93FzWnN5vTGAquD.CYFDSiSoiK	{user}	2024-05-22 09:09:15.205883	2025-05-19 23:28:29.920772
4c6c25aa-15e8-4535-a858-a9b16a979b11	saumyaraj9534@gmail.com	$2b$10$raAxUbOOysafa64Pe1fs9e/AbIwK1o2EpijnoVT8TpRshzes6D7J6	{user}	2024-05-22 09:12:33.056338	2025-05-19 23:28:29.920772
73a89400-2702-464f-9c49-31d07c94e0c5	deybiman9391@gmail.com	$2b$10$oCaVignF36A0cPhhIrnHSutuOoBt9Pwe3KBIy4ke.9mQ/.bbtN3uK	{user}	2024-05-22 09:22:56.253121	2025-05-19 23:28:29.920772
3a333cf4-3876-4a0a-a599-b8065b127033	Chaderdeep95@gmail.com	$2b$10$djEg/lNiuie1MNT5fK9P8esmqr61rIe/IwD4AKSb7AAnZsMgkA41W	{user}	2024-05-22 09:32:06.059344	2025-05-19 23:28:29.920772
cfa52b66-aa64-4453-b716-be3685ac959e	shivasaiv5@gmail.com	$2b$10$Du023VFdVnCrt8F6VVDLV.s7aai0D7q/vYZrhsx1Tejj5AXqgxG7y	{user}	2024-05-22 10:21:27.528348	2025-05-19 23:28:29.920772
d391ddca-46a1-4080-831a-647966a5d205	riteshshandilya62031@gmail.com	$2b$10$WRKD09twaSmdOOHnaVci2uSLG02ucYynszq03.MMTK.w3YAo5QFL2	{user}	2024-05-22 10:28:54.40981	2025-05-19 23:28:29.920772
3fb2cdc6-e085-449e-a626-39741460067a	ac.meena63@gmail.com	$2b$10$PuQNNHoAMlQ0UCKgIzeDNeLR4bg8UZJxaQkzIwUVPOpO6zmnm5sGi	{user}	2024-05-22 10:32:48.523086	2025-05-19 23:28:29.920772
70a0286c-a108-46c4-a9ed-7f673358436d	vinaybeniwal90@gmail.com	$2b$10$NDHwWGGx18dZfB0FZUt4RuLxC9jvuosTGsIicvg30qme7G4ZqytHW	{user}	2024-05-22 10:51:30.486244	2025-05-19 23:28:29.920772
805c68af-8734-4c19-ae1c-baf67024d52b	ankitkushawah7562@gmail.com	$2b$10$8HQcxnGbxjpCjfFoSYzT2uilDZM9OupNqbtt83JyU1qP9.it2K8TS	{user}	2024-05-22 10:53:13.211048	2025-05-19 23:28:29.920772
7633a608-50a6-48db-93fc-3ac9b37267a6	jr7122002rj@gmail.com	$2b$10$8qG8T94x.26ar0y4xm7BH.JP0MGxCed38WZKBmeF5ZZ7Q7ExYeBb6	{user}	2024-05-22 10:53:24.802833	2025-05-19 23:28:29.920772
ed9581c0-e7ef-4407-ae46-70d86b988471	moranamit632@gmail.com	$2b$10$jTZbT8P2sPd.uj.VqI8IMuft8QX6.GeQ56GUJHN92VcemkbZSOWTO	{user}	2024-05-22 10:56:39.51213	2025-05-19 23:28:29.920772
b06f757a-1ef9-4487-bbbf-f489794e4d7e	likhatassam1@gmail.com	$2b$10$3VEPDfjsp8C/9sEwAHTswOpc8CrRw9um9HZTikM4usj7DbGTOe0I2	{user}	2024-05-22 13:01:15.273564	2025-05-19 23:28:29.920772
79554e97-b1e2-4bfd-855f-4b65aa74144f	btriku555@gmail.com	$2b$10$nTBBuVJIrqLIYTUoqULeuetPyt2jVL9KGZI.ZNYakTqoF39lHUNyi	{user}	2024-05-22 14:31:11.980968	2025-05-19 23:28:29.920772
ff52307e-8175-46a5-b7f1-fd218303af6c	piyushsingh9491@gmail.com	$2b$10$Y3cWOd4NhCK0UsMcPNFG3eO36LxL0wslv/fajiU93LtkvGdSJc7jy	{user}	2024-05-22 15:05:07.294048	2025-05-19 23:28:29.920772
a72fcb88-c9f8-4f2e-89a8-27bef713c6bd	pranshuanjay@gmail.com	$2b$10$Xc29zwhY0uT0.3tmLKYZx.tFBmFEOYR98DOIe5RN01yo78eOSlNbO	{user}	2024-05-22 18:11:47.629443	2025-05-19 23:28:29.920772
388cdf71-0a20-4ad7-9c37-d5c70eb1013b	saurabhsandy134@gmail.com	$2b$10$tCIfCQxIw2n17Kl7Q9re.OLlV.20G3n9WdBvVeRs4M/Wcq.Rs0DSm	{user}	2024-05-22 18:11:55.159009	2025-05-19 23:28:29.920772
40ff6408-62f4-445d-9a68-e5d849e9b4ec	prince841460ps@gmail.com	$2b$10$.isF7lRYFcReCsvmgBs1nexV.MMtNrwv.LNb./87iCDICTejXGgzy	{user}	2024-05-23 05:34:39.557519	2025-05-19 23:28:29.920772
feb82a39-ca9b-4cef-adcc-7b7c942d1153	abhishekbasantgupta@gmail.com	$2b$10$fxu1I5beQh4Wadacot1eFuwYppC9CJPJWftR2E4xqsC9fdy7qz.gm	{user}	2024-05-23 06:03:02.965651	2025-05-19 23:28:29.920772
d4a699d8-2805-44f4-8a3c-8ab4b56cdd20	choudharyabhi4387@gmail.com	$2b$10$DALNzPIsv0JwOmu0UZ5Ueegz/as1tdp5Z3ZO1JM5s3bfj5kETi1bS	{user}	2024-05-23 06:32:21.906203	2025-05-19 23:28:29.920772
200f18a1-4f27-402c-a673-d198fba751b2	priyadarshankumar926@gmail.com	$2b$10$E0yYBJIpZF0eWL/WNqu0quaEWTLV1BI6YZ1SoehCAjVdgXkaQAFTC	{user}	2024-05-23 06:44:23.932546	2025-05-19 23:28:29.920772
2552266c-0217-4587-b4e9-f329430b4886	rahulkumarstm1609@gmail.com	$2b$10$lTCOSfWiwcyhMC2EZ7wjWer1ejZTZ8zMgMwLeLUElD12oxCy9OYUe	{user}	2024-05-23 07:22:11.047929	2025-05-19 23:28:29.920772
8fdcfa48-5d88-4063-9b3a-095961b5d72d	9436264521n@gmail.com	$2b$10$KfoXcf0acCjnxAtC37uJI.JHL3afj/T5smWqHSZK0xaEqRE.x1osW	{user}	2024-05-23 07:46:26.142941	2025-05-19 23:28:29.920772
81440d27-e7a8-469c-8448-f6f2183b7752	shimonshiromaniss@gmail.com	$2b$10$xhuEmOX8uTvysAzVkJ5O9umCyAJbAb65uvZTynfUUGHkPdsi5S7wK	{user}	2024-05-23 10:34:33.391004	2025-05-19 23:28:29.920772
e1c121fc-36b0-43eb-bbff-110fb0b51426	baburamyadav2690@gmail.com	$2b$10$N5jSk/8hdTPy0GtdbZUyYOJk02O.WD16t1etE6y5G7Eo5u189.QCS	{user}	2024-05-23 13:44:24.572449	2025-05-19 23:28:29.920772
e58e02cb-e655-4965-bbef-6e8888a2438a	devkanyal07@gmail.com	$2b$10$DLX3o3jOtRCI1WE5BGQ3DuFMK/1wWuDTPM0elVvQCfWyTYRJXKkWS	{user}	2024-05-23 14:09:23.816024	2025-05-19 23:28:29.920772
50f7ccec-7111-4dba-af10-6c40c2fa5c35	paswansonu578@gmail.com	$2b$10$.kzGvypfQXnvan8COPtgWOuc6U4guhH2VBfL0FXZsHIisiBO/.4DK	{user}	2024-05-23 14:12:40.237111	2025-05-19 23:28:29.920772
4519971e-c235-47d8-94ee-ac5970e7fbbc	adityakumarhems01@gmail.com	$2b$10$cGg/3CtE12Ctz2DN.dhkde.ostNWtHFYFtlnkbaAr14NKnRnZpjPy	{user}	2024-05-23 15:28:13.39454	2025-05-19 23:28:29.920772
fc3a71da-d0e9-424a-a4cc-5c317fa0cc6e	saurabhroy40227@gmail.com	$2b$10$UgG0uE.hCmbx92BPk.JqjO53X2G5YGHih7i8SPE9TxLyq3lAOm3VC	{user}	2024-05-23 15:59:06.510966	2025-05-19 23:28:29.920772
579ca13f-afc3-4096-9a60-4447045a805d	ck020237@gmail.com	$2b$10$SeT2rscoWqdgoIOShz0mL.iLPnlhDMoSDYx8tOTbw9VlHVB16ohxW	{user}	2024-05-23 16:00:57.405149	2025-05-19 23:28:29.920772
db62dcdc-dee7-47b0-96ea-6279cc39815b	ervishalsah2302@gmail.com	$2b$10$W8zzwkUt6yYPxLAOQ3k.3OPzyzxjlcBOa81IAInjhGfK0pw1vyo7q	{user}	2024-05-23 16:04:31.35937	2025-05-19 23:28:29.920772
fe15687a-c509-4358-aaa9-dd4a2bfc89ed	dasjipu@gmail.com	$2b$10$qpp4hoWPDk8G4I1YoEPgLumZ9IJ2JT14MoiNJ5jOvnWWLO0Q1dPPq	{user}	2024-05-23 17:37:19.217611	2025-05-19 23:28:29.920772
7f0eb6b7-c75f-4b4e-b7ff-3fbc2179aed5	prokashpegu19@gmail.com	$2b$10$eQAoXL4wCrV6DG41BAe34ey0Ymsfc4FZ0ytwcR2/wxKx0MQVdu2QO	{user}	2024-05-23 21:11:22.949618	2025-05-19 23:28:29.920772
5916bb17-d31d-4c2c-90c6-5b7db870bb26	kadebharath@gmail.com	$2b$10$pJUzepiotEeHVzaKzrWlEuli3urH8WUVpH833B0Je3Kkp0G3P2Y7S	{user}	2024-05-24 02:48:43.824402	2025-05-19 23:28:29.920772
980becfb-6eda-402a-adfa-9f36af4bd7de	mantrimahesh999@gmail.com	$2b$10$zb.IsmlklQQaqgFyidj8AugGfvkLltrrM/ObgEnNjsS4h5zeUGiAe	{user}	2024-05-24 05:33:23.402663	2025-05-19 23:28:29.920772
01e34890-985d-45b1-a80d-ac3926afb74d	ch36praneeth@gmail.com	$2b$10$9wRXoea1qYdUwy590xX62.f9aXJpSRMgFBFlpQGxTc23.k17kC6Yy	{user}	2024-05-24 05:41:15.225342	2025-05-19 23:28:29.920772
952e3643-5a42-49d9-9320-a1daa3fe03e2	Nathmanju557@gmail.com	$2b$10$dKceiL.zHDjCBO1u3I0LFOogyTiS5NVu.GbPFCZli.IZqmKf122VW	{user}	2024-05-24 05:50:47.391842	2025-05-19 23:28:29.920772
53ca35ee-09d0-4cc2-b967-0e2cc5adcc7b	gamjumlaye@gmail.com	$2b$10$l5FxE8M/WaQwXfjIFsbMee/LjfSDrwd4oJZ8K5jfh44U8YFMD8m0y	{user}	2024-05-24 05:58:03.243421	2025-05-19 23:28:29.920772
221d5abf-b72b-435f-ab34-3b8a8781d37f	bomgeyinyo12@gmail.com	$2b$10$NFfIXn1e3ZXuWH9CEDUFi.y6ZmJcqDg7tep2AOt9WMplxNgV3q9Dy	{user}	2024-05-24 06:27:56.825448	2025-05-19 23:28:29.920772
c3e6cfa5-396e-47a2-8fa2-20747ab787e6	ngomlejummo@gmail.com	$2b$10$ptFIS8HrF8if0qXl0OCIVuseCjlMYKBDfvcuLH7mE0o/FciKR5zRi	{user}	2024-05-24 06:34:31.710665	2025-05-19 23:28:29.920772
c45cd835-f58b-42bc-86ed-21acc3e47ca3	pertinusha43@gmail.com	$2b$10$V45mMr0A.n9TAiR3fpagQeLufxEqefKuD56ZrUYNb.DKLpWCLhYzC	{user}	2024-05-24 06:38:47.127824	2025-05-19 23:28:29.920772
875e5149-931e-4961-b295-30484348a2b5	irenmaraww.com@gmail.com	$2b$10$PH1sQEuThfWC1fKm/IvYN.E9U.PWfOOxhUfwF4IEuNUXWassOf/D2	{user}	2024-05-24 06:54:11.163658	2025-05-19 23:28:29.920772
bd3b6c24-e9b8-40e3-a595-a6f0297a1e74	kapakirankumar5@gmail.com	$2b$10$syVcU1fnEvCvJy7z3uIzuOUW1MYQSHhZov.3T1TMuP/UV311Rqfqi	{user}	2024-05-24 06:58:26.180031	2025-05-19 23:28:29.920772
0f53af60-a986-47c8-92bf-28947e50c79a	tejaswiniii612@gmail.com	$2b$10$QWutB6rtSYSpfhsQy4O8beFxL4W08Tmb7NjGQ2Y2YBVhyGAB9wwYO	{user}	2024-05-24 07:06:26.702071	2025-05-19 23:28:29.920772
371d711e-f4e6-4d1e-bc24-50816ee510ea	rahulkumarrohan485@gmail.com	$2b$10$xxBhDD47f4nrUuXEBBMqL.4FHdXW.AEOP81k7fVNiEPW3v8/59UCq	{user}	2024-05-24 07:13:07.212952	2025-05-19 23:28:29.920772
501e08db-bbad-429f-9e42-a05fcbaea837	akhilatgkp@gmail.com	$2b$10$79ulZGOGKXbVOfX4Eh.EFOqOhmiyY3jsF5ETqRuvSUVHUWHTweo6G	{user}	2024-05-24 07:17:33.141263	2025-05-19 23:28:29.920772
91789307-9880-4360-9c20-f3373a62bcf2	rishavpoddar6397@gmail.com	$2b$10$5si9xSEI5OYjSPif1uOgkeuBiuFLK3TlMvazY4N/yGg9imNw3ulDG	{user}	2024-05-24 08:55:07.54299	2025-05-19 23:28:29.920772
27bff842-0d80-410e-ab15-1daa13bacbe2	Kumarabhinav0211@gmail.com	$2b$10$UV4lpu.jKuEEhudlwDcLYegDWpJhdYag.PiOpQTf0NyQIEFWX/60y	{user}	2024-05-24 09:19:37.576856	2025-05-19 23:28:29.920772
524575a5-da66-4d21-bffe-c69247f80eaf	wahgemadap@gmail.com	$2b$10$Su/yLShGyhUwqnoJh07H2evsywte2HN4KZPNwEBU53ffj/aGhAAYO	{user}	2024-05-24 09:20:36.502492	2025-05-19 23:28:29.920772
7577a281-d299-4784-906e-c7a0f2fad587	16agrawalshivani@gmail.com	$2b$10$nwN3dboVnA6XxxGKQCGAXOaWVzOYMnHWYUX9smZQ1C20J2RKGm4RC	{user}	2024-05-24 10:08:41.094557	2025-05-19 23:28:29.920772
9d7c7fbb-92ce-44f1-a018-15378dbc3370	kumarabhinav0298@gmail.com	$2b$10$vtRYktTXgqQ9P9trc2nNweS7Z.FmLgvQYHkpJ2fSeIhvedkx9S222	{user}	2024-05-24 10:58:44.389761	2025-05-19 23:28:29.920772
c5743050-8d2d-4ba3-a57a-5255a013686b	kundanmeena572001@gmail.com	$2b$10$xgIQ9djNFsd6Cn96MYPTVu2R8WarY5L.8JDuPtlDP3KooFLdXZm.6	{user}	2024-05-24 11:08:31.605543	2025-05-19 23:28:29.920772
2e833904-c774-4f55-ae9e-8c553b3a331e	naveenjakhar2004@gmail.com	$2b$10$/ykfawbrQpblsAiI7/nXuOP3uta1DAUtpkBgIZ8io0CRpwfs7XvHi	{user}	2024-05-24 11:08:35.969848	2025-05-19 23:28:29.920772
53bacd86-068a-482b-b87e-59ce48eb018d	brormukesh2002@gmail.com	$2b$10$CeaynhYPvIRJHIK/MDS5supOJ9LKP19QQVOQaQTVKMjmJhz7Y5RZi	{user}	2024-05-24 11:19:41.099911	2025-05-19 23:28:29.920772
e89c5141-8e28-46a0-9c20-0454f4433fd8	archanachawala59@gmail.com	$2b$10$o19eyDHEnk12rcpMuQd1GuJDhQzfr1CEDA9lUWb45WzIwaNxaQyfq	{user}	2024-05-24 11:30:19.991534	2025-05-19 23:28:29.920772
6a4bc22e-19d9-4e85-a5e5-7858d0923d3d	praveenk6117@gmail.com	$2b$10$9PxYitpIx6XMANgm6D0OYO5HPKZJbMRPP.LmWfvpxDghUGaCzsgxu	{user}	2024-05-24 11:38:59.355229	2025-05-19 23:28:29.920772
647418e1-776d-48ac-9bd5-3fb9bdaa759e	singhsima2000@gmail.com	$2b$10$BybZ8QmFG3Wb06bsdW.eKeCcJo4V2OxszpL7skUwLNHVScaDY4OS6	{user}	2024-05-24 15:31:45.3984	2025-05-19 23:28:29.920772
e4a375e4-91f8-4e1c-bd63-d6afa6bb2ed7	sonumeena09799@gmail.com	$2b$10$gH6QkVgswnAGfy2KnL86bOrQPzz9.FCczIYEOKheBF4T2u/lg4GcG	{user}	2024-05-24 18:12:13.938226	2025-05-19 23:28:29.920772
5457a1b0-5764-4d50-bdbc-11f5f17ff693	shivamce2011@gmail.com	$2b$10$VoZtmQm/ksAmzOLLnO8ed.XebRIx1HNU9MWz9UICahC2HJQGhiyqa	{user}	2024-05-24 18:14:11.934539	2025-05-19 23:28:29.920772
7bfaa0cf-3fff-4b5f-97c6-75617af248c8	udaykiranrathod2003@gmail.com	$2b$10$5mbY2Ui7v5HFcWGj8ylrAObH6mb7JZ0WjbPpFbyrRdYftlINO2jVW	{user}	2024-05-24 18:35:31.534881	2025-05-19 23:28:29.920772
7c3fec8b-7791-4000-9f05-05df8f4b9526	waiimekruk@gmail.com	$2b$10$5v4AtbaivBrrtHktPUKlM.K2Sghf5OChM0hEaTwqsJdEsjotABc/2	{user}	2024-05-25 04:17:42.923792	2025-05-19 23:28:29.920772
ae9396a3-77ea-45dc-9f65-bb89b8ec10e5	rajnishantkumar428@gmail.com	$2b$10$wFX5uDIeklD5JJnDTigdpukOoej/4/nO2dnW1f3ydhaFdz/2aPPPC	{user}	2024-05-23 06:42:54.019703	2025-05-19 23:28:29.920772
260f2d36-6354-4af0-b04e-9c0131cde2f7	lankapallibindhu@gmail.com	$2b$10$kjjK91LcGks8/MPhp4fD0e.pIHPAr.rm3M/.sD5ml7w6FKfomCIRO	{user}	2024-05-26 06:47:46.721681	2025-05-19 23:28:29.920772
bd2d6492-af0a-4ee4-af3c-b150481c4e24	chandueduru@gmail.com	$2b$10$rEhWDyZTqTb/ccnRAKoNXuZmNmvH.KFhKUrCIJALSeEBljNOlt4p6	{user}	2024-05-26 07:30:18.704819	2025-05-19 23:28:29.920772
e2a68729-3fdc-47aa-b812-9ad2de0f9441	louichtaid64@gmail.com	$2b$10$z3euF6qvbESLuH8zE9AIcef.0otnFPDGxI/oZK/Hq/IxrOuvdRk3q	{user}	2024-05-26 08:36:02.664173	2025-05-19 23:28:29.920772
65ff0434-a6d0-46e4-b1d1-15322bcc9f72	tripathics17@gmail.com	$2b$10$Sq4O2jt6yn18DTq7ABwZBu7J9mVAFaG4EXjZS5bDVrUAwdMtG.Uzy	{user,admin}	2024-05-22 14:27:14.067399	2025-05-19 23:33:35.657308
\.


--
-- Data for Name: web_messages; Type: TABLE DATA; Schema: public; Owner: shyam
--

COPY public.web_messages (message_from, full_name, email, phone, message, designation, department, avatar) FROM stdin;
director	Prof. Mohan V Aware	director@nitap.ac.in	0360-2284801/2001581/2001583	Dear NITians of Arunachal Pradesh,\n\nWelcome to your Alma Mater!\n\nA landmark of academic excellence bludgeoned with extracurricular activities and enriched research environment in Arunachal Pradesh.\n\nSince its inception, NIT Arunachal Pradesh has proved to be one of the best institutions in North East India for imparting knowledge through best practices in academia and established high-end research environment on cutting edge topics. It is in this endeavour for resplendence, series of events are organized to promote sustained quality education to ensure that our students are globally competent.\n\nWe have introduced new curriculums for the new batches to keep them up-to-date with the ever-changing industrial trends, learned delegates have joined hands with us to nurture our graduates, the startup-cell has been restructured and is no longer the same underdog, the rainwater harvesting system has managed to add sustainability to the already picturesque campus at NITAP Yupia and the cherry on the top would be the medicinal garden at Jote campus whose construction is well underway.\n\nAs mentioned above, the institution has undergone revolutionary changes but the revamp which takes the cake would be the coalescence of our very own Alumni Association. History has witnessed the power of alumni across the globe and we, as an educational institution understand the significance of having a healthy relationship with you all.\n\nHence, it gives me immense pleasure to be in touch with you through the alumni association.\n\nFurther, I congratulate the entire team of NITAP Alumni Association for taking this momentous step for establishing a platform to communicate all the positive changes happening in the campus.\n\nWith a eupeptic heart, I wish my best to the NITAP Alumni Association.	\N	\N	director/director.png?updated_at=1747509508899
president	Dr. Dipak Sen	deepak@nitap.in	9485230593/9999778726	Dear Alumni,\n\nGreetings from NITAP Alumni Association!\n\nAs a President, it is indeed an honour for me to be a part of this remarkable initiative that seeks to establish a lasting relationship with our alumni.\n\nFor any educational institution, alumni serve as a beacon to their present budding scholars. The tremendous support rendered from the former can grant our institution notable influence in our society and nation. Seemingly, it becomes our responsibility to maintain a healthy relationship with you all.\n\nTo achieve such an ambition, we need your proactive support and active involvement. This certainly calls for greater responsibility from my end and I don't intend to abstain from it.\n\nJoin us, as the NITAP Alumni Association team endeavours for Excellence and Glory.\n\nYour cooperation is required to catalyze ideas for the purposeful growth of NITAP Alumni Association.	Associate Professor	Department of Mechanical Engineering	director/director.jpeg?updated_at=1747511317310
\.


--
-- Name: hero_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: shyam
--

SELECT pg_catalog.setval('public.hero_section_id_seq', 2, true);


--
-- Name: educations educations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.educations
    ADD CONSTRAINT educations_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: experiences experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT experiences_pkey PRIMARY KEY (id);


--
-- Name: hero_section hero_section_pkey; Type: CONSTRAINT; Schema: public; Owner: shyam
--

ALTER TABLE ONLY public.hero_section
    ADD CONSTRAINT hero_section_pkey PRIMARY KEY (id);


--
-- Name: membership_applications membership_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membership_applications
    ADD CONSTRAINT membership_applications_pkey PRIMARY KEY (id);


--
-- Name: otp_email_attempts otp_email_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_email_attempts
    ADD CONSTRAINT otp_email_attempts_pkey PRIMARY KEY (email);


--
-- Name: otp_email otp_email_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.otp_email
    ADD CONSTRAINT otp_email_pkey PRIMARY KEY (email);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (user_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: web_messages web_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: shyam
--

ALTER TABLE ONLY public.web_messages
    ADD CONSTRAINT web_messages_pkey PRIMARY KEY (message_from);


--
-- Name: educations educations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.educations
    ADD CONSTRAINT educations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: experiences experiences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.experiences
    ADD CONSTRAINT experiences_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: membership_applications membership_applications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.membership_applications
    ADD CONSTRAINT membership_applications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(user_id) ON DELETE CASCADE;


--
-- Name: profiles profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

