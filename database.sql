-- created the database 
DROP DATABASE IF EXISTS alumnidatabase;
CREATE DATABASE alumnidatabase;

-- connect to the database 
\c alumnidatabase;

-- add createdAt and updatedAt columns in every table
CREATE TABLE users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email varchar(50) NOT NULL UNIQUE,
    password varchar(100) NOT NULL,
    role text[] NOT NULL CHECK(role <@ ARRAY['admin', 'user', 'alumni']) DEFAULT ARRAY['user']
);

CREATE TABLE profiles (
    user_id uuid REFERENCES users(id) PRIMARY KEY,    
    title text NOT NULL CHECK(title = ANY(ARRAY['mr', 'mrs', 'ms', 'dr'])),
    first_name varchar(64) NOT NULL,
    last_name varchar(64),
    dob date NOT NULL,
    sex text NOT NULL CHECK(sex = ANY(ARRAY['male', 'female', 'others'])),
    category text NOT NULL CHECK(category = ANY(ARRAY['general', 'obc', 'sc', 'st', 'others'])),
    nationality varchar(15) NOT NULL,
    religion varchar(16),
    address varchar(128) NOT NULL,
    pincode varchar(10) NOT NULL,
    state  varchar(64) NOT NULL,
    city varchar(64) NOT NULL,
    country  varchar(64) NOT NULL,

    phone varchar(15), 
    altPhone varchar(15),
    altEmail varchar(255),
    linkedin varchar(50),
    github varchar(50),

    registration_no varchar(20) NOT NULL,
    roll_no varchar(16),

    sign  varchar(255) DEFAULT NULL,
    avatar varchar(255) DEFAULT NULL
);

-- create table for storing academics details of users, having foreign key as userId from profile table
CREATE TABLE educations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES profiles(user_id) NOT NULL,
    type text DEFAULT 'full-time' CHECK(type = ANY(ARRAY['part-time', 'full-time'])),
    institute varchar(255) NOT NULL,
    degree varchar(50) NOT NULL,
    discipline varchar(50) NOT NULL,    -- field of study
    start_date date NOT NULL,
    end_date date NOT NULL,       -- or expected
    description varchar(255) NOT NULL
);

-- create table for storing experience (job and internship) details of users having foreign key as userId from profile table
CREATE TABLE experiences (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES profiles(user_id) NOT NULL,
    type text DEFAULT 'job' CHECK(type = ANY(ARRAY['job', 'internship'])),
    organisation varchar(255) NOT NULL,
    designation varchar(255) NOT NULL,
    location varchar(255) NOT NULL,
    start_date date NOT NULL,
    end_date date DEFAULT 'present',
    ctc decimal(10,2),
    description varchar(255) NOT NULL
);

CREATE TABLE membership_applications (
    user_id uuid REFERENCES profiles(user_id) PRIMARY KEY,
    membership_level text NOT NULL CHECK(membership_level = ANY(ARRAY['level1_networking', 'level2_volunteering'])),
    sign VARCHAR(255) NOT NULL,
    submit_date TIMESTAMP DEFAULT NOW(),

    status text DEFAULT 'pending' CHECK(status = ANY(ARRAY['pending', 'approved', 'rejected']))
);

CREATE TABLE otp_email (
    email varchar(50) PRIMARY KEY NOT NULL,
    otp varchar(6) NOT NULL,
    verified BOOLEAN,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE otp_email_attempts (
    email varchar(50) PRIMARY KEY NOT NULL,
    attempts INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE organisationDetails 
(
    organisation  varchar(100) 
);