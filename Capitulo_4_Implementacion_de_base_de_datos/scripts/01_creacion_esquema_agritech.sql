-- =============================================================================
-- PROYECTO: AgriTech (AgroProyectados)
-- MOTOR:    Microsoft SQL Server (T-SQL)
-- DESCRIPCIÓN: Modelo físico completo (32 tablas, PK, FK, NOT NULL, UNIQUE,
--              CHECK, DEFAULT e Índices Únicos Filtrados)
-- =============================================================================

IF DB_ID('AgriTechDB') IS NULL
BEGIN
    CREATE DATABASE AgriTechDB;
END
GO

USE AgriTechDB;
GO

-- =============================================================================
-- MÓDULO 1: SEGURIDAD, ACCESOS Y MULTIEMPRESA
-- =============================================================================

CREATE TABLE dbo.Empresa (
    id_empresa  INT IDENTITY(1,1) NOT NULL,
    ruc         CHAR(11)          NOT NULL,
    nombre      VARCHAR(150)      NOT NULL,
    direccion   VARCHAR(200)      NOT NULL,
    estado      BIT               NOT NULL CONSTRAINT DF_Empresa_Estado DEFAULT 1,
    CONSTRAINT PK_Empresa PRIMARY KEY (id_empresa),
    CONSTRAINT UQ_Empresa_Ruc UNIQUE (ruc),
    CONSTRAINT UQ_Empresa_Nombre UNIQUE (nombre),
    CONSTRAINT CK_Empresa_Ruc CHECK (LEN(ruc) = 11 AND ruc NOT LIKE '%[^0-9]%')
);
GO

CREATE TABLE dbo.Rol (
    id_rol      INT IDENTITY(1,1) NOT NULL,
    nombre_rol  VARCHAR(50)       NOT NULL,
    descripcion VARCHAR(MAX)      NULL,
    estado      BIT               NOT NULL CONSTRAINT DF_Rol_Estado DEFAULT 1,
    CONSTRAINT PK_Rol PRIMARY KEY (id_rol),
    CONSTRAINT UQ_Rol_NombreRol UNIQUE (nombre_rol)
);
GO

CREATE TABLE dbo.Trabajador (
    id_trabajador    INT IDENTITY(1,1) NOT NULL,
    id_empresa       INT               NOT NULL,
    dni              CHAR(8)           NOT NULL,
    nombres          VARCHAR(100)      NOT NULL,
    apellidos        VARCHAR(100)      NOT NULL,
    telefono         VARCHAR(20)       NULL,
    direccion        VARCHAR(200)      NULL,
    fecha_nacimiento DATE              NOT NULL,
    fecha_ingreso    DATE              NOT NULL CONSTRAINT DF_Trabajador_FechaIngreso DEFAULT CAST(GETDATE() AS DATE),
    cargo            VARCHAR(100)      NOT NULL,
    estado           BIT               NOT NULL CONSTRAINT DF_Trabajador_Estado DEFAULT 1,
    CONSTRAINT PK_Trabajador PRIMARY KEY (id_trabajador),
    CONSTRAINT FK_Trabajador_Empresa FOREIGN KEY (id_empresa) REFERENCES dbo.Empresa(id_empresa),
    CONSTRAINT UQ_Trabajador_Empresa_Dni UNIQUE (id_empresa, dni),
    CONSTRAINT CK_Trabajador_Dni CHECK (LEN(dni) = 8 AND dni NOT LIKE '%[^0-9]%'),
    CONSTRAINT CK_Trabajador_Fechas CHECK (fecha_ingreso >= fecha_nacimiento)
);
GO

CREATE TABLE dbo.Usuario (
    id_usuario      INT IDENTITY(1,1) NOT NULL,
    id_empresa      INT               NOT NULL,
    id_trabajador   INT               NULL,
    email           VARCHAR(150)      NOT NULL,
    contrasena_hash VARCHAR(255)      NOT NULL,
    nombre_usuario  VARCHAR(100)      NOT NULL,
    fecha_creacion  DATETIME2(0)      NOT NULL CONSTRAINT DF_Usuario_FechaCreacion DEFAULT SYSDATETIME(),
    ultimo_acceso   DATETIME2(0)      NULL,
    estado          BIT               NOT NULL CONSTRAINT DF_Usuario_Estado DEFAULT 1,
    CONSTRAINT PK_Usuario PRIMARY KEY (id_usuario),
    CONSTRAINT FK_Usuario_Empresa FOREIGN KEY (id_empresa) REFERENCES dbo.Empresa(id_empresa),
    CONSTRAINT FK_Usuario_Trabajador FOREIGN KEY (id_trabajador) REFERENCES dbo.Trabajador(id_trabajador),
    CONSTRAINT UQ_Usuario_Email UNIQUE (email),
    CONSTRAINT UQ_Usuario_Empresa_NombreUsuario UNIQUE (id_empresa, nombre_usuario),
    CONSTRAINT CK_Usuario_Email CHECK (email LIKE '%_@__%.__%')
);
GO

CREATE TABLE dbo.Usuario_Rol (
    id_usuario       INT          NOT NULL,
    id_rol           INT          NOT NULL,
    fecha_asignacion DATETIME2(0) NOT NULL CONSTRAINT DF_UsuarioRol_Fecha DEFAULT SYSDATETIME(),
    estado           BIT          NOT NULL CONSTRAINT DF_UsuarioRol_Estado DEFAULT 1,
    CONSTRAINT PK_Usuario_Rol PRIMARY KEY (id_usuario, id_rol),
    CONSTRAINT FK_UsuarioRol_Usuario FOREIGN KEY (id_usuario) REFERENCES dbo.Usuario(id_usuario),
    CONSTRAINT FK_UsuarioRol_Rol FOREIGN KEY (id_rol) REFERENCES dbo.Rol(id_rol)
);
GO

-- =============================================================================
-- MÓDULO 2: GESTIÓN LABORAL Y PLANIFICACIÓN
-- =============================================================================

CREATE TABLE dbo.Tipo_Labor (
    id_tipo_labor INT IDENTITY(1,1) NOT NULL,
    id_empresa    INT               NOT NULL,
    nombre_labor  VARCHAR(100)      NOT NULL,
    descripcion   VARCHAR(MAX)      NULL,
    estado        BIT               NOT NULL CONSTRAINT DF_TipoLabor_Estado DEFAULT 1,
    CONSTRAINT PK_Tipo_Labor PRIMARY KEY (id_tipo_labor),
    CONSTRAINT FK_TipoLabor_Empresa FOREIGN KEY (id_empresa) REFERENCES dbo.Empresa(id_empresa),
    CONSTRAINT UQ_TipoLabor_Empresa_Nombre UNIQUE (id_empresa, nombre_labor)
);
GO

CREATE TABLE dbo.Registro_Labor (
    id_registro_labor INT IDENTITY(1,1) NOT NULL,
    id_trabajador     INT               NOT NULL,
    id_tipo_labor     INT               NOT NULL,
    fecha_labor       DATE              NOT NULL CONSTRAINT DF_RegistroLabor_Fecha DEFAULT CAST(GETDATE() AS DATE),
    horas_invertidas  DECIMAL(5,2)      NOT NULL,
    observaciones     VARCHAR(MAX)      NULL,
    fecha_registro    DATETIME2(0)      NOT NULL CONSTRAINT DF_RegistroLabor_FechaReg DEFAULT SYSDATETIME(),
    estado            BIT               NOT NULL CONSTRAINT DF_RegistroLabor_Estado DEFAULT 1,
    CONSTRAINT PK_Registro_Labor PRIMARY KEY (id_registro_labor),
    CONSTRAINT FK_RegistroLabor_Trabajador FOREIGN KEY (id_trabajador) REFERENCES dbo.Trabajador(id_trabajador),
    CONSTRAINT FK_RegistroLabor_TipoLabor FOREIGN KEY (id_tipo_labor) REFERENCES dbo.Tipo_Labor(id_tipo_labor),
    CONSTRAINT CK_RegistroLabor_Horas CHECK (horas_invertidas > 0 AND horas_invertidas <= 24)
);
GO

CREATE TABLE dbo.Planificacion_Actividad (
    id_planificacion INT IDENTITY(1,1) NOT NULL,
    id_empresa       INT               NOT NULL,
    id_tipo_labor    INT               NOT NULL,
    id_trabajador    INT               NOT NULL,
    fecha_programada DATE              NOT NULL,
    hora_programada  TIME(0)           NOT NULL,
    estado_ejecucion VARCHAR(50)       NOT NULL CONSTRAINT DF_Planificacion_Estado DEFAULT 'Pendiente',
    observaciones    VARCHAR(MAX)      NULL,
    CONSTRAINT PK_Planificacion_Actividad PRIMARY KEY (id_planificacion),
    CONSTRAINT FK_Planificacion_Empresa FOREIGN KEY (id_empresa) REFERENCES dbo.Empresa(id_empresa),
    CONSTRAINT FK_Planificacion_TipoLabor FOREIGN KEY (id_tipo_labor) REFERENCES dbo.Tipo_Labor(id_tipo_labor),
    CONSTRAINT FK_Planificacion_Trabajador FOREIGN KEY (id_trabajador) REFERENCES dbo.Trabajador(id_trabajador),
    CONSTRAINT UQ_Planificacion_Trabajador_Horario UNIQUE (id_empresa, id_trabajador, fecha_programada, hora_programada),
    CONSTRAINT CK_Planificacion_Estado CHECK (estado_ejecucion IN ('Pendiente', 'En Progreso', 'Completada', 'Vencida'))
);
GO

-- =============================================================================
-- MÓDULO 3: GESTIÓN AGRÍCOLA
-- =============================================================================

CREATE TABLE dbo.Parcela (
    id_parcela       INT IDENTITY(1,1) NOT NULL,
    id_empresa       INT               NOT NULL,
    nombre_parcela   VARCHAR(100)      NOT NULL,
    tamano_hectareas DECIMAL(10,2)     NOT NULL,
    ubicacion        VARCHAR(200)      NULL,
    tipo_suelo       VARCHAR(100)      NULL,
    estado           VARCHAR(20)       NOT NULL CONSTRAINT DF_Parcela_Estado DEFAULT 'Disponible',
    observaciones    VARCHAR(MAX)      NULL,
    CONSTRAINT PK_Parcela PRIMARY KEY (id_parcela),
    CONSTRAINT FK_Parcela_Empresa FOREIGN KEY (id_empresa) REFERENCES dbo.Empresa(id_empresa),
    CONSTRAINT UQ_Parcela_Empresa_Nombre UNIQUE (id_empresa, nombre_parcela),
    CONSTRAINT CK_Parcela_Tamano CHECK (tamano_hectareas > 0),
    CONSTRAINT CK_Parcela_Estado CHECK (estado IN ('Disponible', 'En uso', 'Inactiva'))
);
GO

CREATE TABLE dbo.Especie_Cultivo (
    id_especie_cultivo  INT IDENTITY(1,1) NOT NULL,
    nombre_cultivo      VARCHAR(100)      NOT NULL,
    descripcion         VARCHAR(MAX)      NULL,
    tipo_cultivo        VARCHAR(50)       NOT NULL,
    ciclo_dias_promedio INT               NOT NULL,
    estado              BIT               NOT NULL CONSTRAINT DF_EspecieCultivo_Estado DEFAULT 1,
    CONSTRAINT PK_Especie_Cultivo PRIMARY KEY (id_especie_cultivo),
    CONSTRAINT UQ_EspecieCultivo_Nombre UNIQUE (nombre_cultivo),
    CONSTRAINT CK_EspecieCultivo_Dias CHECK (ciclo_dias_promedio > 0)
);
GO

CREATE TABLE dbo.Ciclo_Siembra (
    id_ciclo_siembra   INT IDENTITY(1,1) NOT NULL,
    id_parcela         INT               NOT NULL,
    id_especie_cultivo INT               NOT NULL,
    fecha_inicio       DATE              NOT NULL,
    fecha_fin_esperada DATE              NOT NULL,
    fecha_fin_real     DATE              NULL,
    area_sembrada      DECIMAL(10,2)     NOT NULL,
    estado             VARCHAR(20)       NOT NULL CONSTRAINT DF_CicloSiembra_Estado DEFAULT 'En curso',
    observaciones      VARCHAR(MAX)      NULL,
    CONSTRAINT PK_Ciclo_Siembra PRIMARY KEY (id_ciclo_siembra),
    CONSTRAINT FK_CicloSiembra_Parcela FOREIGN KEY (id_parcela) REFERENCES dbo.Parcela(id_parcela),
    CONSTRAINT FK_CicloSiembra_Cultivo FOREIGN KEY (id_especie_cultivo) REFERENCES dbo.Especie_Cultivo(id_especie_cultivo),
    CONSTRAINT UQ_CicloSiembra_Parcela_Cultivo_Inicio UNIQUE (id_parcela, id_especie_cultivo, fecha_inicio),
    CONSTRAINT CK_CicloSiembra_Area CHECK (area_sembrada > 0),
    CONSTRAINT CK_CicloSiembra_FechaEsp CHECK (fecha_fin_esperada >= fecha_inicio),
    CONSTRAINT CK_CicloSiembra_FechaReal CHECK (fecha_fin_real IS NULL OR fecha_fin_real >= fecha_inicio),
    CONSTRAINT CK_CicloSiembra_Estado CHECK (estado IN ('En curso', 'Finalizado', 'Cancelado'))
);
GO

CREATE TABLE dbo.Cosecha (
    id_cosecha        INT IDENTITY(1,1) NOT NULL,
    id_ciclo_siembra  INT               NOT NULL,
    fecha_cosecha     DATE              NOT NULL CONSTRAINT DF_Cosecha_Fecha DEFAULT CAST(GETDATE() AS DATE),
    cantidad_obtenida DECIMAL(12,2)     NOT NULL,
    unidad_medida     VARCHAR(20)       NOT NULL CONSTRAINT DF_Cosecha_Unidad DEFAULT 'kg',
    calidad           VARCHAR(50)       NOT NULL CONSTRAINT DF_Cosecha_Calidad DEFAULT 'Primera',
    observaciones     VARCHAR(MAX)      NULL,
    fecha_registro    DATETIME2(0)      NOT NULL CONSTRAINT DF_Cosecha_FechaReg DEFAULT SYSDATETIME(),
    CONSTRAINT PK_Cosecha PRIMARY KEY (id_cosecha),
    CONSTRAINT FK_Cosecha_CicloSiembra FOREIGN KEY (id_ciclo_siembra) REFERENCES dbo.Ciclo_Siembra(id_ciclo_siembra),
    CONSTRAINT CK_Cosecha_Cantidad CHECK (cantidad_obtenida > 0)
);
GO

-- =============================================================================
-- MÓDULO 4: GESTIÓN GANADERA, GENEALOGÍA Y REPRODUCCIÓN
-- =============================================================================

CREATE TABLE dbo.Especie_Animal (
    id_especie_animal INT IDENTITY(1,1) NOT NULL,
    nombre_especie    VARCHAR(100)      NOT NULL,
    descripcion       VARCHAR(MAX)      NULL,
    estado            BIT               NOT NULL CONSTRAINT DF_EspecieAnimal_Estado DEFAULT 1,
    CONSTRAINT PK_Especie_Animal PRIMARY KEY (id_especie_animal),
    CONSTRAINT UQ_EspecieAnimal_Nombre UNIQUE (nombre_especie)
);
GO

CREATE TABLE dbo.Raza (
    id_raza           INT IDENTITY(1,1) NOT NULL,
    id_especie_animal INT               NOT NULL,
    nombre_raza       VARCHAR(100)      NOT NULL,
    descripcion       VARCHAR(MAX)      NULL,
    estado            BIT               NOT NULL CONSTRAINT DF_Raza_Estado DEFAULT 1,
    CONSTRAINT PK_Raza PRIMARY KEY (id_raza),
    CONSTRAINT FK_Raza_EspecieAnimal FOREIGN KEY (id_especie_animal) REFERENCES dbo.Especie_Animal(id_especie_animal),
    CONSTRAINT UQ_Raza_Especie_Nombre UNIQUE (id_especie_animal, nombre_raza)
);
GO

CREATE TABLE dbo.Corral (
    id_corral        INT IDENTITY(1,1) NOT NULL,
    id_empresa       INT               NOT NULL,
    nombre_corral    VARCHAR(100)      NOT NULL,
    capacidad_maxima INT               NOT NULL,
    ubicacion        VARCHAR(200)      NULL,
    estado           VARCHAR(50)       NOT NULL CONSTRAINT DF_Corral_Estado DEFAULT 'En uso',
    CONSTRAINT PK_Corral PRIMARY KEY (id_corral),
    CONSTRAINT FK_Corral_Empresa FOREIGN KEY (id_empresa) REFERENCES dbo.Empresa(id_empresa),
    CONSTRAINT UQ_Corral_Empresa_Nombre UNIQUE (id_empresa, nombre_corral),
    CONSTRAINT CK_Corral_Capacidad CHECK (capacidad_maxima > 0),
    CONSTRAINT CK_Corral_Estado CHECK (estado IN ('En uso', 'Mantenimiento', 'Inactivo'))
);
GO

CREATE TABLE dbo.Animal (
    id_animal        INT IDENTITY(1,1) NOT NULL,
    id_empresa       INT               NOT NULL,
    id_raza          INT               NOT NULL,
    id_corral        INT               NOT NULL,
    id_padre         INT               NULL,
    id_madre         INT               NULL,
    codigo_arete     VARCHAR(50)       NOT NULL,
    sexo             CHAR(1)           NOT NULL,
    fecha_nacimiento DATE              NOT NULL,
    proposito        VARCHAR(50)       NOT NULL,
    estado_vital     VARCHAR(50)       NOT NULL CONSTRAINT DF_Animal_EstadoVital DEFAULT 'Vivo',
    CONSTRAINT PK_Animal PRIMARY KEY (id_animal),
    CONSTRAINT FK_Animal_Empresa FOREIGN KEY (id_empresa) REFERENCES dbo.Empresa(id_empresa),
    CONSTRAINT FK_Animal_Raza FOREIGN KEY (id_raza) REFERENCES dbo.Raza(id_raza),
    CONSTRAINT FK_Animal_Corral FOREIGN KEY (id_corral) REFERENCES dbo.Corral(id_corral),
    CONSTRAINT FK_Animal_Padre FOREIGN KEY (id_padre) REFERENCES dbo.Animal(id_animal),
    CONSTRAINT FK_Animal_Madre FOREIGN KEY (id_madre) REFERENCES dbo.Animal(id_animal),
    CONSTRAINT UQ_Animal_Empresa_CodigoArete UNIQUE (id_empresa, codigo_arete),
    CONSTRAINT CK_Animal_Sexo CHECK (sexo IN ('M', 'F')),
    CONSTRAINT CK_Animal_Proposito CHECK (proposito IN ('Carne', 'Leche', 'Pie de cría', 'Doble propósito')),
    CONSTRAINT CK_Animal_EstadoVital CHECK (estado_vital IN ('Vivo', 'Muerto', 'Vendido')),
    CONSTRAINT CK_Animal_NoAutoPadre CHECK (id_padre IS NULL OR id_padre <> id_animal),
    CONSTRAINT CK_Animal_NoAutoMadre CHECK (id_madre IS NULL OR id_madre <> id_animal),
    CONSTRAINT CK_Animal_PadresDistintos CHECK (id_padre IS NULL OR id_madre IS NULL OR id_padre <> id_madre)
);
GO

CREATE TABLE dbo.Lote_Animal (
    id_lote_animal   INT IDENTITY(1,1) NOT NULL,
    id_empresa       INT               NOT NULL,
    id_raza          INT               NOT NULL,
    id_corral        INT               NOT NULL,
    codigo_lote      VARCHAR(100)      NOT NULL,
    fecha_creacion   DATE              NOT NULL CONSTRAINT DF_LoteAnimal_Fecha DEFAULT CAST(GETDATE() AS DATE),
    cantidad_inicial INT               NOT NULL,
    cantidad_actual  INT               NOT NULL,
    proposito        VARCHAR(50)       NOT NULL,
    estado           BIT               NOT NULL CONSTRAINT DF_LoteAnimal_Estado DEFAULT 1,
    CONSTRAINT PK_Lote_Animal PRIMARY KEY (id_lote_animal),
    CONSTRAINT FK_LoteAnimal_Empresa FOREIGN KEY (id_empresa) REFERENCES dbo.Empresa(id_empresa),
    CONSTRAINT FK_LoteAnimal_Raza FOREIGN KEY (id_raza) REFERENCES dbo.Raza(id_raza),
    CONSTRAINT FK_LoteAnimal_Corral FOREIGN KEY (id_corral) REFERENCES dbo.Corral(id_corral),
    CONSTRAINT UQ_LoteAnimal_Empresa_Codigo UNIQUE (id_empresa, codigo_lote),
    CONSTRAINT CK_LoteAnimal_CantInicial CHECK (cantidad_inicial > 0),
    CONSTRAINT CK_LoteAnimal_CantActual CHECK (cantidad_actual >= 0 AND cantidad_actual <= cantidad_inicial)
);
GO

CREATE TABLE dbo.Control_Peso (
    id_control_peso INT IDENTITY(1,1) NOT NULL,
    id_animal       INT               NULL,
    id_lote_animal  INT               NULL,
    fecha_pesaje    DATE              NOT NULL CONSTRAINT DF_ControlPeso_Fecha DEFAULT CAST(GETDATE() AS DATE),
    peso_registrado DECIMAL(10,2)     NOT NULL,
    unidad_medida   VARCHAR(20)       NOT NULL CONSTRAINT DF_ControlPeso_Unidad DEFAULT 'kg',
    observaciones   VARCHAR(MAX)      NULL,
    CONSTRAINT PK_Control_Peso PRIMARY KEY (id_control_peso),
    CONSTRAINT FK_ControlPeso_Animal FOREIGN KEY (id_animal) REFERENCES dbo.Animal(id_animal),
    CONSTRAINT FK_ControlPeso_Lote FOREIGN KEY (id_lote_animal) REFERENCES dbo.Lote_Animal(id_lote_animal),
    CONSTRAINT CK_ControlPeso_Peso CHECK (peso_registrado > 0),
    CONSTRAINT CK_ControlPeso_Unidad CHECK (unidad_medida IN ('kg', 'g')),
    CONSTRAINT CK_ControlPeso_Xor CHECK (
        (id_animal IS NOT NULL AND id_lote_animal IS NULL) OR
        (id_animal IS NULL AND id_lote_animal IS NOT NULL)
    )
);
GO

-- Índices únicos filtrados para evitar doble pesaje en el mismo día
CREATE UNIQUE INDEX UX_ControlPeso_Animal_Fecha
    ON dbo.Control_Peso (id_animal, fecha_pesaje)
    WHERE id_animal IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_ControlPeso_Lote_Fecha
    ON dbo.Control_Peso (id_lote_animal, fecha_pesaje)
    WHERE id_lote_animal IS NOT NULL;
GO

CREATE TABLE dbo.Empadre (
    id_empadre           INT IDENTITY(1,1) NOT NULL,
    id_padre             INT               NOT NULL,
    id_madre             INT               NOT NULL,
    id_trabajador        INT               NOT NULL,
    fecha_empadre        DATE              NOT NULL,
    tipo_empadre         VARCHAR(50)       NOT NULL CONSTRAINT DF_Empadre_Tipo DEFAULT 'Monta natural',
    fecha_parto_esperada DATE              NOT NULL,
    estado_gestacion     VARCHAR(50)       NOT NULL CONSTRAINT DF_Empadre_Estado DEFAULT 'Pendiente',
    CONSTRAINT PK_Empadre PRIMARY KEY (id_empadre),
    CONSTRAINT FK_Empadre_Padre FOREIGN KEY (id_padre) REFERENCES dbo.Animal(id_animal),
    CONSTRAINT FK_Empadre_Madre FOREIGN KEY (id_madre) REFERENCES dbo.Animal(id_animal),
    CONSTRAINT FK_Empadre_Trabajador FOREIGN KEY (id_trabajador) REFERENCES dbo.Trabajador(id_trabajador),
    CONSTRAINT UQ_Empadre_Padre_Madre_Fecha UNIQUE (id_padre, id_madre, fecha_empadre),
    CONSTRAINT CK_Empadre_PadresDistintos CHECK (id_padre <> id_madre),
    CONSTRAINT CK_Empadre_Tipo CHECK (tipo_empadre IN ('Monta natural', 'Inseminación artificial', 'Transferencia embrionaria')),
    CONSTRAINT CK_Empadre_FechaParto CHECK (fecha_parto_esperada > fecha_empadre),
    CONSTRAINT CK_Empadre_Estado CHECK (estado_gestacion IN ('Confirmada', 'Fallida', 'Pendiente'))
);
GO

CREATE TABLE dbo.Parto (
    id_parto          INT IDENTITY(1,1) NOT NULL,
    id_empadre        INT               NOT NULL,
    fecha_parto_real  DATE              NOT NULL,
    crias_vivas       INT               NOT NULL CONSTRAINT DF_Parto_Vivas DEFAULT 0,
    crias_muertas     INT               NOT NULL CONSTRAINT DF_Parto_Muertas DEFAULT 0,
    peso_camada_total DECIMAL(10,2)     NOT NULL,
    complicaciones    VARCHAR(MAX)      NULL,
    estado            BIT               NOT NULL CONSTRAINT DF_Parto_Estado DEFAULT 1,
    CONSTRAINT PK_Parto PRIMARY KEY (id_parto),
    CONSTRAINT FK_Parto_Empadre FOREIGN KEY (id_empadre) REFERENCES dbo.Empadre(id_empadre),
    CONSTRAINT UQ_Parto_Empadre UNIQUE (id_empadre),
    CONSTRAINT CK_Parto_Vivas CHECK (crias_vivas >= 0),
    CONSTRAINT CK_Parto_Muertas CHECK (crias_muertas >= 0),
    CONSTRAINT CK_Parto_TotalCrias CHECK (crias_vivas + crias_muertas > 0),
    CONSTRAINT CK_Parto_Peso CHECK (peso_camada_total >= 0)
);
GO

-- =============================================================================
-- MÓDULO 5: SANIDAD Y ALIMENTACIÓN
-- =============================================================================

CREATE TABLE dbo.Enfermedad (
    id_enfermedad     INT IDENTITY(1,1) NOT NULL,
    id_especie_animal INT               NOT NULL,
    nombre_enfermedad VARCHAR(100)      NOT NULL,
    descripcion       VARCHAR(MAX)      NULL,
    tipo_enfermedad   VARCHAR(50)       NOT NULL,
    sintomas          VARCHAR(MAX)      NULL,
    gravedad          VARCHAR(20)       NOT NULL,
    estado            BIT               NOT NULL CONSTRAINT DF_Enfermedad_Estado DEFAULT 1,
    CONSTRAINT PK_Enfermedad PRIMARY KEY (id_enfermedad),
    CONSTRAINT FK_Enfermedad_Especie FOREIGN KEY (id_especie_animal) REFERENCES dbo.Especie_Animal(id_especie_animal),
    CONSTRAINT UQ_Enfermedad_Especie_Nombre UNIQUE (id_especie_animal, nombre_enfermedad),
    CONSTRAINT CK_Enfermedad_Tipo CHECK (tipo_enfermedad IN ('Viral', 'Bacteriana', 'Parasitaria', 'Metabólica', 'Fúngica')),
    CONSTRAINT CK_Enfermedad_Gravedad CHECK (gravedad IN ('Leve', 'Moderada', 'Grave'))
);
GO

CREATE TABLE dbo.Diagnostico (
    id_diagnostico    INT IDENTITY(1,1) NOT NULL,
    id_animal         INT               NOT NULL,
    id_enfermedad     INT               NOT NULL,
    id_trabajador     INT               NOT NULL,
    fecha_diagnostico DATETIME2(0)      NOT NULL CONSTRAINT DF_Diagnostico_Fecha DEFAULT SYSDATETIME(),
    resultado         VARCHAR(20)       NOT NULL,
    observaciones     VARCHAR(MAX)      NULL,
    estado            BIT               NOT NULL CONSTRAINT DF_Diagnostico_Estado DEFAULT 1,
    CONSTRAINT PK_Diagnostico PRIMARY KEY (id_diagnostico),
    CONSTRAINT FK_Diagnostico_Animal FOREIGN KEY (id_animal) REFERENCES dbo.Animal(id_animal),
    CONSTRAINT FK_Diagnostico_Enfermedad FOREIGN KEY (id_enfermedad) REFERENCES dbo.Enfermedad(id_enfermedad),
    CONSTRAINT FK_Diagnostico_Trabajador FOREIGN KEY (id_trabajador) REFERENCES dbo.Trabajador(id_trabajador),
    CONSTRAINT CK_Diagnostico_Resultado CHECK (resultado IN ('Positivo', 'Negativo', 'Sospechoso'))
);
GO

CREATE TABLE dbo.Tratamiento_Sanitario (
    id_tratamiento       INT IDENTITY(1,1) NOT NULL,
    id_diagnostico       INT               NULL,
    id_animal            INT               NULL,
    id_lote_animal       INT               NULL,
    id_enfermedad        INT               NOT NULL,
    id_trabajador        INT               NOT NULL,
    tipo_tratamiento     VARCHAR(50)       NOT NULL,
    descripcion          VARCHAR(MAX)      NULL,
    medicamento_aplicado VARCHAR(150)      NOT NULL,
    dosis                VARCHAR(50)       NOT NULL,
    fecha_aplicacion     DATETIME2(0)      NOT NULL CONSTRAINT DF_Tratamiento_Fecha DEFAULT SYSDATETIME(),
    observaciones        VARCHAR(MAX)      NULL,
    estado               BIT               NOT NULL CONSTRAINT DF_Tratamiento_Estado DEFAULT 1,
    CONSTRAINT PK_Tratamiento_Sanitario PRIMARY KEY (id_tratamiento),
    CONSTRAINT FK_Tratamiento_Diagnostico FOREIGN KEY (id_diagnostico) REFERENCES dbo.Diagnostico(id_diagnostico),
    CONSTRAINT FK_Tratamiento_Animal FOREIGN KEY (id_animal) REFERENCES dbo.Animal(id_animal),
    CONSTRAINT FK_Tratamiento_Lote FOREIGN KEY (id_lote_animal) REFERENCES dbo.Lote_Animal(id_lote_animal),
    CONSTRAINT FK_Tratamiento_Enfermedad FOREIGN KEY (id_enfermedad) REFERENCES dbo.Enfermedad(id_enfermedad),
    CONSTRAINT FK_Tratamiento_Trabajador FOREIGN KEY (id_trabajador) REFERENCES dbo.Trabajador(id_trabajador),
    CONSTRAINT CK_Tratamiento_Xor CHECK (
        (id_animal IS NOT NULL AND id_lote_animal IS NULL) OR
        (id_animal IS NULL AND id_lote_animal IS NOT NULL)
    )
);
GO

CREATE TABLE dbo.Racion_Dieta (
    id_racion                   INT IDENTITY(1,1) NOT NULL,
    id_especie_animal           INT               NOT NULL,
    nombre_racion               VARCHAR(100)      NOT NULL,
    descripcion                 VARCHAR(MAX)      NULL,
    etapa_destino               VARCHAR(50)       NOT NULL,
    cantidad_diaria_recomendada DECIMAL(10,2)     NOT NULL,
    unidad_medida               VARCHAR(20)       NOT NULL CONSTRAINT DF_RacionDieta_Unidad DEFAULT 'kg',
    estado                      BIT               NOT NULL CONSTRAINT DF_RacionDieta_Estado DEFAULT 1,
    CONSTRAINT PK_Racion_Dieta PRIMARY KEY (id_racion),
    CONSTRAINT FK_RacionDieta_Especie FOREIGN KEY (id_especie_animal) REFERENCES dbo.Especie_Animal(id_especie_animal),
    CONSTRAINT UQ_RacionDieta_Especie_Nombre UNIQUE (id_especie_animal, nombre_racion),
    CONSTRAINT CK_RacionDieta_Cantidad CHECK (cantidad_diaria_recomendada > 0),
    CONSTRAINT CK_RacionDieta_Unidad CHECK (unidad_medida IN ('kg', 'g'))
);
GO

CREATE TABLE dbo.Consumo_Alimentacion (
    id_consumo        INT IDENTITY(1,1) NOT NULL,
    id_racion         INT               NOT NULL,
    id_animal         INT               NULL,
    id_lote_animal    INT               NULL,
    id_corral         INT               NULL,
    fecha_consumo     DATE              NOT NULL CONSTRAINT DF_Consumo_Fecha DEFAULT CAST(GETDATE() AS DATE),
    cantidad_asignada DECIMAL(10,2)     NOT NULL,
    unidad_medida     VARCHAR(20)       NOT NULL CONSTRAINT DF_Consumo_Unidad DEFAULT 'kg',
    observaciones     VARCHAR(MAX)      NULL,
    fecha_registro    DATETIME2(0)      NOT NULL CONSTRAINT DF_Consumo_FechaReg DEFAULT SYSDATETIME(),
    CONSTRAINT PK_Consumo_Alimentacion PRIMARY KEY (id_consumo),
    CONSTRAINT FK_Consumo_Racion FOREIGN KEY (id_racion) REFERENCES dbo.Racion_Dieta(id_racion),
    CONSTRAINT FK_Consumo_Animal FOREIGN KEY (id_animal) REFERENCES dbo.Animal(id_animal),
    CONSTRAINT FK_Consumo_Lote FOREIGN KEY (id_lote_animal) REFERENCES dbo.Lote_Animal(id_lote_animal),
    CONSTRAINT FK_Consumo_Corral FOREIGN KEY (id_corral) REFERENCES dbo.Corral(id_corral),
    CONSTRAINT CK_Consumo_Cantidad CHECK (cantidad_asignada > 0),
    CONSTRAINT CK_Consumo_Unidad CHECK (unidad_medida IN ('kg', 'g')),
    CONSTRAINT CK_Consumo_XorTriple CHECK (
        (CASE WHEN id_animal IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN id_lote_animal IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN id_corral IS NOT NULL THEN 1 ELSE 0 END) = 1
    )
);
GO

-- =============================================================================
-- MÓDULO 6: INVENTARIO E INSUMOS
-- =============================================================================

CREATE TABLE dbo.Categoria_Insumo (
    id_categoria_insumo INT IDENTITY(1,1) NOT NULL,
    nombre_categoria    VARCHAR(100)      NOT NULL,
    descripcion         VARCHAR(MAX)      NULL,
    estado              BIT               NOT NULL CONSTRAINT DF_CategoriaInsumo_Estado DEFAULT 1,
    CONSTRAINT PK_Categoria_Insumo PRIMARY KEY (id_categoria_insumo),
    CONSTRAINT UQ_CategoriaInsumo_Nombre UNIQUE (nombre_categoria)
);
GO

CREATE TABLE dbo.Insumo (
    id_insumo           INT IDENTITY(1,1) NOT NULL,
    id_empresa          INT               NOT NULL,
    id_categoria_insumo INT               NOT NULL,
    nombre_insumo       VARCHAR(150)      NOT NULL,
    unidad_medida       VARCHAR(50)       NOT NULL,
    stock_minimo        DECIMAL(10,2)     NOT NULL CONSTRAINT DF_Insumo_StockMin DEFAULT 0,
    estado              BIT               NOT NULL CONSTRAINT DF_Insumo_Estado DEFAULT 1,
    CONSTRAINT PK_Insumo PRIMARY KEY (id_insumo),
    CONSTRAINT FK_Insumo_Empresa FOREIGN KEY (id_empresa) REFERENCES dbo.Empresa(id_empresa),
    CONSTRAINT FK_Insumo_Categoria FOREIGN KEY (id_categoria_insumo) REFERENCES dbo.Categoria_Insumo(id_categoria_insumo),
    CONSTRAINT UQ_Insumo_Empresa_Nombre UNIQUE (id_empresa, nombre_insumo),
    CONSTRAINT CK_Insumo_StockMin CHECK (stock_minimo >= 0)
);
GO

CREATE TABLE dbo.Kardex_Inventario (
    id_kardex        INT IDENTITY(1,1) NOT NULL,
    id_insumo        INT               NOT NULL,
    id_trabajador    INT               NOT NULL,
    tipo_movimiento  VARCHAR(20)       NOT NULL,
    cantidad         DECIMAL(10,2)     NOT NULL,
    fecha_movimiento DATETIME2(0)      NOT NULL CONSTRAINT DF_Kardex_Fecha DEFAULT SYSDATETIME(),
    costo_unitario   DECIMAL(10,2)     NULL,
    observaciones    VARCHAR(MAX)      NULL,
    CONSTRAINT PK_Kardex_Inventario PRIMARY KEY (id_kardex),
    CONSTRAINT FK_Kardex_Insumo FOREIGN KEY (id_insumo) REFERENCES dbo.Insumo(id_insumo),
    CONSTRAINT FK_Kardex_Trabajador FOREIGN KEY (id_trabajador) REFERENCES dbo.Trabajador(id_trabajador),
    CONSTRAINT CK_Kardex_Tipo CHECK (tipo_movimiento IN ('ENTRADA', 'SALIDA', 'MERMA')),
    CONSTRAINT CK_Kardex_Cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_Kardex_Costo CHECK (costo_unitario IS NULL OR costo_unitario >= 0)
);
GO

CREATE TABLE dbo.Aplicacion_Insumo (
    id_aplicacion_insumo INT IDENTITY(1,1) NOT NULL,
    id_kardex            INT               NOT NULL,
    id_ciclo_siembra     INT               NULL,
    id_tratamiento       INT               NULL,
    id_trabajador        INT               NOT NULL,
    dosis_aplicada       DECIMAL(10,2)     NOT NULL,
    fecha_aplicacion     DATE              NOT NULL CONSTRAINT DF_Aplicacion_Fecha DEFAULT CAST(GETDATE() AS DATE),
    observaciones        VARCHAR(MAX)      NULL,
    CONSTRAINT PK_Aplicacion_Insumo PRIMARY KEY (id_aplicacion_insumo),
    CONSTRAINT FK_Aplicacion_Kardex FOREIGN KEY (id_kardex) REFERENCES dbo.Kardex_Inventario(id_kardex),
    CONSTRAINT FK_Aplicacion_CicloSiembra FOREIGN KEY (id_ciclo_siembra) REFERENCES dbo.Ciclo_Siembra(id_ciclo_siembra),
    CONSTRAINT FK_Aplicacion_Tratamiento FOREIGN KEY (id_tratamiento) REFERENCES dbo.Tratamiento_Sanitario(id_tratamiento),
    CONSTRAINT FK_Aplicacion_Trabajador FOREIGN KEY (id_trabajador) REFERENCES dbo.Trabajador(id_trabajador),
    CONSTRAINT CK_Aplicacion_Dosis CHECK (dosis_aplicada > 0),
    CONSTRAINT CK_Aplicacion_Xor CHECK (
        (id_ciclo_siembra IS NOT NULL AND id_tratamiento IS NULL) OR
        (id_ciclo_siembra IS NULL AND id_tratamiento IS NOT NULL)
    )
);
GO

-- =============================================================================
-- MÓDULO 7: COMERCIALIZACIÓN Y VENTAS
-- =============================================================================

CREATE TABLE dbo.Cliente (
    id_cliente          INT IDENTITY(1,1) NOT NULL,
    id_empresa          INT               NOT NULL,
    tipo_documento      VARCHAR(20)       NOT NULL,
    numero_documento    VARCHAR(20)       NOT NULL,
    nombre_razon_social VARCHAR(150)      NOT NULL,
    telefono            VARCHAR(20)       NULL,
    direccion           VARCHAR(200)      NULL,
    estado              BIT               NOT NULL CONSTRAINT DF_Cliente_Estado DEFAULT 1,
    CONSTRAINT PK_Cliente PRIMARY KEY (id_cliente),
    CONSTRAINT FK_Cliente_Empresa FOREIGN KEY (id_empresa) REFERENCES dbo.Empresa(id_empresa),
    CONSTRAINT UQ_Cliente_Empresa_Documento UNIQUE (id_empresa, tipo_documento, numero_documento),
    CONSTRAINT CK_Cliente_TipoDoc CHECK (tipo_documento IN ('DNI', 'RUC', 'Pasaporte'))
);
GO

CREATE TABLE dbo.Venta (
    id_venta           INT IDENTITY(1,1) NOT NULL,
    id_empresa         INT               NOT NULL,
    id_cliente         INT               NOT NULL,
    id_usuario         INT               NOT NULL,
    fecha_venta        DATETIME2(0)      NOT NULL CONSTRAINT DF_Venta_Fecha DEFAULT SYSDATETIME(),
    tipo_comprobante   VARCHAR(50)       NOT NULL,
    numero_comprobante VARCHAR(50)       NOT NULL,
    monto_total        DECIMAL(12,2)     NOT NULL CONSTRAINT DF_Venta_Monto DEFAULT 0,
    estado             VARCHAR(50)       NOT NULL CONSTRAINT DF_Venta_Estado DEFAULT 'Pagado',
    CONSTRAINT PK_Venta PRIMARY KEY (id_venta),
    CONSTRAINT FK_Venta_Empresa FOREIGN KEY (id_empresa) REFERENCES dbo.Empresa(id_empresa),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (id_cliente) REFERENCES dbo.Cliente(id_cliente),
    CONSTRAINT FK_Venta_Usuario FOREIGN KEY (id_usuario) REFERENCES dbo.Usuario(id_usuario),
    CONSTRAINT UQ_Venta_Empresa_Comprobante UNIQUE (id_empresa, tipo_comprobante, numero_comprobante),
    CONSTRAINT CK_Venta_TipoComp CHECK (tipo_comprobante IN ('Boleta', 'Factura', 'Recibo Interno')),
    CONSTRAINT CK_Venta_Monto CHECK (monto_total >= 0),
    CONSTRAINT CK_Venta_Estado CHECK (estado IN ('Pagado', 'Pendiente', 'Anulado'))
);
GO

CREATE TABLE dbo.Detalle_Venta (
    id_detalle_venta INT IDENTITY(1,1) NOT NULL,
    id_venta         INT               NOT NULL,
    id_animal        INT               NULL,
    id_lote_animal   INT               NULL,
    id_cosecha       INT               NULL,
    cantidad         DECIMAL(10,2)     NOT NULL,
    precio_unitario  DECIMAL(12,2)     NOT NULL,
    subtotal         DECIMAL(12,2)     NOT NULL,
    CONSTRAINT PK_Detalle_Venta PRIMARY KEY (id_detalle_venta),
    CONSTRAINT FK_DetalleVenta_Venta FOREIGN KEY (id_venta) REFERENCES dbo.Venta(id_venta),
    CONSTRAINT FK_DetalleVenta_Animal FOREIGN KEY (id_animal) REFERENCES dbo.Animal(id_animal),
    CONSTRAINT FK_DetalleVenta_Lote FOREIGN KEY (id_lote_animal) REFERENCES dbo.Lote_Animal(id_lote_animal),
    CONSTRAINT FK_DetalleVenta_Cosecha FOREIGN KEY (id_cosecha) REFERENCES dbo.Cosecha(id_cosecha),
    CONSTRAINT CK_DetalleVenta_Cantidad CHECK (cantidad > 0),
    CONSTRAINT CK_DetalleVenta_Precio CHECK (precio_unitario >= 0),
    CONSTRAINT CK_DetalleVenta_Subtotal CHECK (subtotal >= 0),
    CONSTRAINT CK_DetalleVenta_XorTriple CHECK (
        (CASE WHEN id_animal IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN id_lote_animal IS NOT NULL THEN 1 ELSE 0 END) +
        (CASE WHEN id_cosecha IS NOT NULL THEN 1 ELSE 0 END) = 1
    )
);
GO

-- Índices únicos filtrados para evitar ítems duplicados en un mismo comprobante
CREATE UNIQUE INDEX UX_DetalleVenta_Venta_Animal
    ON dbo.Detalle_Venta (id_venta, id_animal)
    WHERE id_animal IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_DetalleVenta_Venta_Lote
    ON dbo.Detalle_Venta (id_venta, id_lote_animal)
    WHERE id_lote_animal IS NOT NULL;
GO

CREATE UNIQUE INDEX UX_DetalleVenta_Venta_Cosecha
    ON dbo.Detalle_Venta (id_venta, id_cosecha)
    WHERE id_cosecha IS NOT NULL;
GO
