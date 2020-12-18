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

create or replace function create_company(
    new_name varchar, new_business_type varchar, new_manager_name varchar,
    new_bik bigint, new_inn bigint, new_ogrn bigint
) returns text as $$
    declare
        id_company uuid;
    begin
        insert into company(bik, business_type, inn, manager_legal_name, name, ogrn)
        values (new_bik, new_business_type, new_inn, new_manager_name, new_name, new_ogrn)
        returning company.id into id_company;

        return 'Company created. Id: ' || id_company;
    end;
$$ language plpgsql;

-------------

create or replace function create_contract(
    company_id uuid, employee_id uuid, -- REFERENCES
    created_date timestamp, end_date timestamp,
    name varchar, description varchar, doc_url varchar
) returns text as $$
    declare
        id_contract uuid;
    begin
        if exists(select c.id from company c where c.id = company_id) then
            if exists(select e.id from employee e where e.id = employee_id) then
                insert into contract(created_date, description, doc_url, end_date, interrupted, interrupted_date, name, printed, company_id, employee_id)
                values (created_date, description, doc_url, end_date, false, null, name, false, company_id, employee_id)
                returning contract.id into id_contract;

                return 'Contract created. Id: ' || id_contract;
            else
                return 'No such employee_id: ' || employee_id;
            end if;
        else
            return 'No such company_id: ' || company_id;

        end if;
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

create or replace function scene_places(scene_uuid uuid)
    returns table
            (
                scene   varchar(255),
                city    varchar(255),
                country varchar(255),
                address varchar(255)
            )
as
$$
begin
    return query
        select s.name, p.city, p.country, p.address
        from scene s
                 join scene_place sp on sp.scene_list_id = s.id
                 join place p on p.id = sp.place_id
        where s.id=scene_uuid;
end;
$$ language plpgsql;
