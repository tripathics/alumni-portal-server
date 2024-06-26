CREATE TABLE IF NOT EXISTS users (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    email varchar(50) NOT NULL UNIQUE,
    password varchar(100) NOT NULL,
    role text[] NOT NULL CHECK(role <@ ARRAY['admin', 'coordinator', 'alumni', 'user']) DEFAULT ARRAY['user'],
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS profiles (
    user_id uuid REFERENCES users(id) ON DELETE CASCADE PRIMARY KEY,    
    title text NOT NULL CHECK(title = ANY(ARRAY['Mr','Mrs','Ms','Dr'])),
    first_name varchar(64) NOT NULL,
    last_name varchar(64),
    dob date NOT NULL,
    sex text NOT NULL CHECK(sex = ANY(ARRAY['Male', 'Female', 'Others'])),
    category text NOT NULL CHECK(category = ANY(ARRAY['General', 'OBC', 'SC', 'ST', 'EWS'])),
    nationality varchar(15) NOT NULL,
    religion varchar(16),
    address varchar(128) NOT NULL,
    pincode varchar(10) NOT NULL,
    state  varchar(64) NOT NULL,
    city varchar(64) NOT NULL,
    country  varchar(64) NOT NULL,

    phone varchar(15), 
    alt_phone varchar(15),
    alt_email varchar(255),
    linkedin varchar(50),
    github varchar(50),

    registration_no varchar(20) NOT NULL,
    roll_no varchar(16),

    sign  varchar(255) DEFAULT NULL,
    avatar varchar(255) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS educations (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES profiles(user_id) ON DELETE CASCADE NOT NULL,
    type text DEFAULT 'Full time' CHECK(type = ANY(ARRAY['Part time', 'Full time'])),
    institute varchar(255) NOT NULL,
    degree varchar(50) NOT NULL,
    discipline varchar(50) NOT NULL,    -- field of study
    start_date date NOT NULL,
    end_date date NOT NULL,       -- or expected
    description varchar(255) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS experiences (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES profiles(user_id) ON DELETE CASCADE NOT NULL,
    type text DEFAULT 'Job' CHECK(type = ANY(ARRAY['Job', 'Internship'])),
    organisation varchar(255) NOT NULL,
    designation varchar(255) NOT NULL,
    location varchar(255) NOT NULL,
    start_date date NOT NULL,
    end_date date DEFAULT NULL,
    ctc decimal(10,2),
    description varchar(255) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS membership_applications (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES profiles(user_id) ON DELETE CASCADE NOT NULL,
    membership_level text NOT NULL CHECK(membership_level = ANY(ARRAY['level1_networking', 'level2_volunteering'])),
    sign VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),

    status text DEFAULT 'pending' CHECK(status = ANY(ARRAY['pending', 'approved', 'rejected']))
);

CREATE TABLE IF NOT EXISTS otp_email (
    email varchar(50) PRIMARY KEY NOT NULL,
    otp varchar(6) NOT NULL,
    verified BOOLEAN,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS otp_email_attempts (
    email varchar(50) PRIMARY KEY NOT NULL,
    attempts INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS web_director_message (
    director_name varchar(100) NOT NULL,
    director_message text NOT NULL,
    director_email varchar(50) DEFAULT NULL,
    director_phone varchar(100) DEFAULT NULL,
    director_avatar varchar(255) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS web_president_message (  
    president_name varchar(100) NOT NULL,
    president_email varchar(50) DEFAULT NULL,
    president_phone varchar(100) DEFAULT NULL,
    president_designation varchar(100) DEFAULT NULL,
    president_message text NOT NULL,
    president_avatar varchar(255) DEFAULT NULL
);

CREATE TABLE IF NOT EXISTS contributors (
    user_id uuid REFERENCES users(id) ON DELETE CASCADE PRIMARY KEY,
    contribution varchar(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS events (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    title varchar(255) NOT NULL,
    description text NOT NULL,
    start_date date NOT NULL,
    end_date date DEFAULT NULL,
    location varchar(255) DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS posts (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid REFERENCES users(id) ON DELETE CASCADE NOT NULL,
    title varchar(255) NOT NULL,
    content text NOT NULL,
    pictures text[] DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS organisationDetails 
(
    organisation  varchar(100) 
);