Выполнил: Ромасенко Глеб
## Описание структуры базы данных
Данная база данных предназначена для системы онлайн-обучения, которая позволяет пользователям проходить курсы, взаимодействовать с учебными материалами и выполнять задания. Система охватывает полный цикл учебного процесса — от регистрации пользователей до сдачи домашних заданий и учёта оплаты.
### Таблицы базы данных
1. **Пользователи(Users)**  
    Хранит информацию о пользователях платформы:
    - `id` (PK) — уникальный идентификатор пользователя
    - `name` — имя пользователя
    - `email` — уникальный адрес электронной почты
    - `role` — роль пользователя (например, "студент", "преподаватель")

2. **Курсы(Courses)**    
    Содержит данные о курсах:
    - `id` (PK) — уникальный идентификатор курса
    - `title` — название курса
    - `description` — описание курса
    - `author_id` (FK) — идентификатор автора курса (связан с таблицей Users)

3. **Записи(Enrollments)**  
    Отображает записи на курсы (многие-ко-многим между пользователями и курсами):
    - `id` (PK) — уникальный идентификатор записи
    - `user_id` (FK) — пользователь, записавшийся на курс
    - `course_id` (FK) — курс, на который пользователь записан
    - `enrollment_date` — дата записи на курс
    - `UNIQUE` (user_id, course_id) — исключает дублирующие записи

4. **Курсы(Lessons)**  
    Уроки, входящие в курсы:
    - `id` (PK) — уникальный идентификатор урока
    - `course_id` (FK) — идентификатор курса, к которому относится урок
    - `title` — название урока
    - `content` — содержимое/текст урока

5. **Домашние задания(Assignments)**  
    Задания к урокам:
    - `id` (PK) — уникальный идентификатор задания
    - `lesson_id` (FK) — идентификатор урока, к которому относится задание
    - `task_text` — формулировка задания

6. **Решения(Submissions)**  
    Отправленные ответы студентов:
    - `id` (PK) — уникальный идентификатор отправки
    - `assignment_id` (FK) — задание, на которое отправлен ответ
    - `user_id` (FK) — студент, отправивший ответ
    - `answer` — текст ответа
    - `grade` — оценка за выполнение

7. **Оплаты(Payments)**  
    Информация об оплате курсов:
    - `id` (PK) — уникальный идентификатор платежа
    - `user_id` (FK) — пользователь, совершивший оплату
    - `course_id` (FK) — оплаченный курс
    - `amount` — сумма оплаты
    - `payment_date` — дата оплаты
##
# Концептуальная модель
##
![image](https://github.com/user-attachments/assets/66b2c187-b508-4d1c-a371-ebaa5898dc63)

- **Пользователи** записываются на один или несколько **Курсов** через таблицу **Записей**.
- **Пользователи** совершают **Оплаты** за **Курсы**.
- Каждый **Курс** состоит из нескольких **Уроков**.
- Каждый **Урок** содержит одно или несколько **Домашних заданий**.
- **Пользователи** отправляют **Решения** на **Домашние задания**.

## Логическая модель
![image](https://github.com/user-attachments/assets/e0de10e6-d60e-46a2-b8b8-c56637354614)


### Описание логической модели
Логическая модель включает основные сущности с их атрибутами и внешними ключами (FK), которые обеспечивают связь между таблицами. В таблицах реализованы связи между пользователями, курсами, уроками и оплатами. Каждая таблица содержит первичные ключи, а связи между таблицами реализуются через внешние ключи

### Нормальная форма
База данных приведена к Третьей нормальной форме (3NF):

1.1NF (Первая нормальная форма) – все поля атомарны, каждая ячейка содержит одно значение.

2.2NF (Вторая нормальная форма) – нет частичных зависимостей от составного ключа (в таблицах enrollments, submissions и т.п. есть составные ключи, и все неключевые поля зависят от всего ключа).

3.3NF (Третья нормальная форма) – отсутствуют транзитивные зависимости, все неключевые атрибуты зависят только от первичного ключа.

### Тип управления изменениями (SCD)
В данной базе данных реализовано версионирование типа 2 (Type 2 – SCD) — полное сохранение истории изменений(CourseHistory).

## Физическая модель
![image](https://github.com/user-attachments/assets/127c64d9-e9de-4242-b58f-5a9637a9c529)

### [ddl.sql](ddl.sql)
```postgresql
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

```
### [dml.sql](dml.sql)
```
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
```
