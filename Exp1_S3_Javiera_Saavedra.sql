-- =============================================================
-- DUOC UC | PRY2205 | EXPERIENCIA 1 - SEMANA 3 | FORMA B
-- Evaluacion sumativa: Aplicando funciones de agrupacion
-- Estudiante: Javiera Paz Saavedra Perez
-- Caso: ASOCIADOS
-- Basado en el modelo relacional incluido en las instrucciones.
-- Pendiente: ejecucion con datos originales de ASOCIADOS.
-- =============================================================

-- CASO 1: ANALISIS DE PROPIEDADES
-- Ingresar, por ejemplo, 100000 para VALOR_TOTAL_GASTO_COMUN.
SELECT
    p.id_tipo_propiedad AS "TIPO",
    COUNT(*) AS "TOTAL_PROPIEDADES",
    TO_CHAR(MAX(p.valor_arriendo), 'FM$999G999G990') AS "MAX_ARRIENDO",
    TO_CHAR(ROUND(AVG(p.valor_arriendo)), 'FM$999G999G990') AS "PROMEDIO_ARRIENDO",
    TO_CHAR(MIN(p.valor_arriendo), 'FM$999G999G990') AS "MIN_ARRIENDO",
    CASE
        WHEN MAX(p.valor_arriendo) <= 1000000 THEN 'ESTÁNDAR'
        ELSE 'PREMIUM'
    END AS "CLASIFICACION",
    TO_CHAR(SUM(NVL(p.valor_gasto_comun, 0)), 'FM$999G999G990') AS "TOTAL_GASTOS_COMUNES"
FROM PROPIEDAD p
GROUP BY p.id_tipo_propiedad
HAVING SUM(NVL(p.valor_gasto_comun, 0)) > &VALOR_TOTAL_GASTO_COMUN
ORDER BY SUM(NVL(p.valor_gasto_comun, 0)) DESC;

-- CASO 2: ANALISIS DE ANTIGUEDAD DE EMPLEADOS
-- Ingresar, por ejemplo, 30 para CODIGO_SUCURSAL.
SELECT
    UPPER(TRIM(e.pnombre_emp || ' ' || e.apaterno_emp)) AS "Nombre Empleado",
    TO_CHAR(e.sueldo_emp, 'FM$999G999G990') AS "Sueldo con Formato",
    CASE
        WHEN e.sueldo_emp > 2000000 THEN 'ALTO'
        ELSE 'MEDIO'
    END AS "Clasificación Sueldo",
    TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), e.fecing_emp) / 12) AS "Años Antigüedad",
    'Corresponde bono ' ||
    CASE
        WHEN TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), e.fecing_emp) / 12) BETWEEN 5 AND 10 THEN '5%: '
        WHEN TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), e.fecing_emp) / 12) BETWEEN 11 AND 20 THEN '10%: '
        ELSE '15%: '
    END ||
    TO_CHAR(ROUND(e.sueldo_emp *
        CASE
            WHEN TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), e.fecing_emp) / 12) BETWEEN 5 AND 10 THEN 0.05
            WHEN TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), e.fecing_emp) / 12) BETWEEN 11 AND 20 THEN 0.10
            ELSE 0.15
        END), 'FM$999G999G990') AS "BONO"
FROM EMPLEADO e
WHERE e.id_categoria_emp = 3
  AND e.id_sucursal <> &CODIGO_SUCURSAL
  AND TRUNC(MONTHS_BETWEEN(TRUNC(SYSDATE), e.fecing_emp) / 12) > 5
ORDER BY e.sueldo_emp DESC;

-- CASO 3: LISTA DE CLIENTES
SELECT
    CASE
        WHEN c.renta_cli >= 1000000 THEN 'PREMIUM'
        WHEN c.renta_cli >= 600000 THEN 'ALTA'
        WHEN c.renta_cli >= 300000 THEN 'MEDIA'
        ELSE 'BAJA'
    END AS "CLASIFICACION_RENTA",
    COUNT(*) AS "CANTIDAD_CLIENTES",
    TO_CHAR(ROUND(AVG(c.renta_cli)), 'FM$999G999G990') AS "RENTA_PROMEDIO",
    CASE
        WHEN COUNT(c.celular_cli) = 0 THEN 'Clientes sin Teléfono'
        ELSE 'Clientes con Teléfono'
    END AS "ESTADO_TELEFONO"
FROM CLIENTE c
GROUP BY
    CASE
        WHEN c.renta_cli >= 1000000 THEN 'PREMIUM'
        WHEN c.renta_cli >= 600000 THEN 'ALTA'
        WHEN c.renta_cli >= 300000 THEN 'MEDIA'
        ELSE 'BAJA'
    END
HAVING AVG(c.renta_cli) > 200000
ORDER BY AVG(c.renta_cli) DESC;
