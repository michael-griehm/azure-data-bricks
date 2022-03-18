# Databricks CLI Setup

This documents the steps to setup the Databricks CLI.

## Install Python

Download the installer for Windows from here:  <https://www.python.org/downloads/release/python-3103/>

When installing, be sure to select the options:

- py launcher
- Add Python to environment variables

To set these options, you might need to Modify the install after initial Install.

## Install PIP

Run the following shell command

    pip install databricks-cli

## Generate DBx Personal Access Token

- In the Databricks workspace UI, click on the Settings (gear) icon in the lower left hand corner.
- Click 'User Settings'.
- Go to the 'Access Tokens' tab.
- Click the Generate New Token button.

## Configure the CLI to use a Personal Access Token

    databricks configure --token

    https://adb-3560793084381069.9.azuredatabricks.net

    dapid340f44d2f7116638809f59f3101500e-2

## References

- <https://docs.microsoft.com/en-us/azure/databricks/dev-tools/api/latest/authentication>