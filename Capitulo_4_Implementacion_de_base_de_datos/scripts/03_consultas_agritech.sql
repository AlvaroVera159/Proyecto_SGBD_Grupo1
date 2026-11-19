-- =============================================================================
-- PROYECTO: AgriTech (AgroProyectados)
-- MOTOR:    Microsoft SQL Server (T-SQL)
-- ARCHIVO:  03_consultas_agritech.sql
-- DESCRIPCIÓN: 10 Consultas operativas y analíticas (RF-01 a RF-11)
-- =============================================================================

USE AgriTechDB;
GO

-- -----------------------------------------------------------------------------
-- Consulta 1: Árbol Genealógico Recursivo y Detección de Consanguinidad (RF-04, RF-05)
-- Utiliza una Expresión de Tabla Común (CTE) recursiva en T-SQL para obtener todos los ancestros de una hembra candidata a empadre (`VAC-005`) y verificar si el macho propuesto (`VAC-001`) forma parte de su línea ascendente.
-- -----------------------------------------------------------------------------
DECLARE @id_empresa INT = 1;
DECLARE @arete_hembra VARCHAR(50) = 'VAC-005';
DECLARE @arete_macho  VARCHAR(50) = 'VAC-001';

WITH Ancestros AS (
    -- Caso base: padres directos de la hembra
    SELECT
        a.id_animal,
        a.codigo_arete,
        a.id_padre,
        a.id_madre,
        0 AS generacion,
        CAST('Hembra Evaluada' AS VARCHAR(50)) AS vinculo
    FROM dbo.Animal a
    WHERE a.id_empresa = @id_empresa
      AND a.codigo_arete = @arete_hembra

    UNION ALL

    -- Recursión por línea paterna
    SELECT
        p.id_animal,
        p.codigo_arete,
        p.id_padre,
        p.id_madre,
        an.generacion + 1,
        CAST('Ancestro Paterno' AS VARCHAR(50))
    FROM dbo.Animal p
    INNER JOIN Ancestros an ON p.id_animal = an.id_padre

    UNION ALL

    -- Recursión por línea materna
    SELECT
        m.id_animal,
        m.codigo_arete,
        m.id_padre,
        m.id_madre,
        an.generacion + 1,
        CAST('Ancestro Materno' AS VARCHAR(50))
    FROM dbo.Animal m
    INNER JOIN Ancestros an ON m.id_animal = an.id_madre
)
SELECT
    generacion,
    codigo_arete,
    vinculo,
    CASE
        WHEN codigo_arete = @arete_macho THEN 'ALERTA: RIESGO DE CONSANGUINIDAD'
        ELSE 'Sin conflicto directo'
    END AS evaluacion_cruce
FROM Ancestros
WHERE generacion > 0
ORDER BY generacion, codigo_arete;
GO

-- -----------------------------------------------------------------------------
-- Consulta 2: Control de Stock Actual y Alertas de Reposición de Insumos (RF-02)
-- Calcula el stock neto en tiempo real desde `Kardex_Inventario` (`ENTRADA` menos `SALIDA` y `MERMA`) y señala los insumos que se encuentran por debajo del `stock_minimo`.
-- -----------------------------------------------------------------------------
SELECT
    e.nombre AS empresa,
    c.nombre_categoria AS categoria,
    i.nombre_insumo,
    i.unidad_medida,
    SUM(CASE
        WHEN k.tipo_movimiento = 'ENTRADA' THEN k.cantidad
        ELSE -k.cantidad
    END) AS stock_actual,
    i.stock_minimo,
    CASE
        WHEN SUM(CASE WHEN k.tipo_movimiento = 'ENTRADA' THEN k.cantidad ELSE -k.cantidad END) <= i.stock_minimo
            THEN 'REPONER STOCK'
        ELSE 'STOCK NORMAL'
    END AS estado_alerta
FROM dbo.Insumo i
INNER JOIN dbo.Empresa e          ON i.id_empresa = e.id_empresa
INNER JOIN dbo.Categoria_Insumo c ON i.id_categoria_insumo = c.id_categoria_insumo
LEFT  JOIN dbo.Kardex_Inventario k ON i.id_insumo = k.id_insumo
WHERE i.id_empresa = 1 AND i.estado = 1
GROUP BY e.nombre, c.nombre_categoria, i.nombre_insumo, i.unidad_medida, i.stock_minimo
ORDER BY estado_alerta DESC, i.nombre_insumo;
GO

-- -----------------------------------------------------------------------------
-- Consulta 3: Trazabilidad y Costo de Insumos Aplicados por Parcela y Ciclo de Siembra (RF-01, RF-02)
-- Vincula cada parcela y cultivo sembrado con las aplicaciones exactas de fertilizantes/semillas y calcula el costo total invertido por hectárea.
-- -----------------------------------------------------------------------------
SELECT
    p.nombre_parcela,
    ec.nombre_cultivo,
    cs.fecha_inicio,
    cs.estado AS estado_ciclo,
    i.nombre_insumo,
    SUM(ai.dosis_aplicada) AS total_dosis_aplicada,
    i.unidad_medida,
    SUM(ai.dosis_aplicada * ISNULL(k.costo_unitario, 0)) AS costo_total_soles,
    CAST(SUM(ai.dosis_aplicada * ISNULL(k.costo_unitario, 0)) / cs.area_sembrada AS DECIMAL(12,2)) AS costo_por_hectarea
FROM dbo.Aplicacion_Insumo ai
INNER JOIN dbo.Kardex_Inventario k ON ai.id_kardex = k.id_kardex
INNER JOIN dbo.Insumo i            ON k.id_insumo = i.id_insumo
INNER JOIN dbo.Ciclo_Siembra cs    ON ai.id_ciclo_siembra = cs.id_ciclo_siembra
INNER JOIN dbo.Parcela p           ON cs.id_parcela = p.id_parcela
INNER JOIN dbo.Especie_Cultivo ec  ON cs.id_especie_cultivo = ec.id_especie_cultivo
WHERE p.id_empresa = 1
GROUP BY p.nombre_parcela, ec.nombre_cultivo, cs.fecha_inicio, cs.estado, i.nombre_insumo, i.unidad_medida, cs.area_sembrada
ORDER BY p.nombre_parcela, costo_total_soles DESC;
GO

-- -----------------------------------------------------------------------------
-- Consulta 4: Evolución de Ganancia de Peso por Animal con Funciones de Ventana (RF-03)
-- Utiliza la función analítica `LAG()` para comparar cada pesaje con el anterior y calcular la ganancia diaria promedio de peso (GDP).
-- -----------------------------------------------------------------------------
WITH Pesajes AS (
    SELECT
        a.codigo_arete,
        r.nombre_raza,
        cp.fecha_pesaje,
        cp.peso_registrado,
        LAG(cp.peso_registrado) OVER (PARTITION BY cp.id_animal ORDER BY cp.fecha_pesaje) AS peso_anterior,
        LAG(cp.fecha_pesaje)    OVER (PARTITION BY cp.id_animal ORDER BY cp.fecha_pesaje) AS fecha_anterior
    FROM dbo.Control_Peso cp
    INNER JOIN dbo.Animal a ON cp.id_animal = a.id_animal
    INNER JOIN dbo.Raza r   ON a.id_raza = r.id_raza
    WHERE a.id_empresa = 1
)
SELECT
    codigo_arete,
    nombre_raza,
    fecha_pesaje,
    peso_registrado AS peso_actual_kg,
    peso_anterior   AS peso_anterior_kg,
    (peso_registrado - peso_anterior) AS ganancia_kg,
    CASE
        WHEN fecha_anterior IS NOT NULL AND DATEDIFF(DAY, fecha_anterior, fecha_pesaje) > 0
            THEN CAST((peso_registrado - peso_anterior) / DATEDIFF(DAY, fecha_anterior, fecha_pesaje) AS DECIMAL(10,3))
        ELSE NULL
    END AS ganancia_diaria_kg
FROM Pesajes
ORDER BY codigo_arete, fecha_pesaje;
GO

-- -----------------------------------------------------------------------------
-- Consulta 5: Reporte de Eficiencia Reproductiva y Natalidad (RF-04, RF-05)
-- Consolida los empadres realizados con los resultados reales de partos, calculando la tasa de supervivencia neonatal por hembra.
-- -----------------------------------------------------------------------------
SELECT
    madre.codigo_arete AS arete_madre,
    padre.codigo_arete AS arete_padre,
    em.fecha_empadre,
    em.tipo_empadre,
    em.estado_gestacion,
    pa.fecha_parto_real,
    ISNULL(pa.crias_vivas, 0)   AS crias_vivas,
    ISNULL(pa.crias_muertas, 0) AS crias_muertas,
    CASE
        WHEN pa.id_parto IS NOT NULL
            THEN CAST(100.0 * pa.crias_vivas / (pa.crias_vivas + pa.crias_muertas) AS DECIMAL(5,2))
        ELSE NULL
    END AS porcentaje_supervivencia
FROM dbo.Empadre em
INNER JOIN dbo.Animal madre ON em.id_madre = madre.id_animal
INNER JOIN dbo.Animal padre ON em.id_padre = padre.id_animal
LEFT  JOIN dbo.Parto pa     ON em.id_empadre = pa.id_empadre
WHERE madre.id_empresa = 1
ORDER BY em.fecha_empadre DESC;
GO

-- -----------------------------------------------------------------------------
-- Consulta 6: Historial Clínico y Tratamientos Sanitarios Aplicados por Animal (RF-06)
-- Muestra la trazabilidad clínica completa de los animales diagnosticados, incluyendo enfermedad, gravedad, medicamento aplicado y veterinario responsable.
-- -----------------------------------------------------------------------------
SELECT
    a.codigo_arete,
    ea.nombre_especie,
    enf.nombre_enfermedad,
    enf.gravedad,
    d.fecha_diagnostico,
    d.resultado,
    ts.tipo_tratamiento,
    ts.medicamento_aplicado,
    ts.dosis,
    ts.fecha_aplicacion,
    CONCAT(t.nombres, ' ', t.apellidos) AS veterinario_responsable
FROM dbo.Diagnostico d
INNER JOIN dbo.Animal a             ON d.id_animal = a.id_animal
INNER JOIN dbo.Enfermedad enf       ON d.id_enfermedad = enf.id_enfermedad
INNER JOIN dbo.Especie_Animal ea    ON enf.id_especie_animal = ea.id_especie_animal
LEFT  JOIN dbo.Tratamiento_Sanitario ts ON d.id_diagnostico = ts.id_diagnostico
INNER JOIN dbo.Trabajador t         ON d.id_trabajador = t.id_trabajador
WHERE a.id_empresa = 1 AND d.estado = 1
ORDER BY d.fecha_diagnostico DESC;
GO

-- -----------------------------------------------------------------------------
-- Consulta 7: Desviación de Consumo de Alimentación frente a la Ración Recomendada (RF-07)
-- Compara la cantidad real suministrada en `Consumo_Alimentacion` contra la recomendación nutricional definida en `Racion_Dieta`.
-- -----------------------------------------------------------------------------
SELECT
    ca.fecha_consumo,
    COALESCE(a.codigo_arete, la.codigo_lote, c.nombre_corral) AS destino_alimentacion,
    rd.nombre_racion,
    rd.etapa_destino,
    rd.cantidad_diaria_recomendada,
    ca.cantidad_asignada,
    (ca.cantidad_asignada - rd.cantidad_diaria_recomendada) AS variacion_cantidad,
    ca.unidad_medida
FROM dbo.Consumo_Alimentacion ca
INNER JOIN dbo.Racion_Dieta rd ON ca.id_racion = rd.id_racion
LEFT  JOIN dbo.Animal a        ON ca.id_animal = a.id_animal
LEFT  JOIN dbo.Lote_Animal la  ON ca.id_lote_animal = la.id_lote_animal
LEFT  JOIN dbo.Corral c        ON ca.id_corral = c.id_corral
WHERE COALESCE(a.id_empresa, la.id_empresa, c.id_empresa) = 1
ORDER BY ca.fecha_consumo DESC;
GO

-- -----------------------------------------------------------------------------
-- Consulta 8: Ingresos Comerciales Desglosados por Línea de Producto (RF-08, RF-09)
-- Agrupa las ventas pagadas diferenciando los ingresos provenientes de animales individuales, lotes de cuyes y cosechas agrícolas.
-- -----------------------------------------------------------------------------
SELECT
    CASE
        WHEN dv.id_animal IS NOT NULL      THEN 'Animal Individual'
        WHEN dv.id_lote_animal IS NOT NULL THEN 'Lote de Animales'
        WHEN dv.id_cosecha IS NOT NULL     THEN 'Cosecha Agrícola'
    END AS linea_producto,
    COUNT(DISTINCT v.id_venta) AS total_comprobantes,
    SUM(dv.cantidad)           AS unidades_o_kilos_vendidos,
    SUM(dv.subtotal)           AS ingresos_totales_soles
FROM dbo.Venta v
INNER JOIN dbo.Detalle_Venta dv ON v.id_venta = dv.id_venta
WHERE v.id_empresa = 1 AND v.estado = 'Pagado'
GROUP BY
    CASE
        WHEN dv.id_animal IS NOT NULL      THEN 'Animal Individual'
        WHEN dv.id_lote_animal IS NOT NULL THEN 'Lote de Animales'
        WHEN dv.id_cosecha IS NOT NULL     THEN 'Cosecha Agrícola'
    END
ORDER BY ingresos_totales_soles DESC;
GO

-- -----------------------------------------------------------------------------
-- Consulta 9: Productividad Laboral y Cumplimiento de Planificación por Trabajador (RF-08)
-- Cruza las horas realmente invertidas en `Registro_Labor` con el estado de cumplimiento de las tareas agendadas en `Planificacion_Actividad`.
-- -----------------------------------------------------------------------------
SELECT
    CONCAT(t.nombres, ' ', t.apellidos) AS trabajador,
    t.cargo,
    ISNULL(rl.total_horas, 0)      AS horas_registradas,
    ISNULL(pa.tareas_totales, 0)   AS tareas_programadas,
    ISNULL(pa.tareas_completas, 0) AS tareas_completadas
FROM dbo.Trabajador t
LEFT JOIN (
    SELECT id_trabajador, SUM(horas_invertidas) AS total_horas
    FROM dbo.Registro_Labor
    WHERE estado = 1
    GROUP BY id_trabajador
) rl ON t.id_trabajador = rl.id_trabajador
LEFT JOIN (
    SELECT
        id_trabajador,
        COUNT(*) AS tareas_totales,
        SUM(CASE WHEN estado_ejecucion = 'Completada' THEN 1 ELSE 0 END) AS tareas_completas
    FROM dbo.Planificacion_Actividad
    GROUP BY id_trabajador
) pa ON t.id_trabajador = pa.id_trabajador
WHERE t.id_empresa = 1 AND t.estado = 1
ORDER BY horas_registradas DESC;
GO

-- -----------------------------------------------------------------------------
-- Consulta 10: Resumen Ejecutivo Multi-tenant por Empresa Cliente (RF-08, RF-11)
-- Permite al administrador SaaS monitorear la adopción y actividad operativa consolidada de cada fundo registrado en **AgriTech**.
-- -----------------------------------------------------------------------------
SELECT
    e.id_empresa,
    e.ruc,
    e.nombre AS fundo_cliente,
    (SELECT COUNT(*) FROM dbo.Parcela p      WHERE p.id_empresa = e.id_empresa) AS total_parcelas,
    (SELECT COUNT(*) FROM dbo.Animal a       WHERE a.id_empresa = e.id_empresa AND a.estado_vital = 'Vivo') AS animales_vivos,
    (SELECT COUNT(*) FROM dbo.Lote_Animal la WHERE la.id_empresa = e.id_empresa AND la.estado = 1) AS lotes_activos,
    (SELECT ISNULL(SUM(v.monto_total), 0) FROM dbo.Venta v WHERE v.id_empresa = e.id_empresa AND v.estado = 'Pagado') AS ventas_acumuladas_soles
FROM dbo.Empresa e
WHERE e.estado = 1
ORDER BY ventas_acumuladas_soles DESC;
GO
