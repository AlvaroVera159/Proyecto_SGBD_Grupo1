# División de la exposición – Grupo 1

## Orden de exposición

| # | Quién | Bloque | Contenido |
|---|---|---|---|
| 1 | **Persona 1** | Apertura | 1.1.1 Descripción del startup · 1.2 Solution profile (5W2H, problemática central, propuesta de valor) · 1.3 Segmentos objetivo |
| 2 | **Persona 2** | Capítulo II | 2.1 Entrevistas (diseño, registro, análisis) · 2.2 Requisitos (RF-01 a RF-11, RNF-01 a RNF-07) |
| 3 | **Persona 3** | Diseño – Parte A | 3.1 + 3.2 + 3.3 de sus 16 entidades |
| 4 | **Persona 4** | Diseño – Parte B | 3.1 + 3.2 + 3.3 de sus 16 entidades |
| 5 | **Persona 1** | Cierre | 3.3.1 Diagrama ER lógico · 4.1 SGBD (criterios, comparativa, elección de SQL Server, evidencia) · 4.2.1 Diagrama ER físico (solo la foto) |

> Los perfiles de integrantes (1.1.2) **no se exponen**. Opcional: cada uno se presenta en una línea al iniciar su parte.

---

## Persona 1 – Apertura y cierre - José 

**Apertura**
- 1.1.1 Descripción del startup: AgroProyecciones / AgriTech.
- 1.2.1 Antecedentes y problemática: Matriz 5W y 2H, problemática central.
- 1.2.2 Propuesta de valor: problema, soluciones, resultados, usuarios, hipótesis, MVP.
- 1.3 Segmentos objetivo: principal y secundario.
- Transición: *"para validar esta problemática realizamos una entrevista…"*

**Cierre**
- 3.3.1 Diagrama ER lógico (vista general de todos los módulos).
- 4.1 Sistema de gestión de base de datos:
  - A. Criterios de selección
  - B. Análisis comparativo (SQL Server vs MySQL vs Oracle)
  - C. Justificación: RLS para multiempresa y CTEs recursivas para genealogía
  - D. Evidencia de la instancia en SQL Server
- 4.2.1 Diagrama ER físico (mostrar la foto).

---

## Persona 2 – Capítulo II - Renzo

- 2.1.1 Diseño de entrevistas: los 5 bloques de preguntas.
- 2.1.2 Registro: ficha técnica y cronograma de la sesión.
- 2.1.3 Análisis: registros manuales, control genético, limitaciones tecnológicas, acceso operativo, arquetipo *"El empresario agropecuario empírico"*.
- 2.2 Requisitos funcionales y no funcionales.
- Transición: *"a partir de estos requisitos identificamos las entidades…"*

---

## Persona 3 – Diseño, Parte A: Operación del fundo - Mauricio

| Módulo | Entidades |
|---|---|
| Seguridad y multiempresa (4) | Empresa, Usuario, Rol, Usuario_Rol |
| Personal y labores (4) | Trabajador, Tipo_Labor, Registro_Labor, Planificacion_Actividad |
| Agrícola (4) | Parcela, Especie_Cultivo, Ciclo_Siembra, Cosecha |
| Inventario (4) | Categoria_Insumo, Insumo, Kardex_Inventario, Aplicacion_Insumo |

**Relaciones a cubrir (~24):** las que llegan a tablas de sus módulos (Empresa→Usuario/Trabajador/Parcela/Insumo/Planificación, Parcela→Ciclo_Siembra→Cosecha, Insumo→Kardex→Aplicacion_Insumo, etc.).

**Destacar:**
- Usuario **M:N** Rol, resuelta con Usuario_Rol.
- Cadena Kardex_Inventario → Aplicacion_Insumo, que se vincula con Ciclo_Siembra y Tratamiento_Sanitario (trazabilidad de insumos, RF-02).

---

## Persona 4 – Diseño, Parte B: Ganadería y ventas - Alvaro
| Módulo | Entidades |
|---|---|
| Zootécnico y genético (8) | Especie_Animal, Raza, Corral, Animal, Lote_Animal, Control_Peso, Empadre, Parto |
| Sanidad y alimentación (5) | Enfermedad, Diagnostico, Tratamiento_Sanitario, Racion_Dieta, Consumo_Alimentacion |
| Ventas (3) | Cliente, Venta, Detalle_Venta |

**Relaciones a cubrir (~41):** las que llegan a tablas de sus módulos.

**Destacar:**
- Relación **recursiva** padre/madre en Animal (genealogía, RF-04 / RF-05).
- Empadre **1:1** Parto.
- Venta **M:N** Animal / Lote_Animal / Cosecha, resueltas con Detalle_Venta.

---

## Recomendaciones

- En 3.2 no leer tabla por tabla: presentar por módulo y mostrar 1–2 tablas de ejemplo con sus PK/FK.
- En 3.3 no leer las 65 filas: explicar solo los casos clave de cada módulo.
- Persona 4 tiene más relaciones, por eso Persona 1 se encarga del diagrama lógico y de 4.1.
