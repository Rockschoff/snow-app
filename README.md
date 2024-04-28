How to run

1. clone the repo `gh repo clone Rockschoff/snow-app`
2. `cd snow-app`
3. `pip install snowflake-cli-labs`
4. Verify `snow --help`
5. Configure the connection `snow connection add`. Add all the required details. account number looks like `cdefghij-ab12345` and username and password is what you use to login

6. Prepare the data `sh prepare_data.sh`
7. Upload the app to snowflake : `snow app run`
