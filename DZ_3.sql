	База данных «Страны и города мира»:
	1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
	
SELECT 
    cit.title City, reg.title Region, cou.title Country
FROM
    _cities cit
        INNER JOIN
    _regions reg ON cit.region_id = reg.id
        INNER JOIN
    _countries cou ON cit.country_id = cou.id
WHERE
    cit.title = 'Волгоград'
;
	

	2. Выбрать все города из Московской области.
	
SELECT 
    reg.title Region, cit.title City
FROM
    _regions reg
        INNER JOIN
    _cities cit ON reg.id = cit.region_id
WHERE
    reg.title = 'Московская область'
;
	
	База данных «Сотрудники»:
	
	1. Выбрать среднюю зарплату по отделам.
	
SELECT 
    all_employees.dept_name Department, AVG(all_employees.salary) 'Average salary'
FROM
    (SELECT 
        d.dept_name, s.salary
    FROM
        departments d
    INNER JOIN dept_emp de ON d.dept_no = de.dept_no
    INNER JOIN employees e ON de.emp_no = e.emp_no
    INNER JOIN salaries s ON e.emp_no = s.emp_no UNION ALL SELECT 
        d.dept_name, s.salary
    FROM
        departments d
    INNER JOIN dept_manager dm ON d.dept_no = dm.dept_no
    INNER JOIN employees e ON dm.emp_no = e.emp_no
    INNER JOIN salaries s ON e.emp_no = s.emp_no) all_employees
GROUP BY all_employees.dept_name
ORDER BY 2
;


	2. Выбрать максимальную зарплату у сотрудника.
	
SELECT 
    e.emp_no,
    CONCAT(e.first_name, ' ', e.last_name) FIO,
    MAX(s.salary)
FROM
    employees e
        INNER JOIN
    salaries s ON e.emp_no = s.emp_no
GROUP BY e.emp_no
;
	
	3. Удалить одного сотрудника, у которого максимальная зарплата.
	
DELETE
FROM salaries s
WHERE s.emp_no =
	(select max_salary.emp_no from 
		(SELECT
			e.emp_no,
			s.salary
		FROM
			employees e
        INNER JOIN
			salaries s ON e.emp_no = s.emp_no
			order by 2 desc
			limit 1
		) max_salary
    )
; 
	
	4. Посчитать количество сотрудников во всех отделах.
	
SELECT 
    COUNT(emp_no)
FROM
    employees
;
	
	5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.

SELECT 
    all_employees.dept_name Department, COUNT(all_employees.emp_no) 'Employees quantity'
FROM
    (SELECT 
        d.dept_name, e.emp_no
    FROM
        departments d
    INNER JOIN dept_emp de ON d.dept_no = de.dept_no
    INNER JOIN employees e ON de.emp_no = e.emp_no UNION ALL SELECT 
        d.dept_name, e.emp_no
    FROM
        departments d
    INNER JOIN dept_manager dm ON d.dept_no = dm.dept_no
    INNER JOIN employees e ON dm.emp_no = e.emp_no) all_employees
GROUP BY all_employees.dept_name
;
	
	
SELECT 
    all_employees.dept_name Department, SUM(all_employees.salary) 'Summary salary'
FROM
    (
    SELECT 
        d.dept_name, s.salary
    FROM
        departments d
    INNER JOIN dept_emp de ON d.dept_no = de.dept_no
    INNER JOIN employees e ON de.emp_no = e.emp_no
    INNER JOIN salaries s ON e.emp_no = s.emp_no
    UNION ALL SELECT 
        d.dept_name, s.salary
    FROM
        departments d
    INNER JOIN dept_manager dm ON d.dept_no = dm.dept_no
    INNER JOIN employees e ON dm.emp_no = e.emp_no
    INNER JOIN salaries s ON e.emp_no = s.emp_no
    ) all_employees
GROUP BY all_employees.dept_name
;