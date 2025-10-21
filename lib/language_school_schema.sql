-- Supabase SQL Setup for Private Language School App
-- Tables for courses, teachers, news, events, students, and registrations

-- Enable UUID extension if not already enabled
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. teachers Table (created first because courses references it)
CREATE TABLE teachers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  bio TEXT,
  email TEXT UNIQUE NOT NULL,
  phone TEXT,
  languages TEXT[], -- Array of languages they teach
  profile_image_url TEXT,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 2. staff Table (for admin users)
CREATE TABLE staff (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  role TEXT NOT NULL, -- 'admin', 'secretary', 'teacher'
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. courses Table
CREATE TABLE courses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  level TEXT NOT NULL, -- e.g., "Beginner", "Intermediate", "Advanced"
  language TEXT NOT NULL, -- e.g., "English", "Spanish", "French"
  duration_weeks INTEGER NOT NULL,
  hours_per_week INTEGER NOT NULL,
  max_students INTEGER,
  price NUMERIC(10, 2) NOT NULL,
  discount NUMERIC(10, 2) DEFAULT 0.00, -- Added discount field
  discounted_price NUMERIC(10, 2) GENERATED ALWAYS AS (price - discount) STORED, -- Calculated field
  start_date DATE NOT NULL,
  end_date DATE NOT NULL,
  image_url TEXT,
  schedule JSONB, -- e.g., {"monday": "9:00-11:00", "wednesday": "9:00-11:00"}
  teacher_id UUID REFERENCES teachers(id),
  is_active BOOLEAN DEFAULT TRUE,
  discount_expiry DATE, -- Optional: date when discount ends
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. students Table (for registration) // jpns pas nkhdem bih
CREATE TABLE students (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  phone TEXT,
  address TEXT,
  date_of_birth DATE,
  preferred_language TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. registrations Table
CREATE TABLE registrations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  course_id UUID REFERENCES courses(id) NOT NULL,
  student_id UUID REFERENCES students(id) NOT NULL,
  registration_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  notes TEXT,
  UNIQUE(course_id, student_id)
);

-- 6. news Table
CREATE TABLE news (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  image_url TEXT,
  is_featured BOOLEAN DEFAULT FALSE,
  published_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  author_id UUID REFERENCES staff(id),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. events Table
CREATE TABLE events (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  event_date DATE NOT NULL,
  start_time TIME NOT NULL,
  end_time TIME,
  location TEXT NOT NULL,
  image_url TEXT,
  max_attendees INTEGER,
  is_free BOOLEAN DEFAULT TRUE,
  price NUMERIC(10, 2),
  registration_required BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. event_registrations Table
CREATE TABLE event_registrations (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  event_id UUID REFERENCES events(id) NOT NULL,
  student_id UUID REFERENCES students(id) NOT NULL,
  registration_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  attended BOOLEAN DEFAULT FALSE,
  UNIQUE(event_id, student_id)
);

-- Create indexes for better performance
CREATE INDEX idx_courses_language ON courses(language);
CREATE INDEX idx_courses_level ON courses(level);
CREATE INDEX idx_courses_active ON courses(is_active);
CREATE INDEX idx_news_featured ON news(is_featured);
CREATE INDEX idx_events_date ON events(event_date);
CREATE INDEX idx_registrations_course ON registrations(course_id);
CREATE INDEX idx_registrations_student ON registrations(student_id);
CREATE INDEX idx_event_registrations_event ON event_registrations(event_id);
CREATE INDEX idx_event_registrations_student ON event_registrations(student_id);

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger for the courses table
CREATE TRIGGER update_courses_updated_at
BEFORE UPDATE ON courses
FOR EACH ROW
EXECUTE FUNCTION update_updated_at();