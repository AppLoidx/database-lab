create or replace function create_worker(
    new_name varchar, new_surname varchar, new_age integer, gender varchar, bio text, -- EMPLOYEE
    new_document_type varchar, new_document_id integer, new_work_book_id integer      -- DOCUMENT
) returns text as $$
    declare
        id_employee uuid;
    begin
        if not exists(select e.id from employee e where e.name = new_name AND e.surname = new_surname AND e.age = new_age) then
            insert into employee(age, biography, name, sex, surname) values
                (new_age, bio, new_name, gender, new_surname) returning id into id_employee;
            insert into employee_docs(document_id, document_type, work_book_id, owner_id) values
                (new_document_id, new_document_type, new_work_book_id, id_employee);
        end if;
        return 'Worker created. Id: ' || id_employee;
    end;
$$ language plpgsql;

-------------

create or replace function company_has_films(c_id uuid) returns boolean as
$$
declare
    checker integer;
begin
    checker = (
        select count()
        from company c
        join film f on f.company_id = c.id
        where c.id = c_id
    );

    if (checker > 0) then
        return true;
    else
        return false;
    end if;
end;
$$ language plpgsql;

-------------

create or replace function amount_of_films(c_id uuid) returns integer as
$$
declare
    amount integer;
begin
    amount = (
        select count()
        from company c
        join film f on f.company_id = c.id
        where c.id = c_id
    );
    return amount;
end;
$$ language plpgsql;

------------------

CREATE OR REPLACE FUNCTION scene_places(scene_uuid uuid)
    RETURNS TABLE
            (
                scene   varchar(255),
                city    varchar(255),
                country varchar(255),
                address varchar(255)
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT s.name, p.city, p.country, p.address
        FROM scene s
                 JOIN scene_place sp ON sp.scene_list_id = s.id
                 JOIN place p ON p.id = sp.place_id
        WHERE s.id=scene_uuid;
END;
$$ LANGUAGE plpgsql;
