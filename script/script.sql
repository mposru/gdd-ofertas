/*IF OBJECT_ID (N'dbo.Usuario', N'U') IS NOT NULL  
DROP TABLE gd_esquema.Usuario;  
GO*/
-- TODO: cambiar nombre de esquema
CREATE TABLE GD2C2019.gd_esquema.Usuario(
	usuario_username nvarchar(64) NOT NULL,
	usuario_password nvarchar(32) NOT NULL,
	usuario_habilitado BIT DEFAULT 1,
	usuario_intentos_fallidos_login INT DEFAULT 0,
	usuario_eliminado BIT DEFAULT 0
	CONSTRAINT [UN_Usuario_Username] UNIQUE (usuario_username),
	CONSTRAINT [PK_Usuario] PRIMARY KEY (
		usuario_username
	)
)

CREATE TABLE GD2C2019.gd_esquema.Rol(
	rol_id INT identity(1 ,1) NOT NULL PRIMARY KEY,
	rol_nombre varchar(20) NOT NULL,
	rol_habilitado BIT DEFAULT 1,
	rol_eliminado BIT DEFAULT 0,
)

CREATE TABLE GD2C2019.gd_esquema.Funcionalidad(
	funcionalidad_id INT identity(1, 1) NOT NULL PRIMARY KEY,
	funcionalidad_descripcion varchar(64) NOT NULL,
)

CREATE TABLE GD2C2019.gd_esquema.RolesxUsuario(
	rolesxusuario_id_usuario nvarchar(64) NOT NULL,
	rolesxusuario_id_rol INT NOT NULL

	CONSTRAINT [PK_RolesxUsuario] PRIMARY KEY (
		[rolesxusuario_id_usuario] ASC,
		[rolesxusuario_id_rol] ASC
	)
	
	CONSTRAINT [FK_RolesxUsuario_rol_id] FOREIGN KEY(rolesxusuario_id_rol)
		REFERENCES [GD2C2019].[gd_esquema].Rol (rol_id),
	CONSTRAINT [FK_RolesxUsuario_usuario_id] FOREIGN KEY(rolesxusuario_id_usuario)
		REFERENCES [GD2C2019].[gd_esquema].[Usuario] (usuario_username),
	CONSTRAINT UN_RolesxUsuario_id UNIQUE(rolesxusuario_id_usuario,rolesxusuario_id_rol)
)

CREATE TABLE GD2C2019.gd_esquema.FuncionalidadxRol(
	funcionalidadxrol_id_rol INT NOT NULL,
	funcionalidadxrol_id_funcionalidad INT NOT NULL

	CONSTRAINT [PK_FuncionalidadxRol] PRIMARY KEY (
		[funcionalidadxrol_id_rol] ASC,
		[funcionalidadxrol_id_funcionalidad] ASC
	)
	
	CONSTRAINT [FK_FuncionalidadxRol_funcionalidad_id] FOREIGN KEY(funcionalidadxrol_id_funcionalidad)
		REFERENCES [GD2C2019].[gd_esquema].[Funcionalidad] (funcionalidad_id),
	CONSTRAINT [FK_FuncionalidadxRol_rol_id] FOREIGN KEY(funcionalidadxrol_id_rol)
		REFERENCES [GD2C2019].[gd_esquema].[Rol] (rol_id),
	CONSTRAINT UN_FuncionalidadxRol_id UNIQUE(funcionalidadxrol_id_rol,funcionalidadxrol_id_funcionalidad)

)

CREATE TABLE GD2C2019.gd_esquema.Localidad(
	localidad_id INT identity(1, 1) NOT NULL PRIMARY KEY,
	localidad_nombre varchar(64) NOT NULL,
)

CREATE TABLE GD2C2019.gd_esquema.Domicilio(
	domicilio_id INT identity(1, 1) NOT NULL PRIMARY KEY,
	domicilio_id_localidad INT NOT NULL,
	domicilio_calle varchar(64) NOT NULL,
	domicilio_numero_piso INT NULL,
	domicilio_departamento char(20) NULL,
	domicilio_codigo_postal INT NOT NULL,
	
	CONSTRAINT [FK_Domicilio_localidad_id] FOREIGN KEY(domicilio_id_localidad)
		REFERENCES [GD2C2019].[gd_esquema].[Localidad] (localidad_id)
)

CREATE TABLE GD2C2019.gd_esquema.Cliente(
	cliente_id INT identity(1, 1) NOT NULL PRIMARY KEY,
	cliente_id_usuario nvarchar(64) NOT NULL,
	cliente_nombre varchar(64) NOT NULL,
	cliente_apellido varchar(64) NOT NULL,
	cliente_dni varchar(64) NOT NULL,
	cliente_mail varchar(64) NOT NULL,
	cliente_telefono varchar(64) NULL,
	cliente_habilitado BIT DEFAULT 1,
	cliente_fecha_nacimiento datetime NULL,
	cliente_id_domicilio INT NOT NULL,
	cliente_credito INT DEFAULT 0
	
	CONSTRAINT [FK_Cliente_domicilio_id] FOREIGN KEY(cliente_id_domicilio)
		REFERENCES [GD2C2019].[gd_esquema].[Domicilio] (domicilio_id),
	CONSTRAINT [FK_Cliente_usuario_id] FOREIGN KEY(cliente_id_usuario)
		REFERENCES [GD2C2019].[gd_esquema].[Usuario] (usuario_username),
-- asumimos que si dos clientes tienen = nombre, apellido, dni, fecha nac y cliente_mail son "gemelos"
-- esta constraint no estaria andando, toma a todos los campos como unique??? por que
	CONSTRAINT UN_Cliente_unico UNIQUE (cliente_dni)
	-- crear trigger que no haya dato que tenga mismo nombre, apellido, fecha de nacimiento y mail
)

CREATE TABLE GD2C2019.gd_esquema.Tarjeta(
	tarjeta_id INT identity(1, 1) NOT NULL PRIMARY KEY,
	tarjeta_numero varchar(64) NOT NULL,
	tarjeta_fecha_venc datetime NOT NULL,
	tarjeta_cod_seguridad varchar(64) NOT NULL,
)

CREATE TABLE GD2C2019.gd_esquema.Tipo_Pago(
	tipo_pago_id INT identity(1, 1) NOT NULL PRIMARY KEY,
	tipo_pago_nombre varchar(64) NOT NULL,
)

CREATE TABLE GD2C2019.gd_esquema.Carga_Credito(
	carga_credito_id INT identity(1, 1) NOT NULL PRIMARY KEY,
	carga_credito_id_cliente INT NOT NULL,
	carga_credito_id_tipo_pago INT NOT NULL,
	carga_credito_id_tarjeta INT,
	carga_credito_fecha datetime NOT NULL,
	carga_credito_monto decimal(12, 2) NOT NULL,
	
	CONSTRAINT [FK_Carga_Credito_tipo_pago_id] FOREIGN KEY(carga_credito_id_tipo_pago)
		REFERENCES [GD2C2019].[gd_esquema].[Tipo_Pago] (tipo_pago_id),
	CONSTRAINT [FK_Carga_Credito_cliente_id] FOREIGN KEY(carga_credito_id_cliente)
		REFERENCES [GD2C2019].[gd_esquema].[Cliente] (cliente_id),
	CONSTRAINT [FK_Carga_Credito_tarjeta_id] FOREIGN KEY(carga_credito_id_tarjeta)
		REFERENCES [GD2C2019].[gd_esquema].[Tarjeta] (tarjeta_id),
)

SET IDENTITY_INSERT [GD2C2019].[gd_esquema].[Funcionalidad] ON

-- funcionalidades
-- alta de usuario y login todos tienen acceso
INSERT INTO GD2C2019.gd_esquema.Funcionalidad(funcionalidad_id, funcionalidad_descripcion)
Values(1, 'ABM Rol')
INSERT INTO GD2C2019.gd_esquema.Funcionalidad(funcionalidad_id, funcionalidad_descripcion)
Values(2, 'ABM Cliente')
INSERT INTO GD2C2019.gd_esquema.Funcionalidad(funcionalidad_id, funcionalidad_descripcion)
Values(3, 'ABM Proveedor')
INSERT INTO GD2C2019.gd_esquema.Funcionalidad(funcionalidad_id, funcionalidad_descripcion)
Values(5, 'Modificacion Usuario')
INSERT INTO GD2C2019.gd_esquema.Funcionalidad(funcionalidad_id, funcionalidad_descripcion)
Values(6, 'Baja Usuario')
INSERT INTO GD2C2019.gd_esquema.Funcionalidad(funcionalidad_id, funcionalidad_descripcion)
Values(7, 'Carga de Credito')
INSERT INTO GD2C2019.gd_esquema.Funcionalidad(funcionalidad_id, funcionalidad_descripcion)
Values(8, 'Confeccion y Publicacion de Ofertas')
INSERT INTO GD2C2019.gd_esquema.Funcionalidad(funcionalidad_id, funcionalidad_descripcion)
Values(9, 'Compra de Ofertas')
INSERT INTO GD2C2019.gd_esquema.Funcionalidad(funcionalidad_id, funcionalidad_descripcion)
Values(10, 'Entrega/Consumo de Ofertas')
INSERT INTO GD2C2019.gd_esquema.Funcionalidad(funcionalidad_id, funcionalidad_descripcion)
Values(11, 'Facturacion a Proveedor')
INSERT INTO GD2C2019.gd_esquema.Funcionalidad(funcionalidad_id, funcionalidad_descripcion)
Values(4, 'Listado Estadistico')

SET IDENTITY_INSERT [GD2C2019].[gd_esquema].[Funcionalidad] OFF

SET IDENTITY_INSERT [GD2C2019].[gd_esquema].[Rol] ON

INSERT INTO GD2C2019.gd_esquema.Rol(rol_id, rol_nombre, rol_habilitado, rol_eliminado)
Values(1, 'administrativo', 1, 0)
INSERT INTO GD2C2019.gd_esquema.Rol(rol_id, rol_nombre, rol_habilitado, rol_eliminado)
Values(2, 'proveedor', 1, 0)
INSERT INTO GD2C2019.gd_esquema.Rol(rol_id, rol_nombre, rol_habilitado, rol_eliminado)
Values(3, 'cliente', 1, 0)

SET IDENTITY_INSERT [GD2C2019].[gd_esquema].[Rol] OFF

-- agrego tipos de pago
-- crear tipo de pago automatico y usarlo cuando se da de alta al cliente
SET IDENTITY_INSERT [GD2C2019].[gd_esquema].[Tipo_Pago] ON

INSERT INTO [gd_esquema].[Tipo_Pago](tipo_pago_id, tipo_pago_nombre) VALUES (1, 'automatico')
INSERT INTO [gd_esquema].[Tipo_Pago](tipo_pago_id, tipo_pago_nombre) VALUES (2, 'efectivo')
INSERT INTO [gd_esquema].[Tipo_Pago](tipo_pago_id, tipo_pago_nombre) VALUES (3, 'credito')

SET IDENTITY_INSERT [GD2C2019].[gd_esquema].[Tipo_Pago] OFF

-- cuando se crea un cliente se le debitan $200:
USE [GD2C2019]
GO
/****** Object:  Trigger [gd_esquema].[alta_cliente]    Script Date: 11/10/2019 6:48:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [gd_esquema].[alta_cliente]
ON [GD2C2019].[gd_esquema].[Cliente]
AFTER INSERT
AS
BEGIN TRANSACTION
	declare @id_cliente_nuevo varchar(64)
	SELECT @id_cliente_nuevo = c.cliente_id FROM Cliente c INNER JOIN inserted i 
	ON i.cliente_apellido = c.cliente_apellido
	AND i.cliente_dni = c.cliente_dni
	AND i.cliente_fecha_nacimiento = c.cliente_fecha_nacimiento
	AND i.cliente_nombre = c.cliente_nombre
	AND i.cliente_mail = c.cliente_mail
	-- usar cursores?
	INSERT INTO gd_esquema.Carga_Credito(carga_credito_id_cliente, carga_credito_monto, carga_credito_id_tipo_pago, carga_credito_fecha) 
	VALUES (@id_cliente_nuevo, 200, 1, GETDATE()) -- todo: hay que usar la fecha del archivo de config
COMMIT TRANSACTION
GO
-- validar que cliente que carga credito esté habilitado
CREATE TRIGGER [gd_esquema].validez_cliente_credito
ON [GD2C2019].[gd_esquema].Carga_Credito
AFTER INSERT, UPDATE
AS
BEGIN TRANSACTION
	IF EXISTS(SELECT 1 FROM inserted i
		WHERE EXISTS(SELECT 1 FROM Cliente c WHERE c.cliente_id = i.carga_credito_id_cliente AND c.cliente_habilitado = 0))
		BEGIN
			RAISERROR ( 'Un Cliente inhabilitado no puede cargar credito', 1, 1)
			ROLLBACK
			RETURN
		END
COMMIT TRANSACTION
GO

-- funcionalidades administrador
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (1, 1);
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (1, 2);
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (1, 3);
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (1, 5);
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (1, 6);
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (1, 7); -- esta bien?
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (1, 8);
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (1, 11);
-- funcionalidades proveedor
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (2, 5);
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (2, 8);
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (2, 10);
-- funcionalidades cliente
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (3, 5);
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (3, 7);
INSERT INTO gd_esquema.FuncionalidadxRol(funcionalidadxrol_id_rol, funcionalidadxrol_id_funcionalidad) VALUES (3, 9);

-- inserto las localidades
INSERT INTO [GD2C2019].[gd_esquema].[Localidad] (localidad_nombre) 
  SELECT distinct [GD2C2019].[gd_esquema].[Maestra].Cli_Ciudad from [GD2C2019].[gd_esquema].[Maestra] where [GD2C2019].[gd_esquema].[Maestra].Cli_Ciudad  is not null
  UNION SELECT distinct [GD2C2019].[gd_esquema].[Maestra].Provee_Ciudad from [GD2C2019].[gd_esquema].[Maestra] where [GD2C2019].[gd_esquema].[Maestra].Provee_Ciudad is not null 

-- inserto las direcciones
-- cod postal, departamento y numero piso no conozco, va 0
insert into [GD2C2019].[gd_esquema].Domicilio (domicilio_calle, domicilio_id_localidad, domicilio_codigo_postal, domicilio_departamento, domicilio_numero_piso)
select distinct d.Cli_Direccion, l.localidad_id, 0, 0, 0
from [GD2C2019].[gd_esquema].[Maestra] d
inner join [GD2C2019].[gd_esquema].Localidad l on l.localidad_nombre = d.Cli_Ciudad 
where d.Cli_Direccion is not null
union select distinct p.Provee_Dom, lo.localidad_id, 0, 0, 0
from [GD2C2019].[gd_esquema].[Maestra] p
inner join [GD2C2019].[gd_esquema].Localidad lo on lo.localidad_nombre = p.Provee_Ciudad
where p.Provee_Dom is not null

-- inserto los usuarios (solo clientes por ahora), por default el username es el dni
insert into [GD2C2019].[gd_esquema].Usuario (usuario_username, usuario_password)
  select distinct m.Cli_Dni, HASHBYTES('SHA2_256','1234') from [GD2C2019].[gd_esquema].[Maestra] m where m.Cli_Dni is not null
-- para seleccionar el usuario y que pw se vea bien hacer: select u.usuario_username, CONVERT(binary(32), u.usuario_password) from [GD2C2019].[gd_esquema].Usuario u
-- todo: transformar a hexa el valor

-- inserto clientes
-- por default en el credito les pongo 0, despues en procedure lo calculo y pongo bien
insert into [GD2C2019].[gd_esquema].Cliente (cliente_dni, cliente_id_usuario, cliente_nombre, cliente_apellido, cliente_mail, 
cliente_telefono, cliente_fecha_nacimiento, cliente_id_domicilio, cliente_credito)
select distinct m.Cli_Dni, u.usuario_username, m.Cli_Nombre, m.Cli_Apellido, m.Cli_Mail, m.Cli_Telefono, m.Cli_Fecha_Nac, d.domicilio_id, 0
from [GD2C2019].[gd_esquema].[Maestra] m
left join [GD2C2019].[gd_esquema].Localidad l on l.localidad_nombre = m.Cli_Ciudad
left join [GD2C2019].[gd_esquema].Domicilio d on d.domicilio_calle = m.Cli_Direccion and l.localidad_id = d.domicilio_id_localidad
join [GD2C2019].[gd_esquema].Usuario u on u.usuario_username = m.Cli_Dni
 
-- inserto cargas
-- como no especifica tarjeta, pongo null
insert into [gd_esquema].Carga_Credito (
carga_credito_id_cliente,
carga_credito_id_tipo_pago,
carga_credito_id_tarjeta,
carga_credito_fecha,
carga_credito_monto)
select c.cliente_id, (case when m.Tipo_Pago_Desc = 'Crédito' then (select t.tipo_pago_id from [gd_esquema].Tipo_Pago t where t.tipo_pago_nombre = 'credito') 
when m.Tipo_Pago_Desc = 'Efectivo' then (select t.tipo_pago_id from [gd_esquema].Tipo_Pago t where t.tipo_pago_nombre = 'efectivo') 
else 0 end), NULL
, m.Carga_Fecha, m.Carga_Credito 
from [gd_esquema].Maestra m
join [gd_esquema].Cliente c on c.cliente_dni = m.Cli_Dni
where m.Tipo_Pago_Desc is not null and m.Carga_Credito is not null and m.Carga_Fecha is not null

-- inserto a mis usuarios con el rol correspondiente
-- hasta aca solo cargue clientes, por lo tanto, todos tienen el rol de cliente
insert into [gd_esquema].RolesxUsuario (rolesxusuario_id_rol, rolesxusuario_id_usuario)
select 3, u.usuario_username from [gd_esquema].Usuario u
-- HACER TRIGGER CUANDO CLIENTE CARGA CREDITO O COMPRA ALGO, ACTUALIZAR EL CLIENTE_CREDITO

/*
todo: El alumno deberá determinar un procedimiento para evitar la generación de clientes “gemelos” (distinto nombre de usuario, pero igual datos identificatorios según se justifique en la estrategia de resolución). X
Toda creación de cliente nuevo, implica una carga de dinero de bienvenida de $200 X
validar que usuario que compra ofertas o carga credito este habiltiado X OFERTAS ES DE NICO
no pueden existir 2 proveedores con la misma razón social y cuit. NICO
Un proveedor inhabilitado no podrá armar ofertas NICO
ofertas: fecha debe ser mayor o igual a la fecha actual del sistema. NICO
un cupón no puede ser canjeado más de una vez, si el cupón se venció tampoco podrá ser canjeado TODO
crear usuario de cada tipo
*/