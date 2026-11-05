<center>UNIVERSIDAD NACIONAL DE INGENIERÍA</center>
<br>
<center>FACULTAD DE INGENIERÍA INDUSTRIAL Y DE SISTEMAS</center>
<br>
<div align="center">
  <img src="image.png" alt="alt text" width="50%">
</div>
<br>
<center>SW609U Sistemas de Gestión de Base de Datos</center>
<br>
<center>Entregable Capítulo 1</center>
<br>
<center>DOCENTE: Berrocal Navarro Richard Leonardo</center>
<br>
<center>Participantes del Grupo 1:</center>
<br>
<center> - Chavarria Llamacponcca Renzo Moises </center>
<br>
<center> - Chinchayhuara Pantoja Mauricio Miguel </center>
<br>
<center> - Rojas Sanchez Jose Martin </center>
<br>
<center> - Vera Palacios Alvaro Martin </center>
<br>
<center> 29 de octubre de 2026 </center>
<br>
<center> 2026 - II </center>



# Capítulo I: Introducción

## 1.1.   Startup profile

### 1.1.1.    Descripción del startup

**AgroProyectados** es una startup agrotecnológica enfocada en el desarrollo de software de gestión integral para granjas y fundos de producción mixta (agrícola y ganadera). Nuestro producto principal es **AgriTech**, un sistema digital diseñado para modernizar y automatizar el control operativo de pequeños y medianos productores. 

A través de nuestra plataforma, resolvemos problemas críticos del día a día, como la asignación de trabajadores a parcelas específicas, la trazabilidad del uso de insumos (semillas, fertilizantes) y el control zootécnico y genético de animales de crianza (vacunos y cuyes). El núcleo de nuestro software se apoya en una arquitectura de datos robusta, permitiendo transformar fundos que operan de manera empírica en negocios eficientes, escalables y respaldados por información exacta.

### 1.1.2.    Perfiles de integrantes del equipo

- Chavarria Llamacponcca Renzo Moises (20231281J): Estudiante de la carrera de Ing de Software en la Universidad Nacional de Ingeniería cursando el 7mo ciclo. Experiencia previa en base de datos sql y lenguajes de programación como python, c, c++ además de diseño web como HTML y css, considero que tengo gran capacidad de analisis y búsqueda de soluciones.

- Chinchayhuara Pantoja Mauricio Miguel (20244112G): Estudiante de la carrera de Ingenieria de Software en la Universidad Nacional de Ingeniería del Sexto Ciclo. Experiencia previa en Base de Datos SQL tales como MYSQL y SQLServer; lenguajes de programación como Python, Java y C++ y la capacidad de analizar casos extensos para un modelamiento de datos con gran cantidad de relaciones y tablas.

- Rojas Sanchez Jose Martin (20244126H): Esduaitnate de la carrera de Ingeniería de Software, 6to ciclo, enfocado directamente en la creación de sistemas web y movil, con proyectos reales y desplegados en estas tecnologías. Además, cuento con experiencia manejando base de datos en producción, modificando reglas de seguridad y RLS's 

- Vera Palacios Alvaro Martin (Código 20234137G): Estudiante de la carrera de Ingeniería de Software en la Universidad Nacional de Ingeniería, con sexto ciclo relativo, experiencia previa en bases de datos relacionales como PostgreSQL, Oracle, MySQL y SQL Server, en lenguajes de programación como Python. Java, C++, C y JavaScript, en frameworks con React y Express.js, con la capacidad de diseñar y estructurar ecosistemas con grandes cantidades de tablas.

<div align="center">
  <img src="foto_traje.jpg" alt="alt text" width="30%">
</div>


## 1.2.   Solution profile

### 1.2.1.    Antecedentes y problemática

### Matriz 5W y 2H

| Pregunta | Respuesta |
|---|---|
| **¿Qué? (What)** | Los fundos agropecuarios administran sus operaciones con cuadernos físicos y memoria, generando islas de información. No pueden rastrear el uso de insumos por parcela, asignar trabajadores de forma eficiente ni controlar la genealogía y reproducción del ganado. |
| **¿Por qué? (Why)** | La falta de digitalización genera "ceguera administrativa": sobrecostos por mala dosificación de insumos, horas-hombre desperdiciadas, consanguinidad en los animales y dificultad para contener enfermedades, lo que limita los márgenes de ganancia. |
| **¿Quién? (Who)** | Principal: empresarios agropecuarios y criadores que poseen parcelas. Secundario: asociaciones, cooperativas, veterinarios y extensionistas. Internamente: usuarios operativos y administrador del sistema. |
| **¿Dónde? (Where)** | En fundos y granjas de pequeños y medianos productores (parcelas de cultivo y corrales de vacunos y cuyes), con acceso desde celular o computadora. |
| **¿Cuándo? (When)** | En la operación diaria y durante todo el ciclo productivo: siembra, uso de insumos, empadre, gestación, engorde, sanidad y venta. |
| **¿Cómo? (How)** | Con AgriTech, un sistema de base de datos relacional que integra parcelas, lotes, animales, genealogía, sanidad, alimentación, producción y ventas, con roles de acceso, reportes, alertas y estructura multiempresa. |
| **¿Cuánto? (How much)** | Costo de desarrollo e implementación (por definir), modelo de licencias o suscripción para otros criadores, y ahorro esperado por menor desperdicio de insumos y mayor valor del ganado en las 2 hectáreas de cultivo. |

#### Problemática Central

La problemática central radica en la ausencia de herramientas de software y la total dependencia de registros manuales (cuadernos físicos y memoria visual) en la administración diaria de los fundos agropecuarios. Esta falta de digitalización genera islas de información que impiden tener una visión completa del negocio.

Al no contar con un sistema que integre ambas áreas (agricultura y ganadería), los productores son incapaces de rastrear el uso exacto de insumos en sus hectáreas, correlacionar la producción de forraje con la alimentación del ganado, o mantener un control genético y reproductivo estricto para especies de rápida multiplicación (como los cuyes). Esta desconexión operativa provoca una "ceguera administrativa" que oculta ineficiencias, dificulta la contención de enfermedades y frena el crecimiento comercial de la granja.

### 1.2.2.    Propuesta de valor


<table border="1" width="100%">
  <tr>
    <td><b>Problema del Negocio:</b><br>Las granjas agropecuarias sufren fugas de capital y pérdida de valor comercial debido a procesos ineficientes y no estandarizados. Al carecer de un software de gestión, el negocio asume sobrecostos constantes por la mala dosificación de insumos, horas-hombre desperdiciadas en la asignación de labores en las parcelas, y una fuerte devaluación de sus animales por la consanguinidad (cruce entre familiares) o mala rotación genética, limitando severamente sus márgenes de ganancia.</td>
    <td rowspan="2"><b>Soluciones Propuestas:</b><br>Implementar <b>AgriTech</b>, un sistema de gestión de base de datos relacional, seguro y escalable, que integre el registro de parcelas, lotes, animales, genealogía, reproducción, sanidad, alimentación, peso, producción, mortalidad y ventas. La base de datos permitirá relacionar cada animal con su parcela, lote e historial productivo y sanitario, garantizando integridad referencial. Incluirá roles y permisos de acceso, reportes de producción y rentabilidad, alertas sanitarias y reproductivas, respaldo de información y una estructura multiempresa que permita al empresario ofrecer la solución a otros criadores de su rubro</td>
    <td><b>Resultados del Negocio:</b><br>Mediante la implementación de nuestro software, AgroProyectados espera que las granjas obtengan los siguientes resultados cuantificables:
    <ul>
      <li><b>Reducción de sobrecostos operativos:</b> Disminución en la pérdida y desperdicio de insumos agrícolas y veterinarios mediante un control estricto de inventarios vinculados a parcelas y corrales.</li>
      <li><b>Incremento del valor del ganado:</b> Aumento en los índices de natalidad sana y mejora en las métricas de engorde gracias al monitoreo genético y rotación inteligente de toros, vacas y cuyes.</li>
      <li><b>Eficiencia operativa unificada:</b> Eliminación del uso de papel y cuadernos, logrando que el productor pueda auditar el rendimiento de sus trabajadores y el estado de sus 2 hectáreas de cultivo en tiempo real desde una sola plataforma.</li>
    </ul></td>
  </tr>
  <tr>
    <td><b>Usuarios:</b><br>Empresarios agropecuarios y criadores de animales de ganado que poseen parcelas, y que buscan mejorar el rastreo de sus animales sin abandonar el conocimiento adquirido por experiencia. Usuarios operativos: responsables de la crianza que registran datos diarios. Usuarios técnicos: veterinarios y extensionistas que consultan historiales. Usuario administrador: gestiona usuarios, roles, reportes y licencias del sistema.</td>
    <td><b>Resultados y Beneficios del Usuario:</b><br>El empresario podrá conocer el historial reproductivo, sanitario y productivo de cada animal, tomar decisiones basadas en datos y respaldar su método empírico con información organizada. Podrá detectar oportunamente enfermedades, mejorar la alimentación y aumentar la productividad. Además, podrá ofrecer el sistema a otros criadores de su rubro, generando ingresos adicionales y posicionándose como referente en la facilitación de información para la crianza de animales de ganado</td>
  </tr>
  <tr>
    <td><b>Hipótesis:</b><br>
    <ul>
      <li><b>Hipótesis de Adopción y Eficiencia:</b> Creemos que al proveer a los empresarios y operarios agrícolas una interfaz sencilla para registrar insumos y labores por parcela en lugar de cuadernos físicos, se reducirá el desperdicio de insumos en un 20%. Sabremos que tuvimos éxito cuando el 85% de las labores diarias sean registradas digitalmente durante el primer mes de uso.</li>
      <li><b>Hipótesis de Control Zootécnico:</b> Creemos que al incorporar un control genealógico con alertas automáticas de consanguinidad para vacunos y cuyes, aumentará la tasa de crías sanas y el valor comercial del ganado. Sabremos que tuvimos éxito cuando los cruces consanguíneos involuntarios se reduzcan a 0% y la supervivencia de crías aumente en un 15%.</li>
      <li><b>Hipótesis de Escalabilidad y Negocio:</b> Creemos que al estructurar el sistema con capacidades multiempresa y reportes de rentabilidad, los empresarios agropecuarios estarán dispuestos a pagar un modelo de suscripción o licencia y comercializar la solución a otros criadores del rubro. Sabremos que tuvimos éxito cuando al menos 3 granjas piloto decidan contratar el servicio tras el período de evaluación.</li>
    </ul></td>
    <td><b>¿Qué es lo primero y más importante a saber?:</b><br>
    <ul>
      <li><b>Disposición y facilidad de adopción operativa:</b> Determinar si los trabajadores y operarios de campo (con fuerte arraigo en prácticas empíricas y baja familiaridad digital) realmente utilizarán la plataforma de manera constante y sin fricción para registrar labores diarias, o si el ingreso de datos será percibido como una sobrecarga de trabajo.</li>
      <li><b>Viabilidad de la información genealógica inicial:</b> Identificar si los criadores poseen suficiente trazabilidad histórica o datos confiables para poblar el registro inicial de parentesco de sus animales de crianza y validar la efectividad de las alertas reproductivas.</li>
      <li><b>Disposición real de pago y valor percibido:</b> Confirmar si el ahorro operativo generado en insumos y la reducción de pérdidas en animales son lo suficientemente tangibles como para que el productor justifique la inversión en licencias del software.</li>
    </ul></td>
    <td><b>¿Cuál es la menor cantidad de trabajo que necesitamos para aprender algo muy importante?:</b><br>
    <ul>
      <li><b>Desarrollo de un MVP Core (Prototipo funcional mínimo):</b> Construir una versión ligera y accesible desde celular/computadora centrada únicamente en dos flujos esenciales:
        <ol>
          <li>Formulario simplificado para el registro diario de insumos aplicados a una parcela específica.</li>
          <li>Ficha zootécnica elemental con verificación instantánea de parentesco (evitar consanguinidad) al programar un cruce o empadre.</li>
        </ol>
      </li>
      <li><b>Prueba piloto de campo (2 a 3 semanas):</b> Desplegar este MVP en un entorno controlado (las 2 hectáreas de cultivo y un corral piloto de cuyes o vacunos) con un operario clave y el empresario agropecuario.</li>
      <li><b>Mecanismos de medición y aprendizaje directo:</b> Evaluar la tasa de registro efectivo frente al cuaderno tradicional, registrar el tiempo invertido por carga de datos y realizar entrevistas cortas in situ para identificar bloqueos de usabilidad antes de invertir recursos en módulos avanzados o multiempresa.</li>
    </ul></td>
  </tr>
</table>


## 1.3.   Segmentos objetivo 

El segmento objetivo principal está conformado por empresarios agropecuarios y criadores que poseen parcelas, y que actualmente gestionan su producción a partir de experiencia empírica, registros manuales o información dispersa. Estos usuarios se caracterizan por necesitar registros más ordenados sobre reproducción, alimentación, sanidad, peso, mortalidad y producción, así como por visualizar una oportunidad de negocio al poder ofrecer el sistema a otros productores de su rubro.

Como segmento secundario se consideran las asociaciones, cooperativas y otros criadores de cuyes que requieren sistematizar su información y adoptar herramientas digitales para mejorar su producción. También se incluye a técnicos, veterinarios y extensionistas agropecuarios que brindan asesoría y necesitan consultar historiales productivos y sanitarios. Finalmente, el sistema contempla al empresario como futuro proveedor de la solución, ya que podrá comercializar el acceso al sistema a otros criadores interesados en facilitar la información para la crianza de animales de ganado.

# Capítulo II: Recopilación y análisis de requisitos

## 2.1 Entrevistas

### 2.1.1 Diseño de entrevistas

### 2.1.2 Registro de entrevistas

### 2.1.3 Análisis de entrevistas

A partir de la entrevista realizada al segmento principal (empresarios agropecuarios y criadores), se identificaron patrones claros en relación con las necesidades, dificultades y expectativas frente a la gestión de sus fundos. La entrevista, realizada a Demetrio Rojas, gerente de una granja dedicada a la crianza de vacunos de doble propósito y cuyes con mejoramiento genético, reveló que las personas de este segmento gestionan sus operaciones combinando la agricultura (2 hectáreas de alfalfa en el caso del señor Rojas) con la ganadería, apoyándose en un equipo de trabajo reducido y con tareas calendarizadas.

En primer lugar, se evidenció que la principal dificultad operativa radica en la dependencia de registros manuales. El entrevistado manifestó que los datos sobre nacimientos, pesos, destetes, sexado y mortalidad se anotan en cuadernos y hojas físicas. Esta falta de digitalización genera una "ceguera administrativa", ya que el entrevistado indicó que la toma de decisiones, como cambios de raza o ajustes en la alimentación, se retrasa hasta por 15 o 30 días, tiempo en el que se comparan anotes manuales, lo que muchas veces resulta en pérdidas económicas o fracasos en los lotes de animales.

Asimismo, se identificó una marcada preocupación por el control zootécnico y genético. El entrevistado destacó la necesidad de rastrear eventos veterinarios (desparasitaciones, vitaminas, tratamientos para neumonía o salmonelosis) y, sobre todo, de evitar cruces no adecuados entre líneas o razas. Actualmente, identificar si un problema de natalidad o mortalidad de crías se debe al macho o a las hembras toma hasta un año de prueba y error. Frente a ello, se valoró la necesidad de contar con una herramienta que les permita verificar el parentesco y optimizar la conversión alimenticia en tiempo real.

Por otro lado, se detectaron limitaciones tecnológicas y de acceso a la información. El entrevistado señaló que, aunque existen experiencias internacionales de monitoreo con sensores, en el sector rural peruano la falta de herramientas digitales limita el crecimiento. Se enfatizó la necesidad de un aplicativo que no solo registre datos, sino que también brinde información oportuna sobre el comportamiento del mercado (precios de la carne, fenómenos climáticos) y alertas tempranas ante cambios bruscos de estación, los cuales incrementan la mortalidad en cuyes.

Desde la perspectiva del acceso operativo, se observó que la solución debe ser intuitiva, dado que el personal de campo (asistentes) es quien registrará los datos diarios. El entrevistado subrayó que la plataforma debe adaptarse a la rutina del fundo y permitir la consulta desde dispositivos móviles o computadoras, eliminando la necesidad de estar físicamente presente en los corrales para revisar el avance de la producción.

En cuanto al segmento secundario (asociaciones, cooperativas, criadores de cuyes y técnicos/veterinarios), no se cuenta aún con entrevistas registradas que permitan un sustento estadístico. Sin embargo, a partir de las hipótesis del proyecto, se proyecta que estos usuarios demandarán funcionalidades de centralización de información, historiales clínicos compartidos y herramientas para la comercialización de licencias, lo cual deberá validarse en futuras iteraciones.

Finalmente, se concluye que una solución para el sector agropecuario debe ser accesible, bilingüe o de lenguaje sencillo, adaptable a la baja conectividad y centrada en la trazabilidad en tiempo real. A partir de estos hallazgos, se define el siguiente arquetipo preliminar para el segmento principal: "El empresario agropecuario empírico", un gerente que posee fundos mixtos, trabaja con personal reducido, necesita digitalizar sus cuadernos de campo para evitar la consanguinidad, optimizar la alimentación y tomar decisiones basadas en datos para asegurar la rentabilidad de su negocio.



## 2.2 Requisitos

### 2.2.1. Requisitos Funcionales

| Código | Nombre | Descripción |
| :--- | :--- | :--- |
| **RF-01** | Gestión Agrícola | El sistema debe permitir el registro y control de parcelas de cultivo.|
| **RF-02** | Trazabilidad de Insumos | El software debe registrar de manera exacta el uso y dosificación de insumos agrícolas (semillas, fertilizantes) vinculándolos a cada parcela. |
| **RF-03** | Control Zootécnico | El sistema debe permitir el registro de perfiles individuales o por lotes de animales, rastreando su peso, crecimiento y mortalidad. |
| **RF-04** | Registro Genealógico | El sistema debe mantener un registro exacto del parentesco (línea de ascendencia y descendencia) de cada animal registrado en la granja. |
| **RF-05** | Alertas Reproductivas | El sistema debe evaluar el parentesco y generar alertas automáticas al programar empadres para prevenir cruces con consanguinidad. |
| **RF-06** | Control Sanitario | El sistema debe mantener el historial clínico de los animales, registrando enfermedades diagnosticadas, tratamientos aplicados y vacunas. |
| **RF-07** | Gestión de Alimentación | El sistema debe permitir el registro y asignación de esquemas de alimentación (raciones y consumo de forraje) para cada animal o lote. |
| **RF-08** | Generación de Reportes | El sistema debe generar reportes automáticos y cuadros de mando sobre las métricas de producción y la rentabilidad general de la granja. |
| **RF-09** | Registro de Ventas | El sistema debe contar con un módulo transaccional para registrar las ventas finales de los animales y cultivos. |
| **RF-10** | Gestión de Accesos | El sistema debe incluir un módulo para la administración de usuarios y roles con permisos específicos (administrador, operarios de campo, veterinarios). |
| **RF-11** | Módulo Multiempresa | El software debe contar con aislamiento de datos por cuenta (multi-tenant) para que el empresario principal pueda comercializar licencias a otros criadores. |

### 2.2.2. Requisitos No Funcionales

| Código | Nombre | Descripción |
| :--- | :--- | :--- |
| **RNF-01** | Rendimiento | El sistema debe procesar las consultas de los reportes de producción (cruces entre parcelas, animales e insumos) y renderizar la información en pantalla en un tiempo máximo de 1 s egundobajo condiciones de carga normal. |
| **RNF-02** | Integridad de Datos | Se debe garantizar la coherencia estricta entre animales, parcelas y su historial, sin redundancias. |
| **RNF-03** | Usabilidad | La interfaz debe ser intuitiva y guiada, permitiendo que operarios de campo sin experiencia tecnológica avanzada registren insumos o tareas. |
| **RNF-04** | Adaptabilidad | Las vistas del sistema deben renderizarse y funcionar correctamente en los dispositivos disponibles. |
| **RNF-05** | Seguridad de Acceso | El sistema debe encriptar las credenciales de los usuarios y bloquear el acceso a módulos no autorizados según el rol asignado. |
| **RNF-06** | Respaldo de Información | El sistema debe ejecutar copias de seguridad (backups) automáticas de manera diaria para salvaguardar todos los registros operativos y comerciales de las granjas. |
| **RNF-07** | Escalabilidad | La arquitectura backend y de base de datos debe soportar el crecimiento continuo del esquema multiempresa sin que el tiempo de respuesta de las consultas supere los 2 segundos. |

