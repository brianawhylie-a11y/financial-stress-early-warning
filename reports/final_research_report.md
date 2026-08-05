# Financial Stress Early-Warning System: Initial Results

## Research Question

Can information available today help identify whether the U.S. stock market is at elevated risk of a decline of at least 8% during the next 20 trading days?

## Research Design

- Market proxy: SPY
- Research period: 2007-01-03 through 2026-08-05
- Training period ending: 2022-08-29
- Test period beginning: 2022-08-30
- Model: Class-weighted logistic regression
- Warning threshold: 0.509
- Test ROC-AUC: 0.625

## Important Methodology Choices

- The train/test split follows chronological order.
- Future prices are used only to create the target.
- Monthly economic features are delayed to approximate publication lag.
- Features are imputed and standardized using parameters learned from the training period.

## Next Research Steps

1. Add exact economic release dates or real-time data vintages.
2. Compare logistic regression with tree-based models.
3. Use walk-forward validation across multiple market regimes.
4. Test alternative decline thresholds and forecast horizons.
5. Add transaction-cost-aware investment or hedging simulations.

## Disclaimer

This project is for educational and portfolio purposes and is not investment advice.
