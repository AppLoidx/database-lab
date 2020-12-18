create table company
(
    id                 uuid         not null
        constraint company_pkey
            primary key DEFAULT uuid_generate_v4(),
    bik                bigint       not null,
    business_type      varchar(255) not null,
    inn                bigint       not null,
    manager_legal_name varchar(255) not null,
    name               varchar(255) not null,
    ogrn               bigint       not null
);

create table employee
(
    id        uuid         not null
        constraint employee_pkey
            primary key DEFAULT uuid_generate_v4(),
    age       integer      not null,
    biography text,
    name      varchar(255) not null,
    sex       varchar(255) not null CONSTRAINT valid_gender CHECK (
        sex = 'MALE' OR sex = 'FEMALE'
        ),
    surname   varchar(255) not null
);

create table contract
(
    id               uuid         not null
        constraint contract_pkey
            primary key default uuid_generate_v4(),
    created_date     timestamp    not null,
    description      text,
    doc_url          varchar(255) not null,
    end_date         timestamp    not null CONSTRAINT end_date_cnstr CHECK (
        end_date > created_date
    ),
    interrupted      boolean      not null,
    interrupted_date timestamp CONSTRAINT intrpt_date_cnstr CHECK (
        interrupted_date IS NULL OR
        (interrupted_date > created_date AND interrupted_date < contract.end_date)
    ),
    name             varchar(255) not null,
    printed          boolean      not null,
    company_id       uuid
        references company,
    employee_id      uuid
        references employee
);

create table employee_docs
(
    id            uuid         not null
        constraint employee_docs_pkey
            primary key default uuid_generate_v4(),
    document_id   integer      not null,
    document_type varchar(255) not null CONSTRAINT doc_constr CHECK (
        document_type IN ('PASSPORT', 'BIRTH_CERTIFICATE')
        ),
    work_book_id  integer      not null,
    owner_id      uuid
        references employee
);

create table experience
(
    id          uuid not null
        constraint experience_pkey
            primary key default uuid_generate_v4(),
    end_date    timestamp,
    role        varchar(255),
    start_date  timestamp,
    employee_id uuid
        references employee
);

create table film
(
    id         uuid not null
        constraint film_pkey
            primary key default uuid_generate_v4(),
    name       text not null,
    synopsis   text not null,
    company_id uuid
        references company
);

create table actor
(
    id          uuid not null
        constraint actor_pkey
            primary key default uuid_generate_v4(),
    role        varchar(255),
    contract_id uuid
        references contract,
    employee_id uuid
        references employee,
    film_id     uuid
        references film
);

create table cameraman
(
    id          uuid not null
        constraint cameraman_pkey
            primary key default uuid_generate_v4(),
    contract_id uuid
        references contract,
    employee_id uuid
        references employee,
    film_id     uuid
        references film
);

create table director
(
    id          uuid not null
        constraint director_pkey
            primary key default uuid_generate_v4(),
    contract_id uuid
        references contract,
    employee_id uuid
        references employee,
    film_id     uuid
        references film
);

create table place
(
    id          uuid         not null
        constraint place_pkey
            primary key default uuid_generate_v4(),
    address     varchar(255) not null,
    city        varchar(255) not null,
    country     varchar(255) not null,
    description text         not null,
    name        varchar(255) not null
);

create table producer
(
    id          uuid not null
        constraint producer_pkey
            primary key default uuid_generate_v4(),
    contract_id uuid
        references contract,
    employee_id uuid
        references employee,
    film_id     uuid
        references film
);

create table prediction
(
    id              uuid not null
        constraint prediction_pkey
            primary key default uuid_generate_v4(),
    created_date    timestamp,
    description     varchar(255),
    predicted_date  timestamp,
    film_id         uuid
        references film,
    predicted_by_id uuid
        references producer
);

create table producer_predictions
(
    producer_id    uuid not null
        references producer,
    predictions_id uuid not null
        unique
        references prediction
);

create table schedule
(
    id         uuid not null
        constraint schedule_pkey
            primary key,
    end_time   timestamp CONSTRAINT end_time_constr CHECK ( end_time > start_time ),
    start_time timestamp
);

create table scene
(
    id          uuid         not null
        constraint scene_pkey
            primary key default uuid_generate_v4(),
    description text         not null,
    name        varchar(255) not null,
    scene_order integer      not null,
    film_id     uuid
        references film,
    scene_id    uuid
        references scene,
    schedule_id uuid
        references schedule
);

create table occupation
(
    id               uuid not null
        constraint occupation_pkey
            primary key default uuid_generate_v4(),
    occupation_end   timestamp CONSTRAINT end_constr CHECK (
        occupation_end > occupation_start
    ),
    occupation_start timestamp,
    scene_id         uuid
        references scene
);

create table scene_place
(
    scene_list_id uuid not null
        references scene,
    place_id      uuid not null
        references place
);

create table script_writer
(
    id          uuid not null
        constraint script_writer_pkey
            primary key default uuid_generate_v4(),
    contract_id uuid
        references contract,
    employee_id uuid
        references employee,
    film_id     uuid
        references film
);

create table size
(
    id uuid             not null
        constraint size_pkey
            primary key default uuid_generate_v4(),
    x  double precision not null,
    y  double precision not null,
    z  double precision not null
);

create table equipment
(
    id      uuid not null
        constraint equipment_pkey
            primary key default uuid_generate_v4(),
    model   varchar(255),
    name    varchar(255),
    price   numeric(19, 2),
    type    varchar(255),
    size_id uuid
        references size
);

create table actor_equipment_list
(
    actor_list_id     uuid not null
        references actor,
    equipment_list_id uuid not null
        references equipment
);



create table cameraman_equipment_list
(
    cameraman_list_id uuid not null
        references cameraman,
    equipment_list_id uuid not null
        references equipment
);

create table director_equipment_list
(
    director_list_id  uuid not null
        references director,
    equipment_list_id uuid not null
        references equipment
);

create table equipment_occupation_list
(
    equipment_id       uuid not null
        references equipment,
    occupation_list_id uuid not null
        unique
        references occupation
);

create table producer_equipment_list
(
    producer_list_id  uuid not null
        references producer,
    equipment_list_id uuid not null
        references equipment
);

create table prop
(
    id      uuid not null
        constraint prop_pkey
            primary key default uuid_generate_v4(),
    name    varchar(255),
    price   numeric(19, 2),
    type    varchar(255),
    size_id uuid
        references size
);

create table prop_occupation_list
(
    prop_id            uuid not null
        references prop,
    occupation_list_id uuid not null
        unique
        references occupation
);

create table prop_scene
(
    props_id uuid not null
        references prop,
    scene_id uuid not null
        references scene
);

create table script_writer_equipment_list
(
    script_writer_list_id uuid not null
        references script_writer,
    equipment_list_id     uuid not null
        references equipment
);