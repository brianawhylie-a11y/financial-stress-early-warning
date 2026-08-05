
DROP VIEW IF EXISTS market_features_sql;

CREATE VIEW market_features_sql AS
WITH base AS (
    SELECT
        price_date,
        ticker,
        asset_name,
        adjusted_close,
        volume,
        LAG(adjusted_close, 1) OVER (
            PARTITION BY ticker
            ORDER BY price_date
        ) AS previous_close,
        AVG(adjusted_close) OVER (
            PARTITION BY ticker
            ORDER BY price_date
            ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) AS moving_average_20d,
        AVG(volume) OVER (
            PARTITION BY ticker
            ORDER BY price_date
            ROWS BETWEEN 19 PRECEDING AND CURRENT ROW
        ) AS average_volume_20d,
        MAX(adjusted_close) OVER (
            PARTITION BY ticker
            ORDER BY price_date
            ROWS BETWEEN 251 PRECEDING AND CURRENT ROW
        ) AS rolling_peak_252d
    FROM market_prices
),
calculated AS (
    SELECT
        price_date,
        ticker,
        asset_name,
        adjusted_close,
        volume,
        CASE
            WHEN previous_close IS NULL OR previous_close = 0 THEN NULL
            ELSE adjusted_close / previous_close - 1.0
        END AS daily_return,
        CASE
            WHEN moving_average_20d IS NULL OR moving_average_20d = 0 THEN NULL
            ELSE adjusted_close / moving_average_20d - 1.0
        END AS price_vs_ma20,
        CASE
            WHEN average_volume_20d IS NULL OR average_volume_20d = 0 THEN NULL
            ELSE volume / average_volume_20d - 1.0
        END AS volume_vs_average_20d,
        CASE
            WHEN rolling_peak_252d IS NULL OR rolling_peak_252d = 0 THEN NULL
            ELSE adjusted_close / rolling_peak_252d - 1.0
        END AS drawdown_252d
    FROM base
)
SELECT *
FROM calculated;
