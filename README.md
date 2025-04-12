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
![image](https://github.com/user-attachments/assets/a7ffd53d-4ea6-4504-bfd3-344ae38c45cf)

### Описание логической модели
Логическая модель включает основные сущности с их атрибутами и внешними ключами (FK), которые обеспечивают связь между таблицами. В таблицах реализованы связи между пользователями, курсами, уроками и оплатами. Каждая таблица содержит первичные ключи, а связи между таблицами реализуются через внешние ключи

### Нормальная форма
База данных приведена к Третьей нормальной форме (3NF):

1.1NF (Первая нормальная форма) – все поля атомарны, каждая ячейка содержит одно значение.

2.2NF (Вторая нормальная форма) – нет частичных зависимостей от составного ключа (в таблицах enrollments, submissions и т.п. есть составные ключи, и все неключевые поля зависят от всего ключа).

3.3NF (Третья нормальная форма) – отсутствуют транзитивные зависимости, все неключевые атрибуты зависят только от первичного ключа.

### Тип управления изменениями (SCD)
Применён тип SCD Type 1 (перезапись):

1.При изменении данных записи перезаписываются без сохранения истории

2.Используется только поле payment_date или enrollment_date для регистрации момента создания

3.Простая структура и высокая производительность — приоритет на актуальные данные

## Физическая модель
![image](https://github.com/user-attachments/assets/04ae9a6c-b3ad-47e0-90ee-5c743cb41f16)

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
