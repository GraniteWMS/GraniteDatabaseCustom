# StocktakeCountTrackingEntity

- Script Name: PrescriptStocktakeCountTrackingEntity

When scanning a TrackingEntity in Stocktake Count -this checks if it has been counted before, and if so, shows an error.
Without this script, any TE can be scanned multiple times and the count will be added together (used for scannning Item codes for example, you need to be able to add up the scans).

