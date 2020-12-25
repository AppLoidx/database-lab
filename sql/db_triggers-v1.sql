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


-- триггер на изменение данных об оккупации оборудования

create or replace function on_occupation_change() returns trigger as
$$
begin
    raise notice 'occupation start % , occupation end %', NEW.occupation_start, NEW.occupation_end;
    if NEW.occupation_start < NEW.occupation_end then
        return NEW;
    else
        RAISE EXCEPTION 'occupation start date cant be after the occupation end date';
    end if;

end;
$$
    language plpgsql;

drop trigger if exists on_occupation_change_trigger on occupation;

create trigger on_occupation_change_trigger
    before insert or update
    on occupation
    for each row
execute procedure on_occupation_change();
