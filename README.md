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
![image](https://github.com/user-attachments/assets/ac67ada7-01eb-421a-a27d-00085267dfed)


- Пользователи записываются на один или несколько Курсов через таблицу Записей.
→ связь многие-ко-многим между Пользователи и Курсы, реализована через Записи.

- Пользователи совершают Оплаты за Курсы.
→ один пользователь может оплатить несколько курсов; одна оплата относится к одному курсу и одному пользователю.

- Каждый Курс состоит из нескольких Уроков.
→ связь один-ко-многим: один курс → много уроков.

- Каждый Урок содержит одно или несколько Домашних заданий.
→ связь один-ко-многим: один урок → много домашних заданий.

- Пользователи отправляют Решения на Домашние задания.
→ каждый пользователь может отправить много решений; каждое решение относится к одному заданию.

## Логическая модель
![image](https://github.com/user-attachments/assets/e0de10e6-d60e-46a2-b8b8-c56637354614)


### Описание логической модели
Логическая модель включает основные сущности с их атрибутами и внешними ключами (FK), которые обеспечивают связь между таблицами. В таблицах реализованы связи между пользователями, курсами, уроками и оплатами. Каждая таблица содержит первичные ключи, а связи между таблицами реализуются через внешние ключи

### Нормальная форма
База данных приведена к Третьей нормальной форме (3NF):

1.1NF (Первая нормальная форма) – все поля атомарны, каждая ячейка содержит одно значение.

2.2NF (Вторая нормальная форма) – нет частичных зависимостей от составного ключа (в таблицах enrollments, submissions и т.п. есть составные ключи, и все неключевые поля зависят от всего ключа).

3.3NF (Третья нормальная форма) – отсутствуют транзитивные зависимости, все неключевые атрибуты зависят только от первичного ключа.

### Обоснование выбора нормальной формы
База данных была нормализована до третьей нормальной формы (3NF). Это позволяет:
Устранить избыточность данных;
Обеспечить логическую согласованность информации;
Избежать аномалий при обновлении, удалении и вставке данных.
Каждая таблица удовлетворяет требованиям:
Все атрибуты являются атомарными (1NF);
Все неключевые атрибуты полностью зависят от первичного ключа (2NF);
Отсутствуют транзитивные зависимости между неключевыми атрибутами (3NF).
Такой уровень нормализации является оптимальным балансом между читаемостью структуры, эффективностью хранения и производительностью при выполнении запросов в OLTP-сценариях.

### Тип управления изменениями (SCD)
В данной базе данных реализовано версионирование типа 2 (Type 2 – SCD) — полное сохранение истории изменений(CourseHistory).

### Обоснование выбора формы версионирования
Для отслеживания изменений в информации о курсах была выбрана форма версионирования SCD Type 2 (Slowly Changing Dimension Type 2). Эта стратегия позволяет сохранять историю изменений данных без потери предыдущих значений. Каждый раз при обновлении информации создаётся новая строка с тем же бизнес-ключом и новым идентификатором версии. Такой подход обеспечивает:
Аудит и возможность анализа данных в ретроспективе;
Гибкость при отображении информации пользователю на нужную дату;
Сохранение целостности связей между записями, в том числе в аналитике и отчётности.
Данный подход особенно актуален для онлайн-курсов, так как содержание курсов, их структура и описание могут со временем меняться, и важно сохранять каждую версию в истории.

## Физическая модель
![image](https://github.com/user-attachments/assets/127c64d9-e9de-4242-b58f-5a9637a9c529)

### [ddl.sql](ddl.sql)
```postgresql
-- Таблица пользователей
CREATE TABLE IF NOT EXISTS Users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(50) NOT NULL
);

-- Таблица курсов
CREATE TABLE IF NOT EXISTS Courses (
    id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    author_id INTEGER NOT NULL,
    FOREIGN KEY (author_id) REFERENCES Users(id)
);

-- Таблица истории изменений курсов (версионирование)
CREATE TABLE IF NOT EXISTS CourseHistory (
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
CREATE TABLE IF NOT EXISTS Enrollments (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    course_id INTEGER NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (course_id) REFERENCES Courses(id),
    UNIQUE (user_id, course_id)
);

-- Таблица уроков
CREATE TABLE IF NOT EXISTS Lessons (
    id SERIAL PRIMARY KEY,
    course_id INTEGER NOT NULL,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    FOREIGN KEY (course_id) REFERENCES Courses(id)
);

-- Таблица заданий
CREATE TABLE IF NOT EXISTS Assignments (
    id SERIAL PRIMARY KEY,
    lesson_id INTEGER NOT NULL,
    task_text TEXT NOT NULL,
    FOREIGN KEY (lesson_id) REFERENCES Lessons(id)
);

-- Таблица сдачи заданий
CREATE TABLE IF NOT EXISTS Submissions (
    id SERIAL PRIMARY KEY,
    assignment_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    answer TEXT NOT NULL,
    grade INTEGER,
    FOREIGN KEY (assignment_id) REFERENCES Assignments(id),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Таблица платежей
CREATE TABLE IF NOT EXISTS Payments (
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
```postgresql
-- Таблица Users
INSERT INTO Users (name, email, role) VALUES
('Иван Иванов', 'ivan@example.com', 'student'),
('Мария Петрова', 'maria@example.com', 'student'),
('Алексей Смирнов', 'alexey@example.com', 'teacher'),
('Ольга Сидорова', 'olga@example.com', 'student'),
('Николай Козлов', 'nikolay@example.com', 'student'),
('Светлана Орлова', 'sveta@example.com', 'student'),
('Виктор Павлов', 'viktor@example.com', 'teacher'),
('Дарья Лебедева', 'darya@example.com', 'student'),
('Артем Васильев', 'artem@example.com', 'student'),
('Елена Громова', 'elena@example.com', 'student'),
('Григорий Савельев', 'grisha@example.com', 'teacher'),
('Анна Белова', 'anna@example.com', 'student'),
('Константин Волков', 'konst@example.com', 'student'),
('Лидия Жукова', 'lida@example.com', 'student'),
('Михаил Егоров', 'mike@example.com', 'student');

-- Таблица Courses
INSERT INTO Courses (title, description, author_id) VALUES
('Введение в программирование', 'Курс для начинающих', 3),
('Базы данных', 'Основы проектирования и SQL', 3),
('HTML и CSS', 'Верстка сайтов', 7),
('Python: основы', 'Изучение синтаксиса', 3),
('Git и GitHub', 'Контроль версий', 7),
('JavaScript: базовый курс', 'Введение в JS', 11),
('SQL продвинутый', 'Агрегации, JOIN и подзапросы', 3),
('Алгоритмы', 'Базовые структуры данных', 11),
('ООП на Java', 'Принципы ООП', 3),
('React для начинающих', 'Создание SPA', 7),
('Linux для разработчиков', 'Базовые команды и скрипты', 11),
('Docker', 'Контейнеризация приложений', 3),
('PostgreSQL', 'Реляционные БД', 3),
('Data Science', 'Основы анализа данных', 7),
('Machine Learning', 'Машинное обучение для начинающих', 3);

-- Таблица Lessons
INSERT INTO Lessons (course_id, title, content) VALUES
(1, 'Переменные', 'Объявление и типы'),
(1, 'Условные операторы', 'if, elif, else'),
(1, 'Циклы', 'for, while'),
(2, 'ER-диаграммы', 'Концептуальное моделирование'),
(2, 'SQL SELECT', 'Базовые выборки'),
(2, 'JOIN', 'Объединение таблиц'),
(3, 'HTML-разметка', 'Основные теги'),
(3, 'CSS-селекторы', 'Работа со стилями'),
(4, 'Функции', 'Определение и вызов'),
(4, 'Списки', 'Методы и итерирование'),
(5, 'Git init', 'Создание репозитория'),
(5, 'push/pull', 'Работа с GitHub'),
(6, 'Переменные JS', 'let, const, var'),
(6, 'DOM', 'Работа с элементами'),
(7, 'Группировка', 'GROUP BY и агрегаты');

-- Таблица Assignments
INSERT INTO Assignments (lesson_id, task_text) VALUES
(1, 'Создайте переменную и выведите её'),
(2, 'Напишите программу с if'),
(3, 'Выведите числа от 1 до 10'),
(4, 'Нарисуйте ER-диаграмму магазина'),
(5, 'Напишите SELECT-запрос'),
(6, 'Используйте LEFT JOIN для 2 таблиц'),
(7, 'Создайте базовую HTML-страницу'),
(8, 'Сделайте сетку через CSS Grid'),
(9, 'Создайте функцию, возвращающую сумму'),
(10, 'Выведите все элементы списка'),
(11, 'Создайте git-репозиторий'),
(12, 'Отправьте код на GitHub'),
(13, 'Объявите переменные в JS'),
(14, 'Получите элемент по id'),
(15, 'Выведите среднюю цену товаров');

-- Таблица Enrollments
INSERT INTO Enrollments (user_id, course_id) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 4), (2, 5),
(4, 3), (4, 5), (4, 6),
(5, 1), (5, 2), (5, 6),
(6, 7), (6, 8), (6, 9),
(8, 1), (8, 2), (8, 3),
(9, 10), (9, 11), (9, 12),
(10, 2), (10, 3), (10, 7),
(12, 4), (12, 6), (12, 8),
(13, 9), (13, 10), (13, 11);

-- Таблица Submissions
INSERT INTO Submissions (assignment_id, user_id, answer, grade) VALUES
(1, 1, 'x = 5; print(x)', 10),
(2, 1, 'if x > 0: print(x)', 9),
(3, 1, 'for i in range(10): print(i)', 10),
(4, 1, 'ER-диаграмма в PDF', 8),
(5, 2, 'SELECT * FROM users;', 10),
(6, 2, 'LEFT JOIN orders ON...', 9),
(7, 4, '<html><body>Hello</body></html>', 10),
(8, 4, 'display: grid;', 9),
(9, 5, 'def sum(a,b): return a+b', 9),
(10, 5, 'for i in lst: print(i)', 10),
(11, 6, 'git init', 10),
(12, 6, 'git push origin main', 9),
(13, 2, 'let x = 5;', 9),
(14, 2, 'document.getElementById("el")', 9),
(15, 2, 'SELECT AVG(price)...', 10);

-- Таблица Payments
INSERT INTO Payments (user_id, course_id, amount) VALUES
(1, 1, 1999.00),
(1, 2, 2499.00),
(2, 1, 1999.00),
(2, 4, 2999.00),
(2, 5, 1899.00),
(4, 3, 1499.00),
(4, 6, 1799.00),
(5, 2, 1999.00),
(6, 7, 2899.00),
(8, 1, 1999.00),
(8, 3, 2199.00),
(9, 10, 2699.00),
(10, 7, 2299.00),
(12, 6, 1599.00),
(13, 11, 2399.00);

-- Таблица CourseHistory
INSERT INTO CourseHistory (course_id, title, description, author_id) VALUES
(1, 'Введение в программирование', 'v1: начальный вариант', 3),
(1, 'Введение в программирование', 'v2: добавлены примеры', 3),
(1, 'Введение в программирование', 'v3: исправлены ошибки', 3),
(2, 'Базы данных', 'v1: структура', 3),
(2, 'Базы данных', 'v2: примеры JOIN', 3),
(2, 'Базы данных', 'v3: добавлены задания', 3),
(3, 'HTML и CSS', 'v1: базовая структура', 7),
(3, 'HTML и CSS', 'v2: добавлен CSS Grid', 7),
(4, 'Python: основы', 'v1: синтаксис', 3),
(4, 'Python: основы', 'v2: списки и словари', 3),
(4, 'Python: основы', 'v3: работа с файлами', 3),
(5, 'Git и GitHub', 'v1: init и commit', 7),
(5, 'Git и GitHub', 'v2: ветвление', 7),
(5, 'Git и GitHub', 'v3: pull request', 7),
(6, 'JS: базовый', 'v1: синтаксис', 11),
(6, 'JS: базовый', 'v2: функции', 11),
(6, 'JS: базовый', 'v3: DOM', 11),
(7, 'SQL продвинутый', 'v1: GROUP BY', 3),
(7, 'SQL продвинутый', 'v2: HAVING', 3),
(7, 'SQL продвинутый', 'v3: оконные функции', 3),
(8, 'Алгоритмы', 'v1: списки', 11),
(8, 'Алгоритмы', 'v2: стек и очередь', 11),
(9, 'ООП', 'v1: классы', 3),
(9, 'ООП', 'v2: наследование', 3),
(10, 'React', 'v1: компоненты', 7),
(10, 'React', 'v2: хуки', 7),
(11, 'Linux', 'v1: команды', 11),
(11, 'Linux', 'v2: bash-скрипты', 11),
(12, 'Docker', 'v1: установка', 3),
(12, 'Docker', 'v2: Dockerfile', 3);
```

1.Список студентов, записанных на курсы, и количество этих курсов (JOIN + GROUP BY + HAVING + ORDER BY)

```sql
SELECT u.name, COUNT(e.course_id) AS course_count
FROM Users u
JOIN Enrollments e ON u.id = e.user_id
WHERE u.role = 'student'
GROUP BY u.name
HAVING COUNT(e.course_id) > 0
ORDER BY course_count DESC;
```
Показывает самых активных студентов по количеству курсов.

2.Преподаватели, у которых хотя бы один курс был оплачен(EXISTS + подзапрос)

```sql
SELECT DISTINCT u.id, u.name
FROM Users u
WHERE u.role = 'teacher'
AND EXISTS (
    SELECT 1
    FROM Courses c
    JOIN Payments p ON p.course_id = c.id
    WHERE c.author_id = u.id
);
```
Позволяет найти "продающих" преподавателей.

3.Курсы, у которых средний платёж превышает 2000(JOIN + GROUP BY + HAVING)
```sql
SELECT c.title, ROUND(AVG(p.amount), 2) AS avg_amount
FROM Courses c
JOIN Payments p ON c.id = p.course_id
GROUP BY c.title
HAVING AVG(p.amount) > 2000;
```
Анализирует дорогие и востребованные курсы.

4.Пользователи, не записанные ни на один курс(NOT EXISTS + подзапрос)
```sql
SELECT u.id, u.name
FROM Users u
WHERE u.role = 'student'
AND NOT EXISTS (
    SELECT 1 FROM Enrollments e WHERE e.user_id = u.id
);
```
Выводит "пассивных" студентов.

5.Уроки и количество заданий в них(LEFT JOIN + GROUP BY + ORDER BY)
```sql
SELECT l.title, COUNT(a.id) AS assignment_count
FROM Lessons l
LEFT JOIN Assignments a ON l.id = a.lesson_id
GROUP BY l.title
ORDER BY assignment_count DESC;
```
Оценка насыщенности уроков.

6.ТОП-3 студента по среднему баллу за все задания(JOIN + GROUP BY + ORDER BY + LIMIT)
```sql
SELECT u.name, ROUND(AVG(s.grade), 2) AS avg_grade
FROM Users u
JOIN Submissions s ON u.id = s.user_id
WHERE u.role = 'student'
GROUP BY u.name
ORDER BY avg_grade DESC
LIMIT 3;
```
Кто учится лучше всех.

7.Все задания, у которых оценка пользователя выше средней по всем работам(скалярный подзапрос + WHERE)
```sql
SELECT s.id, u.name, a.task_text, s.grade
FROM Submissions s
JOIN Users u ON s.user_id = u.id
JOIN Assignments a ON s.assignment_id = a.id
WHERE s.grade > (
    SELECT AVG(grade) FROM Submissions
);
```
Сильные работы, выше среднего уровня.

8.Курсы и число оплат, отсортированные по убыванию(JOIN + GROUP BY + ORDER BY)
```sql
SELECT c.title, COUNT(p.id) AS payments_count
FROM Courses c
JOIN Payments p ON c.id = p.course_id
GROUP BY c.title
ORDER BY payments_count DESC;
```
Самые коммерчески успешные курсы.

9.Все сдачи с порядковым номером сдачи по каждому студенту(окно RANK + PARTITION BY)
```sql
SELECT s.id, u.name, s.grade,
       RANK() OVER (PARTITION BY s.user_id ORDER BY s.id) AS submission_number
FROM Submissions s
JOIN Users u ON s.user_id = u.id;
```
Показывает прогресс сдачи заданий по каждому студенту.

10.Курсы, в которых участвуют все студенты с хотя бы одной сдачей(подзапрос + сложный оператор IN)
```sql
SELECT c.title
FROM Courses c
WHERE c.id IN (
    SELECT e.course_id
    FROM Enrollments e
    WHERE e.user_id IN (
        SELECT DISTINCT s.user_id
        FROM Submissions s
    )
);
```
Показывает курсы, которые охватывают всех активных студентов.

11.Найти пользователей, у которых все оценки выше 80(ALL)
```sql
SELECT u.name
FROM Users u
WHERE 80 < ALL (
    SELECT s.grade
    FROM Submissions s
    WHERE s.user_id = u.id
);
```

Показывает пользователей, которых все оценки выше 80

