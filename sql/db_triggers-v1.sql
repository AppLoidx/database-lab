create or replace function delete_docs() returns trigger as
$$
begin
    delete from employee_docs e where e.owner_id = OLD.id;
    return null;
end;
$$ LANGUAGE plpgsql;

create or replace function delete_employee() returns trigger as
$$
begin
    delete from employee e where e.id = OLD.owner_id;
    return null;
end;
$$ LANGUAGE plpgsql;

create trigger employee_delete
    after delete
    on employee
    for each row
    execute procedure delete_docs();

create trigger employee_docs_delete
    after delete
    on employee_docs
    for each row
execute procedure delete_employee();