-- Financial Stress Early-Warning System
-- Initial PostgreSQL database structure

CREATE TABLE market_prices (
    price_date DATE NOT NULL,
    ticker VARCHAR(20) NOT NULL,
    open_price NUMERIC(18, 6),
    high_price NUMERIC(18, 6),
    low_price NUMERIC(18, 6),
    close_price NUMERIC(18, 6),
    adjusted_close NUMERIC(18, 6),
    volume BIGINT,
    PRIMARY KEY (price_date, ticker),
    CHECK (volume IS NULL OR volume >= 0),
    CHECK (
        high_price IS NULL
        OR low_price IS NULL
        OR high_price >= low_price
    )
);

CREATE TABLE economic_indicators (
    observation_date DATE NOT NULL,
    indicator_code VARCHAR(50) NOT NULL,
    indicator_name VARCHAR(150) NOT NULL,
    indicator_value NUMERIC(18, 6),
    unit VARCHAR(50),
    frequency VARCHAR(20),
    data_source VARCHAR(100),
    PRIMARY KEY (observation_date, indicator_code)
);

CREATE TABLE interest_rates (
    rate_date DATE NOT NULL,
    rate_name VARCHAR(100) NOT NULL,
    maturity VARCHAR(30),
    rate_value NUMERIC(10, 6),
    data_source VARCHAR(100),
    PRIMARY KEY (rate_date, rate_name)
);

CREATE TABLE sector_prices (
    price_date DATE NOT NULL,
    sector_symbol VARCHAR(20) NOT NULL,
    sector_name VARCHAR(100),
    adjusted_close NUMERIC(18, 6),
    volume BIGINT,
    PRIMARY KEY (price_date, sector_symbol),
    CHECK (volume IS NULL OR volume >= 0)
);

CREATE TABLE market_events (
    event_id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_name VARCHAR(150) NOT NULL,
    event_type VARCHAR(50),
    start_date DATE NOT NULL,
    end_date DATE,
    description TEXT,
    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE INDEX idx_market_prices_ticker
    ON market_prices (ticker);

CREATE INDEX idx_economic_indicators_code
    ON economic_indicators (indicator_code);

CREATE INDEX idx_market_events_dates
    ON market_events (start_date, end_date);
