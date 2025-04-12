-- Добавление пользователей
INSERT INTO Users (name, email, role) VALUES
('Иван Иванов', 'ivan@example.com', 'student'),
('Мария Петрова', 'maria@example.com', 'student'),
('Алексей Смирнов', 'alexey@example.com', 'teacher');

-- Добавление курсов
INSERT INTO Courses (title, description, author_id) VALUES
('Введение в программирование', 'Курс для начинающих', 3),
('Базы данных', 'Основы проектирования и SQL', 3);

-- Добавление записей о зачислении
INSERT INTO Enrollments (user_id, course_id) VALUES
(1, 1),
(2, 1),
(1, 2);

-- Добавление уроков
INSERT INTO Lessons (course_id, title, content) VALUES
(1, 'Переменные и типы данных', 'Контент урока по переменным'),
(1, 'Условные операторы', 'Контент урока по if'),
(2, 'Моделирование таблиц', 'Контент по нормализации');

-- Добавление домашних заданий
INSERT INTO Assignments (lesson_id, task_text) VALUES
(1, 'Напишите программу, которая выводит ваше имя'),
(2, 'Составьте условный блок для проверки возраста'),
(3, 'Нарисуйте ER-диаграмму простой БД');

-- Добавление решений студентов
INSERT INTO Submissions (assignment_id, user_id, answer, grade) VALUES
(1, 1, 'print("Иван")', 10),
(2, 1, 'if age >= 18:', 9),
(3, 1, 'ER-диаграмма — в приложении', 8),
(1, 2, 'print("Мария")', 10);

-- Добавление платежей
INSERT INTO Payments (user_id, course_id, amount) VALUES
(1, 1, 1999.00),
(2, 1, 1999.00),
(1, 2, 2499.00);

INSERT INTO CourseHistory (course_id, title, description, author_id)
VALUES (1, 'Основы SQL', 'Изучение базовых SQL-запросов', 3);
