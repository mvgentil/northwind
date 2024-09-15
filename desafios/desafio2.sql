CREATE TABLE employees_auditoria(
    employee_id INT,
    previous_title VARCHAR(100),
    new_title VARCHAR(100),
    modified_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE PROCEDURE update_employee_title(
    p_employee_id INT,
    p_new_title VARCHAR(100)
)
AS $$
BEGIN
    UPDATE employees
    SET title = p_new_title
    WHERE employee_id = p_employee_id;
END;
$$ LANGUAGE plpgsql

CREATE OR REPLACE FUNCTION registrar_auditoria_titulo()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO employees_auditoria(employee_id, previous_title, new_title)
    VALUES (NEW.employee_id, OLD.title, NEW.title)
    RETURN NEW;
END;
$$ LANGUAGE plpgsql


CREATE TRIGGER trg_employees_auditoria
AFTER UPDATE OF title ON employees
FOR EACH ROW
EXECUTE FUNCTION registrar_auditoria_titulo();

CALL update_employee_title(5, 'Estagiário')