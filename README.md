# README
DESIGN architecture for Data Analytics Platform

Requirements

- User should be able to Sign up (Email/password/Google)
- User should be able to Login via password or google oauth
- User should be able to upload a CSV
    - Save CSV, name and other meta-information
    - Option to download CSV template
    - The template will look something like this -> date, value, domain_name
- User should be able to fetch results for aggregations over this data
example - get max value, plot time series, get median etc.
- User should be able to share the results with other users over EMAIL
    - Other users should be able to download the results via S3.
