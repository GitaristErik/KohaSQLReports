CREATE OR REPLACE VIEW work_diary_statistics as 
(SELECT    
    CAST(s.datetime as DATE) as `Дата`,
    (i.homebranch COLLATE utf8mb4_unicode_ci) as homebranch,
    (i.location COLLATE utf8mb4_unicode_ci) as location,
    ci.`Підрозділ`,
    ci.`Розташування`,
    COUNT(IF(YEAR(bo.dateenrolled) = YEAR(s.datetime), 1, NULL)) as `За реєстраційною картотекою`,
    COUNT(*) as `Число відвідувачів`,
    -- Вік
    COUNT(IF(timestampdiff(year, bo.dateofbirth, curdate()) < 7, 1, NULL)) as `До 7 років`,
    COUNT(IF(timestampdiff(year, bo.dateofbirth, curdate()) BETWEEN 7 AND 14, 1, NULL)) as `Від 7 до 14 років`,
    COUNT(IF(timestampdiff(year, bo.dateofbirth, curdate()) BETWEEN 15 AND 17, 1, NULL)) as `Від 15 до 17 років`,
    COUNT(IF(timestampdiff(year, bo.dateofbirth, curdate()) BETWEEN 18 AND 21, 1, NULL)) as `Від 18 до 21 року`,
    COUNT(IF(timestampdiff(year, bo.dateofbirth, curdate()) BETWEEN 22 AND 59, 1, NULL)) as `Від 22 до 59 років`,
    COUNT(IF(timestampdiff(year, bo.dateofbirth, curdate()) > 60, 1, NULL)) as `Від 60 років`,
    -- Типи 
    COUNT(IF(bo.categorycode = "STD", 1, NULL)) as `Студенти`,
    COUNT(IF(bo.categorycode = "PWSN", 1, NULL)) as `Люди з особливими потребами`,
    COUNT(IF(bo.categorycode = "UNP", 1, NULL)) as `Безробітні`,
    COUNT(IF(bo.categorycode = "IDP", 1, NULL)) as `Внутрішньо-переміщені особи`,
    COUNT(IF(bo.sex = 'F', 1, NULL)) as `Жінки`,
    -- Книги
    ci.`Всього видано`,
    ci.`Книги`,
    ci.`Брошури`,
    ci.`Періодичні видання`,
    ci.`Електронні видання`,
    ci.`Аудіовізуальні`,
    -- UDC
    ci.`Суспільно-політична література`,
    ci.`Пр-тво, математика, медицина`,
    ci.`Техніка`,
    ci.`С/Г`,
    ci.`Мистецтво і спорт`,
    ci.`Художня література`,
    ci.`Л-ра для дошкільнят, казки`,
    ci.`Мовознавство, літ-тво`,
    ci.`Інші`,
    -- Мови
    ci.`Українською`,
    ci.`Російською`,
    ci.`Англійською`,
    ci.`Угорською`,
    ci.`Румунською`,
    ci.`Словацькою`,
    ci.`Іноземною`,
    ci.`Без мови`,
    COUNT(if(s.type LIKE "return", 1, NULL)) as `Всього повернуто`
FROM
    statistics as s
    LEFT JOIN items AS i USING(itemnumber)
    LEFT JOIN biblio AS b USING(biblionumber)
    LEFT JOIN biblioitems AS bi USING(biblioitemnumber)
    LEFT JOIN biblio_metadata bm ON (i.biblionumber = bm.biblionumber)
    LEFT JOIN branches AS br ON(i.homebranch = br.branchcode)
    LEFT JOIN borrowers AS bo USING(borrowernumber)
    RIGHT JOIN copies_issued as ci ON(
        ci.`Дата` = CAST(s.datetime as DATE)
        AND i.homebranch = ci.homebranch
        AND i.location = ci.location
    )
WHERE
    NOT s.borrowernumber is NULL
--     i.homebranch = <<Виберіть бібліотеку|branches>> AND
--     i.location =  <<Підрозділ|LOCA>> 
GROUP BY
    `Дата` ASC,
    i.homebranch ASC,
    `Розташування` ASC
ORDER BY
    `Дата` ASC,
    i.homebranch ASC,
    `Розташування` ASC)
UNION 
(SELECT DATE("1970-01-01"), "", "", "", "", 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
