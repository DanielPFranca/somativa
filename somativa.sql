
-- ETAPA 1 --

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
select * from status;

create table fotos(
	id bigint not null auto_increment,
    linkFoto varchar(255) not null,
	primary key(id)
);

insert into fotos (linkFoto) values ('www.foto.com.br'), ('www.foto.com.br'), ('www.foto.com.br'), ('www.foto.com.br'), ('www.foto.com.br'), ('www.foto.com.br'),
('www.foto.com.br'), ('www.foto.com.br'), ('www.foto.com.br'), ('www.foto.com.br');

insert into fotos (linkFoto) values ('www.foto.com.br'), ('www.foto.com.br');

select * from fotos;

create table tarefas(
	id bigint not null auto_increment,
    nome varchar(50) not null,
    decricao varchar(50) not null,
    dtAbertura datetime not null default now(),
    dtFim datetime null,
    dtPrazo datetime null,
    solicitanteFK bigint not null,
    localFK bigint not null,
    statusFK bigint not null,
    fotoFK bigint not null,
    primary key(id),
    foreign key(solicitanteFK) references usuarios(id),
    foreign key(localFK) references locais(id),
    foreign key(statusFK) references status(id),
    foreign key(fotoFK) references fotos(id)
);

alter table tarefas 
modify column dtPrazo datetime not null;

alter table tarefas
change decricao descricao varchar(255) not null;

insert into tarefas (nome, descricao, dtAbertura, dtPrazo, solicitanteFK, localFK, statusFK, fotoFK)
values ('Tarefa 1', 'Projetor quebrado', '2023-03-10', '2023-03-15', 1, 2, 1, 1),
('Tarefa 2', 'Monitor não está funcionando', '2023-02-10', '2023-02-15', 2, 2, 1, 2);

select * from tarefas;

insert into tarefas (nome, descricao, dtAbertura, dtFim, dtPrazo, solicitanteFK, localFK, statusFK, fotoFK) values
('Tarefa 3', 'Maçaneta quebrada', '2022-11-05', '2022-11-15', '2022-11-20', 1, 5, 1, 3 ),
('Tarefa 4', 'Parede manchada', '2023-02-20', '2023-02-24', '2023-02-25', 4, 4, 1, 4 );

insert into tarefas (nome, descricao, dtAbertura, dtPrazo, solicitanteFK, localFK, statusFK, fotoFK)
values 
('Tarefa 5', 'Ar-Condicionado não está funcionando', '2023-02-10', '2023-02-15', 2, 3, 1, 5 ),
('Tarefa 6', 'Oficina com problemas', '2023-04-13', '2023-04-18', 4, 4, 1, 6 ),
('Tarefa 7', 'Luz com defeito', '2023-01-01', '2023-01-05', 1, 5, 1, 7 );

insert into tarefas (nome, descricao, dtAbertura, dtFim, dtPrazo, solicitanteFK, localFK, statusFK, fotoFK) values
('Tarefa 8', 'Cabo HDMI com mau funcionamento', '2021-09-13', '2021-09-15', '2021-09-14', 3, 5, 1, 8 );

insert into tarefas (nome, descricao, dtAbertura, dtPrazo, solicitanteFK, localFK, statusFK, fotoFK)
values 
('Tarefa 9', 'Cadeira sem espuma', '2023-09-12', '2023-09-15', 2, 5, 1, 23 ),
('Tarefa 10', 'Ar-Condicionado não está funcionando', '2023-02-10', '2023-02-15', 4, 3, 1, 24 );

select * from usuarios;
select * from tarefas;
create table tarefa_responsável(
	id bigint not null auto_increment,
    tarefaFK bigint not null,
    responsavelFK bigint not null,
    primary key(id),
    foreign key(tarefaFK) references tarefas(id),
    foreign key(responsavelFK) references usuarios(id)
);

insert into tarefa_responsável (tarefaFK, responsavelFK) values (1, 6),(1,3), (2, 5),(3, 6), (3, 5),(4, 3),(5, 3),(6, 5), (6,6), (7, 3), (8,5);

select * from fotos;
select * from tarefas;

create table histórico(
	id bigint not null auto_increment,
    tarefaFK bigint not null,
    statusFK bigint not null,
    fotoFK bigint not null,
    comentario varchar(255) not null,
    primary key(id),
    foreign key(statusFK) references status(id),
    foreign key(tarefaFK) references tarefas(id),
	foreign key(fotoFK) references fotos(id)
);

insert into histórico (tarefaFK, statusFK, fotoFK, comentario) values (1,2,9, 'Já estamos cuidando do problema'), 
(1,3,10, 'Terminamos o que tinha de ser feito'), 
(1,4,11, 'A tarefa foi encerrada'),
(2,2,12, 'Já estamos cuidando do problema'),
(2,3,13, 'Terminamos o que tinha de ser feito'), 
(3,3,14, 'Terminamos o que tinha de ser feito'), 
(4,3,15, 'Terminamos o que tinha de ser feito'), 
(4,4,16, 'A tarefa foi encerrada'), 
(5,4,17, 'A tarefa foi encerrada'), 
(6,2,18, 'Já estamos cuidando do problema'), 
(6,3,19, 'Terminamos o que tinha de ser feito'), 
(7,1,20, 'Acabamos de iniciar'), 
(7,2,21, 'Já estamos cuidando do problema'), 
(7,3,22, 'Terminamos o que tinha de ser feito');
select * from histórico;


-- ETAPA 2 --


#A)

select distinct t.nome, u.nome as 'Solicitante', t.nome, us.nome as 'Responsável' from tarefas t
join tarefa_responsável tr on t.id = tr.tarefaFK
join usuarios u on t.solicitanteFK = u.id
join usuarios us on tr.responsavelFK = us.id
order by t.nome; -- O order by é apenas para uma visualização melhor

#B)

select * from tarefas;

select l.nome ,count(t.id) from locais l
join tarefas t on l.id = t.localFK
group by l.id having count(t.id) >= 2;


#C)

select u.nome ,count(t.id) from usuarios u
join tarefas t on u.id = t.solicitanteFK
group by u.id having count(t.id) >= 2;


#D)

select e.nome, l.nome, t.nome from eventos e
join locais l on l.id = e.localFk
join tarefas t on l.id = t.localFk
where e.inicio > now()
and t.id not in (l.id);

#E)

select l.nome ,count(t.id) from locais l
join tarefas t on l.id = t.localFK
group by l.id;

#F)

select l.nome, count(h.id)from locais l
join tarefas t on l.id = t.localFK
join histórico h on h.tarefaFK = t.id
join status s on s.id = h.statusFK
where s.id = '3'
group by l.id;

#G)

select u.nome, count(t.id) as 'QTD. Tarefas' from tarefas t
join usuarios u on u.id = t.solicitanteFK
group by u.id
union
select us.nome ,count(tr.id) from tarefa_responsável tr
join usuarios us on tr.responsavelFK = us.id
group by us.id;

#H) 

select u.nome, count(t.id) from tarefa_responsável tr
join usuarios u on u.id = tr.responsavelFK
join tarefas t on t.id = tr.tarefaFK
group by u.id;


#I)

select Local, Mês, avg(Total) from (
select l.nome Local, month(t.dtAbertura) Mês, count(t.id) Total from tarefas t
join locais l on l.id = t.localFK
group by month(t.dtAbertura), Local) sub
group by Local, Mês;

-- ETAPA 3 --

create table arquivos(
	id bigint not null auto_increment,
    nome varchar(100) not null,
    tipoArquivo varchar(30) not null,
    dataUpload date not null,
    tamanho int not null,
    usuarioFK bigint not null,
    primary key(id),
    foreign key(usuarioFK) references usuarios(id)
);

insert into arquivos (nome, tipoArquivo, dataUpload, tamanho, usuarioFK) values
('Tabelas sobre as tarefas', 'Exel', '2023-04-15', 50, 3),
('Vídeo de como estão as tarefas', 'MP4', '2023-01-29', 150, 6),
('Texto sobre as tarefas', 'Word', '2022-11-09', 14, 2),
('Apresentação das tarefas', 'PowerPoint', '2022-12-18', 80, 5);

select * from arquivos;

create table compartilhar(
	id bigint not null auto_increment,
    usuarioFK bigint not null,
    arquivoFK bigint not null,
    primary key(id),
    foreign key(usuarioFK) references usuarios(id),
    foreign key(arquivoFK) references arquivos(id)
);

insert into compartilhar (usuarioFK, arquivoFK) values (2,3), (4,1), (6,4);

-- Consulta --

select * from arquivos
order by dataUpload;

-- Na minha opinião acrdeito que um banco de dados do tipo noSQL seja mais vantajoso,
-- pois ele possuir uma estrutura muito parecida com um JSON, tendo assim um desempenho 
-- superior em operações de leitura, gravações que se torna ótimo para aplicativos com alto volume de tráfego
-- e requisitos de baixa latência.



