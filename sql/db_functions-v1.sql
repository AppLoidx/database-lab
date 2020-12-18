create or replace function create_worker(
    new_name varchar, new_surname varchar, new_age integer, gender varchar, bio text, -- EMPLOYEE
    new_document_type varchar, new_document_id integer, new_work_book_id integer      -- DOCUMENT
) returns text as $$
    declare
        id_employee int;
    begin
        if not exists(select e.id from employee e where e.name = new_name AND e.surname = new_surname AND e.age = new_age) then
            insert into employee(age, biography, name, sex, surname) values
                (new_age, bio, new_name, gender, new_surname) returning id into id_employee;
            insert into employee_docs(document_id, document_type, work_book_id, owner_id) values
                (new_document_id, new_document_type, new_work_book_id, id_employee);
        end if;
    end;
$$ language plpgsql;

