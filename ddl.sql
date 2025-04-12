-- Таблица пользователей
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL
);

-- Таблица курсов
CREATE TABLE Courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    author_id INTEGER NOT NULL,
    FOREIGN KEY (author_id) REFERENCES Users(id)
);

-- Таблица истории изменений курсов (версионирование)
CREATE TABLE CourseHistory (
    id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    author_id INTEGER NOT NULL,
    valid_from TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valid_to TIMESTAMP,
    is_current BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (course_id) REFERENCES Courses(id),
    FOREIGN KEY (author_id) REFERENCES Users(id)
);

-- Таблица записей на курсы (связь многие-ко-многим между пользователями и курсами)
CREATE TABLE Enrollments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id),
    UNIQUE (user_id, course_id) -- предотвращает повторные записи одного пользователя на один курс
);

-- Таблица уроков
CREATE TABLE Lessons (
    id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

-- Таблица заданий
CREATE TABLE Assignments (
    id SERIAL PRIMARY KEY,
    lesson_id INTEGER NOT NULL,
    task_text TEXT NOT NULL,
    FOREIGN KEY (lesson_id) REFERENCES Lessons(id)
);

-- Таблица сдачи заданий
CREATE TABLE Submissions (
    id SERIAL PRIMARY KEY,
    assignment_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    answer TEXT NOT NULL,
    grade INTEGER,
    FOREIGN KEY (assignment_id) REFERENCES Assignments(id),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Таблица платежей
CREATE TABLE Payments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);
