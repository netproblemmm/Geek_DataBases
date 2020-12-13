1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `max_salary` AS
    SELECT 
        `e`.`emp_no` AS `emp_no`,
        CONCAT(`e`.`first_name`, ' ', `e`.`last_name`) AS `FIO`,
        MAX(`s`.`salary`) AS `MAX(s.salary)`
    FROM
        (`employees` `e`
        JOIN `salaries` `s` ON ((`e`.`emp_no` = `s`.`emp_no`)))
    GROUP BY `e`.`emp_no`



2. Создать функцию, которая найдет менеджера по имени и фамилии.

USE `employees`;
DROP function IF EXISTS `get_manager_on_FIO`;

DELIMITER $$
USE `employees`$$
CREATE FUNCTION `get_manager_on_FIO` (first_name varchar(50), last_name varchar(50))
RETURNS INTEGER DETERMINISTIC
BEGIN
DECLARE result INTEGER;
SELECT dept_manager.emp_no INTO result FROM dept_manager
INNER JOIN employees ON dept_manager.emp_no = employees.emp_no
WHERE first_name = 'Tonny' AND last_name = 'Butterworth';
RETURN result;
END$$

DELIMITER ;

Запуск функции
select get_manager_on_FIO('Tonny','Butterworth');

дает почему-то ошибку:
Error Code: 1172. Result consisted of more than one row

Хотя результат - это номер сотрудника, 1 строка, такой же запрос выдает все верно:
SELECT dept_manager.emp_no FROM dept_manager
INNER JOIN employees ON dept_manager.emp_no = employees.emp_no
WHERE first_name = 'Tonny' AND last_name = 'Butterworth';



3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.

DROP TRIGGER IF EXISTS `employees`.`employees_AFTER_INSERT`;

DELIMITER $$
USE `employees`$$
CREATE DEFINER = CURRENT_USER
TRIGGER `employees`.`employees_AFTER_INSERT`
AFTER INSERT ON `employees` FOR EACH ROW
BEGIN
DECLARE emp_no INT;
INSERT INTO `employees`.`salaries`
(`emp_no`, `salary`, `from_date`, `to_date`)
VALUES (new.emp_no, 50000, SYSDATE(), '9999-01-01');
END$$
DELIMITER ;