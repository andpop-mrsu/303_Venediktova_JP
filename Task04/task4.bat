#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты, проверить отсутствие пар с самим собой. Для каждой пары должны быть указаны имена пользователей и название фильма, который они ценили."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT MIN(v1.name, v2.name) reviewer1, MAX(v1.name, v2.name) reviewer2, mov.title FROM movies m INNER JOIN ratings r1 ON r1.movie_id = m.id INNER JOIN ratings r2 ON r2.movie_id = m.id INNER JOIN movies mov ON mov.id = m.id INNER JOIN users v1 ON v1.id = r1.user_id INNER JOIN users v2 ON v2.id = r2.user_id WHERE (v1.id <> v2.id) ORDER BY reviewer1, reviewer2, mov.title;"
echo " "

echo "2. Найти 10 самых свежих оценок от разных пользователей, вывести названия фильмов, имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT us.name, mov.title, rat.rating, DATE(rat.timestamp, 'unixepoch') as date FROM ratings r INNER JOIN users us ON us.id = r.user_id INNER JOIN movies mov ON mov.id = r.movie_id INNER JOIN ratings rat ON rat.id = r.id ORDER BY rat.timestamp DESC LIMIT 10;"
echo " "

echo "3. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. Общий список отсортировать по году выпуска и названию фильма. В зависимости от рейтинга в колонке "Рекомендуем" для фильмов должно быть написано "Да" или "Нет"."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT title, year, recs.rating AS rating, recs.recommendation AS Рекомендуем FROM movies INNER JOIN (SELECT avg_vals.movie_id AS movie_id, avg_vals.mid_val AS rating, CASE avg_vals.mid_val WHEN max_and_min.max_val THEN 'Да' WHEN max_and_min.min_val THEN'Нет' END 'recommendation' FROM (SELECT movie_id, avg(rating) AS mid_val FROM ratings GROUP BY movie_id) avg_vals  INNER JOIN (SELECT max(mid_val) AS max_val, min(mid_val) AS min_val FROM (SELECT movie_id, avg(rating) AS mid_val FROM ratings GROUP BY movie_id)) max_and_min ON avg_vals.mid_val==max_and_min.max_val OR avg_vals.mid_val==max_and_min.min_val) recs ON movies.id==movie_id ORDER BY year, title;"
echo " "

echo "4. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-женщины в период с 2010 по 2012 год."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT COUNT(marks.rating) as count_of_marks, AVG(marks.rating) as average FROM (SELECT r.rating FROM ratings as r INNER JOIN users user ON user.id = r.user_id WHERE user.gender = 'female' AND r.timestamp > 1262303999 AND r.timestamp < 1325376000) AS marks;"
echo " "

echo "5. Составить список фильмов с указанием их средней оценки и места в рейтинге по средней оценке. Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT movies.title, movies.year, average_rating.avg_rating, row_number() OVER (ORDER BY average_rating.avg_rating DESC) rating_place FROM movies INNER JOIN (SELECT movie_id, AVG(rating) AS avg_rating FROM ratings GROUP BY movie_id) AS average_rating ON average_rating.movie_id = movies.id ORDER BY movies.year, movies.title LIMIT 20;"
echo " "

echo "6. Вывести список из 10 последних зарегистрированных пользователей в формате "Фамилия Имя|Дата регистрации" (сначала фамилия, потом имя)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT SUBSTR(users.name, instr(users.name, ' ') + 1) ||  '  ' ||  SUBSTR(users.name, 0, INSTR(users.name, ' '))  ||  '|' ||  users.register_date AS 'Фамилия Имя|Дата регистрации' FROM users ORDER BY users.register_date DESC LIMIT 10;"
echo " "

echo "7. С помощью рекурсивного CTE составить таблицу умножения для чисел от 1 до 10. Должен получиться один столбец следующего вида:
1x1=1
1x2=2
. . .
1x10=10
2x1=2
2x2=2
. . .
10x9=90
10x10=100"
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE tab(x, y) AS (SELECT 1, 1 UNION All SELECT x + (y)/10, (y + 0) % 10 + 1 FROM tab WHERE x <= 10) SELECT tab.x || 'x' || tab.y || ' = ' || format(tab.x*tab.y) AS tab FROM tab WHERE tab.x <= 10;"
echo " "

echo "8. С помощью рекурсивного CTE выделить все жанры фильмов, имеющиеся в таблице movies (каждый жанр в отдельной строке)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH genres_array(r_lenght, r_part, res) AS (SELECT 1, movies.genres||'|', '' FROM movies WHERE 1 UNION ALL SELECT instr(r_part, '|' ) AS r_l, substr(r_part, instr(r_part, '|' ) + 1), substr(r_part, 1, instr(r_part, '|' ) - 1) FROM genres_array WHERE r_l > 0) SELECT DISTINCT res AS 'Genres' FROM genres_array WHERE length(res) > 0;"
echo " "
pause