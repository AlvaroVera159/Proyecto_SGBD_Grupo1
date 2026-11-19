USE AgriTechDB;
GO

-- 1. Empresas (Multi-tenant)
INSERT INTO dbo.Empresa (ruc, nombre, direccion) VALUES
('20601234567', 'Fundo AgroProyectados S.A.C.', 'Valle de Lurín Km 34, Lima'),
('20609876543', 'Granja San Isidro E.I.R.L.',   'Carretera Central Km 42, Huarochirí');

-- 2. Roles
INSERT INTO dbo.Rol (nombre_rol, descripcion) VALUES
('Administrador', 'Control total del fundo, usuarios, reportes y licencias'),
('Operario',      'Registro diario de labores, alimentación, pesajes e insumos'),
('Veterinario',   'Gestión de diagnósticos, tratamientos sanitarios y genealogía');

-- 3. Trabajadores
INSERT INTO dbo.Trabajador (id_empresa, dni, nombres, apellidos, telefono, direccion, fecha_nacimiento, fecha_ingreso, cargo) VALUES
(1, '45678901', 'Carlos', 'Mendoza Quispe',   '987654321', 'Lurín Mz B Lt 4',     '1985-04-12', '2022-01-10', 'Administrador de Fundo'),
(1, '71234568', 'Luis',   'Ramos Ccahuana',   '976543210', 'Pachacámac Sector 2', '1992-08-20', '2023-03-01', 'Operario Agropecuario'),
(1, '43219876', 'Ana',    'Salazar Paredes',  '965432109', 'Villa El Salvador',   '1988-11-05', '2023-05-15', 'Médico Veterinario'),
(2, '48901234', 'Jorge',  'Huamán Torres',    '954321098', 'Santa Eulalia Lt 9',  '1983-02-19', '2024-01-05', 'Propietario Criador');

-- 4. Usuarios y Usuario_Rol
INSERT INTO dbo.Usuario (id_empresa, id_trabajador, email, contrasena_hash, nombre_usuario) VALUES
(1, 1, 'cmendoza@agroproyectados.pe', 'HASH_SHA256_ADMIN_01', 'cmendoza'),
(1, 2, 'lramos@agroproyectados.pe',   'HASH_SHA256_OPER_02',  'lramos'),
(1, 3, 'asalazar@agroproyectados.pe', 'HASH_SHA256_VET_03',   'asalazar'),
(2, 4, 'jhuaman@granjasanisidro.pe',  'HASH_SHA256_ADMIN_04', 'jhuaman');

INSERT INTO dbo.Usuario_Rol (id_usuario, id_rol) VALUES
(1, 1), (2, 2), (3, 3), (4, 1);

-- 5. Tipos de Labor, Registros y Planificación
INSERT INTO dbo.Tipo_Labor (id_empresa, nombre_labor, descripcion) VALUES
(1, 'Riego Parcela',      'Riego tecnificado o por gravedad de cultivos forrajeros'),
(1, 'Alimentación Corral','Distribución de forraje verde y concentrado'),
(1, 'Limpieza de Pozas',  'Desinfección y cambio de cama en pozas de cuyes'),
(2, 'Alimentación Corral','Suministro diario de alfalfa y balanceado');

INSERT INTO dbo.Registro_Labor (id_trabajador, id_tipo_labor, fecha_labor, horas_invertidas, observaciones) VALUES
(2, 1, '2026-10-15', 3.50, 'Riego completo en Hectárea 1'),
(2, 2, '2026-10-15', 2.00, 'Entrega de ración matutina a vacunos y cuyes'),
(2, 3, '2026-10-16', 2.50, 'Desinfección con cal en Galpón Cuyes A');

INSERT INTO dbo.Planificacion_Actividad (id_empresa, id_tipo_labor, id_trabajador, fecha_programada, hora_programada, estado_ejecucion, observaciones) VALUES
(1, 2, 2, '2026-10-20', '06:30:00', 'Completada', 'Ración matutina vacunos'),
(1, 1, 2, '2026-10-20', '09:00:00', 'En Progreso','Riego por surcos Hectárea 2'),
(1, 3, 2, '2026-10-21', '08:00:00', 'Pendiente',  'Limpieza semanal Galpón Cuyes A');

-- 6. Parcelas, Cultivos, Ciclos de Siembra y Cosechas
INSERT INTO dbo.Parcela (id_empresa, nombre_parcela, tamano_hectareas, ubicacion, tipo_suelo, estado) VALUES
(1, 'Hectárea 1', 1.00, 'Sector Norte del Fundo', 'Franco arenoso', 'En uso'),
(1, 'Hectárea 2', 1.00, 'Sector Sur del Fundo',   'Franco arcilloso','En uso'),
(2, 'Hectárea 1', 1.50, 'Zona Alta',              'Franco',          'En uso');

INSERT INTO dbo.Especie_Cultivo (nombre_cultivo, descripcion, tipo_cultivo, ciclo_dias_promedio) VALUES
('Maíz Chala', 'Forraje de alto rendimiento energético para ganado vacuno', 'Forraje', 110),
('Alfalfa',    'Leguminosa forrajera rica en proteína para cuyes y vacunos','Forraje', 60);

INSERT INTO dbo.Ciclo_Siembra (id_parcela, id_especie_cultivo, fecha_inicio, fecha_fin_esperada, fecha_fin_real, area_sembrada, estado) VALUES
(1, 1, '2026-06-01', '2026-09-20', '2026-09-18', 1.00, 'Finalizado'),
(2, 2, '2026-08-15', '2026-10-15', '2026-10-14', 1.00, 'Finalizado'),
(1, 1, '2026-10-01', '2027-01-20', NULL,         1.00, 'En curso');

INSERT INTO dbo.Cosecha (id_ciclo_siembra, fecha_cosecha, cantidad_obtenida, unidad_medida, calidad) VALUES
(1, '2026-09-18', 42000.00, 'kg', 'Primera'),
(2, '2026-10-14', 18500.00, 'kg', 'Primera');

-- 7. Especies Animales, Razas y Corrales
INSERT INTO dbo.Especie_Animal (nombre_especie, descripcion) VALUES
('Vacuno', 'Ganado bovino para producción de leche y carne'),
('Cuy',    'Cavia porcellus de crianza tecnificada para carne y pie de cría');

INSERT INTO dbo.Raza (id_especie_animal, nombre_raza, descripcion) VALUES
(1, 'Holstein',    'Alta producción lechera'),
(1, 'Brown Swiss', 'Doble propósito adaptada a costa y sierra'),
(2, 'Perú',        'Cuy precoz de alto rendimiento cárnico'),
(2, 'Andina',      'Cuy prolífico para pie de cría');

INSERT INTO dbo.Corral (id_empresa, nombre_corral, capacidad_maxima, ubicacion, estado) VALUES
(1, 'Establo Vacunos 1', 25,  'Zona Este',  'En uso'),
(1, 'Galpón Cuyes A',    150, 'Zona Oeste', 'En uso'),
(2, 'Galpón Cuyes 1',    100, 'Pabellón 1', 'En uso');

-- 8. Animales (3 generaciones para árbol genealógico y validación de consanguinidad)
INSERT INTO dbo.Animal (id_empresa, id_raza, id_corral, id_padre, id_madre, codigo_arete, sexo, fecha_nacimiento, proposito, estado_vital) VALUES
(1, 1, 1, NULL, NULL, 'VAC-001', 'M', '2021-03-10', 'Pie de cría',     'Vivo'), -- Abuelo/Padre base
(1, 1, 1, NULL, NULL, 'VAC-002', 'F', '2021-05-18', 'Leche',           'Vivo'), -- Abuela/Madre base
(1, 1, 1, 1,    2,    'VAC-003', 'F', '2023-06-22', 'Leche',           'Vivo'), -- Hija de VAC-001 y VAC-002
(1, 2, 1, NULL, NULL, 'VAC-004', 'M', '2022-09-14', 'Pie de cría',     'Vivo'), -- Toro externo (sin parentesco)
(1, 1, 1, 4,    3,    'VAC-005', 'F', '2025-08-05', 'Doble propósito', 'Vivo'), -- Hija de VAC-004 y VAC-003 (Nieta de VAC-001)
(2, 3, 3, NULL, NULL, 'CUY-001', 'M', '2025-11-01', 'Pie de cría',     'Vivo');

-- 9. Lotes de Animales (Cuyes)
INSERT INTO dbo.Lote_Animal (id_empresa, id_raza, id_corral, codigo_lote, fecha_creacion, cantidad_inicial, cantidad_actual, proposito) VALUES
(1, 3, 2, 'LOTE-CUY-2026-01', '2026-07-01', 60, 56, 'Engorde'),
(1, 4, 2, 'LOTE-CUY-2026-02', '2026-09-01', 40, 40, 'Pie de cría');

-- 10. Controles de Peso (Individual y por Lote)
INSERT INTO dbo.Control_Peso (id_animal, id_lote_animal, fecha_pesaje, peso_registrado, unidad_medida, observaciones) VALUES
(3,    NULL, '2026-08-01', 485.00, 'kg', 'Buen estado corporal'),
(3,    NULL, '2026-09-01', 498.50, 'kg', 'Incremento esperado'),
(5,    NULL, '2026-08-01', 210.00, 'kg', 'Crecimiento óptimo'),
(5,    NULL, '2026-09-01', 238.00, 'kg', 'Ganancia de 28 kg en 30 días'),
(NULL, 1,    '2026-08-15', 48.20,  'kg', 'Peso total de lote (58 cuyes)'),
(NULL, 1,    '2026-09-15', 59.80,  'kg', 'Listos para comercialización');

-- 11. Empadres y Partos
INSERT INTO dbo.Empadre (id_padre, id_madre, id_trabajador, fecha_empadre, tipo_empadre, fecha_parto_esperada, estado_gestacion) VALUES
(4, 3, 3, '2024-10-28', 'Monta natural', '2025-08-04', 'Confirmada'),
(4, 2, 3, '2026-02-10', 'Inseminación artificial', '2026-11-18', 'Confirmada');

INSERT INTO dbo.Parto (id_empadre, fecha_parto_real, crias_vivas, crias_muertas, peso_camada_total, complicaciones) VALUES
(1, '2025-08-05', 1, 0, 38.50, NULL);

-- 12. Enfermedades, Diagnósticos y Tratamientos Sanitarios
INSERT INTO dbo.Enfermedad (id_especie_animal, nombre_enfermedad, descripcion, tipo_enfermedad, sintomas, gravedad) VALUES
(1, 'Mastitis Bovina', 'Inflamación de la glándula mamaria', 'Bacteriana', 'Fiebre, hinchazón de ubre', 'Moderada'),
(2, 'Salmonelosis',    'Infección entérica grave en cuyes',  'Bacteriana', 'Decaimiento, diarrea, erizamiento', 'Grave');

INSERT INTO dbo.Diagnostico (id_animal, id_enfermedad, id_trabajador, fecha_diagnostico, resultado, observaciones) VALUES
(3, 1, 3, '2026-10-10 09:15:00', 'Positivo', 'Prueba California Mastitis Test positiva en cuarto posterior');

INSERT INTO dbo.Tratamiento_Sanitario (id_diagnostico, id_animal, id_lote_animal, id_enfermedad, id_trabajador, tipo_tratamiento, descripcion, medicamento_aplicado, dosis, fecha_aplicacion) VALUES
(1,    3,    NULL, 1, 3, 'Curación',   'Aplicación intramamaria por 3 días', 'Cefalexina Intramamaria', '1 jeringa c/12h', '2026-10-10 10:00:00'),
(NULL, NULL, 1,    2, 3, 'Preventivo', 'Control sanitario preventivo en agua','Enrofloxacina 10%',      '1 ml/L agua',     '2026-10-12 08:30:00');

-- 13. Raciones y Consumo de Alimentación
INSERT INTO dbo.Racion_Dieta (id_especie_animal, nombre_racion, descripcion, etapa_destino, cantidad_diaria_recomendada, unidad_medida) VALUES
(1, 'Vacuno Producción Leche', 'Chala picada + concentrado proteico 18%', 'Lactancia', 35.00, 'kg'),
(2, 'Cuy Engorde Final',       'Alfalfa fresca + concentrado pelletizado','Engorde',   0.18,  'kg');

INSERT INTO dbo.Consumo_Alimentacion (id_racion, id_animal, id_lote_animal, id_corral, fecha_consumo, cantidad_asignada, unidad_medida) VALUES
(1, 3,    NULL, NULL, '2026-10-15', 36.50, 'kg'),
(2, NULL, 1,    NULL, '2026-10-15', 10.50, 'kg');

-- 14. Categorías de Insumo, Insumos, Kardex y Aplicación de Insumos
INSERT INTO dbo.Categoria_Insumo (nombre_categoria, descripcion) VALUES
('Fertilizante', 'Abonos químicos y orgánicos para parcelas'),
('Semilla',      'Semillas certificadas de cultivos forrajeros'),
('Medicina',     'Antibióticos, vacunas y antiparasitarios veterinarios');

INSERT INTO dbo.Insumo (id_empresa, id_categoria_insumo, nombre_insumo, unidad_medida, stock_minimo) VALUES
(1, 1, 'Urea Agrícola 46%',       'Saco 50kg', 10.00),
(1, 2, 'Semilla Maíz Chala Híbrido','Kg',      25.00),
(1, 3, 'Cefalexina Intramamaria', 'Jeringa',   15.00);

INSERT INTO dbo.Kardex_Inventario (id_insumo, id_trabajador, tipo_movimiento, cantidad, fecha_movimiento, costo_unitario, observaciones) VALUES
(1, 1, 'ENTRADA', 20.00, '2026-09-25 10:00:00', 145.00, 'Compra Factura F001-00231'),
(1, 2, 'SALIDA',  12.00, '2026-10-03 07:30:00', 145.00, 'Abonado inicial Hectárea 1'),
(2, 1, 'ENTRADA', 50.00, '2026-09-25 10:05:00',  18.50, 'Compra semilla certificada'),
(2, 2, 'SALIDA',  30.00, '2026-10-01 06:45:00',  18.50, 'Siembra Hectárea 1'),
(3, 1, 'ENTRADA', 20.00, '2026-10-01 11:00:00',  22.00, 'Reposición botiquín veterinario'),
(3, 3, 'SALIDA',   6.00, '2026-10-10 09:50:00',  22.00, 'Tratamiento mastitis VAC-003');

INSERT INTO dbo.Aplicacion_Insumo (id_kardex, id_ciclo_siembra, id_tratamiento, id_trabajador, dosis_aplicada, fecha_aplicacion, observaciones) VALUES
(2, 3,    NULL, 2, 12.00, '2026-10-03', 'Aplicación en bandas en Hectárea 1'),
(4, 3,    NULL, 2, 30.00, '2026-10-01', 'Siembra mecanizada 30 kg/ha'),
(6, NULL, 1,    3,  6.00, '2026-10-10', '6 jeringas durante 3 días de tratamiento');

-- 15. Clientes, Ventas y Detalle_Venta
INSERT INTO dbo.Cliente (id_empresa, tipo_documento, numero_documento, nombre_razon_social, telefono, direccion) VALUES
(1, 'RUC', '20554433221', 'Distribuidora Carnes del Sur S.A.C.', '999111222', 'Mercado Mayorista Santa Anita'),
(1, 'DNI', '41234567',    'María Elena Quispe Vargas',           '988222333', 'Lurín Centro');

INSERT INTO dbo.Venta (id_empresa, id_cliente, id_usuario, fecha_venta, tipo_comprobante, numero_comprobante, monto_total, estado) VALUES
(1, 1, 1, '2026-10-16 14:20:00', 'Factura', 'F001-000105', 1600.00, 'Pagado'),
(1, 2, 1, '2026-10-17 11:10:00', 'Boleta',  'B001-000240', 1200.00, 'Pagado');

INSERT INTO dbo.Detalle_Venta (id_venta, id_animal, id_lote_animal, id_cosecha, cantidad, precio_unitario, subtotal) VALUES
(1, NULL, 1,    NULL, 40.00,   40.00, 1600.00), -- Venta de 40 cuyes del Lote 1
(2, NULL, NULL, 2,    3000.00,  0.40, 1200.00); -- Venta de 3000 kg de alfalfa cosechada
GO
