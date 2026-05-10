# varmodels_Siryi
# VAR Models for Economic Forecasting

This repo contains files with results of training 3 different VAR models.

### Data
* **`дані для диплому/`** — folder with all macroeconomic indicators from https://stat.gov.ua/
* **`data_var.ipynb`** — notebook for pooling quaterly indicators into dataset for var model.
* **`mfvar_data.ipynb`** — notebook for pooling quaterly and monthly indicators into dataset for mfvar model.

### Models
* **`var_model.ipynb`** — classic vector autoregression model.
* **`bvar_model.R`** — Bayesian VAR model with Minnesota priors.
* **`mfvar_model.ipynb`** — Mixed-frequency VAR model for monthly data training.

## Stack
* **Python** (bib: `pandas`, `statsmodels`, `numpy`, `matplotlib`)
* **R** (for BVAR model)
