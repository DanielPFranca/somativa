
create table usuarios(
	id bigint not null auto_increment,
    nome varchar(150) not null,
    email varchar(150) not null,
	dataNascimento date not null,
    senha varchar(30) not null,
    dataCadastro datetime not null default now(),
    ocupacaoFk bigint not null,
    status boolean not null default true,    
    primary key(id),
    foreign key(ocupacaoFk) references ocupacao(id)
);


alter table usuarios 
add column telefone numeric(10);

alter table usuarios
add column foto varchar(255);

select * from usuarios;






create table status(
	id bigint not null auto_increment,
    status varchar(30) not null,
    primary key(id)
);

insert into status(status) values ('Aberta'), ('Em andamento'), ('Concluída'), ('Encerrada');

create table tarefas(
	id bigint not null auto_increment,
    nome varchar(50) not null,
    decricao varchar(50) not null,
    dtAbertura datetime not null default now(),
    dtPrazo datetime null,
    solicitanteFK bigint not null,
    localFK bigint not null,
    primary key(id),
    foreign key(solicitanteFK) references usuarios(id),
    foreign key(localFK) references locais(id)
);
alter table tarefas add column dtFim datetime null;


insert into tarefas (nome, decricao, dtAbertura, dtPrazo, solicitanteFK, localFK)
values ('Tarefa 1', 'Projetor quebrado', '2023-03-10', '2023-03-15', 1, 2),
('Tarefa 2', 'Monitor não está funcionando', '2023-02-10', '2023-02-15', 2, 2);

insert into tarefas (nome, decricao, dtAbertura, dtPrazo, solicitanteFK, localFK, dtFim) values
('Tarefa 3', 'Maçaneta quebrada', '2022-11-05', '2022-11-20', 1, 5, '2022-11-15'),
('Tarefa 4', 'Parede manchada', '2023-02-20', '2023-02-25', 4, 4, '2023-02-24');

insert into tarefas (nome, decricao, dtAbertura, dtPrazo, solicitanteFK, localFK)
values 
('Tarefa 5', 'Ar-Condicionado não está funcionando', '2023-02-10', '2023-02-15', 3, 3),
('Tarefa 6', 'Oficina com problemas', '2023-04-13', '2023-04-18', 2, 4),
('Tarefa 7', 'Luz com defeito', '2023-01-01', '2023-01-05', 2, 3);


create table tarefa_responsável(
	id bigint not null auto_increment,
    tarefaFK bigint not null,
    respnsavelFK bigint not null,
    primary key(id),
    foreign key(tarefaFK) references tarefas(id),
    foreign key(respnsavelFK) references usuarios(id)
);

insert into tarefa_responsável (tarefaFK, respnsavelFK) values (1, 6),(2, 5),(3, 2),(4, 3),(5, 3),(6, 1),(7, 4);



create table fotos(
	id bigint not null auto_increment,
    linkFoto varchar(255) not null,
    statusFK bigint not null,
	primary key(id),
    foreign key(statusFK) references status(id)
);

insert into fotos (linkFoto, statusFK) values ('www.foto.com.br', 2), ('www.foto.com.br', 1), ('www.foto.com.br', 3), ('www.foto.com.br', 2), ('www.foto.com.br', 4), ('www.foto.com.br', 3),
('www.foto.com.br', 3), ('www.foto.com.br', 1), ('www.foto.com.br', 4), ('www.foto.com.br', 3);


create table histórico(
	id bigint not null auto_increment,
    tarefaFK bigint not null,
    statusFK bigint not null,
    fotoFK bigint not null,
    primary key(id),
    foreign key(statusFK) references status(id),
    foreign key(tarefaFK) references tarefas(id),
	foreign key(fotoFK) references fotos(id)
);

insert into histórico (tarefaFK, statusFK, fotoFK ) values (1,1,2), (1,2,3), (1,3,4),(2,2,4),
(2,3,5), (3,3,1), (4,3,10), (4,4,9), (5,4,2), (6,2,8), (6,3,1), (7,1,7), (7,2,5), (7,3,2);
select * from usuarios;

select t.solicitanteFK, u.nome, tr.respnsavelFK, ur.nome  from tarefas t
inner join tarefa_responsável tr on t.id = tr.tarefaFK
inner join usuarios u on t.solicitanteFK = u.id
inner join usuarios ur on u.id = tr.respnsavelFK
inner join histórico h on h.tarefaFK = t.id
inner join status s on s.id = h.statusFK
where s.id = 'Em andamento';


select * from status;

select count(*) from locais l
inner join tarefas t on l.id = t.localFK
group by t.id;


